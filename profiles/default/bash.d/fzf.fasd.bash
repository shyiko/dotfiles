if [ -f ~/.fzf.bash ]; then

unalias z &>/dev/null

function z() {
  if [[ -z "$*" ]]; then
    dir="$(fasd_cd -d -l 2>&1 | sed -n 's/^[ 0-9.,]*//p' | fzf)"
    if [[ "$dir" != "" ]]; then
      cd "$dir"
    fi
  else
    fasd_cd -d "$@"
  fi
}

# alias ze="fasd -f -e ${EDITOR:-vim}"
# alias zv="fasd -a -e ${VIEWER:-less}"

fi
