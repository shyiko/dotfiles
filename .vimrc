set nocompatible

call plug#begin('~/.vim/bundle')

Plug 'AndrewRadev/splitjoin.vim'
Plug 'bling/vim-airline'
Plug 'briandoll/change-inside-surroundings.vim'
Plug 'bronson/vim-visual-star-search'
Plug 'editorconfig/editorconfig-vim'
Plug 'gregsexton/gitv'
Plug 'itspriddle/vim-stripper'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'junegunn/fzf'
Plug 'junegunn/limelight.vim'
Plug 'kchmck/vim-coffee-script'
Plug 'Lokaltog/vim-easymotion'
Plug 'matze/vim-move'
Plug 'othree/html5.vim'
Plug 'Raimondi/delimitMate'
Plug 'rhysd/accelerated-jk'
Plug 'rking/ag.vim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'shyiko/vim-smooth-scroll'
Plug 'SirVer/ultisnips'
Plug 'sjl/gundo.vim'
Plug 'skammer/vim-css-color'
Plug 'svermeulen/vim-easyclip'
Plug 'terryma/vim-expand-region'
Plug 'terryma/vim-multiple-cursors'
Plug 'thinca/vim-ambicmd'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'Valloric/YouCompleteMe', { 'do': './install.sh' }
Plug 'wavded/vim-stylus'

call plug#end()

syntax on
filetype plugin indent on

" show line numbers
set number
" treat all numbers as decimals
set nrformats=
" enable smart-case searching
set ignorecase
set smartcase
" highlight line
set cursorline
" enable mouse support
set mouse=a
set ttymouse=xterm2
autocmd VimEnter,FocusGained,BufEnter * set ttymouse=xterm2
" make yank+paste interact with system clipboard
set clipboard=unnamed
" change cursor shape between insert and normal mode in iTerm2.app
if $TERM_PROGRAM =~ "iTerm"
  let &t_SI = "\<Esc>]50;CursorShape=1\x7" " vertical bar in insert mode
  let &t_EI = "\<Esc>]50;CursorShape=0\x7" " block in normal mode
endif
" indentation
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smarttab
set expandtab
" don't just stop on the line 'boundaries'
" commented out: clashes with accelerated
" set whichwrap+=<,>,[,]

set backupdir=~/.vim/backup
set directory=~/.vim/swap
set undodir=~/.vim/undo
set backupskip=/tmp/*

" use IDE approach for autocomplete+<CR>
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

let g:zenburn_transparent = 1
colors zenburn

set pastetoggle=<F2>

" accelerate arrow keys
nmap <silent> <Left> :<C-u>call accelerated#time_driven#command('h')<CR>
nmap <silent> <Right> :<C-u>call accelerated#time_driven#command('l')<CR>
" + move by 'screen lines' instead
nmap <silent> <Down> <Plug>(accelerated_jk_gj)
nmap <silent> <Up> <Plug>(accelerated_jk_gk)

nmap <silent> <C-u> :call smooth_scroll#up(&scroll, 0, 2)<CR>
nmap <silent> <C-d> :call smooth_scroll#down(&scroll, 0, 2)<CR>
nmap <silent> <C-b> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
nmap <silent> <C-f> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>

" <M-1>
map ¡ <plug>NERDTreeTabsToggle<CR>

" nnoremap <silent> <C-t> :CommandT<CR>
" nnoremap <silent> <C-e> :CommandTMRU<CR>
"let g:CommandTCancelMap = ['<ESC>', '<C-c>']
"let g:CommandTSelectNextMap = ['<C-j>', '<ESC>OB']
"let g:CommandTSelectPrevMap = ['<C-k>', '<ESC>OA']

cnoremap <expr> <Space> ambicmd#expand("\<Space>")
cnoremap <expr> <CR> ambicmd#expand("\<CR>")

