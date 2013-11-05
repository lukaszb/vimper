" Include user's local 'before' vim config
if filereadable(expand("~/.vimrc.before"))
  source ~/.vimrc.before
endif

" ==============================================================================
" Pathogen
" ==============================================================================
call pathogen#incubate()
call pathogen#helptags()

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ee :e $MYVIMRC<CR>
nmap <silent> <leader>er :so $MYVIMRC<CR>

" Automatic reloading of .vimrc
autocmd! bufwritepost $MYVIMRC source %

" ==============================================================================
" Basics
" ==============================================================================

filetype plugin indent on
syntax on
set background=dark
colorscheme ir_black
set visualbell

nnoremap ' `
nnoremap ` '
let mapleader=','

" numbering
set ruler
set number
set numberwidth=6
" Allow CTRL+L to toggle line numbering
nmap <C-L> :execute 'set nu!'<CR>

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" sorting
vnoremap <Leader>s :sort<CR>

" Whitespace stuff
set wrap
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set list
set listchars=tab:>·,trail:·,extends:>,precedes:< ",eol:$
"autocmd filetype html,xml set listchars-=tab:>.
set pastetoggle=<F2>
nmap <silent> <leader>ww :%s/\s\+$//e<CR> :echo "Whitespace removed"<CR>
nmap <silent> <leader>wt :set list!<CR>

" Searching
set hlsearch
set incsearch
set noignorecase
set smartcase

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,*.rbc,.git,.hg,.svn,.bzr,*.pyc,*.egg,*.egg-info

"Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup

" ... which we actually won't use
set nobackup
set nowritebackup
set noswapfile

" Status bar
set laststatus=2

" Cursor line
set cursorline

" Bell
set visualbell

"Tabs and spaces
set smartindent
set tabstop=4

"Status line"
set statusline=%<%f\%h%m%r%=%-20.(line=%l\ \ col=%c%V\ \ totlin=%L%)\ \ \%h%m%r%=%-40(bytval=0x%B,%n%Y%)\%P
hi StatusLine ctermbg=7 ctermfg=0 gui=undercurl guisp=Yellow

"Sets offset"
set scrolloff=5

" cope (Error list)
nnoremap <Leader>E :cope <CR>

" Bubble lines
inoremap <C-Up> <Esc>:m-2<CR>==gi
inoremap <C-Down> <Esc>:m+<CR>==gi
"nnoremap <C-Up> :m-2<CR>==
"nnoremap <C-Down> :m+<CR>==
vnoremap <C-Up> :m-2<CR>gv=gv
vnoremap <C-Down> :m'>+<CR>gv=gv

" Move around windows
map <C-Up> <C-w>k
map <C-Down> <C-w>j
map <C-Left> <C-w>h
map <C-Right> <C-w>l

" Use modeline overrides
set modeline
set modelines=10

" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif
endif

" Error marker at ~80 character
autocmd BufWinEnter *.py,*.txt,*.rst,*.c,*.cpp let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
set colorcolumn=81

" Better indentation
vnoremap < <gv
vnoremap > >gv
nmap <D-]> >>
vmap <D-]> >>
imap <D-]> <C-O>>>
nmap <D-[> <<
vmap <D-[> <<
imap <D-[> <C-O><<



" ==============================================================================
" NERDTree & NERDTreeTabs configuration
" ==============================================================================
:nmap <C-N> :execute 'NERDTreeTabsToggle' <CR>
let NERDTreeIgnore=['\~$', '\.pyc$', '\.orig', '\.swp\*', '__pycache__']
let NERDTreeHighlightCursorline=1
let NERDTreeWinSize=50


" ==============================================================================
" Filetypes
" ==============================================================================
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType html set filetype=htmldjango
autocmd BufEnter *.html set ft=htmldjango
autocmd BufRead,BufNewFile *.applescript set filetype=applescript

" closetag
autocmd Filetype html,xml,xsl source ~/.vim/bundle/closetag/plugin/closetag.vim
imap <C-_> <C-r>=GetCloseTag()<CR>


" ==============================================================================
" Simple scripts running
" ==============================================================================
autocmd FileType coffee map <buffer> <Leader>rr :w<CR>:new<CR>:r!/usr/bin/env coffee # <CR>
autocmd FileType coffee map <buffer> <Leader>R :w<CR>:!/usr/bin/env coffee %<CR>
autocmd FileType python map <buffer> <Leader>rr :w<CR>:new<CR>:r!/usr/bin/env python # <CR>
autocmd FileType python map <buffer> <Leader>R :w<CR>:!/usr/bin/env python %<CR>
autocmd FileType ruby map <buffer> <Leader>rr :w<CR>:new<CR>:r!/usr/bin/env ruby # <CR>
autocmd FileType ruby map <buffer> <Leader>R :w<CR>:!/usr/bin/env ruby % <CR>
autocmd FileType sh map <buffer> <Leader>rr :w<CR>:new<CR>:r!/usr/bin/env sh # <CR>
autocmd FileType sh map <buffer> <Leader>R :w<CR>:!/usr/bin/env sh % <CR>
autocmd FileType javascript map <buffer> <Leader>rr :w<CR>:new<CR>:r!/usr/bin/env node # <CR>
autocmd FileType javascript map <buffer> <Leader>R :w<CR>:!/usr/bin/env node % <CR>

"
" ==============================================================================
" Load platform specific settings
" ==============================================================================
if has('mac')
    source ~/.vim/conf/osx
endif
if !has('mac') && has('unix')
    source ~/.vim/conf/linux
endif
if has('win32')
    source ~/.vim/conf/windows
endif


" ==============================================================================
" Python-Mode
" ==============================================================================

let g:pymode_options = 0
let g:pymode_syntax = 0
let g:pymode_rope_guess_project = 1
let g:pymode_utils_whitespaces = 0

let g:pymode_rope = 1
let g:pymode_folding = 0
let g:pymode_rope_auto_project = 1
let g:pymode_rope_enable_autoimport = 1
let g:pymode_rope_autoimport_generate = 1
let g:pymode_rope_autoimport_modules = ["os","shutil","datetime"]
let g:pymode_rope_vim_completion = 1
let g:pymode_rope_goto_def_newwin = "tabnew"

let g:pymode_lint = 0

map <C-g> :RopeGotoDefinition<CR>

" ==============================================================================
" SingleCompile
" ==============================================================================
nmap <F8> :SCViewResult<cr>
nmap <F9> :SCCompile<cr>
nmap <F10> :SCCompileRun<cr>

" ==============================================================================
" Powerline
" ==============================================================================
let g:Powerline_symbols = 'fancy'

" ==============================================================================
" CtrlP
" ==============================================================================
let g:ctrlp_custom_ignore = '\v(build|dist)[\/]'
let g:ctrlp_working_path_mode = '' " default is 'ra'

" ==============================================================================
" Tagbar [ctags]
" ==============================================================================
" support for extra file types: https://github.com/majutsushi/tagbar/wiki
nmap <leader>t :TagbarToggle<CR>

" ==============================================================================
" Gundo
" ==============================================================================
nnoremap <C-h> :GundoToggle<CR>

" ==============================================================================
" Multiple-Cursors
" ==============================================================================
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-b>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<C-c>'


" Include user's local vim config
if filereadable(expand("~/.vimrc.after"))
  source ~/.vimrc.after
endif

