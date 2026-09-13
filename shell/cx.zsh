# CoreX (cx) Shell Keybindings & ZLE Integration for Zsh
# Source this file in ~/.zshrc:
#   source ~/.local/share/corex/cx.zsh

__cx_search_and_insert() {
    local cx_bin
    cx_bin="$(command -v cx 2>/dev/null || command -v corex 2>/dev/null || echo "$HOME/.local/bin/cx")"
    if [[ -x "$cx_bin" ]]; then
        local selected
        selected="$("$cx_bin" --select)"
        if [[ -n "$selected" ]]; then
            LBUFFER="${selected} "
            zle reset-prompt
        fi
    fi
}

if [[ -o interactive ]] 2>/dev/null; then
    zle -N __cx_search_and_insert
    bindkey '\ec' __cx_search_and_insert
    bindkey '^@' __cx_search_and_insert
fi
