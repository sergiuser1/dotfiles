" Vim configuration

"" Sensible defaults

" Make Esc take effect more quickly. Might be bad over SSH
set ttimeout
set ttimeoutlen=50

" Show @@ in the last line if it is truncated
set display=truncate

" Do not recognize numbers starting with a zero as octal.
set nrformats-=octal

" Format with Q
map Q gq

" When deleting with ctrl-{u,w}, keep the undo
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" Enable syntax highlighting
syntax on

" Detect filetype and others automatically
filetype plugin indent on

" Only do this part when Vim was compiled with the +eval feature.
if 1

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  " Revert with ":filetype off".
  filetype plugin indent on

  " Put these in an autocmd group, so that you can revert them with:
  " ":augroup vimStartup | au! | augroup END"
  augroup vimStartup
    au!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim) and for a commit message (it's
    " likely a different one than last time).
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif

  augroup END

endif

"" Plugins
call plug#begin('~/.vim/plugged')

" Better yaml
Plug 'stephpy/vim-yaml'

" Better diffs
Plug 'airblade/vim-gitgutter'

" Fuzzy
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" File explorer
Plug 'preservim/nerdtree'

" Surround words
Plug 'tpope/vim-repeat'

" Surround words
Plug 'tpope/vim-surround'

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

" Git plugin
Plug 'tpope/vim-fugitive'

" C++ better highlight
Plug 'bfrg/vim-cpp-modern'

" SudoEdit
Plug 'chrisbra/SudoEdit.vim'

" Incremental search
Plug 'haya14busa/is.vim'
call plug#end()

" Show line numbers
set relativenumber
set number

" Disable read-only warnings
au BufEnter * set noro

"" Spell stuff
set spelllang=en_gb
" Enable word completion when spell is set
set complete+=kspell

" Autoreload
set autoread
au CursorHold,CursorHoldI * checktime
" Autoformat
" autocmd FileType tex,text set formatoptions+=a
" Show command typed
set showcmd
" Show existing tab with 4 spaces width
set tabstop=4
" When indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab
set autoindent
" Allow saving of files as root
command! W :execute ':silent w !sudo tee % > /dev/null' | :edit!
" Remove trailing whitespace
command! RmWhite :%s/\s\+$//e
" Replace every multiple space with only one
command! ChSpace :%s/\S\zs\(\s\)\{2,}\ze\S/\1/eg
" Use system clipboard by default
set clipboard=unnamedplus
set shortmess=a
" Use case insensitive search
set ignorecase
set smartcase
" But not for insert mode completion
au InsertEnter * set noignorecase
au InsertLeave * set ignorecase

" Reload vimrc after writing to it
" autocmd BufWritePost .vimrc source %

" Don't cut by default
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
nnoremap <leader>x "+x
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

" Use incremental search
set incsearch

" Remap Tab and Shift-Tab for cycling around matches
" For replacing with previous search look at
" https://vi.stackexchange.com/a/387
if v:version >= 800
    augroup vimrc-incsearch-highlight
      autocmd!
      autocmd CmdlineEnter /,\? :cnoremap <Tab> <C-G>| cnoremap <S-Tab> <C-T>|
                  \set hlsearch
      autocmd CmdlineLeave /,\? :cunmap <Tab>| cunmap <S-Tab>|set nohlsearch
    augroup END
endif
" Clear screen with Control L
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" Show unprintable characters
set list
set listchars=tab:•\ ,trail:•,extends:»,precedes:«,nbsp:‡


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
"
" Disable style error message
let g:syntastic_quiet_messages = { "type": "style" }
let g:syntastic_mode_map = {
    \ "mode": "passive",
    \ "active_filetypes": ["python"],
    \ "passive_filetypes": [] }

let g:vim_markdown_folding_disabled = 1
" air-line
let g:airline_powerline_fonts = 1

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

"" Vimtex config

" Detect latex files properly
let g:tex_flavor = 'latex'
" Don't open quickfix on warnings
let g:vimtex_quickfix_open_on_warning = 0
" Disable underfull warnings
let g:vimtex_quickfix_ignore_filters = [
      \ 'Marginpar on page',
      \ 'Overfull',
      \ 'Underfull',
      \ 'overfull',
      \ 'underfull',
      \ 'citation',
 \]

augroup vimtex_event_1
    au!
    au User VimtexEventQuit     call vimtex#compiler#clean(0)
    " au User VimtexEventInitPost call vimtex#compiler#compile()
augroup END

let g:vimtex_compiler_latexmk = {
    \ 'build_dir' : 'build',
    \}
let g:vimtex_view_method = 'zathura'

let g:vimtex_complete_bib = { 'menu_fmt': '[@type] "@title", (@year)' }

autocmd BufRead,BufNewFile *.tex inoremap <C-f> \textit{
autocmd BufRead,BufNewFile *.tex inoremap <C-b> \textbf{
autocmd BufRead,BufNewFile *.tex inoremap <C-l> \texttt{

" Run and compile C++
nnoremap <F9> :silent !clear <CR> :SCCompileRunAF -g -Wall -Wextra -std=c++2a<CR><CR>

" Detect ansible yaml files
autocmd BufRead,BufNewFile */playbooks/*.yml set filetype=yaml.ansible
" Box of devops
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" C magic
autocmd FileType c setlocal ts=2 sts=2 sw=2 expandtab

"" Buffer stuff

" Hide buffers instead of unloading them
set hidden

" Cycle through buffers
nnoremap gb :bnext<CR>
nnoremap gB :bprevious<CR>

" Open new windows below and right
set splitbelow
set splitright

" Reload sxhkd on write to sxhkdrc
au BufWritePost *sxhkdrc :silent exec "!pkill -USR1 -x sxhkd"
au BufWritePost *bspwmrc :silent exec "!bspc wm -r"

"" Built-in packages
packadd! matchit

" No backup files after writing
set nobackup writebackup

" No warning for ReadOnly files
autocmd FileChangedRO * echohl WarningMsg | echo "File changed RO." | echohl None
nnoremap <C-n> :NERDTreeToggle<CR>

" Thesis stuff
if match(getcwd(), '.*micro-firewalls') != -1
    set path+=../contiki-ng/os/
    command!      -bang -nargs=* Crg    call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>)." ../contiki-ng/os", 1, fzf#vim#with_preview(), <bang>0)

    command!      -bang  Cfiles         call fzf#vim#files('../contiki-ng/', fzf#vim#with_preview(), <bang>0)
endif

nnoremap <leader>h :History<CR>
nnoremap <leader>f :Files<CR>
