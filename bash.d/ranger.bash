function rr() {
    source /usr/bin/ranger
}

# https://github.com/ranger/ranger/wiki/Integration-with-other-programs#changing-directories
function ranger_cd {
    local IFS=$'\t\n'
    local tempfile="$(mktemp -t tmp.XXXXXX)"
    command ranger --cmd="map Q chain shell echo %d > "$tempfile"; quitall" "$@"
    if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]]; then
        cd -- "$(cat "$tempfile")" || return
    fi
    command rm -f -- "$tempfile" 2>/dev/null
}

bind '"\C-g":"ranger_cd\C-m"'

