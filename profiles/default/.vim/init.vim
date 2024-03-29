filetype off
filetype plugin indent on
" show line numbers
set number
" enable smart-case searching
set ignorecase
set smartcase
" enable mouse support
set mouse=a
" make yank+paste interact with system clipboard
" set clipboard=unnamed
if has('unnamedplus')
  set clipboard=unnamedplus
endif
" vimpager
if exists("vimpager")
  set noswapfile
  set undolevels=-1
  set nomodifiable
  noremap q :q<CR>
endif
" backup/swap/undo location
set backupdir=~/.cache/vim
set directory=~/.cache/vim
set undodir=~/.cache/vim
" paste without indent-mangling
set pastetoggle=<F2>
" move "by word"
map <M-left> <Esc>b
map! <M-left> <Esc>b
map <M-right> <Esc>w
map! <M-right> <Esc>w
" move "to the line beginning/end"
" <C-Left> (iTerm2-mapped as 0x01)
map <silent> <C-a> 0
inoremap <silent> <C-a> <C-o>0
cnoremap <C-a> <C-b>
" <C-Right> (iTerm2-mapped as 0x05)
map <silent> <C-e> $
inoremap <silent> <C-e> <C-o>$
" theme (from https://github.com/chriskempson/base16-vim)
colors base16-ocean
