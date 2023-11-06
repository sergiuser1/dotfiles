" Vim configuration

"" Sensible defaults

" Don't auto set end of line
set nofixeol

" Use Space as the leader instead of backslash
map <SPACE> <leader>

" Save to disk every 100ms
set updatetime=100

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

" Show line numbers
set relativenumber
set number

" Disable read-only warnings
au BufEnter * set noro

"" Spell stuff
set spelllang=en_gb
" Enable word completion when spell is set
set complete+=kspell

set autoread
au CursorHold,CursorHoldI * silent! checktime
" Show command typed
set showcmd
" Show existing tab with 4 spaces width
set tabstop=4
" Use same indent as tabstop
set shiftwidth=0
" On pressing tab, insert 4 spaces
set expandtab
set autoindent

" Only conceal text in normal mode
set concealcursor=n

set hidden

" Cycle through buffers
nnoremap gb :bnext<CR>
nnoremap gB :bprevious<CR>

" Open new windows below and right
set splitbelow
set splitright

" Filetype specific configs
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType c setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType gitcommit set colorcolumn=72 | set textwidth=72

" Don't cut by default
nnoremap x "_x
nnoremap d "_d
nnoremap D "_D
vnoremap d "_d
nnoremap c "_c
nnoremap s "_s
nnoremap C "_C
nnoremap Y y$

nnoremap <leader>dd "+dd
nnoremap <leader>x "+x
nnoremap <leader>d "+d
nnoremap <leader>D "cD
vnoremap <leader>d "+d
" Yank the contents of the file
nnoremap <leader>Y :%y<CR>

" Close buffer without closing window
nnoremap <silent> <Leader>q :bp<BAR>bd#<CR>

"" Commands
" Allow saving of files as root
command! W :execute ':silent w !sudo tee % > /dev/null' | :edit!
" Remove trailing whitespace
command! RWhite :%s/\s\+$//e
" Replace every multiple space with only one
command! ChSpace :%s/\S\zs\(\s\)\{2,}\ze\S/\1/eg
" Remove Windows LF
command! RWind :%s///e

" Use system clipboard by default
set clipboard=unnamedplus
set shortmess=a
" Use case insensitive search
set ignorecase
set smartcase
" But not for insert mode completion
au InsertEnter * set noignorecase
au InsertLeave * set ignorecase

"" Search
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
" Use incremental search
set incsearch

" Show unprintable characters
set list
set listchars=tab:•\ ,trail:•,extends:»,precedes:«,nbsp:‡


" Plugins
" call plug#begin('~/.vim/plugged')

" Kotlin
" Plug 'udalov/kotlin-vim'

" Indent lines
" Plug 'Yggdroot/indentLine'

" Terraform
" Plug 'hashivim/vim-terraform'

" Code completion
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Dotnet stuff
" Plug 'OmniSharp/omnisharp-vim'

" Better yaml
" Plug 'stephpy/vim-yaml'

" Better diffs
" Plug 'airblade/vim-gitgutter'

" Fuzzy
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'junegunn/fzf.vim'

" File explorer
" Plug 'preservim/nerdtree'

" Surround words
" Plug 'tpope/vim-repeat'

" Surround words
" Plug 'tpope/vim-surround'

" vim-airline
" Plug 'vim-airline/vim-airline'

" vim-airline-themes
" Plug 'vim-airline/vim-airline-themes'

" Plug 'jamessan/vim-gnupg'

" Better color scheme
" Plug 'cocopon/iceberg.vim/'

" Higlight the yanked region
" Plug 'machakann/vim-highlightedyank'

" Easy commenting
" Plug 'scrooloose/nerdcommenter'


" Markdown highlighting
" Plug 'plasticboy/vim-markdown'

" Alligning tables
" Plug 'dhruvasagar/vim-table-mode'

" Latex plugin
" Plug 'lervag/vimtex'

" sxhk
" Plug 'kovetskiy/sxhkd-vim'

" C++ compiler
" Plug 'vim-scripts/SingleCompile'

" Ansible highlighting
" Plug 'pearofducks/ansible-vim'

" Git plugin
" Plug 'tpope/vim-fugitive'

" C++ better highlight
" Plug 'bfrg/vim-cpp-modern'

" SudoEdit
" Plug 'chrisbra/SudoEdit.vim'

" Incremental search
" Plug 'haya14busa/is.vim'
" call plug#end()



" Commenting
" nmap <C-_>   <Plug>NERDCommenterToggle
" vmap <C-_>   <Plug>NERDCommenterToggle<CR>gv

" Old vim
" if !exists('##TextYankPost')
"   map y <Plug>(highlightedyank)
" endif

" NERD commenter settings
" Add spaces after comment delimiters by default
" let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
" let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
" let g:NERDDefaultAlign = 'start'

" let g:vim_markdown_folding_disabled = 1
" air-line
" let g:airline_powerline_fonts = 1

" let g:airline#extensions#tabline#enabled = 1

" Dark background
" set background=dark

" Icerberg
" colorscheme iceberg

" Transparency
" highlight Normal guibg=NONE ctermbg=NONE
" highlight NonText ctermbg=NONE
" highlight LineNr ctermbg=NONE
" highlight EndOfBuffer ctermbg=none
" highlight ErrorMsg ctermbg=none
" highlight Error ctermbg=none
" highlight WarningMsg ctermbg=none
" highlight Todo ctermbg=none

" Change unprintable chars color
" highlight SpecialKey ctermbg=none ctermfg=blue guifg=grey70
" set foldmethod=marker
" set colorcolumn=80
" set textwidth=0
" Remove splash screen
" set shortmess+=I

" Vimtex config

" Detect latex files properly
" let g:vimtex_syntax_conceal_disable = 1
" let g:tex_flavor = 'latex'
" Don't open quickfix on warnings
" let g:vimtex_quickfix_open_on_warning = 0
" Disable underfull warnings
" let g:vimtex_quickfix_ignore_filters = [
"       \ 'Marginpar on page',
"       \ 'Overfull',
"       \ 'Underfull',
"       \ 'overfull',
"       \ 'underfull',
"       \ 'citation',
"  \]

" augroup vimtex_event_1
"     au!
"     au User VimtexEventQuit     call vimtex#compiler#clean(0)
"     au User VimtexEventInitPost call vimtex#compiler#compile()
" augroup END

" let g:vimtex_compiler_latexmk = {
"     \ 'build_dir' : 'build',
"     \}
" let g:vimtex_view_method = 'zathura'

" let g:vimtex_complete_bib = { 'menu_fmt': '[@type] "@title", (@year)' }

" autocmd BufRead,BufNewFile *.tex inoremap <C-f> \textit{
" autocmd BufRead,BufNewFile *.tex inoremap <C-b> \textbf{
" autocmd BufRead,BufNewFile *.tex inoremap <C-l> \texttt{


" Reload sxhkd on write to sxhkdrc
" au BufWritePost *sxhkdrc :silent exec "!pkill -USR1 -x sxhkd"
" au BufWritePost *bspwmrc :silent exec "!bspc wm -r"

" Built-in packages
" packadd! matchit

" No backup files after writing
" set nobackup writebackup

" No warning for ReadOnly files
" autocmd FileChangedRO * echohl WarningMsg | echo "File changed RO." | echohl None
" nnoremap <C-n> :NERDTreeToggle<CR>

" Fzf keybinds
" nnoremap <leader>i :History<CR>
" nnoremap <leader>f :Files<CR>
" Show untracked files
" nnoremap <leader>g :GFiles --cached --others --exclude-standard<CR>
" nnoremap <leader>r :Rg<Space>
" Search for the word under cursos
" nnoremap <leader>e :Rg \b<c-r><c-w>\b<CR>
" nnoremap <leader>b :Buffers<CR>
