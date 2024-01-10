# do nothing if not running interactively
[ -z "$PS1" ] && return

setterm -tabs 4

# enable case-insensitive globbing
shopt -s nocaseglob
# do not override bash history file (append to it)
shopt -s histappend
# autocorrect typos during cd calls
shopt -s cdspell
# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize
# put multi-line commands onto one line of history
shopt -s cmdhist
# turn on confirmation for history expansion (histexpand)
shopt -s histverify

# enable bash4 features (if available)
# autocd = `**/smth` -> `./somewhere/smth`
# globstart = `echo **/*.log`
for option in autocd globstar; do
  shopt -s "$option" 2> /dev/null;
done;

export LC_ALL="en_US.UTF-8"
export LANG="en_US"

# do not auto/tab-complete .DS_Store
export FIGNORE=DS_Store

# https://github.com/neovim/neovim
export EDITOR='vim'
export VIEWER='lessvim'

# read-only version of vim (.vimrc's `if exists("vimpager") ... endif`)
lessvim() {
  vim --cmd 'let vimpager=1' "$@"
}

alias q="exit"

export HISTSIZE=-1 # prev value used - 32768
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoredups:ignorespace

[ -s "/etc/bash_completion" ] && source "/etc/bash_completion"

source ~/.dotfiles/profiles/default/.prompt.bash
# curl -sSL https://github.com/shyiko/commacd/raw/v1.0.0/commacd.sh -o ~/.dotfiles/profiles/default/.commacd.sh
source ~/.dotfiles/profiles/default/.commacd.sh

for f in $(ls ~/.dotfiles/profiles/default/bash.d/*.bash); do
  source $f
done

[ -s "$HOME/.dotfiles/profiles/default/.bashrc_local" ] && source "$HOME/.dotfiles/profiles/default/.bashrc_local"

_history_append() { local exit_code=$?; history -a; return $exit_code; }
export PROMPT_COMMAND="_history_append; $PROMPT_COMMAND"

_remember_pwd() { local exit_code=$?; printf %s "$PWD" > ~/.pwd; return $exit_code; }
export PROMPT_COMMAND="_remember_pwd; $PROMPT_COMMAND"
# $OLDPWD check is here to ensure things like (cd other_dir && bash -i) work as expected
[ -f ~/.pwd ] && [[ "$OLDPWD" == "" ]] && cd "$(cat ~/.pwd)"

if [ -f ~/Sounds/error.wav ]; then
	_play_on_error() {
		local exit_code=$?
		if [ $exit_code -ne 0 ]; then
			mpv ~/Sounds/error.wav >/dev/null 2>&1 & disown $!
		fi
		return $exit_code
	}
	export PROMPT_COMMAND="_play_on_error; $PROMPT_COMMAND"
fi

_urxvt_selection_open() { local exit_code=$?; echo -ne "\0033]777;selection-open;path;$PWD\0007"; return $exit_code; }
export PROMPT_COMMAND="_urxvt_selection_open; $PROMPT_COMMAND"

if [ -x "$(which direnv)" ]; then
  eval "$(direnv hook bash)" # installs _direnv_hook into PROMPT_COMMAND
fi

# _update_title() { local exit_code=$?; echo -ne "\033]0;${HOSTNAME}~${PWD##*/}\007"; return $exit_code; }
# export PROMPT_COMMAND="_update_title; $PROMPT_COMMAND"

for f in $(ls -d $HOME/.bin.*/ 2>/dev/null); do # installed by ~/.dotfiles/profiles/default/profiles/*
  export PATH=$f:$PATH
done
export PATH=$HOME/.dotfiles/profiles/default/bin:$PATH
export PATH=$HOME/.bin:$PATH

# python/pip{,x}
export PATH=$HOME/.local/bin:$PATH

# `go env` (https://golang.org/cmd/go/#hdr-GOPATH_environment_variable)
export GOPATH=$HOME/.go
export GOBIN=~/.go/bin # go get installed binaries
export GOROOT=$HOME/.go/default # sdk
export PATH=$GOROOT/bin:$GOBIN:$PATH

# rustup
# no need to add ~/.cargo/bin to the PATH as ~/.cargo/env does that automatically
[ -s "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

true
