" Vim configuration


" Show line numbers
set relativenumber
set number

" Show command typed
set showcmd
syntax on
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab
set autoindent
" Allow saving of files as sudo when I forgot to start vim using sudo.
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!
" Remove trailing whitespace
command RmWhite :%s/\s\+$//e
" Use system clipboard by default
set clipboard=unnamedplus
set shortmess=a
" Use case insensitive search
set ignorecase
set smartcase
" Reload vimrc after writing to it
autocmd BufWritePost .vimrc source %
nnoremap x "_x
nnoremap d "_d
nnoremap D "_D
vnoremap d "_d
nnoremap c "_c
nnoremap s "_s
nnoremap C "_C
nnoremap Y y$

" Yank the contents of the file
nnoremap <leader>Y :%y<CR>

nnoremap <leader>dd "+dd
nnoremap <leader>d "+d
nnoremap <leader>D "cD
vnoremap <leader>d "+d

" Swtich between tabs
nnoremap <F6> :tabp<CR>
nnoremap <F7> :tabn<CR>
" Execute current file
nnoremap <F10> :w<CR>:!clear && %:p<CR>
" Toggle list (display unprintable characters).
nnoremap <F4> :set list!<CR>
" Paste toggle for SSH
set pastetoggle=<F3>

" Use the incremental search
set incsearch
set hlsearch

" Remap Tab and Shift-Tab for cycling around matches
augroup vimrc-incsearch-highlight
  autocmd!
  autocmd CmdlineEnter /,\? :cnoremap <Tab> <C-G>| cnoremap <S-Tab> <C-T>
  autocmd CmdlineLeave /,\? :cunmap <Tab>| cunmap <S-Tab>
augroup END
" Clear screen with Control L
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" Show unprintable characters
set list
set listchars=tab:•\ ,trail:•,extends:»,precedes:«,nbsp:‡

" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" vim-airline
Plug 'vim-airline/vim-airline'
"
" vim-airline-themes
Plug 'vim-airline/vim-airline-themes'

Plug 'jamessan/vim-gnupg'

" Better color scheme
Plug 'cocopon/iceberg.vim/'

" Higlight the yanked region
Plug 'machakann/vim-highlightedyank'

" Easy commenting
Plug 'scrooloose/nerdcommenter'

" Syntax check
Plug 'vim-syntastic/syntastic'

" Markdown highlighting
Plug 'plasticboy/vim-markdown'

" Vim script for text filtering and alignment
Plug 'godlygeek/tabular'

" Latex plugin
Plug 'lervag/vimtex'

" sxhk
Plug 'kovetskiy/sxhkd-vim'

" C++ compiler
Plug 'vim-scripts/SingleCompile'

" Ansible highlighting
Plug 'pearofducks/ansible-vim'
call plug#end()

" Commenting
nmap <C-_>   <Plug>NERDCommenterToggle
vmap <C-_>   <Plug>NERDCommenterToggle<CR>gv

" Old vim
if !exists('##TextYankPost')
  map y <Plug>(highlightedyank)
endif

" NERD commenter settings
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Syntax
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
" Disable style error message
let g:syntastic_quiet_messages = { "type": "style" }
let g:syntastic_mode_map = {
    \ "mode": "passive",
    \ "active_filetypes": [],
    \ "passive_filetypes": []}

let g:vim_markdown_folding_disabled = 1
" air-line
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

let g:airline#extensions#tabline#enabled = 1

" Dark background
set bg=dark

" Icerberg
colorscheme iceberg

" Transparency
highlight Normal guibg=NONE ctermbg=NONE
highlight NonText ctermbg=NONE
highlight LineNr ctermbg=NONE
highlight EndOfBuffer ctermbg=none
highlight ErrorMsg ctermbg=none
highlight Error ctermbg=none
highlight WarningMsg ctermbg=none
highlight Todo ctermbg=none

" Change unprintable chars color
highlight SpecialKey ctermbg=none ctermfg=blue guifg=grey70
set foldmethod=marker
set colorcolumn=80
set textwidth=80
" Remove splash screen
set shortmess+=I

" Vimtex config

" Detect latex files properly
let g:tex_flavor = 'latex'
" Disable underfull warnings
" let g:vimtex_quickfix_latexlog = {
"       \ 'overfull' : 0,
"       \ 'underfull' : 0,
"       \ 'packages' : {
"       \   'default' : 0,
"       \ },
"       \}
" Run and compile C++
nnoremap <F9> :silent !clear <CR> :SCCompileRunAF -g -Wall -Wextra -std=c++2a<CR><CR>

" Detect ansible yaml files
autocmd BufRead,BufNewFile */playbooks/*.yml set filetype=yaml.ansible
" Box of devops
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

"" Buffer stuff

" Hide buffers instead of unloading them
set hidden

" Cycle through buffers
nnoremap gb :bnext<CR>
nnoremap gB :bprevious<CR>

" Reload sxhkd on write to sxhkdrc
au BufWritePost *sxhkdrc :silent exec "!pkill -USR1 -x sxhkd"
au BufWritePost *bspwmrc :silent exec "!bspc wm -r"
