" ==============================================================================
" Pathogen
" ==============================================================================
call pathogen#incubate()
call pathogen#helptags()

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

" Whitespace stuff
set wrap
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set nolist
set listchars=eol:$,tab:>-,trail:.,extends:>,precedes:<
autocmd filetype html,xml set listchars-=tab:>.
nmap <F3> :execute 'set list!'<CR>
set pastetoggle=<F2>

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

