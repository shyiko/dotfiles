function git-status-d() {
    if ! command -v gitstatus_check >/dev/null; then
        . ~/.gitstatus/gitstatus.plugin.sh
    fi
    gitstatus_stop && gitstatus_start -s -1 -u -1 -c -1 -d -1
}

alias g="git "