command! FZFMru call fzf#run({
  \'source': reverse(v:oldfiles),
  \'sink' : 'e ',
  \'options' : '--extended-exact --reverse --no-sort',
  \})

