set relativenumber
set number
syntax on
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab
" Allow saving of files as sudo when I forgot to start vim using sudo.
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!
" Use system clipboard by default
set clipboard=unnamedplus
set shortmess=a
" Use case insensitive search
set ignorecase
set smartcase
nnoremap x "_x
nnoremap d "_d
nnoremap D "_D
vnoremap d "_d
nnoremap c "_c
nnoremap s "_s
nnoremap C "_C

nnoremap <leader>dd "+dd
nnoremap <leader>d "cd
nnoremap <leader>D "cD
vnoremap <leader>d "cd
vnoremap <leader>d "+d
" Execute current file
nnoremap <F9> :w<CR> :!clear && %:p<Enter>
" Compile and run C file
map <F8> :w <CR> :!clear && gcc % -o %< && ./%< <CR>
" Save and restart i3
map <F10> :w <CR> :!i3 restart <CR><CR>
" F3: Toggle list (display unprintable characters).
nnoremap <F3> :set list!<CR>

" set _ as a word boundary
set iskeyword-=_

" Use the incremental search
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

set list          " Display unprintable characters f12 - switches
set listchars=tab:•\ ,trail:•,extends:»,precedes:«,nbsp:‡ " Unprintable chars mapping

" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" vim-airline
Plug 'vim-airline/vim-airline'

" incremental searching
Plug 'haya14busa/incsearch.vim'

Plug 'jamessan/vim-gnupg'

" Better color scheme
Plug 'cocopon/iceberg.vim/'

" Higlight the yanked region
Plug 'machakann/vim-highlightedyank'

" Easy commenting
Plug 'scrooloose/nerdcommenter'

" Syntax check
Plug 'vim-syntastic/syntastic'
call plug#end()

" Commenting
nmap <C-_>   <Plug>NERDCommenterToggle
vmap <C-_>   <Plug>NERDCommenterToggle<CR>gv

" cool color scheme
colorscheme iceberg

" Change unprintable chars color
highlight SpecialKey ctermfg=blue guifg=grey70

" Old vim
if !exists('##TextYankPost')
  map y <Plug>(highlightedyank)
endif
" Syntax
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0

