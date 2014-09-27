export FZF_DEFAULT_COMMAND='ag -l -g ""'
export FZF_DEFAULT_OPTS="-e -m --sort 500"

source ~/.bash/bundle/fzf/fzf.bash

cd() {
  if [[ -z "$*" ]]; then
    local dir
    dir=$(find ${1:-*} -path '*/\.*' -prune \
      -o -type d -print 2> /dev/null | fzf +m) &&
      builtin cd "$dir"
  else
    builtin cd "$@"
  fi
}

e() {
  if [[ -z "$*" ]]; then
    local file
    file=$(fzf --query="$1" --select-1 --exit-0)
    [ -n "$file" ] && ${EDITOR:-vim} "$file"
  else
    ${EDITOR:-vim} "$@"
  fi
}

v() {
  if [[ -z "$*" ]]; then
    local file
    file=$(fzf --query="$1" --select-1 --exit-0)
    [ -n "$file" ] && view "$file"
  else
    view "$@"
  fi
}

o() {
  if [[ -z "$*" ]]; then
    local file
    file=$(fzf --query="$1" --select-1 --exit-0)
    [ -n "$file" ] && open "$file"
  else
    open "$@"
  fi
}

