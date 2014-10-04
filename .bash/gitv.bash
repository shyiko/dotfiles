# https://github.com/gregsexton/gitv has to be installed
alias gitv='vim "$(git rev-parse --show-toplevel)"/.git/index -c "Gitv --all" -c "tabonly"'
