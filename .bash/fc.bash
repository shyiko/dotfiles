# fc which DOES remember about PROMPT_COMMAND,PS1,...

fc() {
  if [[ -z "$*" ]]; then
    local tmpfile=$(mktemp -q /tmp/bash-fake-fc.XXXXXXXXXX)
    ${FCEDIT:-${EDITOR:-vi}} $tmpfile
    echo -e 'HISTFILE=~/.bash_history\nset -o history\n' | cat - $tmpfile > $tmpfile~ && mv $tmpfile{~,}
    eval "$(cat $tmpfile)"
  else
    builtin fc "$@"
  fi
}

bind '"\C-x\C-e":"fc\n"'

export HISTIGNORE="fc:$HISTIGNORE"
