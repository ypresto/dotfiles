set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

filetype plugin on
filetype indent on

let eskk_enabled = 0
let skk_enabled = 1

set encoding=utf-8
set fileencodings=ucs-bom,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,utf-8,sjis,cp932
set number
set incsearch
set hlsearch
set laststatus=2 " always show statusline
set showcmd
set wildmenu " enhanced commandline completion
set nolist
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:% "eol:
if skk_enabled
    set statusline=%<%f\ %h%m%r\ %{SkkGetModeStr()}%=%-14.(%l,%c%V%)\ %P
else
    set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
endif
highlight SignColumn ctermfg=white ctermbg=black cterm=none

command! FullPath :echo expand("%")

"
" Editing config
"

noremap j gj
noremap gj j
noremap k gk
noremap gk k
onoremap q aW
inoremap <C-a> <Home>
" inoremap <C-e> <End>
inoremap <C-d> <Del>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
" see :help map-alt-keys
inoremap <silent> <C-[> <Esc>
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
" conflicts with delimitMate
" inoremap <expr> <TAB> pumvisible() ? "\<Down>" : "\<TAB>"
" inoremap <expr> <S-TAB> pumvisible() ? "\<Up>" : "\<S-TAB>"
nnoremap ,m '
nnoremap ,k `
nnoremap ,q :cwin<CR>
" nnoremap ; :
" nnoremap : ;
" noremap <silent> <C-b>n :next<CR>
" noremap <silent> <C-b>p :prev<CR>
if eskk_enabled
	inoremap <expr> <C-l> eskk#toggle()
endif
if skk_enabled
	let g:skk_control_j_key = '<C-l>'
endif
let g:user_zen_leader_key = '<C-y>'
let g:user_zen_expandabbr_key = '<C-y><C-y>'

" Indentation / Tab
set tabstop=8
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent
autocmd FileType html,css,javascript,tex set shiftwidth=2 softtabstop=2
autocmd FileType make set softtabstop=8 shiftwidth=8 noexpandtab

" Highlighting
set cursorline
" カレントウィンドウにのみ罫線を引く
augroup cch
    autocmd! cch
    autocmd WinLeave * set nocursorline
    autocmd WinEnter,BufRead * set cursorline
augroup END
highlight clear CursorLine
highlight CursorLine ctermbg=black guibg=black

" ZenkakuSpace
function! ZenkakuSpace()
  highlight ZenkakuSpace cterm=underline ctermfg=darkgrey gui=underline guifg=darkgrey
endfunction
if has('syntax')
  augroup ZenkakuSpace
    autocmd!
    " ZenkakuSpaceをカラーファイルで設定するなら次の行は削除
    autocmd ColorScheme       * call ZenkakuSpace()
    " 全角スペースのハイライト指定
    autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
  augroup END
  call ZenkakuSpace()
endif

" Folding
Bundle 'python_fold'

" QuickFix
Bundle 'dannyob/quickfixstatus'
Bundle 'thinca/vim-qfreplace'
command! -nargs=+ QfArgs let b:quickrun_config = {'args': substitute(<f-args>, ',', ' ', 'g')}

" Templates
autocmd BufNewFile *.pl 0r $HOME/.vim/template/perl.pl

" Braces
inoremap <expr><CR> <SID>BlockCompl()
function! s:BlockCompl()
    if col('.') == col('$')
        let l = getline('.')
        if l =~ '{$'
            return "\<CR>}\<Up>\<End>\<CR>"
        elseif l =~ '($'
            return "\<CR>)\<Up>\<End>\<CR>"
        elseif l =~ '[$'
            return "\<CR>]\<Up>\<End>\<CR>"
        else
            return "\<CR>"
        endif
    elseif getline(".")[col(".") - 1] =~ '[})\]]$'
        return "\<CR>\<C-o>O"
    else
        return "\<CR>"
    endif
endfunction

"
" Extensions
"

" TODO: To be used
Bundle 'thinca/vim-quickrun'
Bundle 'kana/vim-fakeclip'
Bundle 'TaskList.vim'
" Bundle 'scrooloose/nerdcommenter'
" Bundle 'ervandew/supertab'
Bundle 'scrooloose/nerdtree'
Bundle 'Align'
" required by fuzzyfinder
Bundle 'L9'
Bundle 'FuzzyFinder'

runtime macros/matchit.vim
Bundle 'tpope/vim-surround'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'thinca/vim-ref'
Bundle 'Shougo/vimshell'
Bundle 'Shougo/vimproc'
Bundle 'tpope/vim-fugitive'
Bundle 'ShowMarks'
Bundle 'mattn/gist-vim'
Bundle 'sudo.vim'
Bundle 'scrooloose/syntastic'

" MiniBuf settings
" Bundle 'fholgado/minibufexpl.vim' " conflicts with unite-outline
" let g:miniBufExplMapWindowNavVim = 1
" let g:miniBufExplMapWindowNavArrows = 1
" let g:miniBufExplMapCTabSwitchBuffs = 1
" let g:miniBufExplModSelTarget = 1

" errormarker.vim settings
Bundle 'errormarker.vim'
let g:errormarker_errorgroup = "my_error_mark"
let g:errormarker_warninggroup = "my_warning_mark"
highlight my_error_mark ctermbg=red cterm=none
highlight my_warning_mark ctermbg=blue cterm=none

" neocomplcache settings
Bundle 'Shougo/neocomplcache'
" Bundle 'ujihisa/neco-look' " too heavy
let g:neocomplcache_enable_at_startup = 1
let g:NeoComplCache_SmartCase = 1
let g:NeoComplCache_EnableCamelCaseCompletion = 1
let g:NeoComplCache_EnableUnderbarCompletion = 1
" let g:NeoComplCache_MinKeywordLength = 3
" let g:NeoComplCache_MinSyntaxLength = 3
" let g:NeoComplCache_ManualCompletionStartLength = 0
let g:NeoComplCache_CachingPercentInStatusline = 1
" let g:NeoComplCache_PluginCompleteLength = {
" \   'snipmate_complete' : 1,
" \   'keyword_complete'  : 2,
" \   'syntax_complete'   : 2
" \}
let g:neocomplcache_max_list = 100
if !exists('g:neocomplcache_keyword_patterns')
   let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*' " avoid japanese keywords

" unite.vim settings
Bundle 'Shougo/unite.vim'
Bundle 'tacroe/unite-mark'
Bundle 'h1mesuke/unite-outline'
" 入力モードで開始する
" let g:unite_enable_start_insert=1
nnoremap ,u: :Unite -direction=botright -auto-resize 
nnoremap ,U: :Unite -create -no-quit -toggle  -vertical -direction=botright -winwidth=30 
" バッファ一覧
nmap ,ub ,u:buffer<CR>
nmap ,Ub ,U:buffer<CR>
" ファイル一覧
nmap ,uf :UniteWithBufferDir -direction=botright -auto-resize -auto-preview -buffer-name=files file<CR>
nmap ,Uf :UniteWithCurrentDir -create -no-quit -toggle  -vertical -direction=botright -winwidth=30 -buffer-name=files file<CR>
" レジスタ一覧
nmap ,ur :Unite -auto-preview -buffer-name=register register<CR>
" 最近使用したファイル一覧
nmap ,us ,u:file_mru<CR>
nmap ,Us ,U:file_mru<CR>
" 全部乗せ
nmap ,ua :UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
" unite-mark
nmap ,um ,u:-auto-preview mark<CR>
nmap ,Um ,U:-auto-preview mark<CR>
" unite-outline
nmap ,uo ,u:-auto-preview outline<CR>
nmap ,Uo ,U:-auto-preview outline<CR>
" history/yankの有効化
let g:unite_source_history_yank_enable = 1
nmap ,uy ,u:-auto-resize -direction=botright history/yank<CR>
nmap ,Uy ,U:-auto-resize -direction=botright history/yank<CR>
" others
" nnoremap <silent> ,Uo :40vnew<CR><C-w>n:Unite -create -no-quit -no-split outline<CR><C-w>j:Unite -create -no-quit -no-split buffer<CR>
" nnoremap <silent> ,uO :Unite -create -no-quit -no-split outline<CR>

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
Bundle 'thinca/vim-textobj-comment'

" Snipmate settings
" XXX: freezes with inputting {<TAB>}
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'snipmate-snippets'
Bundle 'garbas/vim-snipmate'

" delimitMate settings
Bundle 'Raimondi/delimitMate'

" smartchr settings
Bundle 'kana/vim-smartchr'
if skk_enabled || eskk_enabled
    autocmd BufNewFile,BufRead *.tex,*.txt inoremap <expr> , smartchr#one_of(',', '，')
    autocmd BufNewFile,BufRead *.tex,*.txt inoremap <expr> . smartchr#one_of('.', '．')
else
    inoremap <expr> , smartchr#one_of(', ', ',')
endif
autocmd FileType perl inoremap <expr> : smartchr#one_of(': ', '::', ' => ')

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

" Bundle 'git://vim-latex.git.sourceforge.net/gitroot/vim-latex/vim-latex'
Bundle 'AutomaticLaTexPlugin'

autocmd BufNewFile,BufRead *.go :colorscheme go

"
" IMEs
"

" Bundle 'vimtaku/vim-mlh'
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
    let g:skk_keep_state = 1
    let g:skk_egg_like_newline = 1
    let g:skk_show_annotation = 1
    let g:skk_use_face = 1
    let g:skk_use_numeric_conversion = 1
    let g:skk_sticky_key = ";"
    let g:skk_kutouten_type = "en"
" FIXME: These are not working, help!
"    let g:skk_rom_kana_rules = substitute(g:skk_rom_kana_rules, '"x', '"l', 'g')
"    let g:skk_rom_func_rules = substitute(substitute(g:skk_rom_func_rules, '"x', '"l', 'g'), '"X', '"L', 'g')
    
    let g:skk_rom_kana_rules = ""
        \. "a	あ	ア\<NL>"
        \. "bb	っ	ッ	b\<NL>"
        \. "ba	ば	バ\<NL>"
        \. "be	べ	ベ\<NL>"
        \. "bi	び	ビ\<NL>"
        \. "bo	ぼ	ボ\<NL>"
        \. "bu	ぶ	ブ\<NL>"
        \. "bya	びゃ	ビャ\<NL>"
        \. "bye	びぇ	ビェ\<NL>"
        \. "byi	びぃ	ビィ\<NL>"
        \. "byo	びょ	ビョ\<NL>"
        \. "byu	びゅ	ビュ\<NL>"
        \. "cc	っ	ッ	c\<NL>"
        \. "cha	ちゃ	チャ\<NL>"
        \. "che	ちぇ	チェ\<NL>"
        \. "chi	ち	チ\<NL>"
        \. "cho	ちょ	チョ\<NL>"
        \. "chu	ちゅ	チュ\<NL>"
        \. "cya	ちゃ	チャ\<NL>"
        \. "cye	ちぇ	チェ\<NL>"
        \. "cyi	ちぃ	チィ\<NL>"
        \. "cyo	ちょ	チョ\<NL>"
        \. "cyu	ちゅ	チュ\<NL>"
        \. "dd	っ	ッ	d\<NL>"
        \. "da	だ	ダ\<NL>"
        \. "de	で	デ\<NL>"
        \. "dha	でゃ	デャ\<NL>"
        \. "dhe	でぇ	デェ\<NL>"
        \. "dhi	でぃ	ディ\<NL>"
        \. "dho	でょ	デョ\<NL>"
        \. "dhu	でゅ	デュ\<NL>"
        \. "di	ぢ	ヂ\<NL>"
        \. "do	ど	ド\<NL>"
        \. "du	づ	ヅ\<NL>"
        \. "dya	ぢゃ	ヂャ\<NL>"
        \. "dye	ぢぇ	ヂェ\<NL>"
        \. "dyi	ぢぃ	ヂィ\<NL>"
        \. "dyo	ぢょ	ヂョ\<NL>"
        \. "dyu	ぢゅ	ヂュ\<NL>"
        \. "e	え	エ\<NL>"
        \. "ff	っ	ッ	f\<NL>"
        \. "fa	ふぁ	ファ\<NL>"
        \. "fe	ふぇ	フェ\<NL>"
        \. "fi	ふぃ	フィ\<NL>"
        \. "fo	ふぉ	フォ\<NL>"
        \. "fu	ふ	フ\<NL>"
        \. "fya	ふゃ	フャ\<NL>"
        \. "fye	ふぇ	フェ\<NL>"
        \. "fyi	ふぃ	フィ\<NL>"
        \. "fyo	ふょ	フョ\<NL>"
        \. "fyu	ふゅ	フュ\<NL>"
        \. "gg	っ	ッ	g\<NL>"
        \. "ga	が	ガ\<NL>"
        \. "ge	げ	ゲ\<NL>"
        \. "gi	ぎ	ギ\<NL>"
        \. "go	ご	ゴ\<NL>"
        \. "gu	ぐ	グ\<NL>"
        \. "gya	ぎゃ	ギャ\<NL>"
        \. "gye	ぎぇ	ギェ\<NL>"
        \. "gyi	ぎぃ	ギィ\<NL>"
        \. "gyo	ぎょ	ギョ\<NL>"
        \. "gyu	ぎゅ	ギュ\<NL>"
        \. "hh	っ	ッ	h\<NL>"
        \. "ha	は	ハ\<NL>"
        \. "he	へ	ヘ\<NL>"
        \. "hi	ひ	ヒ\<NL>"
        \. "ho	ほ	ホ\<NL>"
        \. "hu	ふ	フ\<NL>"
        \. "hya	ひゃ	ヒャ\<NL>"
        \. "hye	ひぇ	ヒェ\<NL>"
        \. "hyi	ひぃ	ヒィ\<NL>"
        \. "hyo	ひょ	ヒョ\<NL>"
        \. "hyu	ひゅ	ヒュ\<NL>"
        \. "i	い	イ\<NL>"
        \. "jj	っ	ッ	j\<NL>"
        \. "ja	じゃ	ジャ\<NL>"
        \. "je	じぇ	ジェ\<NL>"
        \. "ji	じ	ジ\<NL>"
        \. "jo	じょ	ジョ\<NL>"
        \. "ju	じゅ	ジュ\<NL>"
        \. "jya	じゃ	ジャ\<NL>"
        \. "jye	じぇ	ジェ\<NL>"
        \. "jyi	じぃ	ジィ\<NL>"
        \. "jyo	じょ	ジョ\<NL>"
        \. "jyu	じゅ	ジュ\<NL>"
        \. "kk	っ	ッ	k\<NL>"
        \. "ka	か	カ\<NL>"
        \. "ke	け	ケ\<NL>"
        \. "ki	き	キ\<NL>"
        \. "ko	こ	コ\<NL>"
        \. "ku	く	ク\<NL>"
        \. "kya	きゃ	キャ\<NL>"
        \. "kye	きぇ	キェ\<NL>"
        \. "kyi	きぃ	キィ\<NL>"
        \. "kyo	きょ	キョ\<NL>"
        \. "kyu	きゅ	キュ\<NL>"
        \. "ma	ま	マ\<NL>"
        \. "me	め	メ\<NL>"
        \. "mi	み	ミ\<NL>"
        \. "mo	も	モ\<NL>"
        \. "mu	む	ム\<NL>"
        \. "mya	みゃ	ミャ\<NL>"
        \. "mye	みぇ	ミェ\<NL>"
        \. "myi	みぃ	ミィ\<NL>"
        \. "myo	みょ	ミョ\<NL>"
        \. "myu	みゅ	ミュ\<NL>"
        \. "n	ん	ン\<NL>"
        \. "n'	ん	ン\<NL>"
        \. "na	な	ナ\<NL>"
        \. "ne	ね	ネ\<NL>"
        \. "ni	に	ニ\<NL>"
        \. "nn	ん	ン\<NL>"
        \. "no	の	ノ\<NL>"
        \. "nu	ぬ	ヌ\<NL>"
        \. "nya	にゃ	ニャ\<NL>"
        \. "nye	にぇ	ニェ\<NL>"
        \. "nyi	にぃ	ニィ\<NL>"
        \. "nyo	にょ	ニョ\<NL>"
        \. "nyu	にゅ	ニュ\<NL>"
        \. "o	お	オ\<NL>"
        \. "pp	っ	ッ	p\<NL>"
        \. "pa	ぱ	パ\<NL>"
        \. "pe	ぺ	ペ\<NL>"
        \. "pi	ぴ	ピ\<NL>"
        \. "po	ぽ	ポ\<NL>"
        \. "pu	ぷ	プ\<NL>"
        \. "pya	ぴゃ	ピャ\<NL>"
        \. "pye	ぴぇ	ピェ\<NL>"
        \. "pyi	ぴぃ	ピィ\<NL>"
        \. "pyo	ぴょ	ピョ\<NL>"
        \. "pyu	ぴゅ	ピュ\<NL>"
        \. "rr	っ	ッ	r\<NL>"
        \. "ra	ら	ラ\<NL>"
        \. "re	れ	レ\<NL>"
        \. "ri	り	リ\<NL>"
        \. "ro	ろ	ロ\<NL>"
        \. "ru	る	ル\<NL>"
        \. "rya	りゃ	リャ\<NL>"
        \. "rye	りぇ	リェ\<NL>"
        \. "ryi	りぃ	リィ\<NL>"
        \. "ryo	りょ	リョ\<NL>"
        \. "ryu	りゅ	リュ\<NL>"
        \. "ss	っ	ッ	s\<NL>"
        \. "sa	さ	サ\<NL>"
        \. "se	せ	セ\<NL>"
        \. "sha	しゃ	シャ\<NL>"
        \. "she	しぇ	シェ\<NL>"
        \. "shi	し	シ\<NL>"
        \. "sho	しょ	ショ\<NL>"
        \. "shu	しゅ	シュ\<NL>"
        \. "si	し	シ\<NL>"
        \. "so	そ	ソ\<NL>"
        \. "su	す	ス\<NL>"
        \. "sya	しゃ	シャ\<NL>"
        \. "sye	しぇ	シェ\<NL>"
        \. "syi	しぃ	シィ\<NL>"
        \. "syo	しょ	ショ\<NL>"
        \. "syu	しゅ	シュ\<NL>"
        \. "tt	っ	ッ	t\<NL>"
        \. "ta	た	タ\<NL>"
        \. "te	て	テ\<NL>"
        \. "tha	てぁ	テァ\<NL>"
        \. "the	てぇ	テェ\<NL>"
        \. "thi	てぃ	ティ\<NL>"
        \. "tho	てょ	テョ\<NL>"
        \. "thu	てゅ	テュ\<NL>"
        \. "ti	ち	チ\<NL>"
        \. "to	と	ト\<NL>"
        \. "tsu	つ	ツ\<NL>"
        \. "tu	つ	ツ\<NL>"
        \. "tya	ちゃ	チャ\<NL>"
        \. "tye	ちぇ	チェ\<NL>"
        \. "tyi	ちぃ	チィ\<NL>"
        \. "tyo	ちょ	チョ\<NL>"
        \. "tyu	ちゅ	チュ\<NL>"
        \. "u	う	ウ\<NL>"
        \. "vv	っ	ッ	v\<NL>"
        \. "va	う゛ぁ	ヴァ\<NL>"
        \. "ve	う゛ぇ	ヴェ\<NL>"
        \. "vi	う゛ぃ	ヴィ\<NL>"
        \. "vo	う゛ぉ	ヴォ\<NL>"
        \. "vu	う゛	ヴ\<NL>"
        \. "ww	っ	ッ	w\<NL>"
        \. "wa	わ	ワ\<NL>"
        \. "we	うぇ	ウェ\<NL>"
        \. "wi	うぃ	ウィ\<NL>"
        \. "wo	を	ヲ\<NL>"
        \. "wu	う	ウ\<NL>"
        \. "ll	っ	ッ	l\<NL>"
        \. "la	ぁ	ァ\<NL>"
        \. "le	ぇ	ェ\<NL>"
        \. "li	ぃ	ィ\<NL>"
        \. "lka	か	ヵ\<NL>"
        \. "lke	け	ヶ\<NL>"
        \. "lo	ぉ	ォ\<NL>"
        \. "ltsu	っ	ッ\<NL>"
        \. "ltu	っ	ッ\<NL>"
        \. "lu	ぅ	ゥ\<NL>"
        \. "lwa	ゎ	ヮ\<NL>"
        \. "lwe	ゑ	ヱ\<NL>"
        \. "lwi	ゐ	ヰ\<NL>"
        \. "lya	ゃ	ャ\<NL>"
        \. "lyo	ょ	ョ\<NL>"
        \. "lyu	ゅ	ュ\<NL>"
        \. "yy	っ	ッ	y\<NL>"
        \. "ya	や	ヤ\<NL>"
        \. "ye	いぇ	イェ\<NL>"
        \. "yo	よ	ヨ\<NL>"
        \. "yu	ゆ	ユ\<NL>"
        \. "zz	っ	ッ	z\<NL>"
        \. "z,	‥\<NL>"
        \. "z-	〜\<NL>"
        \. "z.	…\<NL>"
        \. "z/	・\<NL>"
        \. "z[	『\<NL>"
        \. "z]	』\<NL>"
        \. "za	ざ	ザ\<NL>"
        \. "ze	ぜ	ゼ\<NL>"
        \. "zh	←\<NL>"
        \. "zi	じ	ジ\<NL>"
        \. "zj	↓\<NL>"
        \. "zk	↑\<NL>"
        \. "zl	→\<NL>"
        \. "zo	ぞ	ゾ\<NL>"
        \. "zu	ず	ズ\<NL>"
        \. "zya	じゃ	ジャ\<NL>"
        \. "zye	じぇ	ジェ\<NL>"
        \. "zyi	じぃ	ジィ\<NL>"
        \. "zyo	じょ	ジョ\<NL>"
        \. "zyu	じゅ	ジュ\<NL>"
        \. "-	ー\<NL>"
        \. ":	：\<NL>"
        \. ";	；\<NL>"
        \. "!	！\<NL>"
        \. "?	？\<NL>"
        \. "[	「\<NL>"
        \. "]	」\<NL>"
    let g:skk_rom_func_rules = ""
        \. ".	SkkCurrentKuten(kana)\<NL>"
        \. ",	SkkCurrentTouten(kana)\<NL>"
        \. "x	SkkAsciiMode(kana)\<NL>"
        \. "X	SkkZeneiMode(kana)\<NL>"
        \. "q	SkkToggleKana(kana)\<NL>"
        \. "Q	SkkSetHenkanPoint1(kana)\<NL>"
        \. "/	SkkAbbrevMode(kana)\<NL>"
endif
