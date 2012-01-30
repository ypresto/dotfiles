autocmd BufRead *.go :colorscheme go

set rtp+=~/.vim/vundle/
call vundle#rc()
" necessary?
filetype plugin on

set encoding=utf-8
set fileencodings=ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932,utf-8
set number

Bundle 'mattn/zencoding-vim.git'
Bundle 'tpope/vim-surround.git'
Bundle 'Shougo/neocomplcache'
Bundle 'Shougo/unite.vim'
Bundle 'Shougo/vimshell'
Bundle 'Shougo/vimproc'
Bundle 'tpope/vim-surround'
Bundle 'thinca/vim-quickrun'
Bundle 'thinca/vim-ref'
Bundle 'kana/vim-fakeclip'
" Bundle 'rstacruz/sparkup'
Bundle 'sjl/gundo.vim'
" Bundle 'sukima/xmledit'
" autocmd FileType html,php,xml :source ~/.vim/bundle/xmledit/ftplugin/xml.vim 
Bundle 'soh335/vim-symfony'
Bundle 'sukima/xmledit'

source $VIMRUNTIME/macros/matchit.vim

let g:use_zen_complete_tag = 1
let g:user_zen_expandabbr_key = '<c-e>'

" http://www.vim.org/scripts/script.php?script_id=3172
autocmd FileType php set omnifunc=phpcomplete
if has("autocmd") && exists("+omnifunc")
autocmd Filetype * 
\ if &omnifunc == "" | 
\   setlocal omnifunc=syntaxcomplete#Complete | 
\ endif 
endif


" inoremap <Leader>a <Home>
if 0

inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-d> <Del>
 
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

noremap j gj
noremap k gk
noremap <C-j> i<CR>

endif

