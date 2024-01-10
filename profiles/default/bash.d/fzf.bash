if [ -f ~/.fzf.bash ]; then

export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
export FZF_DEFAULT_OPTS="-e -m --sort 500"

# https://github.com/junegunn/fzf#using-git
source ~/.fzf.bash

function cd() {
  if [[ -z "$*" ]]; then
    local dir
    dir=$(find ${1:-*} -path '*/\.*' -prune \
      -o -type d -print 2> /dev/null | fzf +m) &&
      builtin cd "$dir"
  else
    builtin cd "$@"
  fi
}

function e() {
  if [[ -z "$*" ]]; then
    local file
    file=$(fzf --query="$1" --select-1 --exit-0)
    [ -n "$file" ] && ${EDITOR:-vim} "$file"
  else
    ${EDITOR:-vim} "$@"
  fi
}

function v() {
  if [[ -z "$*" ]]; then
    local file
    file=$(fzf --query="$1" --select-1 --exit-0)
    [ -n "$file" ] && ${VIEWER:-less} "$file"
  else
    ${VIEWER:-less} "$@"
  fi
}

fi
