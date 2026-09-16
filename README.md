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
    <b>The Modular CLI Multitool, Terminal Launcher & Workstation Engine for Modern Linux</b>
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

Type `cx` and instantly launch an interactive `fzf` menu featuring live preview panes for GPU overclocking & thermals, PipeWire routing, Docker & Kubernetes management, Linux kernel diagnostics, local AI copilot workflows (ComfyUI & Ollama), and everyday developer utilities.

---

## Key Features

- ⚡ **Sub-30ms Startup**: Pure Python standard library with binary configuration caching (`~/.cache/corex/config_cache.pickle`) and lazy runtime imports.
- 🎯 **175+ Built-in Workstation Actions**: Pre-configured, syntax-checked shell routines organized across 15 clean `@category` tags.
- 🎨 **Theme Studio**: 6 built-in color palettes (`catppuccin-mocha`, `tokyonight`, `nord`, `gruvbox`, `dracula`, `rose-pine`) with live ANSI swatches.
- 📊 **Telemetry & Analytics (`cx stats`)**: Track execution frequency, catalog coverage, category distribution, and recent command history.
- 🔍 **Instant Cheatsheet Mode (`cx find <query>`)**: Search across all actions, descriptions, categories, and shell commands instantly.
- 📦 **Profile Sync (`cx export` / `cx import`)**: Export and restore your pinned favorites, themes, and custom commands across workstations with automatic backups.
- 🖥️ **Desktop & WM Integrations (`cx integrations`)**: Native `corex.desktop` application entry plus ready-to-paste floating window rules for **Hyprland**, **Sway**, and **i3**.
- 🔄 **Automated Updater (`cx upgrade`)**: One-command git remote synchronization, shell completion regeneration, cache invalidation, and system doctor audit.
- 💡 **Intelligent Fuzzy Suggestions**: Automatic "Did you mean...?" suggestions with aliases and descriptions when a command is misspelled.
- 🌳 **Workstation Toys**: Real-time growing sakura bonsai (`cx bonsai`), typing speed test (`cx type-test`), terminal snake (`cx snake`), digital clock (`cx clock`), cyberpunk matrix (`cx matrix`), system fetch (`cx fetch`), disk visualizer (`cx disks`), hardware sensors (`cx sensors`), stereo DAC audio test (`cx audio-test`), and ephemeral file sharing (`cx share`).
- 🩺 **System Doctor (`cx doctor`)**: Automated dependency scanning and shell syntax validator (`bash -n`) with one-click package installation.

---

## Installation

### Method 1: Arch Linux / CachyOS (AUR)

CoreX is packaged for Arch-based distributions:

```bash
# Using paru:
paru -S corex-git

# Using yay:
yay -S corex-git
```

### Method 2: One-Line Git Clone (Universal Linux)

```bash
git clone https://github.com/Darnix-a/CoreX.git
cd CoreX
chmod +x install.sh
./install.sh
```

The installer:
1. Links `cx` and `corex` into `~/.local/bin/`.
2. Generates initial configuration at `~/.config/corex/config.toml`.
3. Installs autocompletions for **Fish**, **Bash**, and **Zsh**.
4. Installs the XDG desktop entry to `~/.local/share/applications/corex.desktop`.
5. Verifies syntax and dependencies via `cx doctor`.

---

## How to Use

### 1. Interactive Launcher Menu
Simply run:
```bash
cx
```
- Type to fuzzy-search across all 175+ workstation actions.
- Filter directly by category tag:
  - `@pinned` — Pinned favorite actions (hit `Tab` to toggle favorites)
  - `@daily` — Daily driver tools, clipboard, notes, todo, stats, disk visualizer
  - `@ai` — ComfyUI boot/sync, Ollama VRAM drop/models, AI Copilot (`ask`)
  - `@audio` — PipeWire patching, streaming YouTube audio to mpv, FLAC rippers
  - `@gpu` — GPU clocks, power limits, displays, GameMode, thermals
  - `@kernel` — Hardware interrupts (`irq-top`), dmesg, kmods, sysctl, cgroups
  - `@mem` — RAM forensic breakdown, hugepages, zRAM, BTRFS scrub, TRIM
  - `@netflow` — Socket summary, ports, DNS leak test, tcpdump
  - `@dsp` — Audio tone generators, PipeWire link picker, latency test
  - `@docker` — Containers, compose up/down, logs, podman, k8s
  - `@code` — Regex tester, JSON formatter, git diff patches, sqlite browser
  - `@sys` — BTRFS snapper snapshots, fkill, orphaned packages, journal vacuum
  - `@net` — Public IP card, VPN toggle, SSH picker, local HTTP server
  - `@dev` — Git branch switcher, stash pop, squasher, cheat sheets

### 2. TUI Hotkeys
While inside `cx`:
- `Enter` — Execute highlighted action
- `Tab` — Toggle Pin/Favorite status live (starred `★ ` at top of menu)
- `Ctrl+N` — Open In-App Command Builder to register a new action
- `Ctrl+R` — Invalidate cache and reload command matrix in-place
- `Ctrl+Y` — Copy underlying shell command to clipboard (`wl-copy` / `xclip`)
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
# Export preferences, pinned items, and custom commands:
cx export ~/.config/corex/my-profile.json

# Restore on a new machine (creates safety backup automatically):
cx import ~/.config/corex/my-profile.json
```

### 6. Desktop & Window Manager Integrations
Add CoreX to your application launcher (Rofi, Wofi, Walker, Fuzzel, KDE, GNOME):
```bash
cx install-desktop
```

Display ready-to-paste floating window rules and keybindings:
```bash
cx integrations
```

#### Hyprland Setup (`~/.config/hypr/hyprland.conf`):
```ini
# Floating launcher window rules for CoreX
windowrulev2 = float, class:^(corex-launcher)$
windowrulev2 = size 1020 650, class:^(corex-launcher)$
windowrulev2 = center, class:^(corex-launcher)$
windowrulev2 = dimaround, class:^(corex-launcher)$

# Global Hotkey (Mod + Space)
bind = $mainMod, Space, exec, kitty --class corex-launcher -e cx
```

#### Sway / i3 Setup (`~/.config/sway/config`):
```ini
for_window [app_id="corex-launcher"] floating enable, resize set 1020 650, move position center
bindsym $mod+space exec kitty --class corex-launcher -e cx
```

### 7. Automated Self-Updater
Keep your CoreX installation synchronized with the latest upstream features:
```bash
cx upgrade                # Pull from git, rebuild completions, refresh cache & verify doctor
cx upgrade --dry-run      # Preview update steps without modifying local files
```

### 8. Workstation Toys & Terminal Diversions
CoreX includes interactive, zero-dependency terminal utilities:
```bash
cx bonsai                 # Interactive growing sakura/bonsai tree with duration selection
cx type-test              # Terminal typing speed and accuracy benchmark (WPM / CPM)
cx snake                  # Classic retro snake game in pure ANSI
cx clock                  # Minimalist fullscreen terminal digital clock
cx matrix                 # Cyberpunk digital rain matrix animation
cx fetch                  # Clean system fetch with the CoreX ASCII logo
cx disks                  # Visual disk usage overview with colored percentage meters
cx sensors                # Real-time hardware thermal dashboard (CPU, GPU, NVMe)
cx audio-test             # Spatial stereo channel balance and latency test
cx share <file>           # Ephemeral file/paste upload with automatic clipboard link
cx quote                  # UNIX philosophy and hacker zen quotes
cx colors                 # Terminal color test card (ANSI 16, 256 cube, TrueColor)
```

---

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

Verify all 175+ actions and automatically install missing packages for your detected distribution:
```bash
cx doctor                 # Audit command matrix, shell syntax, and dependencies
cx doctor -y              # Automatically install all missing packages
cx doctor --dry-run       # Dry-run audit without making any system changes
```

Supported package managers: `pacman` (Arch/CachyOS), `apt` (Debian/Ubuntu), `dnf` (Fedora/RHEL), `zypper` (openSUSE), and `apk` (Alpine).

---

## Terminal Demonstrations (VHS)

Generate demonstration GIFs of CoreX using [Charm VHS](https://github.com/charmbracelet/vhs):
```bash
cd docs/vhs
vhs launcher.tape         # Interactive menu walkthrough
vhs bonsai.tape           # Live growing sakura bonsai simulation
vhs theme.tape            # Theme studio color switcher
```

---

## Uninstallation

To completely uninstall CoreX (binaries, desktop entries, completions, configurations, and cache):
```bash
chmod +x uninstall.sh
./uninstall.sh
```

To remove binaries and completions while preserving your configurations and notes:
```bash
./uninstall.sh --keep-folder
```

---

## License

Released under the [MIT License](LICENSE). Built with zero external Python dependencies for maximum performance and portability.
