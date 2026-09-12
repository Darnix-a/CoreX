#!/usr/bin/env bash
# ==============================================================================
# CoreX (cx) Automated Installer & Environment Setup
# Tailored for CachyOS / Arch Linux, Hyprland, Fish, Bash, and Zsh.
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
echo -e "${RESET}${GRAY}─────────────────────────────────────────────────────${RESET}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${HOME}/.local/bin"
CONFIG_DIR="${HOME}/.config/corex"
NOTES_DIR="${HOME}/.local/share/corex/notes"
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

REQ_FAILED=0
check_dep "python3" "required" "sudo pacman -S python" || REQ_FAILED=1
check_dep "fzf" "required" "sudo pacman -S fzf" || REQ_FAILED=1
check_dep "mpv" "optional" "sudo pacman -S mpv"
check_dep "ffmpeg" "optional" "sudo pacman -S ffmpeg"
check_dep "yt-dlp" "optional" "sudo pacman -S yt-dlp"
check_dep "nvidia-smi" "optional" "Install nvidia proprietary drivers"
check_dep "snapper" "optional" "sudo pacman -S snapper"
check_dep "docker" "optional" "sudo pacman -S docker"

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

if [ ! -f "${CONFIG_DIR}/config.toml" ]; then
    cp "${SCRIPT_DIR}/config.default.toml" "${CONFIG_DIR}/config.toml"
    echo -e "  [${GREEN}✔${RESET}] Initialized default config at ${CYAN}${CONFIG_DIR}/config.toml${RESET}"
else
    echo -e "  [${GREEN}✔${RESET}] Existing config preserved at ${CYAN}${CONFIG_DIR}/config.toml${RESET}"
fi

# 4. Setup Fish Shell Integrations
if command -v fish >/dev/null 2>&1; then
    echo -e "\n${CYAN}λ${RESET} ${BOLD}Installing Fish Shell Integrations...${RESET}"
    mkdir -p "$FISH_FUNCTIONS"
    mkdir -p "$FISH_COMPLETIONS"

    cp "${SCRIPT_DIR}/shell/cx.fish" "${FISH_FUNCTIONS}/cx.fish"
    cp "${SCRIPT_DIR}/completions/cx.fish" "${FISH_COMPLETIONS}/cx.fish"
    echo -e "  [${GREEN}✔${RESET}] Installed function to ${CYAN}${FISH_FUNCTIONS}/cx.fish${RESET}"
    echo -e "  [${GREEN}✔${RESET}] Installed completions to ${CYAN}${FISH_COMPLETIONS}/cx.fish${RESET}"
fi

# 5. Bash & Zsh completions
echo -e "\n${CYAN}λ${RESET} ${BOLD}Setting up Bash/Zsh completions...${RESET}"
BASH_COMP_DIR="${HOME}/.local/share/bash-completion/completions"
ZSH_COMP_DIR="${HOME}/.zsh/completions"

mkdir -p "$BASH_COMP_DIR"
"${BIN_DIR}/cx" completions bash > "${BASH_COMP_DIR}/cx"
echo -e "  [${GREEN}✔${RESET}] Bash completions written to ${CYAN}${BASH_COMP_DIR}/cx${RESET}"

if [ -d "$HOME/.zsh" ] || command -v zsh >/dev/null 2>&1; then
    mkdir -p "$ZSH_COMP_DIR"
    cp "${SCRIPT_DIR}/completions/_cx" "${ZSH_COMP_DIR}/_cx"
    echo -e "  [${GREEN}✔${RESET}] Zsh completions written to ${CYAN}${ZSH_COMP_DIR}/_cx${RESET}"
fi

# 6. Verification Self-Test
echo -e "\n${CYAN}λ${RESET} ${BOLD}Verifying Installation...${RESET}"
INSTALLED_VER=$("${BIN_DIR}/cx" --version)
echo -e "  [${GREEN}✔${RESET}] CoreX execution verified: ${GREEN}${INSTALLED_VER}${RESET}"

echo -e "\n${GREEN}${BOLD}═════════════════════════════════════════════════════${RESET}"
echo -e "${GREEN}${BOLD}✔ CoreX (cx) successfully installed and configured!${RESET}"
echo -e "${GREEN}${BOLD}═════════════════════════════════════════════════════${RESET}"
echo -e "\nQuick Start:"
echo -e "  • Run ${CYAN}${BOLD}cx${RESET} to open the interactive launcher menu"
echo -e "  • Run ${CYAN}${BOLD}cx comfy${RESET} to auto-detect VRAM and launch ComfyUI"
echo -e "  • Run ${CYAN}${BOLD}cx vram${RESET} to monitor GPU memory & kill zombie processes"
echo -e "  • Run ${CYAN}${BOLD}cx stream <query>${RESET} to search & stream music/video"
echo -e "  • Run ${CYAN}${BOLD}cx scratch${RESET} for timestamped notes in your editor"
echo -e "  • Run ${CYAN}${BOLD}cx --help${RESET} for all commands and options\n"
