import CoreAudio
import CoreGraphics
import CoreLocation
import CoreWLAN
import Foundation
import Metal

func fail(_ message: String) -> Never {
    FileHandle.standardError.write(Data((message + "\n").utf8))
    exit(1)
}

func checkDisplay(_ result: CGError) {
    guard result == .success else {
        fail("Display configuration failed (Quartz error \(result.rawValue)).")
    }
}

func setMirroring(_ enabled: Bool) {
    var count: UInt32 = 0
    checkDisplay(CGGetOnlineDisplayList(0, nil, &count))
    guard count > 1 else { fail("Connect at least two displays first.") }
    var displays = [CGDirectDisplayID](repeating: 0, count: Int(count))
    checkDisplay(CGGetOnlineDisplayList(count, &displays, &count))
    let main = CGMainDisplayID()
    var config: CGDisplayConfigRef?
    checkDisplay(CGBeginDisplayConfiguration(&config))
    for display in displays.prefix(Int(count)) where display != main {
        let destination = enabled ? main : kCGNullDirectDisplay
        if CGDisplayMirrorsDisplay(display) != destination {
            let result = CGConfigureDisplayMirrorOfDisplay(config, display, destination)
            if result != .success {
                CGCancelDisplayConfiguration(config)
                checkDisplay(result)
            }
        }
    }
    checkDisplay(CGCompleteDisplayConfiguration(config, .forSession))
    print(enabled ? "Displays mirrored for this session." : "Displays extended for this session.")
}

func displayRefreshRate(_ value: String) {
    let display = CGMainDisplayID()
    guard let rate = Double(value), rate.isFinite, rate > 0,
          let current = CGDisplayCopyDisplayMode(display),
          let modes = CGDisplayCopyAllDisplayModes(display, nil) as? [CGDisplayMode] else {
        fail("A positive refresh rate and an active display are required.")
    }
    let sameResolution = modes.filter {
        $0.width == current.width && $0.height == current.height &&
            $0.pixelWidth == current.pixelWidth && $0.pixelHeight == current.pixelHeight
    }.filter { $0.refreshRate > 0 }
    guard let mode = sameResolution.min(by: { abs($0.refreshRate - rate) < abs($1.refreshRate - rate) }),
          abs(mode.refreshRate - rate) < 1 else {
        let rates = Set(sameResolution.map { $0.refreshRate }).sorted()
        fail("Available refresh rates at the current resolution: \(rates). Check System Settings for variable modes.")
    }
    checkDisplay(CGDisplaySetDisplayMode(display, mode, nil))
    print("Main display refresh rate: \(mode.refreshRate) Hz")
}

func metalBenchmark() throws {
    guard let device = MTLCreateSystemDefaultDevice(),
          let queue = device.makeCommandQueue() else {
        fail("No Metal GPU is available in this session.")
    }
    let library = try device.makeLibrary(source: """
        #include <metal_stdlib>
        using namespace metal;
        vertex float4 full_screen(uint id [[vertex_id]]) {
            const float2 positions[] = { float2(-1, -1), float2(3, -1), float2(-1, 3) };
            return float4(positions[id], 0, 1);
        }
        fragment half4 shade(float4 p [[position]]) {
            float2 uv = p.xy / float2(1920, 1080);
            float3 color = 0.5 + 0.5 * sin(float3(uv.x, uv.y, uv.x + uv.y) * 24.0);
            return half4(half3(color), 1.0h);
        }
        """, options: nil)
    let width = 1920, height = 1080
    let textureInfo = MTLTextureDescriptor.texture2DDescriptor(
        pixelFormat: .bgra8Unorm, width: width, height: height, mipmapped: false
    )
    textureInfo.storageMode = .private
    textureInfo.usage = .renderTarget
    guard let target = device.makeTexture(descriptor: textureInfo) else { fail("Unable to allocate render texture.") }
    let pipelineInfo = MTLRenderPipelineDescriptor()
    pipelineInfo.vertexFunction = library.makeFunction(name: "full_screen")
    pipelineInfo.fragmentFunction = library.makeFunction(name: "shade")
    pipelineInfo.colorAttachments[0].pixelFormat = target.pixelFormat
    let pipeline = try device.makeRenderPipelineState(descriptor: pipelineInfo)
    let pass = MTLRenderPassDescriptor()
    pass.colorAttachments[0].texture = target
    pass.colorAttachments[0].loadAction = .dontCare
    pass.colorAttachments[0].storeAction = .store

    let frames = 180
    let start = DispatchTime.now().uptimeNanoseconds
    for _ in 0..<frames {
        guard let buffer = queue.makeCommandBuffer(),
              let encoder = buffer.makeRenderCommandEncoder(descriptor: pass) else {
            fail("Unable to encode Metal commands.")
        }
        encoder.setRenderPipelineState(pipeline)
        encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        encoder.endEncoding()
        buffer.commit()
        buffer.waitUntilCompleted()
        if let error = buffer.error { throw error }
    }
    let elapsed = Double(DispatchTime.now().uptimeNanoseconds - start) / 1e9
    let timing = String(format: "%.1f frames/s, %.2f ms/frame", Double(frames) / elapsed, elapsed * 1000 / Double(frames))
    print("\(device.name) · offscreen Metal · \(width)×\(height) · \(timing)")
}

func audioUInt32(
    _ object: AudioObjectID, _ selector: AudioObjectPropertySelector,
    _ scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal
) -> UInt32? {
    var address = AudioObjectPropertyAddress(
        mSelector: selector, mScope: scope, mElement: kAudioObjectPropertyElementMain
    )
    var value: UInt32 = 0
    var size = UInt32(MemoryLayout<UInt32>.size)
    let status = AudioObjectGetPropertyData(object, &address, 0, nil, &size, &value)
    return status == 0 ? value : nil
}

func audioLatency() {
    let devices: [(String, AudioObjectPropertySelector, AudioObjectPropertyScope)] = [
        ("Input", kAudioHardwarePropertyDefaultInputDevice, kAudioObjectPropertyScopeInput),
        ("Output", kAudioHardwarePropertyDefaultOutputDevice, kAudioObjectPropertyScopeOutput)
    ]
    for (name, selector, scope) in devices {
        guard let device = audioUInt32(AudioObjectID(kAudioObjectSystemObject), selector),
              device != kAudioObjectUnknown else {
            print("\(name): no default device")
            continue
        }
        print("\(name) device \(device)")
        let properties: [(String, AudioObjectPropertySelector, AudioObjectPropertyScope)] = [
            ("Device latency", kAudioDevicePropertyLatency, scope),
            ("Safety offset", kAudioDevicePropertySafetyOffset, scope),
            ("I/O buffer size", kAudioDevicePropertyBufferFrameSize, kAudioObjectPropertyScopeGlobal)
        ]
        for (label, property, propertyScope) in properties {
            if let frames = audioUInt32(device, property, propertyScope) {
                print("  \(label): \(frames) frames")
            }
        }
    }
    print("Values reported by devices. Use a physical loopback to measure round-trip latency.")
}

struct AccessPoint: Encodable {
    var ssid: String
    var bssid: String?
    var signal: Int
    var noise: Int
    var channel: Int?
    var secure: Bool
}

func requestLocation() {
    let manager = CLLocationManager()
    if manager.authorizationStatus == .notDetermined {
        manager.requestWhenInUseAuthorization()
        let deadline = Date().addingTimeInterval(15)
        while manager.authorizationStatus == .notDetermined && Date() < deadline {
            RunLoop.current.run(until: Date().addingTimeInterval(0.2))
        }
    }
}

func scan(_ interface: CWInterface, ssid: String? = nil) throws -> Set<CWNetwork> {
    guard interface.powerOn() else { fail("Wi-Fi is off. Run cx wifi on.") }
    requestLocation()
    return try interface.scanForNetworks(withSSID: ssid.map { Data($0.utf8) })
}

let args = Array(CommandLine.arguments.dropFirst())
switch args.first {
case "--self-test":
    print("CoreX native helper")
case "metal-benchmark":
    do { try metalBenchmark() }
    catch { fail(error.localizedDescription) }
case "refresh-rate":
    guard args.count == 2 else { fail("Usage: cx mon-res <Hz>") }
    displayRefreshRate(args[1])
case "extend":
    setMirroring(false)
case "mirror":
    setMirroring(true)
case "audio-latency":
    audioLatency()
case "wifi-scan", "wifi-join", "wifi-status", "wifi-disconnect":
    guard let interface = CWWiFiClient.shared().interface() else {
        fail("No Wi-Fi interface was found.")
    }
    do {
        switch args[0] {
        case "wifi-status":
            if interface.powerOn() {
                requestLocation()
                let network = interface.ssid() ?? "Unavailable (disconnected or Location Services restricted)"
                print("Network: \(network)")
                if let channel = interface.wlanChannel() {
                    print("Channel: \(channel.channelNumber)")
                    print("Signal: \(interface.rssiValue()) dBm · Noise: \(interface.noiseMeasurement()) dBm")
                }
            }
        case "wifi-scan":
            let networks = try scan(interface)
            let points = networks.compactMap { network -> AccessPoint? in
                guard let ssid = network.ssid, !ssid.isEmpty else { return nil }
                return AccessPoint(
                    ssid: ssid, bssid: network.bssid, signal: network.rssiValue,
                    noise: network.noiseMeasurement, channel: network.wlanChannel?.channelNumber,
                    secure: !network.supportsSecurity(.none)
                )
            }.sorted { $0.signal > $1.signal }
            if points.isEmpty && !networks.isEmpty {
                fail("macOS withheld Wi-Fi names. Allow CoreX or your terminal in System Settings → Privacy & Security → Location Services.")
            }
            FileHandle.standardOutput.write(try JSONEncoder().encode(points))
        case "wifi-join":
            guard args.count >= 2 else { fail("SSID required.") }
            let ssid = args[1]
            let bssid = args.count > 2 ? args[2] : ""
            let networks = try scan(interface, ssid: ssid)
            guard let network = networks
                .filter({ $0.ssid == ssid && (bssid.isEmpty || $0.bssid == bssid) })
                .max(by: { $0.rssiValue < $1.rssiValue }) else {
                fail("Network unavailable or its name is hidden by Location Services.")
            }
            let password = readLine(strippingNewline: true) ?? ""
            try interface.associate(to: network, password: password.isEmpty ? nil : password)
        default:
            interface.disassociate()
        }
    } catch {
        fail(error.localizedDescription)
    }
default:
    fail("Unknown CoreX native operation.")
}
