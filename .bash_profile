# do nothing if not running interactively
[ -z "$PS1" ] && return

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

# make less more friendly for binary files, see lesspipe
if which lesspipe.sh > /dev/null; then
  export LESSOPEN="|lesspipe.sh %s"
fi

export LC_ALL="en_US.UTF-8"
export LANG="en_US"

export FIGNORE=DS_Store

# for vim's colors
export TERM=xterm-256color

export EDITOR='vim'

export HISTSIZE=32768
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoredups:ignorespace

. ~/.bash/afk.bash
. ~/.bash/ag.bash
. ~/.bash/aliases.bash
[ -s ~/.bash/aliases.local.bash ] && . ~/.bash/aliases.local.bash
. ~/.bash/brew.bash
. ~/.bash/docker.bash
. ~/.bash/extract.bash
. ~/.bash/fasd.bash
. ~/.bash/fc.bash
. ~/.bash/fzf.bash
. ~/.bash/fzf.fasd.bash
. ~/.bash/fzf.git.bash
. ~/.bash/fzf.kill-on-port.bash
. ~/.bash/gem.bash
. ~/.bash/git.bash
. ~/.bash/grunt.bash
. ~/.bash/hg.bash
. ~/.bash/http.bash
. ~/.bash/ip.bash
. ~/.bash/ipfw.bash
. ~/.bash/java.bash
. ~/.bash/kill-on-port.bash
. ~/.bash/macosx.bash
. ~/.bash/mvn.bash
. ~/.bash/npm.bash
. ~/.bash/pip.bash
. ~/.bash/serve.bash
. ~/.bash/svn.bash
. ~/.bash/up.bash
. ~/.bash/url.bash
. ~/.bash/vagrant.bash

. ~/.bashrc

export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
# draw in 'shared history'
alias hsync='history -c; history -r'

# set title to hostname~current_dir
_update_title() { echo -ne "\033]0;${HOSTNAME}~${PWD##*/}\007"; }
export PROMPT_COMMAND="_update_title; $PROMPT_COMMAND"

# MUST be the last one among those who modify PROMPT_COMMAND
. ~/.bash/powerline.bash

