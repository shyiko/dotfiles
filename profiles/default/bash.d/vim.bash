# alias vim=nvim

function vimd() { mkdir -p $(dirname "$1") && vim "$1"; }
