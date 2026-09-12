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

Just type `cx` and you get an interactive `fzf` menu with live preview panes for monitoring your GPU, managing PipeWire audio, running docker/k8s stuff, inspecting kernel/memory, launching AI workflows (ComfyUI / Ollama), and doing daily terminal chores.

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
- `Ctrl+Y` — Copy the raw shell command to your clipboard (`wl-copy` / `xclip`)
- `Ctrl+E` — Open the command in `$EDITOR` before running it
- `Ctrl+D` — Run in `--dry-run` mode so you can see what it actually runs

### 3. Direct Command Execution
You don't have to open the menu every time. Direct commands bypass the UI instantly:
```bash
cx vram-watch             # Live 1s GPU VRAM & power draw
cx comfy-boot             # Auto venv check, free VRAM check, launch ComfyUI
cx ram-breakdown          # Clean forensic RAM stats
cx socket-summary         # TCP/UDP connection summary
cx fkill                  # Interactive process killer
cx snap-now               # Instant BTRFS root snapshot
cx my-ip                  # Local IPs + Public IP + Geo card
cx notes "cool-idea"      # Quick markdown note in $EDITOR
cx doctor                 # Test all 150+ commands & auto-install missing packages
```

### 4. Background Runner (`--bg`)
Want to run something detached as a systemd user service?
```bash
cx --bg stream-radio
cx --bg weather
```
Spawns via `systemd-run --user` so it stays alive cleanly and cleans up when done.

### 5. Dry Run
Not sure what a command does? Preview it safely:
```bash
cx --dry-run btrfs-scrub
```

---

## Add Your Own Commands

Everything is defined in `~/.config/corex/config.toml`. You don't have to touch Python code.

Just add:
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

Now `my-script` instantly shows up in `cx` and in tab completions.

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

