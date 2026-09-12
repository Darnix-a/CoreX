# CoreX (`cx`) — Elite Linux Systems Multitool & Interactive Launcher

```
   ______                     _  __
  / ____/____   _____ ___     | |/ /
 / /    / __ \ / ___// _ \    |   / 
/ /___ / /_/ // /   /  __/   /   |  
\____/ \____//_/    \___/   /_/|_|  v1.0.0
─────────────────────────────────────────────────────
```

An ultra-fast, zero-bloat, modular terminal multitool and launcher CLI engineered for modern Linux power users (CachyOS/Arch, Hyprland, Fish/Bash/Zsh, Nvidia GPU, BTRFS/Snapper, Dev & AI workflows).

Powered by `fzf` with dynamic live side-by-side previews, color-coded ANSI status lines, and zero-latency direct command dispatch.

---

## Highlights & Features

- ⚡ **Blazingly Fast & Zero Bloat**: Standalone Python 3 execution with built-in 24-bit ANSI styling engine. Zero required third-party Python packages.
- 🎯 **Dual-Mode UX**:
  - Run `cx` with no arguments to launch the master interactive `fzf` menu categorized by workflow, with live system previews.
  - Run `cx <cmd> [args]` to immediately execute targeted subcommands with zero UI overhead.
- 🤖 **Dev & AI Stack Automation**:
  - `cx comfy`: One-click ComfyUI launcher. Detects venv, checks GPU VRAM via `nvidia-smi`, dynamically selects `--highvram` or `--lowvram`, launches the server, avoids port collisions, and opens the browser/desktop notification.
  - `cx ai`: Real-time inspection of loaded Ollama/vLLM models in GPU memory, one-click VRAM eviction (`keep_alive=0`), and daemon lifecycle control.
  - `cx docker`: Interactive container manager with live trailing logs, restart (`Ctrl-R`), kill/stop (`Ctrl-K`), and shell execution (`Ctrl-E`).
- 🎵 **Media Engine**:
  - `cx stream [query]`: Instant YouTube & SoundCloud search via `yt-dlp` metadata cache; pipes directly into `mpv` for audio or hardware-accelerated video.
  - `cx rip`: Multithreaded audio extractor targeting `.mp4`, `.mkv`, `.webm` in current directory; converts to pristine 24-bit FLAC or high-bitrate Opus via `ffmpeg`.
  - `cx play [path]`: Fast fuzzy-search player for local music libraries with live `ffprobe` tag previews (Artist, Album, Duration, Bitrate).
- 🛡️ **System Health & Process Killer**:
  - `cx kill [filter]`: Interactive process manager via `fzf` showing PID, User, CPU%, MEM%, and Command; live `/proc/<pid>/status` preview; multi-select (`Tab`) for SIGTERM or SIGKILL (`Ctrl-X`).
  - `cx vram`: Visual breakdown of Nvidia VRAM usage with a colored gauge bar; detects active and zombie/orphaned processes hogging GPU memory with instant force-kill.
  - `cx snap [label]`: One-command BTRFS / Snapper system snapshot helper with timestamping.
- 📝 **Quick Scratchpad**:
  - `cx scratch [title]`: Instant timestamped markdown scratchpad opened in `$EDITOR` (`nvim`, `micro`, `nano`), saved to `~/.local/share/corex/notes/`.
- ⚙️ **Extensible TOML Configuration**:
  - Add your own custom commands in `~/.config/corex/config.toml`; they appear automatically in the interactive menu and can be run via `cx <custom_id>`.
- 🐚 **First-Class Shell Integrations**:
  - Native completions and wrapper function for **Fish Shell** (`~/.config/fish/functions/cx.fish`).
  - Completions for **Bash** and **Zsh**.
- 🛡️ **Dry-Run Mode**:
  - Pass `--dry-run` to any command to inspect the exact shell commands that would be executed.

---

## Installation

Run the automated installer script:

```bash
git clone <repo-url> ~/Documents/programming/CX
cd ~/Documents/programming/CX
chmod +x install.sh
./install.sh
```

The installer will:
1. Verify system dependencies (`fzf`, `mpv`, `ffmpeg`, `yt-dlp`, `nvidia-smi`, `snapper`, `docker`).
2. Symlink `corex` and `cx` to `~/.local/bin/`.
3. Initialize `~/.config/corex/config.toml` (if not already present).
4. Install the native Fish function (`~/.config/fish/functions/cx.fish`) and completions (`~/.config/fish/completions/cx.fish`).
5. Install Bash and Zsh completions.
6. Verify execution.

---

## Quick Command Reference

| Command | Description | Shortcut / Action |
|---|---|---|
| `cx` | Master interactive `fzf` launcher menu | Browse categories, live previews |
| `cx comfy` | ComfyUI launcher | Auto-detects venv & optimal VRAM flag |
| `cx ai` | Ollama / vLLM model manager | View & unload VRAM models, toggle daemon |
| `cx docker` | Container manager | `Enter` to tail logs, `Ctrl-R` restart, `Ctrl-K` stop |
| `cx stream [query]` | Stream YouTube/SoundCloud | `Enter` audio stream, `Ctrl-V` video, `Ctrl-Y` copy URL |
| `cx rip [path]` | Extract audio from video | Select files (`Tab`), export to 24-bit FLAC / Opus |
| `cx play [path]` | Local music library player | Fuzzy-browse tracks with live `ffprobe` tag preview |
| `cx kill [filter]` | Interactive process killer | `Tab` multi-select, `Enter` SIGTERM, `Ctrl-X` SIGKILL |
| `cx vram` | Nvidia VRAM breakdown | Visual bar, zombie GPU process detection & kill |
| `cx snap [label]` | System snapshot helper | Snapper / BTRFS timestamped snapshot |
| `cx scratch [title]` | Instant markdown scratchpad | Opens note in `$EDITOR` (`micro`/`nvim`/`nano`) |
| `cx completions fish` | Shell completions | Outputs native completion code |

### Common Flags

- `--dry-run`: Preview commands safely without executing them.
  ```bash
  cx --dry-run comfy
  cx --dry-run snap pre-upgrade
  cx --dry-run vram
  ```
- `--config <path>`: Use a custom configuration file.
- `--no-color`: Disable ANSI color formatting.
- `-h`, `--help`: Show usage and help message.
- `-v`, `--version`: Show version.

---

## Interactive Menu Keybindings

When running `cx` or any interactive subcommand with `fzf`:

| Context | Key | Action |
|---|---|---|
| **Global Menu** | `Enter` | Launch selected action |
| **Global Menu** | `Esc` / `Ctrl-C` | Exit cleanly without tracebacks |
| **Docker** | `Enter` | Live trailing logs (`docker logs -f --tail 100`) |
| **Docker** | `Ctrl-R` | Restart selected container |
| **Docker** | `Ctrl-K` | Stop / Kill selected container |
| **Docker** | `Ctrl-E` | Exec shell into container |
| **Stream** | `Enter` | Stream audio via `mpv --no-video` |
| **Stream** | `Ctrl-V` | Stream video with hardware acceleration |
| **Stream** | `Ctrl-Y` | Copy stream URL to clipboard (`wl-copy` / `xclip`) |
| **Rip Audio** | `Tab` | Multi-select video files for batch processing |
| **Process Killer** | `Tab` | Multi-select processes |
| **Process Killer** | `Enter` | Send `SIGTERM` (-15) |
| **Process Killer** | `Ctrl-X` | Send `SIGKILL` (-9) |
| **Process Killer** | `Ctrl-H` | Send `SIGHUP` (-1) |
| **Scratchpad** | `Enter` | Open selected note in `$EDITOR` |
| **Scratchpad** | `Ctrl-D` | Delete selected note |

---

## Configuration (`~/.config/corex/config.toml`)

The configuration file is formatted in TOML and located at `~/.config/corex/config.toml`.

```toml
[general]
editor = ""                            # Text editor (defaults to $EDITOR, nvim, micro, nano)
notes_dir = "~/.local/share/corex/notes"
color = true

[ai]
comfyui_path = "~/ComfyUI"             # Root directory of ComfyUI
comfyui_venv = "venv"                  # Virtual environment folder
comfyui_port = 8188
comfyui_host = "127.0.0.1"
vram_high_threshold_mb = 8192         # MiB to activate --highvram
vram_low_threshold_mb = 4096          # MiB below which to activate --lowvram
comfyui_extra_flags = ["--preview-method", "auto"]
comfyui_auto_browser = true           # Open browser automatically on launch
comfyui_notify = true                 # Send desktop notification via notify-send
ollama_url = "http://127.0.0.1:11434"

[media]
music_dir = "~/Music"
stream_provider = "ytsearch"
stream_results_count = 25
mpv_hwdec = "auto"
rip_format = "flac"                   # "flac" or "opus"
rip_flac_bits = "24"                  # 24-bit PCM
rip_opus_bitrate = "256k"

[system]
snapshot_backend = "auto"             # "auto", "snapper", or "btrfs"
snapper_config = "root"
btrfs_mount = "/"

# Add your custom subcommands here!
# They will appear in the fzf menu and can be run via 'cx <id>'
[custom_commands.update]
name = "System Update"
category = "System & GPU"
description = "Fast system package upgrade via pacman"
command = "sudo pacman -Syu"
preview = "echo 'Performs full Arch / CachyOS package sync and upgrade.'"

[custom_commands.hypr_reload]
name = "Reload Hyprland"
category = "Quick Tools"
description = "Reload Hyprland compositor configuration"
command = "hyprctl reload"
preview = "echo 'Sends reload signal to Hyprland compositor.'"
```

---

## Architecture & Code Structure

```
CX/
├── corex                      # Main executable Python 3 multitool
├── cx                         # Symlink to corex
├── config.default.toml        # Default configuration template
├── install.sh                 # Self-contained installer and validator
├── completions/
│   ├── cx.fish                # Fish shell completions
│   └── _cx                    # Zsh completion definition
└── shell/
    └── cx.fish                # Native Fish function wrapper (~/.config/fish/functions/cx.fish)
```

---

## License

MIT License. Engineered for maximum speed and developer productivity.
