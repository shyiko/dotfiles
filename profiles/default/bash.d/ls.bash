if [[ $OSTYPE == darwin* ]]; then
  export CLICOLOR=1 # BSD ls
else
  alias ls="ls --color=auto" # GNU ls
fi

alias l="ls -CF"
alias la="ls -A"
alias ll="ls -alF"
