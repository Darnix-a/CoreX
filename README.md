# CoreX (`cx`)

```
   ______                     _  __
  / ____/____   _____ ___     | |/ /
 / /    / __ \ / ___// _ \    |   / 
/ /___ / /_/ // /   /  __/   /   |  
\____/ \____//_/    \___/   /_/|_|  v3.0
──────────────────────────────────────────
```

A fast, modular CLI multitool and terminal launcher so you don't have to remember 200 different flags, aliases, and one-liner bash scripts.

Just type `cx` and you get an interactive `fzf` menu with live preview panes for monitoring your GPU, managing PipeWire audio, running docker/k8s stuff, inspecting kernel/memory, launching AI workflows (ComfyUI / Ollama), doing daily terminal chores, and much, much more.

Runs in ~40ms with zero bloated python dependencies.

---

## Quick Install

```bash
git clone https://github.com/Darnix-a/CoreX.git
cd CoreX
chmod +x install.sh
./install.sh
```

This symlinks `cx` into `~/.local/bin/cx`, sets up `~/.config/corex/config.toml`, and installs autocompletions for **Fish**, **Bash**, and **Zsh**.

---

## How to Use

### 1. Interactive Menu
Just run:
```bash
cx
```
- Type anything to fuzzy-search across all 150+ actions.
- Filter by category by typing `@tag` directly:
  - `@pinned` — Pinned favorite actions (hit `Tab` to toggle favorites)
  - `@gpu` — GPU clocks, power limits, displays, GameMode
  - `@ai` — ComfyUI boot/sync, Ollama VRAM drop/models, HuggingFace/Civitai fetch
  - `@audio` — PipeWire patching, streaming YouTube audio to mpv, FLAC ripper
  - `@docker` — Containers, compose up/down, logs, podman, k8s
  - `@kernel` — Hardware interrupts (`irq-top`), dmesg, kmods, sysctl, cgroups
  - `@mem` — RAM breakdown, hugepages, zRAM, BTRFS scrub, TRIM
  - `@netflow` — Socket summary, ports, DNS leak test, tcpdump
  - `@dsp` — Audio tone generators, PipeWire link picker, latency test
  - `@code` — Regex tester, JSON formatter, git diff patches, sqlite browser
  - `@sys` — BTRFS snapper snapshots, fkill, orphaned packages, journal vacuum
  - `@net` — Public IP card, VPN toggle, SSH picker, local HTTP server
  - `@dev` — Git branch switcher, stash pop, squasher, cheat sheets
  - `@daily` — Clipboard history, QR codes, timer, stopwatch, notes, todo

### 2. In-Menu Hotkeys
While inside `cx`:
- `Enter` — Run selected command
- `Tab` — Pin or unpin the highlighted action live (starred `★ ` at top of list)
- `Ctrl+N` — Open the In-App Command Builder (make & register a new action on the fly)
- `Ctrl+R` — Reload the action catalog in-place
- `Ctrl+Y` — Copy the raw shell command to your clipboard (`wl-copy` / `xclip`)
- `Ctrl+E` — Open the command in `$EDITOR` before running it
- `Ctrl+D` — Run in `--dry-run` mode so you can see what it actually runs
- `?` — Toggle the action details preview pane

### 3. Themes & Theme Studio
Switch between 6 color palettes (`catppuccin-mocha`, `tokyonight`, `nord`, `gruvbox`, `dracula`, `rose-pine`) with live preview cards:
```bash
cx theme                  # Interactive Theme Studio with live color swatches
cx theme tokyonight       # Switch theme directly and save to config.toml
cx theme --list           # View all available themes and active status
```

### 4. Favorites & Pinning
Pin your most frequent actions to keep them starred at the top of the TUI:
```bash
cx pin trim-video         # Pin action to favorites
cx unpin trim-video       # Remove action from favorites
cx pinned                 # List all pinned favorites
```

### 5. Direct Command Execution
You don't have to open the menu every time. Direct commands bypass the UI instantly:
```bash
cx vram-watch             # Live 1s GPU VRAM & power draw
cx comfy-boot             # Auto venv check, free VRAM check, launch ComfyUI
cx ram-breakdown          # Clean forensic RAM stats
cx socket-summary         # TCP/UDP connection summary
cx fkill                  # Interactive process killer
cx snap-now               # Instant BTRFS root snapshot
cx my-ip                  # Local IPs + Public IP + Geo card
cx speedtest              # Zero-dependency bandwidth benchmark (ping, jitter, download & upload Mbps)
cx notes "cool-idea"      # Quick markdown note in $EDITOR
cx builder                # Open the in-app command builder / studio
cx new                    # Guided wizard to build and add a new action
cx doctor                 # Test all 150+ commands & auto-install missing packages
```

### 6. Background Runner (`--bg`)
Want to run something detached as a systemd user service?
```bash
cx --bg stream-radio
cx --bg weather
```
Spawns via `systemd-run --user` so it stays alive cleanly and cleans up when done.

### 7. Dry Run
Not sure what a command does? Preview it safely:
```bash
cx --dry-run btrfs-scrub
```

---

## In-App Command Builder

Don't want to manually edit TOML files? Just run:
```bash
cx new
```
or press `Ctrl+N` inside the `cx` menu.

The interactive wizard will:
1. Ask for an ID/alias and category tag.
2. Check your shell syntax (`bash -n`) so you don't save broken commands.
3. Automatically detect dependencies (like `curl`, `rsync`, `ffmpeg`).
4. Let you test-run the command right there.
5. Save it into `~/.config/corex/config.toml` and instantly update your shell completions.

Prefer editing TOML directly? It's right at `~/.config/corex/config.toml`:
```toml
[commands.my-script]
category = "Daily Driver Quality-of-Life & Crypto/Files"
description = "Sync my backups to NAS"
command = "rsync -avz ~/Documents/ nas:/backups/"
preview_cmd = "df -h /mnt/nas"
requires_sudo = false
confirm = true
deps = ["rsync"]
```

---

## Dependencies

- **Required**: `python3` (3.11+), `fzf`
- **Optional tools** (used by specific commands):
  - `mpv`, `ffmpeg`, `yt-dlp` (streaming & media)
  - `nvidia-smi` (GPU stats)
  - `snapper`, `btrfs-progs` (snapshots)
  - `docker` / `docker-compose` (containers)
  - `pipewire`, `wireplumber` (audio routing)

If a tool isn't installed on your machine, `cx` simply grays it out or warns you in the preview pane instead of crashing.

---

## Uninstallation

To completely remove CoreX (binaries, shell completions, configurations, data, and this folder):
```bash
chmod +x uninstall.sh
./uninstall.sh
```

To remove all binaries and configurations while preserving the source directory:
```bash
./uninstall.sh --keep-folder
```



