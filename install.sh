#!/usr/bin/env bash
# ==============================================================================
# CoreX (cx) Automated Installer & Environment Setup
# Supports Linux and macOS with Fish, Bash, and Zsh.
# ==============================================================================

set -eo pipefail

BOLD="\033[1m"
GREEN="\033[38;5;46m"
YELLOW="\033[38;5;220m"
CYAN="\033[38;5;51m"
RED="\033[38;5;196m"
GRAY="\033[38;5;244m"
RESET="\033[0m"

echo -e "${CYAN}${BOLD}"
echo "   ______                     _  __"
echo "  / ____/____   _____ ___     | |/ /"
echo " / /    / __ \ / ___// _ \    |   / "
echo "/ /___ / /_/ // /   /  __/   /   |  "
echo "\____/ \____//_/    \___/   /_/|_|  INSTALLER"
echo -e "${RESET}${GRAY}──────────────────────────────────────────────────────────────────${RESET}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${HOME}/.local/bin"
CONFIG_DIR="${HOME}/.config/corex"
NOTES_DIR="${HOME}/.local/share/corex/notes"
PLATFORM="$(uname -s)"
FISH_FUNCTIONS="${HOME}/.config/fish/functions"
FISH_COMPLETIONS="${HOME}/.config/fish/completions"

# 1. Verify Core Dependencies
echo -e "\n${CYAN}λ${RESET} ${BOLD}Verifying System Dependencies...${RESET}"

check_dep() {
    local name="$1"
    local required="$2"
    local install_tip="$3"

    if command -v "$name" >/dev/null 2>&1; then
        echo -e "  [${GREEN}✔${RESET}] ${BOLD}${name}${RESET} is installed ($(command -v "$name"))"
        return 0
    else
        if [ "$required" = "required" ]; then
            echo -e "  [${RED}✖${RESET}] ${BOLD}${name}${RESET} is ${RED}REQUIRED${RESET} but missing! -> ${install_tip}"
            return 1
        else
            echo -e "  [${YELLOW}▲${RESET}] ${BOLD}${name}${RESET} is optional but recommended -> ${install_tip}"
            return 0
        fi
    fi
}

# Detect distro package manager for install hints
if [ "$PLATFORM" = "Darwin" ]; then
    PM_INSTALL="brew install"
    PY_PKG="python"
    if ! command -v brew >/dev/null 2>&1; then
        for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
            if [ -x "$brew_bin" ]; then
                eval "$("$brew_bin" shellenv)"
                break
            fi
        done
    fi
elif command -v pacman >/dev/null 2>&1; then
    PM_INSTALL="sudo pacman -S"
    PY_PKG="python"
elif command -v apt-get >/dev/null 2>&1 || command -v apt >/dev/null 2>&1; then
    PM_INSTALL="sudo apt install"
    PY_PKG="python3"
elif command -v dnf5 >/dev/null 2>&1 || command -v dnf >/dev/null 2>&1; then
    PM_INSTALL="sudo dnf install"
    PY_PKG="python3"
elif command -v zypper >/dev/null 2>&1; then
    PM_INSTALL="sudo zypper install"
    PY_PKG="python3"
elif command -v apk >/dev/null 2>&1; then
    PM_INSTALL="sudo apk add"
    PY_PKG="python3"
elif command -v xbps-install >/dev/null 2>&1; then
    PM_INSTALL="sudo xbps-install -S"
    PY_PKG="python3"
else
    PM_INSTALL="your-package-manager install"
    PY_PKG="python3"
fi

REQ_FAILED=0
check_dep "python3" "required" "${PM_INSTALL} ${PY_PKG}" || REQ_FAILED=1
check_dep "fzf" "required" "${PM_INSTALL} fzf" || REQ_FAILED=1
if command -v python3 >/dev/null 2>&1 && ! python3 -c 'import tomllib' 2>/dev/null; then
    echo -e "  [${RED}✖${RESET}] Python 3.11 or newer is required. Run ${PM_INSTALL} ${PY_PKG}."
    REQ_FAILED=1
fi
if command -v fzf >/dev/null 2>&1 &&
    ! fzf --with-shell='sh -c' --footer='CoreX' --filter=corex <<< corex >/dev/null; then
    echo -e "  [${RED}✖${RESET}] Upgrade fzf to a release with --with-shell and --footer support."
    REQ_FAILED=1
fi
check_dep "mpv" "optional" "${PM_INSTALL} mpv"
check_dep "ffmpeg" "optional" "${PM_INSTALL} ffmpeg"
check_dep "yt-dlp" "optional" "${PM_INSTALL} yt-dlp"
if [ "$PLATFORM" = "Darwin" ]; then
    check_dep "docker" "optional" "Install Docker Desktop or configure another Docker engine"
    if ! xcrun --find swiftc >/dev/null 2>&1; then
        echo "  Xcode Command Line Tools enable Wi-Fi scanning, monitor presets and audio latency."
        echo "  Run xcode-select --install to add those features."
    fi
else
    check_dep "nvidia-smi" "optional" "Install nvidia proprietary drivers"
    check_dep "snapper" "optional" "${PM_INSTALL} snapper"
    check_dep "docker" "optional" "${PM_INSTALL} docker"
fi

if [ $REQ_FAILED -ne 0 ]; then
    echo -e "\n${RED}${BOLD}Error:${RESET} Missing required dependencies. Please install them and rerun install.sh."
    exit 1
fi

# 2. Setup ~/.local/bin and Link Executables
echo -e "\n${CYAN}λ${RESET} ${BOLD}Installing Executables to ${BIN_DIR}...${RESET}"
mkdir -p "$BIN_DIR"
chmod +x "${SCRIPT_DIR}/corex"

ln -sf "${SCRIPT_DIR}/corex" "${BIN_DIR}/corex"
ln -sf "${SCRIPT_DIR}/corex" "${BIN_DIR}/cx"
echo -e "  [${GREEN}✔${RESET}] Symlinked ${CYAN}${BIN_DIR}/corex${RESET} -> ${SCRIPT_DIR}/corex"
echo -e "  [${GREEN}✔${RESET}] Symlinked ${CYAN}${BIN_DIR}/cx${RESET} -> ${SCRIPT_DIR}/corex"

# Verify PATH
if [[ ":$PATH:" != *":${BIN_DIR}:"* ]]; then
    echo -e "  [${YELLOW}▲${RESET}] Note: ${BIN_DIR} is not currently in your active PATH."
    echo -e "      For Fish: run ${CYAN}fish_add_path ~/.local/bin${RESET}"
    echo -e "      For Bash/Zsh: add ${CYAN}export PATH=\"\$HOME/.local/bin:\$PATH\"${RESET} to ~/.bashrc or ~/.zshrc"
fi

# 3. Setup Configuration
echo -e "\n${CYAN}λ${RESET} ${BOLD}Configuring CoreX...${RESET}"
mkdir -p "$CONFIG_DIR"
mkdir -p "$NOTES_DIR"

if [ -f "${CONFIG_DIR}/config.toml" ]; then
    echo -e "  [${GRAY}i${RESET}] Using existing config at ${CONFIG_DIR}/config.toml"
else
    cp "${SCRIPT_DIR}/config.default.toml" "${CONFIG_DIR}/config.toml"
    echo -e "  [${GREEN}✔${RESET}] Installed config at ${CYAN}${CONFIG_DIR}/config.toml${RESET}"
fi

# 4. Setup Fish Shell Integrations
if command -v fish >/dev/null 2>&1; then
    echo -e "\n${CYAN}λ${RESET} ${BOLD}Installing Fish Shell Integrations...${RESET}"
    FISH_CONFD="${HOME}/.config/fish/conf.d"
    mkdir -p "$FISH_FUNCTIONS"
    mkdir -p "$FISH_COMPLETIONS"

    cp "${SCRIPT_DIR}/shell/cx.fish" "${FISH_FUNCTIONS}/cx.fish"
    "${BIN_DIR}/cx" completions fish > "${FISH_COMPLETIONS}/cx.fish"
    rm -f "${FISH_CONFD}/cx_key_bindings.fish"
    echo -e "  [${GREEN}✔${RESET}] Installed function to ${CYAN}${FISH_FUNCTIONS}/cx.fish${RESET}"
    echo -e "  [${GREEN}✔${RESET}] Installed completions to ${CYAN}${FISH_COMPLETIONS}/cx.fish${RESET}"
fi

# 5. Bash & Zsh Shell Integrations & Completions
echo -e "\n${CYAN}λ${RESET} ${BOLD}Setting up Bash/Zsh Integrations...${RESET}"
BASH_COMP_DIR="${HOME}/.local/share/bash-completion/completions"
ZSH_COMP_DIR="${HOME}/.zsh/completions"
COREX_SHARE_DIR="${HOME}/.local/share/corex"

mkdir -p "$BASH_COMP_DIR"
mkdir -p "$COREX_SHARE_DIR"
"${BIN_DIR}/cx" completions bash > "${BASH_COMP_DIR}/cx"
rm -f "${COREX_SHARE_DIR}/cx.bash" "${COREX_SHARE_DIR}/cx.zsh"
echo -e "  [${GREEN}✔${RESET}] Bash completions written to ${CYAN}${BASH_COMP_DIR}/cx${RESET}"

if [ -d "$HOME/.zsh" ] || command -v zsh >/dev/null 2>&1; then
    mkdir -p "$ZSH_COMP_DIR"
    "${BIN_DIR}/cx" completions zsh > "${ZSH_COMP_DIR}/_cx"
    echo -e "  [${GREEN}✔${RESET}] Zsh completions written to ${CYAN}${ZSH_COMP_DIR}/_cx${RESET}"
fi

# 6. Desktop launcher
echo -e "\n${CYAN}λ${RESET} ${BOLD}Installing Desktop Launcher...${RESET}"
"${BIN_DIR}/cx" install-desktop

# 7. Verification Self-Test
echo -e "\n${CYAN}λ${RESET} ${BOLD}Verifying Installation...${RESET}"
INSTALLED_VER=$("${BIN_DIR}/cx" --version)
CMD_COUNT=$("${BIN_DIR}/cx" --list | wc -l)
echo -e "  [${GREEN}✔${RESET}] CoreX execution: ${GREEN}${INSTALLED_VER}${RESET}"
echo -e "  [${GREEN}✔${RESET}] Registered Commands: ${GREEN}${CMD_COUNT} actions loaded${RESET}"

echo -e "\n${GREEN}${BOLD}══════════════════════════════════════════════════════════════════${RESET}"
echo -e "${GREEN}${BOLD}✔ CoreX (cx) successfully deployed!${RESET}"
echo -e "${GREEN}${BOLD}══════════════════════════════════════════════════════════════════${RESET}"
echo -e "\nQuick Start:"
echo -e "  • Run ${CYAN}${BOLD}cx${RESET} to open the interactive menu (type ${YELLOW}@tag${RESET} to filter)"
echo -e "  • Favorites: Highlight any action and press ${CYAN}${BOLD}Tab${RESET} in TUI to Pin/Unpin (filter with ${YELLOW}@pinned${RESET})"
echo -e "  • Themes: Run ${CYAN}${BOLD}cx theme${RESET} to preview and switch between 6 color themes"
echo -e "  • Run ${CYAN}${BOLD}cx <command>${RESET} for zero-latency direct execution (e.g. ${CYAN}cx comfy-boot${RESET}, ${CYAN}cx vram-watch${RESET})"
echo -e "  • Run ${CYAN}${BOLD}cx --dry-run <command>${RESET} to preview actions safely"
echo -e "  • Run ${CYAN}${BOLD}cx --bg <command>${RESET} to detach into a background process"
echo -e "  • Run ${CYAN}${BOLD}cx --list${RESET} to inspect all registered actions"
echo -e "  • Run ${CYAN}${BOLD}cx --help${RESET} for full documentation\n"
