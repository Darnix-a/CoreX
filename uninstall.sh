#!/usr/bin/env bash
# ==============================================================================
# CoreX (cx) Automated Uninstaller & Cleanup
# Removes CoreX binaries, completions, shell integrations, and optional configs.
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

BIN_DIR="${HOME}/.local/bin"
CONFIG_DIR="${HOME}/.config/corex"
SHARE_DIR="${HOME}/.local/share/corex"
FISH_FUNCTIONS="${HOME}/.config/fish/functions"
FISH_COMPLETIONS="${HOME}/.config/fish/completions"
FISH_CONFD="${HOME}/.config/fish/conf.d"
BASH_COMP_DIR="${HOME}/.local/share/bash-completion/completions"
ZSH_COMP_DIR="${HOME}/.zsh/completions"

PURGE=false
ASSUME_YES=false

for arg in "$@"; do
    case "$arg" in
        --purge|--all|-a)
            PURGE=true
            ;;
        -y|--yes)
            ASSUME_YES=true
            ;;
        -h|--help)
            echo "Usage: ./uninstall.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -y, --yes      Bypass confirmation prompts"
            echo "  --purge, --all Also remove user configuration (~/.config/corex) and data"
            echo "  -h, --help     Show this help message"
            exit 0
            ;;
    esac
done

if [ "$ASSUME_YES" = false ]; then
    echo -e "${YELLOW}Warning:${RESET} This will remove CoreX binaries, shell completions, and integrations."
    read -r -p "Are you sure you want to uninstall CoreX? [y/N]: " confirm
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

# Share directory
if [ -d "$SHARE_DIR" ]; then
    rm -f "${SHARE_DIR}/cx.bash" "${SHARE_DIR}/cx.zsh"
fi

echo -e "\n${CYAN}λ${RESET} ${BOLD}Configuration & User Data...${RESET}"
if [ "$PURGE" = true ]; then
    rm -rf "$CONFIG_DIR" "$SHARE_DIR"
    echo -e "  [${GREEN}✔${RESET}] Purged ${CYAN}${CONFIG_DIR}${RESET} and ${CYAN}${SHARE_DIR}${RESET}"
else
    if [ "$ASSUME_YES" = false ] && [ -d "$CONFIG_DIR" ]; then
        read -r -p "Do you also want to remove your custom configuration and notes ($CONFIG_DIR)? [y/N]: " purge_confirm
        if [[ "$purge_confirm" =~ ^[yY]([eE][sS])?$ ]]; then
            rm -rf "$CONFIG_DIR" "$SHARE_DIR"
            echo -e "  [${GREEN}✔${RESET}] Purged ${CYAN}${CONFIG_DIR}${RESET} and ${CYAN}${SHARE_DIR}${RESET}"
        else
            echo -e "  [${GRAY}i${RESET}] Preserved configuration at ${CYAN}${CONFIG_DIR}${RESET}"
        fi
    else
        echo -e "  [${GRAY}i${RESET}] Preserved configuration at ${CYAN}${CONFIG_DIR}${RESET} (use --purge to delete)"
    fi
fi

echo -e "\n${GREEN}${BOLD}══════════════════════════════════════════════════════════════════${RESET}"
echo -e "${GREEN}${BOLD}✔ CoreX (cx) has been successfully uninstalled.${RESET}"
echo -e "${GREEN}${BOLD}══════════════════════════════════════════════════════════════════${RESET}\n"
