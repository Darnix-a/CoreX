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
        # If commandline is empty or has content, update buffer
        commandline -r -- "$selected "
        commandline -f repaint
    end
end

# Bind Alt+c (\ec) and Ctrl+Space (\x00) in default mode
bind \ec __cx_search_and_insert
bind \x00 __cx_search_and_insert

# Also bind in insert mode if vi-mode is active
if bind -M insert >/dev/null 2>&1
    bind -M insert \ec __cx_search_and_insert
    bind -M insert \x00 __cx_search_and_insert
end
