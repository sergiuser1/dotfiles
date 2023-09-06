" Vim configuration

"" Sensible defaults

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

"" Plugins
call plug#begin('~/.vim/plugged')

" Kotlin
Plug 'udalov/kotlin-vim'

" Indent lines
Plug 'Yggdroot/indentLine'

" Terraform
Plug 'hashivim/vim-terraform'

" Code completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Dotnet stuff
Plug 'OmniSharp/omnisharp-vim'

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
" Plug 'vim-syntastic/syntastic'

" Markdown highlighting
Plug 'plasticboy/vim-markdown'

" Alligning tables
Plug 'dhruvasagar/vim-table-mode'

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
au CursorHold,CursorHoldI * silent! checktime
" Autoformat
" autocmd FileType tex,text set formatoptions+=a

" Show command typed
set showcmd
" Show existing tab with 4 spaces width
set tabstop=4
" Use same indent as tabstop
set shiftwidth=0
" On pressing tab, insert 4 spaces
set expandtab
set autoindent

"" Commands
" Allow saving of files as root
command! W :execute ':silent w !sudo tee % > /dev/null' | :edit!
" Remove trailing whitespace
command! RmWhite :%s/\s\+$//e
" Replace every multiple space with only one
command! ChSpace :%s/\S\zs\(\s\)\{2,}\ze\S/\1/eg
" Remove Windows LF
command! Rwind :%s///e

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
let g:NERDDefaultAlign = 'start'

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
set background=dark

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
set textwidth=0
" Remove splash screen
set shortmess+=I

"" Vimtex config

" Detect latex files properly
let g:vimtex_syntax_conceal_disable = 1
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

" Fzf keybinds
nnoremap <leader>i :History<CR>
nnoremap <leader>f :Files<CR>
" Show untracked files
nnoremap <leader>g :GFiles --cached --others --exclude-standard<CR>
nnoremap <leader>r :Rg<Space>
" Search for the word under cursos
nnoremap <leader>e :Rg \b<c-r><c-w>\b<CR>
nnoremap <leader>b :Buffers<CR>

autocmd FileType gitcommit set colorcolumn=72 | set textwidth=72
" Close buffer without closing window
nnoremap <silent> <Leader>q :bp<BAR>bd#<CR>

" Copy-pasted from Readme
augroup omnisharp_commands
  autocmd!

  " Show type information automatically when the cursor stops moving.
  " Note that the type is echoed to the Vim command line, and will overwrite
  " any other messages in this space including e.g. ALE linting messages.
  autocmd CursorHold *.cs OmniSharpTypeLookup

  " The following commands are contextual, based on the cursor position.
  autocmd FileType cs nmap <silent> <buffer> gd <Plug>(omnisharp_go_to_definition)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfu <Plug>(omnisharp_find_usages)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfi <Plug>(omnisharp_find_implementations)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ospd <Plug>(omnisharp_preview_definition)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ospi <Plug>(omnisharp_preview_implementations)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ost <Plug>(omnisharp_type_lookup)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osd <Plug>(omnisharp_documentation)augroup omnisharp_commands
  autocmd!

  " Show type information automatically when the cursor stops moving.
  " Note that the type is echoed to the Vim command line, and will overwrite
  " any other messages in this space including e.g. ALE linting messages.
  autocmd CursorHold *.cs OmniSharpTypeLookup

  " The following commands are contextual, based on the cursor position.
  autocmd FileType cs nmap <silent> <buffer> gd <Plug>(omnisharp_go_to_definition)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfu <Plug>(omnisharp_find_usages)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfi <Plug>(omnisharp_find_implementations)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ospd <Plug>(omnisharp_preview_definition)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ospi <Plug>(omnisharp_preview_implementations)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ost <Plug>(omnisharp_type_lookup)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osd <Plug>(omnisharp_documentation)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfs <Plug>(omnisharp_find_symbol)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfx <Plug>(omnisharp_fix_usings)
  autocmd FileType cs nmap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)
  autocmd FileType cs imap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)

  " Navigate up and down by method/property/field
  autocmd FileType cs nmap <silent> <buffer> [[ <Plug>(omnisharp_navigate_up)
  autocmd FileType cs nmap <silent> <buffer> ]] <Plug>(omnisharp_navigate_down)
  " Find all code errors/warnings for the current solution and populate the quickfix window
  autocmd FileType cs nmap <silent> <buffer> <Leader>osgcc <Plug>(omnisharp_global_code_check)
  " Contextual code actions (uses fzf, vim-clap, CtrlP or unite.vim selector when available)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osca <Plug>(omnisharp_code_actions)
  autocmd FileType cs xmap <silent> <buffer> <Leader>osca <Plug>(omnisharp_code_actions)
  " Repeat the last code action performed (does not use a selector)
  autocmd FileType cs nmap <silent> <buffer> <Leader>os. <Plug>(omnisharp_code_action_repeat)
  autocmd FileType cs xmap <silent> <buffer> <Leader>os. <Plug>(omnisharp_code_action_repeat)

  autocmd FileType cs nmap <silent> <buffer> <Leader>os= <Plug>(omnisharp_code_format)

  autocmd FileType cs nmap <silent> <buffer> <Leader>osnm <Plug>(omnisharp_rename)

  autocmd FileType cs nmap <silent> <buffer> <Leader>osre <Plug>(omnisharp_restart_server)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osst <Plug>(omnisharp_start_server)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ossp <Plug>(omnisharp_stop_server)
augroup END

" Only conceal text in normal mode
set concealcursor=n
