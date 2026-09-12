# Bash completions for CoreX (cx)
_cx_completions() {
    local cur prev words cword
    _init_completion || return

    local commands="comfy-boot comfy-nuke comfy-sync model-symlink ollama-up ollama-ps ollama-drop ollama-fzf hf-download civit-grab vram-watch cuda-purge stream-yt stream-video stream-radio rip-flac rip-opus trim-video make-gif demucs-stems pw-restart pw-devices pw-volume tag-editor cover-extract gpu-clock cpu-gov cpu-turboboost mon-res mon-dual mon-single sens-watch game-mode snap-now snap-fzf snap-clean fkill disk-space pkg-orphans service-fail journal-vacuum boot-analyze my-ip vpn-up vpn-down port-audit speed-check lan-scan ssh-fzf serve-dir dns-flush git-branch-fzf git-squash git-stash-pop git-clean-branches docker-fzf docker-prune venv-init cheat hex-view clip-hist qr-gen qr-read tar-pack tar-unpack hash-check weather calc timer stopwatch notes todo url-short trash-empty sys-info --dry-run --help --version --list --yes"

    if [[ $cword -eq 1 ]]; then
        COMPREPLY=( $(compgen -W "$commands" -- "$cur") )
    fi
}
complete -F _cx_completions cx
complete -F _cx_completions corex

