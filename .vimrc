set nocompatible

call plug#begin('~/.vim/bundle')

Plug 'AndrewRadev/splitjoin.vim' " simplify the transition between multiline and single-line code
Plug 'bling/vim-airline' " lean & mean status/tabline for Vim
Plug 'briandoll/change-inside-surroundings.vim' " change the contents of the innermost 'surrounding'
Plug 'bronson/vim-visual-star-search' " * or # search from a visual block
Plug 'editorconfig/editorconfig-vim' " EditorConfig plugin for Vim
Plug 'gregsexton/gitv' " gitk for Vim
Plug 'itspriddle/vim-stripper' " strip trailing whitespace
Plug 'jistr/vim-nerdtree-tabs' " NERDTree and tabs together in Vim, painlessly
Plug 'junegunn/fzf' " general-purpose fuzzy finder
Plug 'junegunn/limelight.vim' " light and configurable statusline/tabline for Vim
Plug 'kchmck/vim-coffee-script' " CoffeeScript support for Vim
Plug 'Lokaltog/vim-easymotion' " simpler way to use some motions in Vim
Plug 'matze/vim-move' " move lines and selections up and down
Plug 'othree/html5.vim' " HTML5 omnicomplete funtion and syntax for Vim
Plug 'Raimondi/delimitMate' " insert mode auto-completion for quotes, parens, brackets, etc
Plug 'rhysd/accelerated-jk' " accelerate up-down moving
Plug 'rking/ag.vim' " front for ag, A.K.A. the_silver_searcher
Plug 'scrooloose/nerdtree' " tree explorer plugin for Vim
Plug 'scrooloose/syntastic' " syntax checking hacks for Vim
Plug 'shyiko/vim-smooth-scroll' " nice and smooth scrolling in Vim
Plug 'SirVer/ultisnips' " ultimate snippet solution for Vim
Plug 'sjl/gundo.vim' " visualize your Vim undo tree
Plug 'ap/vim-css-color' " highlight colors in css files
Plug 'svermeulen/vim-easyclip' " simplified clipboard functionality for Vim
Plug 'terryma/vim-expand-region' " visually select increasingly larger regions of text using the same key combination
Plug 'terryma/vim-multiple-cursors' " true Sublime Text style multiple selections for Vim
Plug 'thinca/vim-ambicmd' " ambiguous command resolver
Plug 'tommcdo/vim-exchange' " easy text exchange operator for Vim
Plug 'tpope/vim-abolish' " easily search for, substitute, and abbreviate multiple variants of a word
Plug 'tpope/vim-dispatch' " asynchronous build and test dispatcher
Plug 'tpope/vim-repeat' " enable repeating supported plugin maps with '.'
Plug 'tpope/vim-sensible' " defaults everyone can agree on
Plug 'tpope/vim-surround' " quoting/parenthesizing made simple
Plug 'tpope/vim-unimpaired' " handy bracket mappings
Plug 'Valloric/YouCompleteMe', { 'do': './install.sh' } "fast, as-you-type, fuzzy-search code completion engine for Vim
Plug 'wavded/vim-stylus' "syntax highlighting for Stylus
Plug 'kien/ctrlp.vim' "fuzzy file, buffer, mru, tag, etc finder
Plug 'tpope/vim-fugitive' " a Git wrapper so awesome, it should be illegal
Plug 'jlfwong/vim-mercenary' " mercurial wrapper
Plug 'pbrisbin/vim-mkdir' " automatically create any non-existent directories before writing the buffer
Plug 'mhinz/vim-signify' " show a VCS diff using Vim's sign column
Plug 'elzr/vim-json' " better JSON for Vim
Plug 'tomtom/tcomment_vim' " comment vim-plugin that also handles embedded filetypes

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

" map = nvo, map! = ic

" move 'by word' with:
" <M-left>
map <Esc>B <C-Left>
map! <Esc>B <C-Left>
" <M-right>
map <Esc>F <C-Right>
map! <Esc>F <C-Right>

" move 'to the line beginning/end' with:
" <C-Left> (iTerm2-mapped as 0x01)
map <silent> <C-a> 0
inoremap <silent> <C-a> <C-o>0
cnoremap <C-a> <C-b>
" <C-Right> (iTerm2-mapped as 0x05)
map <silent> <C-e> $
inoremap <silent> <C-e> <C-o>$

inoremap <silent> <C-k> <C-o>D

" <M-1>
map ¡ <plug>NERDTreeTabsToggle<CR>

" taken from http://robots.thoughtbot.com/faster-grepping-in-vim
set grepprg=ag\ --nogroup\ --nocolor
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
let g:ctrlp_use_caching = 0

" <M-p>
nnoremap π :CtrlPMRU<CR>

cnoremap <expr> <Space> ambicmd#expand("\<Space>")
cnoremap <expr> <CR> ambicmd#expand("\<CR>")

let g:vim_json_syntax_conceal = 0

