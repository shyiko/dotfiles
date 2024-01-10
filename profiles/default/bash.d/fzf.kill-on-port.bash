if [ -f ~/.fzf.bash ]; then

_fzf_kill-on-port_completion() {
  [ -n "${COMP_WORDS[COMP_CWORD]}" ] && return 1

  local selected
  tput sc
  selected=$(echo `lsof -P -i -sTCP:LISTEN | grep LISTEN | fzf -m $FZF_COMPLETION_OPTS` | cut -d: -f2 | cut -d\  -f1)
  tput rc

  if [ -n "$selected" ]; then
    COMPREPLY=( "$selected" )
    return 0
  fi
}

complete -F _fzf_kill-on-port_completion -o nospace -o default -o bashdefault kill-on-port

fi
