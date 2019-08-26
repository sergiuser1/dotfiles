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
cmap w!! w !sudo tee > /dev/null %
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

nnoremap <leader>d "cd
nnoremap <leader>D "cD
vnoremap <leader>d "cd

" Execute current file
nnoremap <F9> :w<CR> :!clear && %:p<Enter>

" set _ as a word boundary
set iskeyword-=_

" Use the incremental search
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

set list          " Display unprintable characters f12 - switches
set listchars=tab:•\ ,trail:•,extends:»,precedes:« " Unprintable chars mapping

" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" vim-airline
Plug 'vim-airline/vim-airline'

" incremental searching
Plug 'haya14busa/incsearch.vim'

Plug 'jamessan/vim-gnupg'

" Better color scheme
Plug 'cocopon/iceberg.vim/'
call plug#end()

" cool color scheme
colorscheme iceberg
