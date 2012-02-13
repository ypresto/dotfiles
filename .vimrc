set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

filetype plugin on

let eskk_enabled = 0
let skk_enabled = 1

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
inoremap <C-d> <Del>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>:set nopaste<CR>
inoremap <expr> <CR>  pumvisible() ? neocomplcache#close_popup() : "<CR>"
inoremap <expr> <C-x><C-f>  neocomplcache#manual_filename_complete()
inoremap <expr> <C-j>  &filetype == 'vim' ? "\<C-x>\<C-v>\<C-p>" : neocomplcache#manual_omni_complete()
" C-nでneocomplcache補完
inoremap <expr> <C-n>  pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>"
" C-pでkeyword補完
inoremap <expr> <C-p> pumvisible() ? "\<C-p>" : "\<C-p>\<C-n>"
" 補完候補が表示されている場合は確定。そうでない場合は改行
inoremap <expr> <CR>  pumvisible() ? neocomplcache#close_popup() : "<CR>"
" 補完をキャンセル＋End
inoremap <expr> <C-e>  pumvisible() ? neocomplcache#close_popup() : "<End>"
" not functioning
inoremap <expr> <TAB> pumvisible() ? "\<Down>" : "\<TAB>"
inoremap <expr> <S-TAB> pumvisible() ? "\<Up>" : "\<S-TAB>"
nnoremap ,m '
nnoremap ,k '
if eskk_enabled
	inoremap <expr> <C-c> eskk#toggle()
endif
if skk_enabled
	let g:skk_control_j_key = '<C-c>'
endif

" Indentation / Tab
set tabstop=8
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent
autocmd FileType html,css,javascript,tex set shiftwidth=2 softtabstop=2
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
Bundle 'ujihisa/neco-look'
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
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'snipmate-snippets'
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

Bundle 'othree/html5.vim'
Bundle 'hail2u/vim-css3-syntax'
" Bundle 'rstacruz/sparkup'
Bundle 'sukima/xmledit'
" see http://nanasi.jp/articles/vim/xml-plugin.html

Bundle 'soh335/vim-symfony'
" http://www.vim.org/scripts/script.php?script_id=3172
autocmd FileType php set omnifunc=phpcomplete
if has("autocmd") && exists("+omnifunc")
autocmd Filetype * 
\   if &omnifunc == "" | 
\       setlocal omnifunc=syntaxcomplete#Complete | 
\   endif 
endif

"jkiadfljk:make to check perl syntax, :cw to quickfix
autocmd FileType perl,cgi :compiler perl

Bundle 'git://vim-latex.git.sourceforge.net/gitroot/vim-latex/vim-latex'
Bundle 'AutomaticTexPlugin'

autocmd BufNewFile,BufRead *.go :colorscheme go

"
" IMEs
"

Bundle 'vimtaku/vim-mlh'
Bundle 'mattn/webapi-vim'

if eskk_enabled
    Bundle 'tyru/eskk.vim'
    let g:eskk#no_default_mappings = 1
    let g:eskk#large_dictionary = { 'path': "~/.vim/dict/SKK-JISYO.L", 'sorted': 1, 'encoding': 'euc-jp', }
    let g:eskk#enable_completion = 1
    " function! s:eskk_initial_pre()
    "     let t = eskk#table#new('rom_to_hira*', 'rom_to_hira')
    "     call t.add_map(',', '，')
    "     call t.add_map('.', '．') 
    "     call eskk#register_mode_table('hira', t)
    "     let t = eskk#table#new('rom_to_kata*', 'rom_to_kata')
    "     call t.add_map(',', '，')
    "     call t.add_map('.', '．')
    "     call eskk#register_mode_table('kata', t)
    " endfunction
endif

if skk_enabled
    Bundle 'anyakichi/skk.vim'
    " original: Bundle 'tyru/skk.vim'
    let g:skk_jisyo = '~/.skk-jisyo'
    let g:skk_large_jisyo = '~/.vim/dict/SKK-JISYO.L'
    let g:skk_auto_save_jisyo = 1
    let g:skk_keep_state = 0
    let g:skk_egg_like_newline = 1
    let g:skk_show_annotation = 1
    let g:skk_use_face = 1
endif
