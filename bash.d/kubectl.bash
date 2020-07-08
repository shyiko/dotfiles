if command -v kubectl &>/dev/null; then
    source <(kubectl completion bash)
    alias k="kubectl "
    complete -F __start_kubectl k
fi
