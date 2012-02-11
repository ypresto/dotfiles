set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

filetype plugin on

set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,utf-8,sjis,cp932
set number
set incsearch
set hlsearch

"
" Editing config
"

noremap j gj
noremap k gk
inoremap <C-a> <Home>
" inoremap <C-e> <End>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>:set nopaste<CR>
inoremap <expr> <CR>  pumvisible() ? neocomplcache#close_popup() : "<CR>"
inoremap <expr> <C-x><C-f>  neocomplcache#manual_filename_complete()
inoremap <expr> <C-j>  &filetype == 'vim' ? "\<C-x>\<C-v>\<C-p>" : neocomplcache#manual_omni_complete()
" C-nでneocomplcache補完
inoremap <expr><C-n>  pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>"
" C-pでkeyword補完
inoremap <expr><C-p> pumvisible() ? "\<C-p>" : "\<C-p>\<C-n>"
" 補完候補が表示されている場合は確定。そうでない場合は改行
inoremap <expr><CR>  pumvisible() ? neocomplcache#close_popup() : "<CR>"
" 補完をキャンセル
inoremap <expr><C-e>  pumvisible() ? neocomplcache#close_popup() : "<End>"
" not functioning
inoremap <expr> <TAB> pumvisible() ? "\<Down>" : "\<TAB>"
inoremap <expr> <S-TAB> pumvisible() ? "\<Up>" : "\<S-TAB>"
inoremap <expr><C-e>  neocomplcache#close_popup()
nnoremap ,m '
nnoremap ,k '

" Indentation / Tab
set tabstop=8
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent
autocmd FileType html,css,javascript set shiftwidth=2 softtabstop=2
autocmd FileType make set softtabstop=8 shiftwidth=8 noexpandtab

" Highlighting
" カーソル行をハイライト
set cursorline
" カレントウィンドウにのみ罫線を引く
augroup cch
    autocmd! cch
    autocmd WinLeave * set nocursorline
    autocmd WinEnter,BufRead * set cursorline
augroup END

:hi clear CursorLine
:hi CursorLine gui=underline
highlight CursorLine ctermbg=black guibg=black

" Folding
Bundle 'python_ifold'

"
" Extensions
"

runtime macros/matchit.vim
Bundle 'tpope/vim-surround'
" Bundle 'kana/vim-smartchr'
" to use smartchr: noremap <expr> _ smartchr#one_of(' <- ', '_')
" Bundle 'scrooloose/nerdcommenter'
Bundle 'thinca/vim-qfreplace'
Bundle 'thinca/vim-ref'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'thinca/vim-quickrun'
Bundle 'kana/vim-fakeclip'
Bundle 'Shougo/vimshell'
Bundle 'Shougo/vimproc'
Bundle 'tpope/vim-fugitive'
Bundle 'ShowMarks'
Bundle 'errormarker.vim'

Bundle 'Shougo/neocomplcache'
let g:neocomplcache_enable_at_startup = 1
let g:NeoComplCache_SmartCase = 1
let g:NeoComplCache_EnableCamelCaseCompletion = 1
let g:NeoComplCache_EnableUnderbarCompletion = 1
" let g:NeoComplCache_MinKeywordLength = 3
" let g:NeoComplCache_MinSyntaxLength = 3
" let g:NeoComplCache_ManualCompletionStartLength = 0
let g:NeoComplCache_CachingPercentInStatusline = 1
" let g:NeoComplCache_PluginCompleteLength = {
" \   'snipMate_complete' : 1,
" \   'keyword_complete'  : 2,
" \   'syntax_complete'   : 2
" \}
let g:neocomplcache_max_list = 10

Bundle 'buftabs'
" バッファタブにパスを省略してファイル名のみ表示する
let g:buftabs_only_basename=1
" バッファタブをステータスライン内に表示する
let g:buftabs_in_statusline=1
" 現在のバッファをハイライト
let g:buftabs_active_highlight_group="Visual"
" ステータスライン
set statusline=%=\ [%{(&fenc!=''?&fenc:&enc)}/%{&ff}]\[%Y]\[%04l,%04v][%p%%]
" ステータスラインを常に表示
set laststatus=2

Bundle 'Shougo/unite.vim'
Bundle 'tacroe/unite-mark'
Bundle 'h1mesuke/unite-outline'
" 入力モードで開始する
" let g:unite_enable_start_insert=1
" バッファ一覧
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
" ファイル一覧
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" レジスタ一覧
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
nnoremap <silent> ,us :<C-u>Unite file_mru<CR>
" 全部乗せ
nnoremap <silent> ,ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
" unite-mark
nnoremap <silent> ,um :<C-u>Unite mark<CR>
" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> q
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>q

" vim-textobj
Bundle 'kana/vim-textobj-datetime'
Bundle 'kana/vim-textobj-diff'
Bundle 'kana/vim-textobj-entire'
Bundle 'kana/vim-textobj-fold'
Bundle 'kana/vim-textobj-function'
Bundle 'kana/vim-textobj-indent'
Bundle 'kana/vim-textobj-jabraces'
Bundle 'kana/vim-textobj-lastpat'
Bundle 'kana/vim-textobj-syntax'
Bundle 'kana/vim-textobj-user'

" Snipmate settings
Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle "snipmate-snippets"
Bundle 'garbas/vim-snipmate'

" Undo/Backup settings
Bundle 'sjl/gundo.vim'
nnoremap ,g :GundoToggle<CR>
let g:gundo_right = 1
set undofile
set undodir=~/.vim/undo
set nobackup
" set backupdir=~/.vim/backup

"
" IMEs
"
" Bundle 'anyakichi/skk.vim'
" original: Bundle 'tyru/skk.vim'
" Bundle 'mattn/webapi-vim'
" Bundle 'vimtaku/vim-mlh'

" 
" Filetype specific config
" 

autocmd BufNewFile,BufRead *.json set filetype=javascript

Bundle 'basyura/jslint.vim'
function! s:javascript_filetype_settings()
    autocmd BufLeave     <buffer> call jslint#clear()
    autocmd BufWritePost <buffer> call jslint#check()
    autocmd CursorMoved  <buffer> call jslint#message()
endfunction
autocmd FileType javascript call s:javascript_filetype_settings()

Bundle 'mattn/zencoding-vim'
let g:user_zen_settings = {
\   'lang': "ja"
\}
let g:use_zen_complete_tag = 1
let g:user_zen_expandabbr_key = '<c-c>'

" autocmd BufFilePost Manpageview* silent execute ":NeoComplCacheCachingBuffer"

Bundle "othree/html5.vim"
Bundle 'hail2u/vim-css3-syntax'
" Bundle 'rstacruz/sparkup'
Bundle 'sukima/xmledit'
" see http://nanasi.jp/articles/vim/xml-plugin.html

Bundle 'soh335/vim-symfony'
" http://www.vim.org/scripts/script.php?script_id=3172
autocmd FileType php set omnifunc=phpcomplete
if has("autocmd") && exists("+omnifunc")
autocmd Filetype * 
\ if &omnifunc == "" | 
\   setlocal omnifunc=syntaxcomplete#Complete | 
\ endif 
endif

" :make to check perl syntax, :cw to quickfix
autocmd FileType perl,cgi :compiler perl

Bundle 'git://vim-latex.git.sourceforge.net/gitroot/vim-latex/vim-latex'
Bundle 'AutomaticTexPlugin'

autocmd BufNewFile,BufRead *.go :colorscheme go

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
