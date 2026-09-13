# CoreX (cx) Shell Keybindings & Readline Integration for Bash
# Source this file in ~/.bashrc:
#   source ~/.local/share/corex/cx.bash

__cx_search_and_insert() {
    local cx_bin
    cx_bin="$(command -v cx 2>/dev/null || command -v corex 2>/dev/null || echo "$HOME/.local/bin/cx")"
    if [[ -x "$cx_bin" ]]; then
        local selected
        selected="$("$cx_bin" --select)"
        if [[ -n "$selected" ]]; then
            READLINE_LINE="${selected} "
            READLINE_POINT=${#READLINE_LINE}
        fi
    fi
}

# Only bind in interactive shells
if [[ $- == *i* ]] || [[ -t 0 ]]; then
    bind -x '"\ec": __cx_search_and_insert' 2>/dev/null || true
    bind -x '"\C-@": __cx_search_and_insert' 2>/dev/null || true
fi
