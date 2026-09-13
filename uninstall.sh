#!/usr/bin/env bash
# ==============================================================================
# CoreX (cx) Automated Uninstaller & Complete Cleanup
# Removes all binaries, shell completions, configurations, user data,
# and the main CoreX directory.
# ==============================================================================

set -eo pipefail

BOLD="\033[1m"
GREEN="\033[38;5;46m"
YELLOW="\033[38;5;220m"
CYAN="\033[38;5;51m"
RED="\033[38;5;196m"
GRAY="\033[38;5;244m"
RESET="\033[0m"

echo -e "${RED}${BOLD}"
echo "   ______                     _  __"
echo "  / ____/____   _____ ___     | |/ /"
echo " / /    / __ \ / ___// _ \    |   / "
echo "/ /___ / /_/ // /   /  __/   /   |  "
echo "\____/ \____//_/    \___/   /_/|_|  UNINSTALLER"
echo -e "${RESET}${GRAY}──────────────────────────────────────────────────────────────────${RESET}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${HOME}/.local/bin"
CONFIG_DIR="${HOME}/.config/corex"
SHARE_DIR="${HOME}/.local/share/corex"
FISH_FUNCTIONS="${HOME}/.config/fish/functions"
FISH_COMPLETIONS="${HOME}/.config/fish/completions"
FISH_CONFD="${HOME}/.config/fish/conf.d"
BASH_COMP_DIR="${HOME}/.local/share/bash-completion/completions"
ZSH_COMP_DIR="${HOME}/.zsh/completions"

ASSUME_YES=false
KEEP_FOLDER=false

for arg in "$@"; do
    case "$arg" in
        -y|--yes)
            ASSUME_YES=true
            ;;
        --keep-folder|--keep-source)
            KEEP_FOLDER=true
            ;;
        -h|--help)
            echo "Usage: ./uninstall.sh [OPTIONS]"
            echo ""
            echo "Completely uninstalls CoreX: removes binaries, shell completions,"
            echo "configurations, data directories, and the main CoreX folder."
            echo ""
            echo "Options:"
            echo "  -y, --yes          Bypass confirmation prompts"
            echo "  --keep-folder      Remove system installations but preserve this CoreX source folder"
            echo "  -h, --help         Show this help message"
            exit 0
            ;;
    esac
done

if [ "$ASSUME_YES" = false ]; then
    echo -e "${YELLOW}Warning:${RESET} This will completely remove CoreX from your system:"
    echo -e "  • Executables in ${CYAN}${BIN_DIR}{/cx, /corex}${RESET}"
    echo -e "  • Shell completions for Fish, Bash, and Zsh"
    echo -e "  • Configuration & notes in ${CYAN}${CONFIG_DIR}${RESET} and ${CYAN}${SHARE_DIR}${RESET}"
    if [ "$KEEP_FOLDER" = false ]; then
        echo -e "  • The main CoreX directory: ${RED}${SCRIPT_DIR}${RESET}"
    fi
    echo ""
    read -r -p "Are you sure you want to completely remove everything? [y/N]: " confirm
    if [[ ! "$confirm" =~ ^[yY]([eE][sS])?$ ]]; then
        echo -e "${GRAY}Uninstallation cancelled.${RESET}"
        exit 0
    fi
fi

echo -e "\n${CYAN}λ${RESET} ${BOLD}Removing Executables & Symlinks...${RESET}"
for b in "cx" "corex"; do
    if [ -L "${BIN_DIR}/${b}" ] || [ -f "${BIN_DIR}/${b}" ]; then
        rm -f "${BIN_DIR}/${b}"
        echo -e "  [${GREEN}✔${RESET}] Removed ${CYAN}${BIN_DIR}/${b}${RESET}"
    fi
done

echo -e "\n${CYAN}λ${RESET} ${BOLD}Removing Shell Completions & Functions...${RESET}"
# Fish
if [ -f "${FISH_FUNCTIONS}/cx.fish" ]; then
    rm -f "${FISH_FUNCTIONS}/cx.fish"
    echo -e "  [${GREEN}✔${RESET}] Removed ${CYAN}${FISH_FUNCTIONS}/cx.fish${RESET}"
fi
if [ -f "${FISH_COMPLETIONS}/cx.fish" ]; then
    rm -f "${FISH_COMPLETIONS}/cx.fish"
    echo -e "  [${GREEN}✔${RESET}] Removed ${CYAN}${FISH_COMPLETIONS}/cx.fish${RESET}"
fi
if [ -f "${FISH_CONFD}/cx_key_bindings.fish" ]; then
    rm -f "${FISH_CONFD}/cx_key_bindings.fish"
    echo -e "  [${GREEN}✔${RESET}] Removed ${CYAN}${FISH_CONFD}/cx_key_bindings.fish${RESET}"
fi

# Bash
if [ -f "${BASH_COMP_DIR}/cx" ]; then
    rm -f "${BASH_COMP_DIR}/cx"
    echo -e "  [${GREEN}✔${RESET}] Removed ${CYAN}${BASH_COMP_DIR}/cx${RESET}"
fi

# Zsh
if [ -f "${ZSH_COMP_DIR}/_cx" ]; then
    rm -f "${ZSH_COMP_DIR}/_cx"
    echo -e "  [${GREEN}✔${RESET}] Removed ${CYAN}${ZSH_COMP_DIR}/_cx${RESET}"
fi

echo -e "\n${CYAN}λ${RESET} ${BOLD}Removing Configurations & User Data...${RESET}"
if [ -d "$CONFIG_DIR" ]; then
    rm -rf "$CONFIG_DIR"
    echo -e "  [${GREEN}✔${RESET}] Removed ${CYAN}${CONFIG_DIR}${RESET}"
fi
if [ -d "$SHARE_DIR" ]; then
    rm -rf "$SHARE_DIR"
    echo -e "  [${GREEN}✔${RESET}] Removed ${CYAN}${SHARE_DIR}${RESET}"
fi

if [ "$KEEP_FOLDER" = false ]; then
    echo -e "\n${CYAN}λ${RESET} ${BOLD}Removing Main CoreX Folder...${RESET}"
    if [ -n "$SCRIPT_DIR" ] && [ "$SCRIPT_DIR" != "/" ] && [ "$SCRIPT_DIR" != "$HOME" ] && [ "$SCRIPT_DIR" != "/home" ] && [ -d "$SCRIPT_DIR" ]; then
        echo -e "  [${GREEN}✔${RESET}] Removed ${CYAN}${SCRIPT_DIR}${RESET}"
    fi
fi

echo -e "\n${GREEN}${BOLD}══════════════════════════════════════════════════════════════════${RESET}"
echo -e "${GREEN}${BOLD}✔ CoreX (cx) has been completely removed from your system.${RESET}"
echo -e "${GREEN}${BOLD}══════════════════════════════════════════════════════════════════${RESET}\n"

# Final step: Delete the main CoreX directory itself
if [ "$KEEP_FOLDER" = false ]; then
    if [ -n "$SCRIPT_DIR" ] && [ "$SCRIPT_DIR" != "/" ] && [ "$SCRIPT_DIR" != "$HOME" ] && [ "$SCRIPT_DIR" != "/home" ] && [ -d "$SCRIPT_DIR" ]; then
        cd "$HOME"
        rm -rf "$SCRIPT_DIR" 2>/dev/null || true
    fi
fi

exit 0
