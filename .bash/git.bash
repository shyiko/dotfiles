# up-to-date version available at https://github.com/git/git/blob/master/contrib/completion/git-completion.bash
. ~/.bash/bundle/git/contrib/completion/git-completion.bash
. ~/.bash/bundle/bash-it/completion/available/git_flow.completion.bash

function git-ignore-locally() {
  echo "$1" >> .git/info/exclude
}

