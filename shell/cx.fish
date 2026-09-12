# Fish function for CoreX (cx)
# Installed to ~/.config/fish/functions/cx.fish

function cx --description "CoreX (cx) - Elite Linux Systems Multitool & Launcher"
    # Locate corex binary in ~/.local/bin or current PATH
    set -l cx_bin (command -v cx 2>/dev/null; or command -v corex 2>/dev/null; or echo "$HOME/.local/bin/cx")

    if not test -x "$cx_bin"
        echo "CoreX (cx) executable not found in PATH or ~/.local/bin/cx" >&2
        return 1
    end

    # Pass all arguments through to corex
    $cx_bin $argv
end
