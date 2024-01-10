if [[ $OSTYPE == darwin* ]]; then
  export GREP_OPTIONS="--color=auto" # BSD grep
else
  alias grep="grep --color=auto" # GNU grep
fi