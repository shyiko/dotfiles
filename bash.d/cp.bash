function cpmd() { mkdir -p "${@: -1}" && cp "$1" "$2"; }
function cpb() { cp $1 $1~$(date +%Y%m%d_%H%M%S); }
function cpr() { rsync -ah --info=progress2 "$@"; }
