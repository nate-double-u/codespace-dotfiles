" ~/.config/nvim/init.vim

" sane defaults
set nocompatible
filetype plugin on
syntax on

" leader key (set early so all mappings pick it up)
let mapleader=","

" # Plugin setup

" Bootstrap vim-plug on fresh machines (including codespaces)
let s:plug_file = stdpath('data') . '/site/autoload/plug.vim'
if empty(glob(s:plug_file))
  silent execute '!curl -fLo ' . shellescape(s:plug_file) . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  execute 'source ' . fnameescape(s:plug_file)
endif

call plug#begin()

" ## File Tree
Plug 'preservim/nerdtree'

" ## Git stuff
Plug 'airblade/vim-gitgutter'
Plug 'Xuyuanp/nerdtree-git-plugin'

" ## Linters stuff
" Plug 'w0rp/ale'
Plug 'dense-analysis/ale'

" ## Editor Config Support
Plug 'editorconfig/editorconfig-vim'

" ## Syntax helpers
Plug 'anyakichi/vim-surround'
Plug 'cakebaker/scss-syntax.vim'
Plug 'glench/vim-jinja2-syntax'
Plug 'stephpy/vim-yaml'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'ap/vim-css-color'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'pangloss/vim-javascript'
Plug 'ryanoasis/vim-devicons'
Plug 'blueshirts/darcula'
Plug 'mustache/vim-mustache-handlebars'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'jxnblk/vim-mdx-js'
Plug 'chr4/nginx.vim'
Plug 'martinda/jenkinsfile-vim-syntax'

" ## GitHub Copilot
Plug 'github/copilot.vim'

" ## Fuzzy finding
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

" Install any missing plugins on startup
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)')) | PlugInstall --sync | source $MYVIMRC | endif

" # Colors and other basic settings
syntax enable
silent! colorscheme darcula
" colorscheme gruvbox
" set guifont=Inconsolata\ 10
set fillchars+=vert:\│
set background=dark
set ruler
set hidden
set number
" set relativenumber
set laststatus=2
set smartindent
autocmd Filetype javascript setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype nginx setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype Jenkinsfile setlocal ts=2 sts=2 sw=2 expandtab
autocmd Filetype python setlocal ts=4 sts=4 sw=4 expandtab
let &colorcolumn="80"
:set nolist wrap linebreak breakat&vim
:command W w
:command Q q
:command Wq wq
:command WQ wq

" ## handlebars
autocmd BufRead,BufNewFile *.hbs set syntax=mustache 

" ## Ale Linter settings for JavaScript Standard
let g:ale_linters = {
\   'javascript': ['standard'],
\}
let g:ale_fixers = {'javascript': ['standard']}

" linting and fixing on save
" let g:ale_lint_on_save = 1
" let g:ale_fix_on_save = 1

" #$ Indent Guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=grey   ctermbg=237
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=lightgrey ctermbg=236

" # NERDTREE
let NERDTreeIgnore = ['__pycache__', '\.pyc$', '\.o$', '\.so$', '\.a$', '\.swp', '*\.swp', '\.swo', '\.swn', '\.swh', '\.swm', '\.swl', '\.swk', '\.sw*$', '[a-zA-Z]*egg[a-zA-Z]*', '.DS_Store']

let NERDTreeShowHidden=1
let g:NERDTreeWinPos="left"
let g:NERDTreeDirArrows=0
map <C-t> :NERDTreeToggle<CR>

let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }

let g:NERDTreeGitStatusShowIgnored = 1

" # mouse in normal mode only (use `set mouse=` to disable entirely)
set mouse=n

" # copy and paste
set clipboard=unnamed


