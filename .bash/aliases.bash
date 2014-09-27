# alias e="${EDITOR:-vim}"
# alias v="view"

export CLICOLOR=1
alias l="ls -CF"
alias la="ls -A"
alias ll="ls -alF"

alias ..="cd .."
alias ...="cd ../.."
alias ~="cd ~"
alias -- -="cd -"

alias q="exit"

export GREP_OPTIONS="--ignore-case --color=auto"

md() { mkdir -p "$@" && cd "$@"; }

alias tac="tail -r"

alias g="grep"

# allow aliases to be sudo'ed
alias sudo='sudo '

quiet() { $* &> /dev/null & }

cpb() { cp $1 $1~$(date +%Y%m%d_%H%M%S); }

rm-hidden() { (find ${1:-.} -name ".*" -print0 | xargs -0 rm -rf) }
rm-dsstore() { find ${1:-.} -type f -name '*.DS_Store' -ls -delete; }

alias ebp="${EDITOR:-vim} ~/.bash_profile"
alias ebrc="${EDITOR:-vim} ~/.bashrc"
alias evrc="${EDITOR:-vim} ~/.vimrc"

alias remind-sudo-passwordless-mode='string="Defaults:username !requiretty \nDefaults:username visiblepw \nDefaults:username !authenticate"; echo -e $string; unset string'

alias dl="cd ~/Downloads"
alias dd="cd ~/Desktop"
alias dg="cd ~/Development/github"

alias stopwatch='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

command -v md5sum > /dev/null || alias md5sum="md5"
command -v sha1sum > /dev/null || alias sha1sum="shasum"

