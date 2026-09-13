# CoreX (cx) Shell Keybindings for Fish
# Installed to ~/.config/fish/conf.d/cx_key_bindings.fish

function __cx_search_and_insert --description "Interactive CoreX action search & buffer insert"
    set -l cx_bin (command -v cx 2>/dev/null; or command -v corex 2>/dev/null; or echo "$HOME/.local/bin/cx")
    if not test -x "$cx_bin"
        return 1
    end

    # Run CoreX in picker selection mode
    set -l selected ($cx_bin --select)
    if test -n "$selected"
        commandline -r -- "$selected "
    end
    commandline -f repaint
end

# Clean up any stale empty fallback bindings
bind -e "" 2>/dev/null
bind -e -M insert "" 2>/dev/null

# Bind Alt+c and Ctrl+Space for CoreX launcher overlay
bind alt-c __cx_search_and_insert
bind ctrl-space __cx_search_and_insert 2>/dev/null
if bind -M insert >/dev/null 2>&1
    bind -M insert alt-c __cx_search_and_insert
    bind -M insert ctrl-space __cx_search_and_insert 2>/dev/null
end

