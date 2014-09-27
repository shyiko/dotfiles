unalias z
z() {
  if [[ -z "$*" ]]; then
    cd "$(fasd_cd -d -l 2>&1 | sed -n 's/^[ 0-9.,]*//p' | fzf)"
  else
    fasd_cd -d "$@"
  fi
}
