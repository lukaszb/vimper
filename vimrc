" Include user's local 'before' vim config
if filereadable(expand("~/.vimrc.before"))
  source ~/.vimrc.before
endif

" ==============================================================================
" Pathogen
" ==============================================================================
call pathogen#infect()
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

set foldlevelstart=10 " open file with all 10-depth folds opened

set splitright " vnew creates new buffer on the right

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

" set encoding
scriptencoding utf-8
set encoding=utf-8

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
set wildignore+=*.o,*.obj,*.rbc,.git,.hg,.svn,.bzr,*.pyc,*.egg,*.egg-info,.tox,.ropeproject,.venv,venv

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

" CDC = Change to Directory of Current file
command CDC cd %:p:h

" Error marker at ~100 character
autocmd BufWinEnter *.py,*.txt,*.rst,*.c,*.cpp let w:m2=matchadd('ErrorMsg', '\%>100v.\+', -1)
set colorcolumn=101

" Better indentation
vnoremap < <gv
vnoremap > >gv
nmap <D-]> >>
vmap <D-]> >>
imap <D-]> <C-O>>>
nmap <D-[> <<
vmap <D-[> <<
imap <D-[> <C-O><<

" delimitMate split bracketes with newline
imap <C-c> <CR><Esc>O



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

autocmd FileType go nmap <leader>R <CR>:GoRun %<CR>
autocmd FileType go nmap <leader>rr <Plug>(go-run)
"autocmd FileType go nmap <leader>b <Plug>(go-build)
"autocmd FileType go nmap <leader>t <Plug>(go-test)
"autocmd FileType go nmap <leader>c <Plug>(go-coverage)

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

"let g:pymode = 1
let g:pymode_options = 0
let g:pymode_syntax = 0
let g:pymode_rope_guess_project = 1
let g:pymode_utils_whitespaces = 0

let g:pymode_rope = 1
let g:pymode_folding = 0
let g:pymode_rope_auto_project = 1
let g:pymode_rope_enable_autoimport = 0
let g:pymode_rope_autoimport_generate = 0
let g:pymode_rope_autoimport_modules = ["os","shutil","datetime"]
let g:pymode_rope_vim_completion = 1
let g:pymode_rope_complete_on_dot = 0
let g:pymode_virtualenv = 1

let g:pymode_lint = 0

let g:pymode_rope_goto_definition_bind = '<C-g>'
let g:pymode_rope_goto_definition_cmd = 'tabnew'

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

" Almost all the config was taken from vimfiles repo

" No default mappings.
let g:ctrlp_map = ''

" Directory mode for launching ':CtrlP' with no directory argument:
"   0 - Don't manage the working directory (Vim's CWD will be used).
"       Same as ':CtrlP $PWD'.
let g:ctrlp_working_path_mode = 0

" Set to list of marker directories used for ':CtrlPRoot'.
" A marker signifies that the containing parent directory is a "root".  Each
" marker is probed from current working directory all the way up, and if
" the marker is not found, then the next marker is checked.
let g:ctrlp_root_markers = []

" Don't open multiple files in vertical splits.  Just open them, and re-use the
" buffer already at the front.
let g:ctrlp_open_multiple_files = '1vr'

" :C [path]  ==> :CtrlP [path]
command! -n=? -com=dir C CtrlP <args>

" :CD [path]  ==> :CtrlPDir [path]
command! -n=? -com=dir CD CtrlPDir <args>

" Define prefix mapping for CtrlP plugin so that buffer-local mappings
" for CTRL-P (such as in Tagbar) will override all CtrlP plugin mappings.
nmap <C-P> <SNR>CtrlP.....

" An incomplete mapping should do nothing.
nnoremap <SNR>CtrlP.....      <Nop>

nnoremap <SNR>CtrlP.....<C-B> :<C-U>CtrlPBookmarkDir<CR>
nnoremap <SNR>CtrlP.....c     :<C-U>CtrlPChange<CR>
nnoremap <SNR>CtrlP.....C     :<C-U>CtrlPChangeAll<CR>
nnoremap <SNR>CtrlP.....<C-D> :<C-U>CtrlPDir<CR>
nnoremap <SNR>CtrlP.....<C-F> :<C-U>CtrlPCurFile<CR>
nnoremap <SNR>CtrlP.....<C-L> :<C-U>CtrlPLine<CR>
nnoremap <SNR>CtrlP.....<C-M> :<C-U>CtrlPMRU<CR>
nnoremap <SNR>CtrlP.....m     :<C-U>CtrlPMixed<CR>

" Mnemonic: "open files"
nnoremap <SNR>CtrlP.....<C-O> :<C-U>CtrlPBuffer<CR>
nnoremap <SNR>CtrlP.....<C-P> :<C-U>CtrlP<CR>
nnoremap <SNR>CtrlP.....<C-Q> :<C-U>CtrlPQuickfix<CR>
nnoremap <SNR>CtrlP.....<C-R> :<C-U>CtrlPRoot<CR>
nnoremap <SNR>CtrlP.....<C-T> :<C-U>CtrlPTag<CR>
nnoremap <SNR>CtrlP.....t     :<C-U>CtrlPBufTag<CR>
nnoremap <SNR>CtrlP.....T     :<C-U>CtrlPBufTagAll<CR>
nnoremap <SNR>CtrlP.....<C-U> :<C-U>CtrlPUndo<CR>

" Transitional mappings to migrate from historical Command-T functionality.
" At first, redirect to CtrlP equivalent functionality.  Later, just
" provide an error message.  Eventually, remove this mappings.
nnoremap <leader><leader>t :<C-U>echoe "Use CTRL-P CTRL-P instead"<Bar>
            \ sleep 1<Bar>
            \ CtrlP<CR>

nnoremap <leader><leader>b :<C-U>echoe "Use CTRL-P CTRL-O instead"<Bar>
            \ sleep 1<Bar>
            \ CtrlPBuffer<CR>

" Reverse move and history binding pairs:
" - For consistency with other plugins that use <C-N>/<C-P> for moving around.
" - Because <C-J> is bound to the tmux prefix key, so it's best to map
"   that key to a less-used function.
let g:ctrlp_prompt_mappings = {
    \ 'PrtSelectMove("j")':   ['<C-N>', '<down>'],
    \ 'PrtSelectMove("k")':   ['<C-P>', '<up>'],
    \ 'PrtHistory(-1)':       ['<C-J>'],
    \ 'PrtHistory(1)':        ['<C-K>'],
    \ }

" Maximum height of filename window.
let g:ctrlp_max_height = 50

let g:ctrlp_custom_ignore = '\v(build|dist|__pycache__|node_modules|bower_components|virtualenv)[\/]'

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

" ==============================================================================
" Riv (rst support)
" ==============================================================================
let g:riv_python_rst_hl=1

" ==============================================================================
" Syntastic
" ==============================================================================
let g:syntastic_aggregate_errors = 1
let g:syntastic_check_on_open=0
let g:syntastic_check_on_wq=1 " default
let g:syntastic_error_symbol='E'
let g:syntastic_warning_symbol='W'
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': ['javascript'],
                           \ }

" ==============================================================================
" UltiSnips
" ==============================================================================
let g:UltiSnipsSnippetDirectories=["UltiSnips"]

" ==============================================================================
" Tabs
" ==============================================================================

function! Tab2()
    set tabstop=2
    set shiftwidth=2
    set softtabstop=2
endfunction

function! Tab4()
    set tabstop=4
    set shiftwidth=4
    set softtabstop=4
endfunction

command! -nargs=0 Tab2 call Tab2()
command! -nargs=0 Tab4 call Tab4()


" Include user's local vim config
if filereadable(expand("~/.vimrc.after"))
  source ~/.vimrc.after
endif

