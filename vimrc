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
colorscheme ir_black
set background=dark
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
set nolist
set listchars=eol:$,tab:>-,trail:.,extends:>,precedes:<
autocmd filetype html,xml set listchars-=tab:>.
set pastetoggle=<F2>
nmap <F3> :execute 'set list!'<CR>
nmap <silent> <leader>ww :%s/\s\+$//e<CR> :echo "Whitespace removed"<CR>

" Searching
set hlsearch
set incsearch
set noignorecase
set smartcase

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,*.rbc,.git,.hg,.svn,.bzr,*.pyc

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

" CTags
map <Leader>rt :!ctags --extra=+f -R *<CR><CR>
"Toggle Tags List
nmap <C-C> :execute 'TlistToggle' <CR>
let Tlist_Use_Right_Window = 1
let Tlist_Sort_Type = "name"
let Tlist_WinWidth = 40

" Bubble lines
inoremap <C-Up> <Esc>:m-2<CR>==gi
inoremap <C-Down> <Esc>:m+<CR>==gi
nnoremap <C-Up> :m-2<CR>==
nnoremap <C-Down> :m+<CR>==
vnoremap <C-Up> :m-2<CR>gv=gv
vnoremap <C-Down> :m'>+<CR>gv=gv

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
" NERDTree configuration
" ==============================================================================
:nmap <C-N> :execute 'NERDTreeToggle ' .getcwd() <CR>
":nmap <C-N> :execute 'NERDTreeTabsToggle ' <CR>
let NERDTreeIgnore=['\~$', '\.pyc$', '\.orig', '\.swp\*', '__pycache__']
let NERDTreeHighlightCursorline=1
let NERDTreeWinSize=50


" ==============================================================================
" Filetypes
" ==============================================================================
autocmd FileType python set omnifunc=pythoncomplete#Complete


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
" SingleCompile
" ==============================================================================
nmap <F9> :SCCompile<cr>
nmap <F10> :SCCompileRun<cr>

