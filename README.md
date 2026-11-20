# CoreX (`cx`)

<p align="center">
  <pre>
   ______                     _  __
  / ____/____   _____ ___     | |/ /
 / /    / __ \ / ___// _ \    |   / 
/ /___ / /_/ // /   /  __/   /   |  
\____/ \____//_/    \___/   /_/|_|  v3.2
──────────────────────────────────────────
  </pre>
  <p align="center">
    <b>The Modular CLI Multitool, Terminal Launcher & Workstation Engine for Linux and macOS</b>
  </p>
  <p align="center">
    <img src="https://img.shields.io/badge/version-3.2.0-blue.svg?style=flat-square" alt="Version 3.2.0" />
    <img src="https://img.shields.io/badge/license-MIT-green.svg?style=flat-square" alt="License MIT" />
    <img src="https://img.shields.io/badge/dependencies-zero%20pip-orange.svg?style=flat-square" alt="Zero Pip Dependencies" />
    <img src="https://img.shields.io/badge/AUR-corex--git-blueviolet.svg?style=flat-square" alt="AUR corex-git" />
    <img src="https://img.shields.io/badge/startup-%3C30ms-brightgreen.svg?style=flat-square" alt="Startup <30ms" />
  </p>
</p>

A fast, zero-bloat CLI multitool and interactive terminal launcher designed so you never have to memorize hundreds of flags, aliases, and one-liner bash scripts again.

Type `cx` to open an interactive `fzf` launcher with live previews for system diagnostics, audio and media tools, Docker and Kubernetes, local AI workflows, and developer utilities. The catalog selects platform-specific implementations automatically.

---

## Key Features

-  **Sub-30ms Startup**: Pure Python standard library with binary configuration caching (`~/.cache/corex/config_cache.pickle`) and lazy runtime imports.
-  **184 Built-in Actions**: Pre-configured, syntax-checked shell routines organized across 15 clean `@category` tags.
-  **Background Job Manager (`cx bg`)**: Inspect jobs started with `--bg`, follow logs, restart, or stop them.
-  **Layered Configuration (`cx custom`)**: Inspect personal actions, field overrides, and disabled actions. Built-in defaults load automatically.
-  **Interactive Wi-Fi Manager (`cx wifi`)**: Fast wireless network scanner, signal meter, and connection manager via NetworkManager on Linux and CoreWLAN on macOS.
-  **Deep Process Forensics (`cx proc`)**: Process inspector with physical RSS/Virtual/Swap breakdown, active sockets/ports, open file descriptors, and interactive signal manager (`SIGKILL`, `SIGTERM`, `SIGSTOP`, `SIGCONT`, renice).
-  **Media & Codec Forensics (`cx media-info`)**: Deep video, audio, and image codec inspection, frame rates, color spaces, and tag extraction via `ffprobe`.
-  **Theme Studio**: 6 built-in color palettes (`catppuccin-mocha`, `tokyonight`, `nord`, `gruvbox`, `dracula`, `rose-pine`) with live ANSI swatches.
-  **Telemetry & Analytics (`cx stats`)**: Track execution frequency, catalog coverage, category distribution, and recent command history.
-  **Instant Cheatsheet Mode (`cx find <query>`)**: Search across all actions, descriptions, categories, and shell commands instantly.
-  **Profile Sync (`cx export` / `cx import`)**: Export and restore your pinned favorites, themes, and custom commands across workstations with automatic backups.
-  **Desktop & WM Integrations (`cx integrations`)**: Native `corex.desktop` application entry and window rules for **Hyprland**, **Sway**, and **i3** on Linux. On macOS, install **CoreX.app** for Finder, Spotlight, and the Dock.
-  **Automated Updater (`cx upgrade`)**: One-command git remote synchronization, shell completion regeneration, cache invalidation, and system doctor audit.
-  **Intelligent Fuzzy Suggestions**: Automatic "Did you mean...?" suggestions with aliases and descriptions when a command is misspelled.
-  **Workstation Toys**: Real-time growing sakura bonsai (`cx bonsai`), typing speed test (`cx type-test`), terminal snake (`cx snake`), digital clock (`cx clock`), cyberpunk matrix (`cx matrix`), system fetch (`cx fetch`), disk visualizer (`cx disks`), hardware sensors (`cx sensors`), stereo DAC audio test (`cx audio-test`), and ephemeral file sharing (`cx share`).
-  **System Doctor (`cx doctor`)**: Automated dependency scanning and shell syntax validator (`bash -n`) with one-click package installation.

---

## Installation

### macOS (Apple Silicon)

Install [Homebrew](https://brew.sh/) and activate it in your shell using the setup command printed by its installer. Then run:

```bash
brew install python fzf
git clone --branch macos-support https://github.com/Darnix-a/CoreX.git
cd CoreX
./install.sh
```

CoreX needs Python 3.11 or newer and fzf 0.63 or newer on both platforms.

Use `cx doctor` to review optional Homebrew packages.

### Arch Linux / CachyOS (PKGBUILD / Paru)

CoreX includes native Arch packaging files in `packaging/`. You can build and install via `paru` or `makepkg`:

```bash
git clone https://github.com/Darnix-a/CoreX.git
cd CoreX/packaging

# Build & install with paru:
paru -Bi .

# Or build & install with makepkg:
makepkg -si
```

*(Note: Direct `paru -S corex-git` will be enabled as soon as Arch Linux AUR re-opens new account registrations).*

### Other Linux distributions

```bash
git clone https://github.com/Darnix-a/CoreX.git
cd CoreX
chmod +x install.sh
./install.sh
```

The installer:
1. Links `cx` and `corex` into `~/.local/bin/`.
2. Creates `~/.config/corex/config.toml` on first install and uses the existing file on subsequent installs.
3. Installs autocompletions for **Fish**, **Bash**, and **Zsh**.
4. Installs the XDG desktop entry to `~/.local/share/applications/corex.desktop`.
5. Verifies the launcher and action catalog. Run `cx doctor --dry-run` to audit action dependencies and syntax.

---

## macOS action behavior

Both systems expose the same stock action IDs. On macOS, `config.macos.toml` adapts the Linux-oriented IDs to the following tools and workflows.

| Workflow | macOS implementation |
| --- | --- |
| Wi-Fi and networking | CoreWLAN scan with signal and channel data, Wi-Fi status and radio controls, personal-network join, DNS and PF diagnostics, route and socket inspection. Use `cx wifi settings` for hidden, enterprise, or managed networks. |
| Processes, logs, and services | BSD `ps` and `lsof`, interactive signals and renice, Unified Log, `launchctl`, and Mach memory data. Some process details require additional privileges. |
| Disk and snapshots | APFS and Time Machine snapshots, volume verification, and disk telemetry. Use Time Machine to restore files. |
| GPU and display | Apple Silicon `powermetrics`, display refresh-rate selection, mirroring and extending the display, offscreen Metal benchmark, and optional MoltenVK tools. macOS activates Game Mode for supported full-screen games. |
| Audio and media | Core Audio playback and device details, Audio MIDI Setup, a recording noise-gate filter, Apple Music and Spotify metadata when Automation permission is granted, and the macOS pasteboard. |
| Updates | `cx sys-update` updates Homebrew packages. `cx sys-update --os` opens Apple Software Update. `cx sys-update --os --preview` lists macOS updates. |
| Local AI | Ollama model sizing uses unified memory estimates on Apple Silicon. ComfyUI starts with its configured Python environment and uses PyTorch MPS when available. |
| Clipboard and background jobs | `cx clip-hist` browses text copied through CoreX. `--capture` saves the current pasteboard and `--clear` removes CoreX history. `cx --bg` logs detached actions under `~/.local/share/corex/logs/`. |

macOS reports nine stock actions as unavailable: `cuda-purge`, `gpu-clock`, `cpu-turboboost`, `journal-vacuum`, `shader-cache-purge`, `hugepages-toggle`, `fstrim-all`, `swap-compact`, and `gamescope-run`. The launcher, `cx --list`, and `cx doctor` show the status, and direct invocation explains the platform limitation.

Custom actions can set macOS-specific fields under `[commands.<id>.macos]`. Custom action scripts run in Bash, so they can also check the host with `uname`. Configuration, profiles, notes, and favorites use the same paths and formats across Linux and macOS.

## How to Use

### 1. Interactive Launcher Menu
Simply run:
```bash
cx
```
- Type to fuzzy-search across the workstation catalog.
- Filter directly by category tag:
  - `@pinned` — Pinned favorite actions (hit `Tab` to toggle favorites)
  - `@daily` — Daily driver tools, clipboard, notes, todo, stats, disk visualizer
  - `@ai` — ComfyUI boot/sync, Ollama VRAM drop/models, AI Copilot (`ask`)
  - `@audio` — Media forensics (`media-info`), PipeWire patching, streaming YouTube audio to mpv, FLAC rippers
  - `@gpu` — GPU clocks, power limits, displays, GameMode, thermals
  - `@kernel` — Hardware interrupts (`irq-top`), dmesg, kmods, sysctl, cgroups
  - `@mem` — RAM forensic breakdown, hugepages, zRAM, BTRFS scrub, TRIM
  - `@netflow` — Socket summary, ports, DNS leak test, tcpdump
  - `@dsp` — Audio tone generators, PipeWire link picker, latency test
  - `@docker` — Containers, compose up/down, logs, podman, k8s
  - `@code` — Regex tester, JSON formatter, git diff patches, sqlite browser
  - `@sys` — Process forensics (`proc`), BTRFS snapper snapshots, fkill, orphaned packages, journal vacuum
  - `@net` — Interactive Wi-Fi manager (`wifi`), public IP card, VPN toggle, SSH picker, local HTTP server
  - `@dev` — Git branch switcher, stash pop, squasher, cheat sheets

### 2. TUI Hotkeys
While inside `cx`:
- `Enter` — Execute highlighted action
- `Tab` — Toggle Pin/Favorite status live (starred `★ ` at top of menu)
- `Ctrl+N` — Open In-App Command Builder to register a new action
- `Ctrl+R` — Invalidate cache and reload command matrix in-place
- `Ctrl+Y` — Copy the shell command to the clipboard
- `Ctrl+E` — Open command in `$EDITOR` before executing
- `Ctrl+D` — Preview command safely via `--dry-run`
- `?` — Toggle preview pane on/off

### 3. Fast Cheatsheet & Search
Need a quick command without opening the full interactive TUI?
```bash
cx find audio             # Search for all actions relating to audio
cx find gpu               # Search GPU monitoring and tuning commands
cx find docker            # Search container management commands
```

### 4. Telemetry & Analytics Dashboard
Inspect your workstation usage patterns and catalog coverage:
```bash
cx stats                  # View execution counts, frequency bars, and top categories
cx stats --reset          # Clear execution history
```

### 5. Profile Export & Import (Multi-Machine Sync)
Sync your customized setup across machines:
```bash
# Export personal settings, favorites, and action overrides:
cx export ~/.config/corex/my-profile.json
cx export --full ~/.config/corex/catalog.json

# Restore on a new machine (creates safety backup automatically):
cx import ~/.config/corex/my-profile.json
```

### 6. Desktop & Window Manager Integrations
Install a desktop launcher. On Linux it appears in freedesktop application menus such as Rofi, KDE, and GNOME. On macOS it opens CoreX in Terminal.
```bash
cx install-desktop
```



### 7. Background jobs

```bash
cx --bg serve-dir
cx bg
cx bg list
cx bg logs serve-dir
cx bg logs serve-dir --no-follow
cx bg status serve-dir
cx bg restart serve-dir
cx bg stop serve-dir
```

Jobs use predictable `corex-<action>.service` names. Starting an active action again displays its PID, state, and start time. In the picker, Enter follows logs, Ctrl+S shows status, Ctrl+R restarts, and Ctrl+X stops the job.

Linux uses transient systemd user services when a systemd user session is available. macOS and Linux without a systemd user session use a detached CoreX worker. Finished and failed jobs leave the active list on both backends. Linux systemd logs use the user journal. Detached workers append logs to `~/.local/share/corex/logs/`.

### 8. Custom actions and overrides

`~/.config/corex/config.toml` can contain just your changes. Override a built-in field or disable a built-in by action ID:

```toml
[commands.calc]
description = "My calculator"

[commands.demucs-stems]
disabled = true
```

`cx custom` opens the custom action browser. Use `cx custom --list` for tab-delimited output or `cx new` to create an action. Older configs that copied the stock catalog still load. Unedited copies of built-in fields are ignored when listing personal overrides.

### 9. Automated Self-Updater
Keep your CoreX installation synchronized with the latest upstream features:
```bash
cx upgrade                # Pull from git, rebuild completions, refresh cache & verify doctor
cx upgrade --dry-run      # Preview update steps without modifying local files
```


## Configuration & Command Builder

### In-App Command Builder Wizard
Add your own actions without touching TOML syntax:
```bash
cx new [action-name]
```
The interactive wizard guides you through:
1. Specifying command ID, category, and description.
2. Automated shell syntax validation (`bash -n`).
3. Automatic binary dependency detection (e.g., `ffmpeg`, `curl`).
4. Instant live execution testing.
5. Saving directly to `~/.config/corex/config.toml` and regenerating shell completions.

### Manual Configuration
CoreX configurations live at `~/.config/corex/config.toml`:
```toml
[general]
editor = "nvim"
theme = "catppuccin-mocha"
color = true

[commands.nas-sync]
category = "Daily Driver Quality-of-Life & Crypto/Files"
description = "Synchronize local documents to home NAS via rsync"
command = "rsync -avz --delete ~/Documents/ nas:/volume1/backups/"
preview_cmd = "df -h /mnt/nas"
requires_sudo = false
confirm = true
deps = ["rsync"]
```

---

## System Doctor & Dependency Audit

Audit the action catalog and install missing dependencies using the detected package manager:
```bash
cx doctor                 # Audit command matrix, shell syntax, and dependencies
cx doctor -y              # Automatically install all missing packages
cx doctor --dry-run       # Dry-run audit without making any system changes
```

Supported package managers include Homebrew (macOS), pacman (Arch/CachyOS), apt (Debian/Ubuntu), dnf (Fedora/RHEL), zypper (openSUSE), apk (Alpine), and xbps (Void).

---

## Terminal Demonstrations (VHS)

Recorded with [Charm VHS](https://github.com/charmbracelet/vhs):

<p align="center">
  <img src="docs/vhs/launcher.gif" alt="CoreX Interactive Launcher Demo" width="800" />
</p>

| Sakura Zen Garden (`cx bonsai`) | Theme Studio (`cx theme`) |
|:---:|:---:|
| <img src="docs/vhs/bonsai.gif" width="420" /> | <img src="docs/vhs/theme.gif" width="420" /> |

To re-record or customize the demo tapes:
```bash
vhs docs/vhs/launcher.tape
vhs docs/vhs/bonsai.tape
vhs docs/vhs/theme.tape
```

---

## Uninstallation

To completely uninstall CoreX (binaries, desktop entries, completions, configurations, and cache):
```bash
chmod +x uninstall.sh
./uninstall.sh
```

To uninstall CoreX and preserve the Git checkout:
```bash
./uninstall.sh --keep-folder
```

## Development checks

Run these from the checkout:

```bash
python3 -m py_compile corex corex_bg.py corex_macos.py
bash -n install.sh
bash -n uninstall.sh
python3 -m unittest discover -s tests -v
```

GitHub Actions runs the tests on Linux and Apple Silicon macOS. Hardware-dependent Wi-Fi, audio, displays, and power actions require a physical Mac and the relevant system permissions.

---

## License

Released under the [MIT License](LICENSE). Built with zero external Python dependencies for maximum performance and portability.
