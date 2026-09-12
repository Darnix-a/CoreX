# CoreX (`cx`) — 75+ Command Mission-Control Workstation Engine

```
   ______                     _  __
  / ____/____   _____ ___     | |/ /
 / /    / __ \ / ___// _ \    |   / 
/ /___ / /_/ // /   /  __/   /   |  
\____/ \____//_/    \___/   /_/|_|  v2.0.0 WORKSTATION COCKPIT
──────────────────────────────────────────────────────────────────
```

An elite, blazingly fast, modular terminal workstation engine that transforms your Linux terminal into an exhaustive mission-control cockpit. Engineered specifically for power users (CachyOS/Arch, Hyprland, Fish/Bash/Zsh, Nvidia GPU, BTRFS/Snapper, Dev & AI workflows).

Powered by a **declarative TOML architecture**, **two-tier interactive `fzf` navigation**, dynamic live ANSI preview panes, and **zero-latency direct subshell dispatch**.

---

## ⚡ Key Architectural Capabilities

1. **Zero-Latency Direct Dispatch**:
   - Running `cx <command> [args...]` bypasses all interactive TUI layers and dispatches immediately via subshell execution (<5ms overhead).
2. **Two-Tier Mission-Control Navigation**:
   - Running `cx` without arguments launches a lightning-fast two-tier interactive `fzf` UI:
     - **Tier 1**: Select from 7 strict workflow categories or `[★ All Commands (Global Search)]`.
     - **Tier 2**: Fuzzy-search commands within the category with live dynamic ANSI side-by-side previews (`--preview`).
3. **Declarative TOML Engine (`~/.config/corex/config.toml`)**:
   - Every single command is registered declaratively with:
     - `category`, `description`, `command`, `preview_cmd`, `requires_sudo`, `confirm`, and `deps`.
   - Any command can be edited, swapped with custom shell scripts, or extended without touching Python source code.
4. **Dependency Health Checks**:
   - Binary dependencies are checked dynamically. Missing tools are flagged with clear warnings in previews rather than crashing.
5. **System & Shell Integration**:
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

The installer verifies your dependencies, symlinks `cx` to `~/.local/bin/cx`, initializes `~/.config/corex/config.toml`, and configures completions for Fish, Bash, and Zsh.

---

## 🎛️ Complete 75-Command Catalog

### 1. [AI, CUDA & Deep Learning] (12 Commands)

| Command | Description | Action / Flags |
|---|---|---|
| `cx comfy-boot` | One-click ComfyUI launcher | Checks venv, port 8188, sets `expandable_segments`, optimal VRAM flag, notifies & opens browser |
| `cx comfy-nuke` | Kill ComfyUI & rogue Torch memory holders | Force-kills zombie Python processes holding port 8188 |
| `cx comfy-sync` | Parallel git-pull across ComfyUI & nodes | Syncs core ComfyUI and every installed `custom_nodes` repo |
| `cx model-symlink` | Interactive safetensors model symlinker | Fuzzy-picks `.safetensors` in cwd/Downloads and links into target ComfyUI model subfolder |
| `cx ollama-up` | Start Ollama inference daemon | Boots systemd service or background daemon |
| `cx ollama-ps` | Display loaded models in GPU memory | Live table of active LLMs, VRAM footprint, and expiration |
| `cx ollama-drop` | Evict all active LLMs from VRAM | Instantly frees GPU memory buffers (`keep_alive=0`) |
| `cx ollama-fzf` | Interactive model runner / chat | Fuzzy-selects locally pulled model and launches CLI session |
| `cx hf-download` | Fast HuggingFace downloader | Multithreaded chunked resume via `aria2c` |
| `cx civit-grab` | Civitai model / LoRA downloader | Downloads checkpoint/LoRA with optional SHA256 validation |
| `cx vram-watch` | 1000ms live VRAM & GPU dashboard | Per-process GPU memory, power draw, and temperature |
| `cx cuda-purge` | Terminate orphaned CUDA processes | Scans `/dev/nvidia*` file handles and nukes orphaned holders |

### 2. [Media, Audio & PipeWire Power-Tools] (13 Commands)

| Command | Description | Action / Flags |
|---|---|---|
| `cx stream-yt` | YouTube audio streamer | Fuzzy search via `yt-dlp` metadata; stream into `mpv --no-video` |
| `cx stream-video` | 1440p/4K hardware-accelerated video | Streams YouTube video directly into borderless mpv with HW-dec |
| `cx stream-radio` | Endless lo-fi & ambient radio | Curated stations (Lofi Girl, Nightwave Plaza, SomaFM Groove Salad) |
| `cx rip-flac` | Batch 24-bit FLAC audio ripper | Multithreaded extraction from `.mp4`, `.mkv`, `.webm` to pristine FLAC |
| `cx rip-opus` | Fast high-efficiency Opus ripper | Converts video/audio files to 160kbps Opus |
| `cx trim-video` | Lossless video cutter | Stream copy (`-c copy`) with start/end timestamps, no re-encoding |
| `cx make-gif` | Palette-optimized GIF converter | High-fidelity two-pass palettegen GIF from video segment |
| `cx demucs-stems` | 4-stem audio demixer | Demixes audio into Vocals, Drums, Bass, Other via Demucs |
| `cx pw-restart` | One-key audio stack reboot | Reboots PipeWire, WirePlumber, and pipewire-pulse daemons |
| `cx pw-devices` | Interactive audio output switcher | Fuzzy-select and switch default audio sink on the fly via `wpctl` |
| `cx pw-volume` | Master audio volume fader | Set master channel volume percentage via CLI |
| `cx tag-editor` | Audio metadata inspector | Displays audio tags, codecs, and container info via `ffprobe` |
| `cx cover-extract` | Album art extractor | Extracts embedded ID3/FLAC cover art into `cover.jpg` |

### 3. [Gaming, Hardware & Display Orchestration] (8 Commands)

| Command | Description | Action / Flags |
|---|---|---|
| `cx gpu-clock` | GPU power & persistence toggle | Toggles persistence mode and manages power limits via `nvidia-smi` |
| `cx cpu-gov` | Interactive CPU governor picker | Switch between `performance`, `powersave`, and `schedutil` |
| `cx cpu-turboboost` | Toggle Intel/AMD Turbo Boost | Hardware-level enable/disable for thermal and clock headroom |
| `cx mon-res` | Monitor refresh rate & resolution toggle | Inspect and configure displays via compositor (`hyprctl`) |
| `cx mon-dual` | Dual-monitor arrangement preset | Applies dual-display workspace layout preset |
| `cx mon-single` | Enforce max refresh on primary OLED | Disables secondary monitor to dedicate GPU bandwidth |
| `cx sens-watch` | Clean ANSI sensor dashboard | Live temperatures for CPU cores, NVMe, and GPU hotspot |
| `cx game-mode` | Activate gaming workstation mode | Sets CPU performance governor, pauses indexers, sets GPU clocks |

### 4. [System Architecture & BTRFS Snapshotting] (9 Commands)

| Command | Description | Action / Flags |
|---|---|---|
| `cx snap-now` | Instant Snapper/BTRFS root snapshot | Captures labeled timestamped snapshot with user comment |
| `cx snap-fzf` | Interactive snapshot browser | Inspect past snapshots, view diffs, and generate rollback commands |
| `cx snap-clean` | Prune old snapshots | Cleans timeline and number-based old system snapshots |
| `cx fkill` | Interactive multi-select process killer | Shows PID, User, CPU%, MEM%, with SIGTERM, SIGKILL (-9), SIGHUP |
| `cx disk-space` | Visual disk usage explorer | Interactive storage breakdown via `ncdu`, `dust`, or `df` |
| `cx pkg-orphans` | Clean orphaned packages & cache | Scans and purges unneeded pacman package dependencies |
| `cx service-fail` | List failed systemd services | Displays failed system and user units (`systemctl --failed`) |
| `cx journal-vacuum` | Trim journal logs under 200MB | Reclaims disk space from bloated systemd logs |
| `cx boot-analyze` | Profile kernel & userspace boot time | Profiles startup latency via `systemd-analyze blame` |

### 5. [Network, VPN & Remote Infrastructure] (9 Commands)

| Command | Description | Action / Flags |
|---|---|---|
| `cx my-ip` | Network interface & Public IP card | Shows Public IP, Local IPs, Gateway, ISP, Geo-coordinates |
| `cx vpn-up` | Interactive VPN profile selector | Fuzzy-connects WireGuard / OpenVPN profiles |
| `cx vpn-down` | Disconnect all VPN tunnels | Cleans interfaces and restores DNS leak settings |
| `cx port-audit` | Open listening port audit | Shows open ports (`ss -tulpn`) with one-key process termination |
| `cx speed-check` | Network speed & latency test | Fast throughput and ping latency test |
| `cx lan-scan` | Local subnet device scan | ARP scan of local network with MAC vendor identification |
| `cx ssh-fzf` | Interactive SSH host selector | Pulls hosts from `~/.ssh/config` for instant connection |
| `cx serve-dir` | Instant ad-hoc HTTP file server | Hosts current directory on port 8000 with terminal QR code |
| `cx dns-flush` | Flush local DNS cache | Clears `systemd-resolved` DNS cache |

### 6. [Git, Dev & Code Utilities] (9 Commands)

| Command | Description | Action / Flags |
|---|---|---|
| `cx git-branch-fzf` | Fuzzy Git branch switcher | Interactive branch selector with live commit graph preview |
| `cx git-squash` | Interactive commit squasher | Combines the last N commits into a single clean commit |
| `cx git-stash-pop` | Fuzzy stash browser | Interactive stash picker with unified diff preview |
| `cx git-clean-branches` | Prune merged local branches | Safely removes local branches merged into master/main |
| `cx docker-fzf` | Container mission control | Tail logs (`Enter`), restart (`Ctrl-R`), stop (`Ctrl-K`), shell (`Ctrl-E`) |
| `cx docker-prune` | Clean dangling Docker resources | Wipes unused images, dangling volumes, and stopped containers |
| `cx venv-init` | One-key Python `.venv` setup | Creates `.venv`, activates it, and upgrades `pip` |
| `cx cheat` | Interactive cheatsheet lookup | Queries `cht.sh` community programming cheatsheets |
| `cx hex-view` | Terminal binary hex dump | Inspects raw bytes and ASCII side-by-side |

### 7. [Daily Driver Quality-of-Life & Crypto/Files] (15 Commands)

| Command | Description | Action / Flags |
|---|---|---|
| `cx clip-hist` | Fuzzy clipboard history | Search clipboard history and copy selection to active buffer |
| `cx qr-gen` | Terminal ANSI QR code generator | Generates crisp ANSI UTF-8 QR code from any string or URL |
| `cx qr-read` | QR code screen/file scanner | Decodes QR codes from screenshots or local image files |
| `cx tar-pack` | Interactive archive creator | Compresses files/folders into high-ratio `.tar.zst`, `.tar.gz`, or `.zip` |
| `cx tar-unpack` | Universal archive extractor | Automatically detects and extracts compressed archives |
| `cx hash-check` | Checksum calculator & verifier | Computes SHA256 & MD5 hashes with match verification |
| `cx weather` | Minimalist terminal weather forecast | Clean ANSI forecast for current location via `wttr.in/?0` |
| `cx calc` | Mathematical evaluator | Evaluates expressions with `sqrt`, `sin`, `cos`, `pi`, `log`, etc. |
| `cx timer` | Countdown timer with progress bar | Graphical bar countdown with audio chime & desktop notification |
| `cx stopwatch` | Precision terminal stopwatch | Milliseconds precision stopwatch with split times |
| `cx notes` | Timestamped scratchpad | Opens markdown scratchpad in `$EDITOR` saved to `~/.local/share/corex/notes/` |
| `cx todo` | Minimalist task tracker | Interactive checklist stored at `~/.local/share/corex/todo.json` |
| `cx url-short` | Quick URL shortener | Shortens clipboard link via `0x0.st` or TinyURL |
| `cx trash-empty` | Safe trash purge | Displays trash size and performs clean wipe |
| `cx sys-info` | Modern hardware summary card | Clean hardware, kernel, RAM, and GPU VRAM card without bloated ASCII |

---

## 🛠️ Configuration Reference (`~/.config/corex/config.toml`)

Every command is defined declaratively. You can customize existing commands or append your own:

```toml
[commands.my-custom-task]
category = "Daily Driver Quality-of-Life & Crypto/Files"
description = "My specialized automation script"
command = "python3 ~/scripts/backup.py"
preview_cmd = "echo 'Status of last backup:' && cat ~/scripts/backup.log"
requires_sudo = false
confirm = true
deps = ["python3"]
```

### Global Options

```toml
[general]
editor = ""                             # Falls back to $EDITOR, nvim, micro, nano
notes_dir = "~/.local/share/corex/notes"
todo_file = "~/.local/share/corex/todo.json"
color = true

[ai]
comfyui_path = "~/ComfyUI"
comfyui_venv = "venv"
comfyui_port = 8188
comfyui_host = "127.0.0.1"
vram_high_threshold_mb = 8192          # MiB for --highvram
vram_low_threshold_mb = 4096           # MiB for --lowvram
comfyui_auto_browser = true
comfyui_notify = true
ollama_url = "http://127.0.0.1:11434"
```

---

## ⌨️ Interactive Keybindings Cheat Sheet

| Screen | Key | Description |
|---|---|---|
| **Tier 1 (Category Selection)** | `Enter` | Choose category to enter Tier 2 |
| **Tier 1 (Category Selection)** | `Esc` / `Ctrl-C` | Exit CoreX cleanly |
| **Tier 2 (Command Search)** | `Enter` | Execute selected command |
| **Tier 2 (Command Search)** | `Esc` | Return to Tier 1 category selector |
| **Docker (`cx docker-fzf`)** | `Enter` | Stream live trailing logs (`docker logs -f --tail 100`) |
| **Docker (`cx docker-fzf`)** | `Ctrl-R` | Restart container |
| **Docker (`cx docker-fzf`)** | `Ctrl-K` | Stop container |
| **Docker (`cx docker-fzf`)** | `Ctrl-E` | Open interactive shell inside container |
| **Process Killer (`cx fkill`)** | `Tab` | Multi-select processes |
| **Process Killer (`cx fkill`)** | `Enter` | Send `SIGTERM` (-15) |
| **Process Killer (`cx fkill`)** | `Ctrl-X` | Send `SIGKILL` (-9) |
| **YouTube Streamer (`cx stream-yt`)** | `Ctrl-Y` | Copy stream URL to clipboard |
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
