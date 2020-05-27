function md() { mkdir -p "$@" && cd "$@"; }

function mdt() {
    local dir="$(mktemp -d -t mdt.XXXXXXX)"
    cd "$dir"
}
