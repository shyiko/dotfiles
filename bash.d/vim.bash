alias vim=nvim

function vimmd() { mkdir -p $(dirname "$1") && vim "$1"; }
