function _update_ps1() {
  export PS1="$(~/.bash/bundle/powerline-shell/powerline-shell.py --mode flat $? 2> /dev/null)"
}

export PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"

. ~/.bash/bundle/bash-command-duration/command-duration.bash
