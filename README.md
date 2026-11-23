# CoreX (`cx`)

<p align="center">
  <pre>
   ______                     _  __
  / ____/____   _____ ___     | |/ /
 / /    / __ \ / ___// _ \    |   / 
/ /___ / /_/ // /   /  __/   /   |  
\____/ \____//_/    \___/   /_/|_|  v3.3
──────────────────────────────────────────
  </pre>
  <p align="center">
    <b>A Linux terminal launcher and CLI multitool with embedded Kiro scripting</b>
  </p>
  <p align="center">
    <a href="https://github.com/Darnix-a/CoreX/releases/latest"><img src="https://img.shields.io/badge/version-3.3.0-blue.svg?style=flat-square" alt="Latest release, CoreX 3.3.0" /></a>
    <a href="#kiro-scripting"><img src="https://img.shields.io/badge/scripting-Kiro-7c3aed.svg?style=flat-square" alt="Kiro scripting setup" /></a>
    <img src="https://img.shields.io/badge/license-MIT-green.svg?style=flat-square" alt="License MIT" />
    <img src="https://img.shields.io/badge/AUR-corex--git-blueviolet.svg?style=flat-square" alt="AUR corex-git-(soon)" />
  </p>
</p>
  <p align="center">
    <b>AUR Coming soon.</b>
  </p>

A fast, zero-bloat CLI multitool and interactive terminal launcher designed so you never have to memorize hundreds of flags, aliases, and one-liner bash scripts again.

Type `cx` and instantly launch an interactive `fzf` menu featuring live preview panes for GPU overclocking & thermals, PipeWire routing, Docker & Kubernetes management, Linux kernel diagnostics, local AI copilot workflows (ComfyUI & Ollama), and everyday developer utilities.

## Automate CoreX with Kiro

Run [Kiro](https://github.com/Darnix-a/kiro) scripts directly inside CoreX.
Use `.kr` files for one-off commands, register them as custom actions in the
launcher, or run them in the background with `cx bg run`. Scripts can use
`import cx` to read the CoreX version, action catalog, and arguments.

Save this as `status.kr` once you've [installed the shared Kiro interpreter](#kiro-scripting).

```python
import cx

print("CoreX {cx.version} · {len(cx.commands)} actions")
```

```sh
cx kiro ./status.kr
```

---

## Key Features

-  **Sub-30ms Startup**: Pure Python standard library with binary configuration caching (`~/.cache/corex/config_cache.pickle`) and lazy runtime imports.
-  **185+ Built-in Actions**: Pre-configured, syntax-checked shell routines organized across 15 clean `@category` tags.
-  **Interactive Background Unit Manager (`cx bg`)**: Live cockpit for managing transient systemd user daemons (`systemd-run --user`) with real-time log tailing, status inspection, restarts, and stop controls.
-  **Deterministic & Auto-Cleaning Background Tasks (`--bg`)**: Run any action in the background with deterministic unit naming (`corex-<slug>.service`), active duplicate guards, and automatic self-cleaning on completion (`CollectMode=inactive-or-failed`).
-  **Layered Configuration & Custom Actions (`cx custom`)**: Keep lightweight personal configs in `~/.config/corex/config.toml` that cleanly override defaults without copying 180+ commands. Disable built-ins with `disabled = true` and manage custom routines with `cx custom`.
-  **Interactive Wi-Fi Manager (`cx wifi`)**: Fast wireless network scanner, signal meter, and connection manager via `nmcli` and `fzf`.
-  **Deep Process Forensics (`cx proc`)**: Process inspector with physical RSS/Virtual/Swap breakdown, active sockets/ports, open file descriptors, and interactive signal manager (`SIGKILL`, `SIGTERM`, `SIGSTOP`, `SIGCONT`, renice).
-  **Media & Codec Forensics (`cx media-info`)**: Deep video, audio, and image codec inspection, frame rates, color spaces, and tag extraction via `ffprobe`.
-  **Theme Studio**: 6 built-in color palettes (`catppuccin-mocha`, `tokyonight`, `nord`, `gruvbox`, `dracula`, `rose-pine`) with live ANSI swatches.
-  **Telemetry & Analytics (`cx stats`)**: Track execution frequency, catalog coverage, category distribution, and recent command history.
-  **Instant Cheatsheet Mode (`cx find <query>`)**: Search across all actions, descriptions, categories, and shell commands instantly.
-  **Profile Sync (`cx export` / `cx import`)**: Export and restore your personal overrides, custom actions, themes, and favorites across workstations (`--full` for full catalog).
-  **Desktop & WM Integrations (`cx integrations`)**: Native `corex.desktop` application entry plus ready-to-paste floating window rules for **Hyprland**, **Sway**, and **i3**.
-  **Automated Updater (`cx upgrade`)**: One-command git remote synchronization, shell completion regeneration, cache invalidation, and system doctor audit.
-  **Intelligent Fuzzy Suggestions**: Automatic "Did you mean...?" suggestions with aliases and descriptions when a command is misspelled.
-  **Workstation Toys**: Real-time growing sakura bonsai (`cx bonsai`), typing speed test (`cx type-test`), terminal snake (`cx snake`), digital clock (`cx clock`), cyberpunk matrix (`cx matrix`), system fetch (`cx fetch`), disk visualizer (`cx disks`), hardware sensors (`cx sensors`), stereo DAC audio test (`cx audio-test`), and ephemeral file sharing (`cx share`).
-  **System Doctor (`cx doctor`)**: Automated dependency scanning and shell syntax validator (`bash -n`) with one-click package installation.

---

## Installation

### Method 1: Arch Linux / CachyOS (PKGBUILD / Paru)

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
- Type to fuzzy-search across all 180+ workstation actions.
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

### 7. Background Service & Daemon Manager (`cx bg` & `--bg`)
Run long-running processes or servers in the background as transient systemd user units:
```bash
cx --bg ollama-up           # Run action in background via deterministic unit corex-ollama-up.service
cx bg                       # Interactive background service cockpit (tail logs, status, restart, stop)
cx bg list                  # Fast CLI table of running background units with PID, memory, and CPU
cx bg logs <unit>           # Live tail journal logs for a service
cx bg status <unit>         # Inspect full systemd status, invocation ID, and cgroups
cx bg restart <unit>        # Restart background unit
cx bg stop <unit>           # Gracefully stop background unit
```
- **Deterministic Unit Naming**: Background units follow `corex-<slug>.service` naming conventions.
- **Duplicate Guard**: If an action is already active, CoreX displays its active PID, uptime, and management instructions instead of spawning duplicate processes.
- **Auto-Cleanup**: Units automatically unload upon completion or failure (`CollectMode=inactive-or-failed`).

### 8. Custom Actions & Layered Overrides (`cx custom`)
CoreX uses a clean layered configuration system: built-in defaults stay untouched, while your `~/.config/corex/config.toml` holds only personal additions and overrides:
```bash
cx custom                   # List user-defined actions and configuration overrides with interactive launcher
cx custom --list            # Scriptable tab-delimited list of custom actions
cx new [action-name]        # Interactive wizard to create a new action
```
To hide any built-in action without deleting it:
```toml
[commands.demucs-stems]
disabled = true
```

### 9. Automated Self-Updater
Keep your CoreX installation synchronized with the latest upstream features:
```bash
cx upgrade                # Pull from git, rebuild completions, refresh cache & verify doctor
cx upgrade --dry-run      # Preview update steps without modifying local files
```


## Kiro scripting

CoreX has built-in [Kiro](https://github.com/Darnix-a/kiro) support. Install
the shared interpreter once, and CoreX will load it when a `.kr` script runs.

```sh
git clone https://github.com/Darnix-a/kiro.git
cd kiro
./install.sh --embed --no-path
```

Run a script in the foreground or launch it through the background service
manager.

```sh
cx kiro ./check.kr "a value"
cx bg run ./monitor.kr
cx bg logs monitor
```

For a custom action or macro, add a command with the `cx kiro` prefix to
your CoreX TOML config. It receives CoreX's usual action confirmation and
can also run with `cx --bg`.

```toml
[commands.kiro-monitor]
description = "Run a Kiro monitor"
command = "cx kiro '/absolute/path/to/monitor.kr'"
```

Inside a script, `import cx` exposes `cx.command`, `cx.args`,
`cx.version`, `cx.commands`, and `cx.has_command(name)`.
The usual Kiro prelude is available. CoreX prints a top-level return value
as JSON and propagates `exit(code)`. Set `CX_KIRO_LIBRARY` to the
shared library's full path if you used a custom installation prefix.

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

To remove binaries and completions while preserving your configurations and notes:
```bash
./uninstall.sh --keep-folder
```

---

## License

Released under the [MIT License](LICENSE). Built with zero external Python dependencies for maximum performance and portability.
