# Fish shell completions for CoreX (cx)
# Installed to ~/.config/fish/completions/cx.fish

function __fish_cx_needs_command
    set -l cmd (commandline -opc)
    if test (count $cmd) -eq 1
        return 0
    end
    return 1
end

function __fish_cx_using_command
    set -l cmd (commandline -opc)
    if test (count $cmd) -gt 1
        if test "$argv[1]" = "$cmd[2]"
            return 0
        end
    end
    return 1
end

complete -c cx -f

# Global flags
complete -c cx -s h -l help -d "Show CoreX help message"
complete -c cx -s v -l version -d "Show CoreX version"
complete -c cx -l dry-run -d "Preview commands without executing them"
complete -c cx -l no-color -d "Disable ANSI terminal styling"
complete -c cx -l config -r -F -d "Custom TOML configuration path"

# Core subcommands
complete -c cx -n "__fish_cx_needs_command" -a comfy -d "One-click ComfyUI launcher with smart VRAM detection"
complete -c cx -n "__fish_cx_needs_command" -a comfyui -d "One-click ComfyUI launcher with smart VRAM detection"
complete -c cx -n "__fish_cx_needs_command" -a ai -d "Inspect & manage local LLMs, Ollama daemon"
complete -c cx -n "__fish_cx_needs_command" -a ollama -d "Inspect & manage local LLMs, Ollama daemon"
complete -c cx -n "__fish_cx_needs_command" -a docker -d "Interactive container manager (logs, restart, kill)"
complete -c cx -n "__fish_cx_needs_command" -a stream -d "Fuzzy-search YouTube/SoundCloud & stream via mpv"
complete -c cx -n "__fish_cx_needs_command" -a rip -d "Extract audio from video files to 24-bit FLAC / Opus"
complete -c cx -n "__fish_cx_needs_command" -a play -d "Instant fuzzy local music player with tag preview"
complete -c cx -n "__fish_cx_needs_command" -a kill -d "Interactive process manager and multi-killer"
complete -c cx -n "__fish_cx_needs_command" -a fkill -d "Interactive process manager and multi-killer"
complete -c cx -n "__fish_cx_needs_command" -a vram -d "Nvidia VRAM usage breakdown & zombie killer"
complete -c cx -n "__fish_cx_needs_command" -a snap -d "BTRFS / Snapper system snapshot helper"
complete -c cx -n "__fish_cx_needs_command" -a snapshot -d "BTRFS / Snapper system snapshot helper"
complete -c cx -n "__fish_cx_needs_command" -a scratch -d "Instant markdown scratchpad notes"
complete -c cx -n "__fish_cx_needs_command" -a completions -a "fish bash zsh" -d "Generate shell completion scripts"

# Subcommand-specific arguments
complete -c cx -n "__fish_cx_using_command rip" -F -d "Video file to extract audio from"
complete -c cx -n "__fish_cx_using_command play" -F -d "Music directory or audio track"
complete -c cx -n "__fish_cx_using_command kill" -a "(__fish_complete_proc)" -d "Process name filter"
complete -c cx -n "__fish_cx_using_command fkill" -a "(__fish_complete_proc)" -d "Process name filter"

# Mirror completions for 'corex' binary
complete -c corex -w cx
