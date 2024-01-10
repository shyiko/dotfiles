function mvd() { mkdir -p "$(dirname "${@: -1}")" && mv "$1" "$2"; }
function mvb() { mv $1 $1~$(date +%Y%m%d_%H%M%S); }
