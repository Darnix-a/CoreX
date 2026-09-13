# Bash completions for CoreX (cx)
_cx_completions() {
    local cur prev words cword
    _init_completion || return

    local commands="ask models comfy-boot comfy-nuke comfy-sync model-symlink ollama-up ollama-ps ollama-drop ollama-fzf hf-download civit-grab vram-watch cuda-purge stream-yt stream-video stream-radio now-playing song rip-flac rip-opus trim-video make-gif demucs-stems pw-restart pw-devices pw-volume tag-editor cover-extract gpu-clock cpu-gov cpu-turboboost mon-res mon-dual mon-single sens-watch game-mode snap-now snap-fzf snap-clean fkill disk-space pkg-orphans service-fail journal-vacuum boot-analyze my-ip vpn-up vpn-down port-audit speed-check lan-scan ssh-fzf serve-dir dns-flush git-branch-fzf git-squash git-stash-pop git-clean-branches docker-fzf docker-prune venv-init cheat hex-view clip-hist qr-gen qr-read tar-pack tar-unpack hash-check weather calc timer stopwatch notes todo url-short trash-empty sys-info irq-top dmesg-follow kmod-fzf sysctl-search cgroup-inspect oom-score klog-err pcie-topo slab-top numa-stat ipc-audit vk-caps vk-layers glmark-quick shader-cache-purge display-edid vrr-status nv-enc-stat dri-info wayland-diag mangohud-config ram-breakdown hugepages-toggle zram-stats io-top inode-check file-locks btrfs-scrub btrfs-dedup fstrim-all smart-health swap-compact socket-summary dns-leak-test tcp-dump-quick ssl-inspect mtu-bench route-trace band-top conntrack-dump dns-benchmark wifi-radar firewall-status sine-gen pink-noise spectrogram xrun-dump audio-resample-bench pw-link-fzf latency-test sweep-gen bit-depth-check compose-up compose-down container-shell image-dive registry-inspect container-stats compose-logs podman-pods k8s-nodes port-forward regex-test json-pretty diff-patch tokei-count cron-inspect git-bisect-start sqlite-browser http-bench env-diff perf-stat entropy-check gamescope-run noise-gate git-rebase-i semver-bump k8s-pods-fzf builder doctor theme pin unpin pinned --select --select-raw --pinned --dry-run --bg --help --version --list --yes"

    if [[ $cword -eq 1 ]]; then
        COMPREPLY=( $(compgen -W "$commands" -- "$cur") )
    fi
}
complete -F _cx_completions cx
complete -F _cx_completions corex

