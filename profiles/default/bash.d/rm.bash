function rm-garbage() (
    set -x
    docker volume prune -f
    docker image prune -f
    # linux
    rm -rf ~/.local/share/Trash/*
    # darwin
    rm -rf ~/.Trash/* /private/var/log/asl/*.asl
)

function rm-dsstore() {
    find ${1:-.} -type f -name '*.DS_Store' -ls -delete
}

function rm-hidden() {
    find ${1:-.} -name ".*" -print0 | xargs -0 rm -rf
}
