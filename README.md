# CoreX (`cx`) — 150+ Action Mission-Control Workstation Engine

```
   ______                     _  __
  / ____/____   _____ ___     | |/ /
 / /    / __ \ / ___// _ \    |   / 
/ /___ / /_/ // /   /  __/   /   |  
\____/ \____//_/    \___/   /_/|_|  v3.0.0 ENTERPRISE WORKSTATION COCKPIT
──────────────────────────────────────────────────────────────────
```

An elite, blazingly fast, modular terminal workstation engine that transforms your Linux terminal into an exhaustive mission-control cockpit. Engineered specifically for Linux power users, systems engineers, and kernel hackers (CachyOS/Arch, Hyprland/Wayland, Fish/Bash/Zsh, Nvidia GPU, BTRFS/Snapper, eBPF/Kernel, Dev & AI workflows).

Powered by a **declarative TOML architecture**, **instant `@category` fuzzy filtering**, dynamic live ANSI preview panes, **in-TUI hotkey orchestration**, **systemd background daemon runners (`--bg`)**, and **sub-50ms zero-latency direct execution**.

---

## ⚡ Key Architectural Capabilities

1. **Sub-50ms Startup Latency**:
   - Zero-dependency architecture utilizing standard library lazy imports and an optimized slot-based command index. Direct execution (`cx <command> [args...]`) runs in ~40ms without runtime bloat.
2. **Interactive Mission Control Cockpit (`cx`)**:
   - Running `cx` without arguments launches a lightning-fast fuzzy finder loaded with **153 operational actions**.
   - **Direct Category Tag Filtering**: Type `@category` directly into the search prompt (e.g. `@kernel`, `@gpu`, `@vulkan`, `@mem`, `@netflow`, `@dsp`, `@docker`, `@code`) to instantly slice the catalog.
3. **In-TUI Action Hotkeys**:
   - `Enter`: Execute the selected action immediately.
   - `Ctrl+Y`: Copy the underlying shell command to system clipboard (`wl-copy` / `xclip`).
   - `Ctrl+E`: Open the shell command in `$EDITOR` before execution for dynamic edits.
   - `Ctrl+D`: Execute the action in `--dry-run` mode without leaving the TUI.
4. **Background Daemon Runner (`--bg`)**:
   - Detaches any command cleanly into an isolated transient systemd user service unit (`systemd-run --user --unit=corex-<cmd>-<ts>`) or background `nohup` subshell.
5. **Declarative TOML Engine (`~/.config/corex/config.toml`)**:
   - Every single command is registered declaratively with:
     `category`, `description`, `command`, `preview_cmd`, `requires_sudo`, `confirm`, and `deps`.
   - Any action can be customized, overridden, or extended without touching Python code.
6. **System & Shell Integration**:
   - Automated installer (`install.sh`) with native Fish functions (`~/.config/fish/functions/cx.fish`), Fish completions, Bash completions, and Zsh completions.
   - Built-in `--list` for raw scripting/completion output and `--dry-run` to preview shell commands before execution.

---

## 🚀 Installation & Setup

```bash
git clone <repo-url> ~/Documents/programming/CX
cd ~/Documents/programming/CX
chmod +x install.sh
./install.sh
```

The installer verifies your dependencies, symlinks `cx` to `~/.local/bin/cx`, updates `~/.config/corex/config.toml`, and configures completions for Fish, Bash, and Zsh.

---

## 🏷️ Category Filter Tags

Type any of the following tags directly into the `cx` prompt to filter actions:

| Tag | Category | Actions | Focus Area |
|---|---|:---:|---|
| `@kernel` | Kernel Tracing, Interrupts & eBPF | 11 | IRQ load balancing, dmesg, kmods, sysctl tuning, cgroups, OOM scores, NUMA, IPC |
| `@vulkan` | Vulkan, 3D & Graphics Telemetry | 11 | Vulkan caps & layers, glmark2, shader caches, EDID, VRR, NVENC, DRI, MangoHud |
| `@mem` | Memory, HugePages & Storage Forensics | 11 | Physical RAM breakdown, HugePages toggle, zRAM, iotop, inodes, BTRFS scrub/dedup, SMART |
| `@netflow` | Network Traffic Analysis & Socket Forensics | 11 | Socket summary, DNS leak audit, tcpdump, SSL inspect, MTU bench, conntrack, Wi-Fi radar |
| `@dsp` | Audio Synthesis, Signal Routing & Metrology | 10 | Sine & pink noise generator, PipeWire linking, spectrograms, xruns, latency testing, bit depth |
| `@docker` | Container, Pod & Service Micro-Orchestration | 10 | Compose up/down, dive, container stats, Podman pods, K8s nodes & pods, port forwarding |
| `@code` | Local Development & Code Diagnostics | 14 | Regex sandbox, JSON formatter, patch diffs, tokei lines, cron inspection, SQLite, git bisect |
| `@ai` | AI, CUDA & Deep Learning | 12 | ComfyUI launcher/sync, Ollama lifecycle, HuggingFace & Civitai fetchers, VRAM watchers |
| `@audio` | Media, Audio & PipeWire Power-Tools | 13 | YouTube streaming, lossless video cutters, FLAC/Opus rippers, Demucs stem demixing |
| `@gpu` | Gaming, Hardware & Display Orchestration | 8 | GPU power profiles, CPU governors, Turbo Boost toggles, Hyprland display profiles, GameMode |
| `@sys` | System Architecture & BTRFS Snapshotting | 9 | Snapper snapshots/diffs/rollbacks, fkill, orphaned pacman packages, journal vacuuming |
| `@net` | Network, VPN & Remote Infrastructure | 9 | Public IP info card, VPN profile toggle, listening port audit, speed test, SSH fuzzy picker |
| `@dev` | Git, Dev & Code Utilities | 9 | Git branch fzf, squash, stash pop, branch cleanup, cheat sheets, hex viewer |
| `@daily` | Daily Driver Quality-of-Life & Crypto/Files | 15 | Clipboard history, QR generator/scanner, archive tools, weather, calculator, timer, notes, todo |

---

## 🎛️ Complete 153-Command Catalog

### 1. Kernel Tracing, Interrupts & eBPF (`@kernel`)
- `cx irq-top`: Real-time hardware interrupt frequency table per CPU core (`/proc/interrupts`).
- `cx dmesg-follow`: Live colorized kernel ring-buffer log stream (`dmesg -wH`).
- `cx kmod-fzf`: Interactive fuzzy kernel module browser with description, size, and unload (`modprobe -r`).
- `cx sysctl-search`: Fuzzy browser for live kernel runtime tunables (`sysctl -a`).
- `cx cgroup-inspect`: Tree of active systemd cgroup resource slices and CPU/memory allocations.
- `cx oom-score`: Out-of-Memory (OOM) killer badness ranking across all active processes.
- `cx klog-err`: Filter kernel ring buffer for critical alerts, kernel panics, and hardware errors.
- `cx pcie-topo`: PCI Express link speed (Gen 3/4/5) and link width (x16/x8/x4) verification.
- `cx slab-top`: Real-time kernel memory slab cache allocator usage (`slabtop`).
- `cx numa-stat`: Non-Uniform Memory Access (NUMA) node hit/miss ratio and allocation statistics.
- `cx ipc-audit`: System V and POSIX inter-process communication shared memory, semaphores, and message queues.

### 2. Vulkan, 3D & Graphics Telemetry (`@vulkan`)
- `cx vk-caps`: Fuzzy search Vulkan physical device capabilities, features, and limits (`vulkaninfo`).
- `cx vk-layers`: Enumerate active and implicit Vulkan validation, overlay, and capture layers.
- `cx glmark-quick`: Rapid offscreen/onscreen OpenGL & EGL performance benchmark (`glmark2`).
- `cx shader-cache-purge`: Safely purge Mesa, DXVK, and Nvidia shader cache folders to resolve stutter.
- `cx display-edid`: Query active monitor EDID block details, pixel clocks, and color depth via DRM.
- `cx vrr-status`: Verify Variable Refresh Rate (G-Sync / FreeSync) state across active Wayland displays.
- `cx nv-enc-stat`: Real-time hardware video encoder (NVENC) and decoder (NVDEC) session load.
- `cx dri-info`: Direct Rendering Infrastructure (DRI/DRM) node state and graphics card bus topology.
- `cx wayland-diag`: Wayland compositor protocol inspection and active client surface hierarchy.
- `cx mangohud-config`: Interactive selector and editor for MangoHud gaming telemetry overlay presets.

### 3. Memory, HugePages & Storage Forensics (`@mem`)
- `cx ram-breakdown`: Detailed breakdown of physical RAM (AnonPages, Active/Inactive, Slab, Dirty, Buffers/Cache).
- `cx hugepages-toggle`: Query and toggle Transparent Huge Pages (THP) between `always`, `madvise`, and `never`.
- `cx zram-stats`: ZRAM compressed RAM swap statistics, compression ratios, and disk limits.
- `cx io-top`: High-priority disk I/O usage monitor sorted by process transfer rate.
- `cx inode-check`: Inode utilization per mounted filesystem to detect filesystem exhaustion before raw space runs out.
- `cx file-locks`: Inspect active advisory and mandatory kernel file locks (`/proc/locks`).
- `cx btrfs-scrub`: Start or inspect background integrity verification on BTRFS filesystem mounts.
- `cx btrfs-dedup`: Read-only deduplication and extents sharing audit via `duperemove`.
- `cx fstrim-all`: Issue manual TRIM discard requests across all mounted SSDs/NVMe drives.
- `cx smart-health`: Read SMART health status, power cycles, and temperature from internal NVMe and SATA drives.
- `cx swap-compact`: Safely flush and re-enable active swap partitions/files to reclaim fragmented memory.

### 4. Network Traffic Analysis & Socket Forensics (`@netflow`)
- `cx socket-summary`: Instant statistics of all TCP, UDP, RAW, and INET socket states (`ss -s`).
- `cx dns-leak-test`: Query DNS resolution servers against known resolvers to detect VPN leakage.
- `cx tcp-dump-quick`: Rapid packet capture on default network interface with ASCII & hex preview.
- `cx ssl-inspect`: Connect to remote TLS endpoint and inspect certificate chain, SANs, and expiry date.
- `cx mtu-bench`: Automated ICMP ping sweep with Don't Fragment (DF) flag to find path MTU without fragmentation.
- `cx route-trace`: Modern visual network route hop latency tracer (`traceroute` / `tracepath`).
- `cx band-top`: Terminal bandwidth monitor showing transfer speeds per active network connection.
- `cx conntrack-dump`: Inspect Linux kernel Netfilter connection tracking state table.
- `cx dns-benchmark`: Benchmark response times of configured DNS resolvers vs Cloudflare, Quad9, and Google.
- `cx wifi-radar`: Scan nearby Wi-Fi SSIDs, signal strength (RSSI), channels, and frequency bands.
- `cx firewall-status`: Enumerate active UFW, firewalld, or raw `nftables` packet filtering rules.

### 5. Audio Synthesis, Signal Routing & Metrology (`@dsp`)
- `cx sine-gen`: Generate a pure 440 Hz test tone directly through PipeWire / ALSA.
- `cx pink-noise`: Generate calibrated pink noise audio signal for acoustic calibration.
- `cx spectrogram`: Generate visual audio frequency spectrogram from audio/video file in cwd.
- `cx xrun-dump`: Tail system logs for PipeWire audio buffer overruns/underruns (XRuns) causing audio pops.
- `cx audio-resample-bench`: Benchmark sample-rate conversion quality and CPU load via `speexdsp`.
- `cx pw-link-fzf`: Interactive fuzzy linker connecting PipeWire audio output ports to input sink ports.
- `cx latency-test`: Measure round-trip audio buffer latency and sample rate in PipeWire.
- `cx sweep-gen`: Generate a continuous 20 Hz - 20 kHz linear audio sine sweep file.
- `cx bit-depth-check`: Inspect true bit-depth and integer/float formatting of audio streams (`pw-dump`).

### 6. Container, Pod & Service Micro-Orchestration (`@docker`)
- `cx compose-up`: Boot Docker Compose services in background with colored startup log streaming.
- `cx compose-down`: Gracefully stop and remove Docker Compose containers, networks, and volumes.
- `cx container-shell`: Fuzzy select any active container and spawn an interactive `bash` / `sh` session.
- `cx image-dive`: Explore docker image layers and discover waste removal opportunities (`dive`).
- `cx registry-inspect`: Query remote container registry for image tags and digest manifests via `skopeo`.
- `cx container-stats`: Real-time stream of container resource metrics (CPU %, Mem %, Net I/O).
- `cx compose-logs`: Interactive multi-container log streamer with timestamps and tail buffering.
- `cx podman-pods`: List and inspect rootless Podman pods and associated application containers.
- `cx k8s-nodes`: Query Kubernetes cluster node health, capacity, and Kubernetes API conditions.
- `cx port-forward`: Interactive SSH tunneling helper (Local `-L` or Remote `-R` port forwarding).

### 7. Local Development & Code Diagnostics (`@code`)
- `cx regex-test`: Interactive Python regular expression evaluator with match extraction and span indices.
- `cx json-pretty`: Pretty-print, syntax-highlight, and validate JSON from clipboard or file.
- `cx diff-patch`: Generate a unified Git diff patch file from uncommitted workspace changes.
- `cx tokei-count`: Rapid code metrics breakdown by language, blank lines, comments, and lines of code.
- `cx cron-inspect`: Enumerate all scheduled cron jobs and systemd user timers in a clean table.
- `cx git-bisect-start`: Guide and bootstrap binary search debugging (`git bisect`) to pinpoint regressions.
- `cx sqlite-browser`: Interactive CLI browser and query runner for SQLite database files.
- `cx http-bench`: High-concurrency HTTP load benchmarking tool against local or remote endpoints.
- `cx env-diff`: Compare current process shell environment variables against a clean subshell.
- `cx perf-stat`: Profile hardware performance counters (cycles, instructions, cache misses) for any command.
- `cx entropy-check`: Query system random number generator entropy pool availability (`/proc/sys/kernel/random/entropy_avail`).
- `cx gamescope-run`: Launch custom game or application wrapped in Valve's Gamescope micro-compositor.
- `cx noise-gate`: Toggle real-time AI background noise suppression for PipeWire microphone inputs.
- `cx git-rebase-i`: Start interactive Git rebase for the last N commits.
- `cx semver-bump`: Inspect project versions and calculate next SemVer release (`major`, `minor`, `patch`).

### 8. AI, CUDA & Deep Learning (`@ai`)
- `cx comfy-boot`: Intelligent ComfyUI bootstrapper (venv detection, port 8188 inspection, CUDA alloc flags).
- `cx comfy-nuke`: Force kill zombie ComfyUI servers and Torch memory holders.
- `cx comfy-sync`: Parallel git-pull across ComfyUI core and all cloned `custom_nodes` directories.
- `cx model-symlink`: Interactive fzf picker to symlink `.safetensors` files into ComfyUI models.
- `cx ollama-up`: Start the Ollama background inference daemon if stopped.
- `cx ollama-ps`: Display currently loaded models in GPU memory with context memory footprint.
- `cx ollama-drop`: Unload all active LLMs from VRAM immediately (`keep_alive=0`).
- `cx ollama-fzf`: Interactive fuzzy selector to run or chat with locally pulled LLMs.
- `cx hf-download`: Fast model puller from HuggingFace via aria2c multithreaded resume.
- `cx civit-grab`: Download model/LoRA from Civitai API key/URL with SHA256 verification.
- `cx vram-watch`: Loop `nvidia-smi` showing per-process memory, power draw, and temperature at 1000ms.
- `cx cuda-purge`: Scan specifically for orphaned Python processes holding `/dev/nvidia*` file handles.

### 9. Media, Audio & PipeWire Power-Tools (`@audio`)
- `cx stream-yt`: Interactive YouTube fuzzy search via `yt-dlp` metadata streaming into `mpv --no-video`.
- `cx stream-video`: Hardware-accelerated 1440p/4K YouTube video streaming in borderless `mpv`.
- `cx stream-radio`: Background endless ambient/lo-fi/synthwave stream player with minimal CPU footprint.
- `cx rip-flac`: Batch-convert video or audio files in cwd to uncompressed 24-bit FLAC.
- `cx rip-opus`: Fast high-efficiency audio compression to Opus at 160kbps.
- `cx trim-video`: Interactive lossless video cutter via ffmpeg stream copy.
- `cx make-gif`: High-fidelity palettegen GIF converter from any video segment.
- `cx demucs-stems`: Demix audio tracks into 4 isolated stems (vocals, drums, bass, other) via Demucs CLI.
- `cx pw-restart`: One-key reboot of PipeWire, WirePlumber, and pipewire-pulse daemons.
- `cx pw-devices`: Interactive audio output switcher via `wpctl`.
- `cx pw-volume`: Set master channel volume percentage via CLI.
- `cx tag-editor`: Inspect audio file metadata, codecs, and container information.
- `cx cover-extract`: Extract embedded album artwork to `cover.jpg`.

### 10. Gaming, Hardware & Display Orchestration (`@gpu`)
- `cx gpu-clock`: Enable Nvidia persistence mode and query GPU clocks/power limits.
- `cx cpu-gov`: Interactive CPU governor picker (`performance`, `powersave`, `schedutil`).
- `cx cpu-turboboost`: Toggle Intel/AMD Turbo Boost on/off.
- `cx mon-res`: Inspect and adjust display resolutions and refresh rates via compositor.
- `cx mon-dual`: Apply dual-monitor workspace arrangement preset.
- `cx mon-single`: Enforce high refresh rate on primary monitor and disable secondary display.
- `cx sens-watch`: Clean terminal dashboard showing CPU core, NVMe, and GPU temperatures.
- `cx game-mode`: Engage maximum performance profile (CPU governor, I/O priorities, disable indexers).

### 11. System Architecture & BTRFS Snapshotting (`@sys`)
- `cx snap-now`: Create labeled Snapper BTRFS root snapshot with timestamp and comment.
- `cx snap-fzf`: Interactive snapshot browser with visual diff inspection and rollback generation.
- `cx snap-clean`: Prune old Snapper snapshots.
- `cx fkill`: Fuzzy interactive process killer with multi-select and SIGTERM/SIGKILL signals.
- `cx disk-space`: Interactive disk usage visualization (`ncdu` / `dust`).
- `cx pkg-orphans`: Find and remove unneeded orphaned pacman packages.
- `cx service-fail`: List all failed systemd system and user services.
- `cx journal-vacuum`: Clean up systemd journal logs keeping size under 200MB.
- `cx boot-analyze`: Analyze kernel and userspace system boot times (`systemd-analyze blame`).

### 12. Network, VPN & Remote Infrastructure (`@net`)
- `cx my-ip`: Display local network interfaces, public IP, ASN, and geo-location card.
- `cx vpn-up`: Fuzzy select and establish WireGuard or OpenVPN connection.
- `cx vpn-down`: Disconnect all active WireGuard and OpenVPN tunnels.
- `cx port-audit`: View open listening ports (`ss -tulpn`) with hotkey process termination.
- `cx speed-check`: Network throughput download, upload, and ping latency test.
- `cx lan-scan`: Discover active devices and MAC vendors on local subnet.
- `cx ssh-fzf`: Interactive SSH connection picker from `~/.ssh/config`.
- `cx serve-dir`: Instant ad-hoc HTTP server on port 8000 with terminal ANSI QR code.
- `cx dns-flush`: Flush local DNS cache.

### 13. Git, Dev & Code Utilities (`@dev`)
- `cx git-branch-fzf`: Interactive Git branch selector with live commit graph preview.
- `cx git-squash`: Interactively squash the last N commits into a clean unified commit.
- `cx git-stash-pop`: Interactive Git stash browser with diff preview.
- `cx git-clean-branches`: Delete merged local Git branches.
- `cx docker-fzf`: Interactive Docker container manager with log trailing and container restart.
- `cx docker-prune`: Reclaim disk space by pruning stopped containers and dangling images.
- `cx venv-init`: Setup and initialize a standard Python `.venv` environment.
- `cx cheat`: Interactive community cheatsheet lookup via `cht.sh`.
- `cx hex-view`: Hexadecimal viewer with ASCII inspection (`xxd` / `hexdump`).

### 14. Daily Driver Quality-of-Life & Crypto/Files (`@daily`)
- `cx clip-hist`: Fuzzy search clipboard history.
- `cx qr-gen`: Generate terminal ANSI QR code from text or URL.
- `cx qr-read`: Decode QR code from screenshot or image file.
- `cx tar-pack`: Interactive tarball compression (`.tar.zst`, `.tar.gz`).
- `cx tar-unpack`: Extract any compressed archive format automatically.
- `cx hash-check`: Calculate and verify SHA256 and MD5 checksums.
- `cx weather`: Minimalist ANSI weather forecast card for current location.
- `cx calc`: Quick CLI mathematical expression evaluator.
- `cx timer`: Visual countdown timer with audio alert and desktop notification.
- `cx stopwatch`: Precision terminal stopwatch with split times.
- `cx notes`: Quick timestamped scratchpad saved to `~/.local/share/corex/notes/`.
- `cx todo`: Interactive terminal task checklist with toggle and completion state.
- `cx url-short`: Shorten URL via `0x0.st`.
- `cx trash-empty`: Purge system trash safely.
- `cx sys-info`: Minimalist hardware and system information summary card.

---

## 🛠️ Configuration Reference (`~/.config/corex/config.toml`)

Every command is defined declaratively. You can customize existing commands or append your own:

```toml
[commands.my-custom-task]
category = "Local Development & Code Diagnostics"
description = "My specialized automation script"
command = "python3 ~/scripts/backup.py"
preview_cmd = "echo 'Status of last backup:' && cat ~/scripts/backup.log"
requires_sudo = false
confirm = true
deps = ["python3"]
```

---

## ⌨️ Interactive Keybindings Cheat Sheet

| Screen / Mode | Key | Description |
|---|---|---|
| **Global Mission Control** | `Enter` | Execute selected action |
| **Global Mission Control** | `Ctrl+Y` | Copy underlying command to system clipboard |
| **Global Mission Control** | `Ctrl+E` | Open command in `$EDITOR` before execution |
| **Global Mission Control** | `Ctrl+D` | Preview action execution with `--dry-run` |
| **Docker (`cx docker-fzf`)** | `Enter` | Stream live trailing logs (`docker logs -f --tail 100`) |
| **Docker (`cx docker-fzf`)** | `Ctrl-R` | Restart container |
| **Docker (`cx docker-fzf`)** | `Ctrl-K` | Stop container |
| **Process Killer (`cx fkill`)** | `Tab` | Multi-select processes |
| **Process Killer (`cx fkill`)** | `Enter` | Send `SIGTERM` (-15) |
| **Process Killer (`cx fkill`)** | `Ctrl-X` | Send `SIGKILL` (-9) |
| **Notes (`cx notes`)** | `Ctrl-D` | Delete selected scratchpad note |

---

## 📜 Shell Integration & Completions

### Fish Shell
Fish function wrapper is installed to `~/.config/fish/functions/cx.fish` and completions to `~/.config/fish/completions/cx.fish`.

To manually regenerate completions:
```bash
cx completions fish > ~/.config/fish/completions/cx.fish
```

### Bash & Zsh
```bash
# Bash
cx completions bash > ~/.local/share/bash-completion/completions/cx

# Zsh
cx completions zsh > ~/.zsh/completions/_cx
```
