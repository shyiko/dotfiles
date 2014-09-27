command! FZFLines call fzf#run({
  \ 'source':  BuffersLines(),
  \ 'sink':    function('LineHandler'),
  \ 'options': '--extended-exact --reverse --no-sort --nth=2..,',
  \ 'tmux_height': '60%'
  \})

function! LineHandler(l)
        let keys = split(a:l, ':\t')
        exec keys[0]
        normal! ^zz
endfunction

function! BuffersLines()
        let res = []
        for b in filter(range(1, bufnr('$')), 'buflisted(v:val)')
                call extend(res, map(getbufline(b,0,"$"), '(v:key + 1) . ":\t" . v:val '))
        endfor
        return reverse(res)
endfunction
