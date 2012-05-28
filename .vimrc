" **
" * .vimrc for yuya_presto
" *

" *** Reloadable config *** {{{
autocmd!
autocmd BufWritePost $MYVIMRC,$HOME/dotfiles/.vimrc source $MYVIMRC |
            \if has('gui_running') | source $MYGVIMRC
autocmd BufWritePost $MYGVIMRC,$HOME/dotfiles/.gvimrc if has('gui_running') | source $MYGVIMRC
" *** }}}

" *** Config for this script *** {{{
let unite_enabled = 0
let mlh_enabled = 1
let skk_enabled = 0
let eskk_enabled = 0
" *** }}}

" *** Vundler *** {{{
if has('vim_starting')
    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()
endif
Bundle 'gmarik/vundle'
" }}}

" *** Edit *** {{{
set backspace=2 " for os x
" }}}

" *** File *** {{{

" ** Encoding / Syntax ** {{{
filetype plugin on
filetype indent on
syntax on " for os x
set encoding=utf-8
" FIXME: buggy, defaulting to iso-2022
set fileencodings=ucs-bom,utf-8,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932
" ** }}}

" ** Indentation and Tab ** {{{
set tabstop=8
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent
autocmd FileType html,css,javascript,tex set shiftwidth=2 softtabstop=2
autocmd FileType make set softtabstop=8 shiftwidth=8 noexpandtab
" ** }}}

" ** Undo / Backup ** {{{
set undofile
set undodir=~/.vim/undo
set nobackup
" set backupdir=~/.vim/backup
" ** }}}

" *** }}}

" *** View *** {{{
set number
set incsearch
set hlsearch
set laststatus=2 " always show statusline
set showcmd
set wildmenu " enhanced commandline completion
set nolist
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:% "eol:
set foldmethod=marker
if skk_enabled
    set statusline=%<%f\ %h%m%r\ %{SkkGetModeStr()}%=%-14.(%l,%c%V%)\ %P
else
    set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
endif
" ** Highlighting ** {{{
set cursorline
" カレントウィンドウにのみ罫線を引く
augroup cch
    autocmd! cch
    autocmd WinLeave * set nocursorline
    autocmd WinEnter,BufRead * set cursorline
augroup END
highlight clear CursorLine
highlight CursorLine ctermbg=black guibg=black
highlight SignColumn ctermfg=white ctermbg=black cterm=none
" * ZenkakuSpace * {{{
function! ZenkakuSpace()
  highlight ZenkakuSpace cterm=underline ctermbg=darkgray gui=underline guifg=darkgrey
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
" * }}}
" ** }}}
" *** }}}

" *** Keymapping *** {{{
noremap ZJ :w<CR>
noremap <silent> j gj
noremap <silent> gj j
noremap <silent> k gk
noremap <silent> gk k
onoremap <silent> q aW
inoremap <silent> <C-a> <C-o>^
" inoremap <C-e> <End>
inoremap <silent> <C-d> <Del>
cnoremap <silent> <C-p> <Up>
cnoremap <silent> <C-n> <Down>
inoremap <silent> <C-[> <Esc>
nnoremap <Esc><Esc> :nohlsearch<CR>:set nopaste<CR>
nnoremap ,c :cwin<CR>
nnoremap ,C :cclose<CR>
nnoremap ,l :lwin<CR>
nnoremap ,L :lclose<CR>
let g:user_zen_leader_key = '<C-q>'
let g:user_zen_expandabbr_key = '<C-q><C-q>'
nnoremap ,g :GundoToggle<CR>

" ** neocomplcache ** {{{
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
" ** }}}

" ** unite ** {{{
if unite_enabled
" デフォルト
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
" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> q
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>q
endif
" ** }}}

" ** IME ** {{{
if eskk_enabled
	inoremap <expr> <C-l> eskk#toggle()
endif
if skk_enabled
	let g:skk_control_j_key = '<C-l>'
endif
" ** }}}

" *** }}}

" *** Custom Scripts *** {{{

" ** Braces ** {{{
"inoremap <expr><CR> <SID>BlockCompl()
set cindent
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
" ** }}}

" ** Templates ** {{{
autocmd BufNewFile *.pl 0r $HOME/.vim/template/perl.pl
" ** }}}

" *** }}}

" *** Plugins *** {{{

" Shared by many modules
Bundle 'Shougo/vimproc'

" TODO: To be used {{{
Bundle 'thinca/vim-quickrun'
Bundle 'TaskList.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'Align'
" required by fuzzyfinder
Bundle 'L9'
" Bundle 'FuzzyFinder'
" Bundle 'kana/vim-smartchr'
" Snipmate
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'snipmate-snippets'
Bundle 'garbas/vim-snipmate'
" Bundle 'Shougo/vimshell'
" }}}

" extended % key matching
runtime macros/matchit.vim

" autocompletes parenthesis, braces and more
Bundle 'Raimondi/delimitMate'

" moving
" Bundle 'Lokaltog/vim-easymotion'

" convenient functions for surrounding characters [ds'], [ys'], etc.
Bundle 'tpope/vim-surround'

" open some reference manual with K key
Bundle 'thinca/vim-ref'

" git support
Bundle 'tpope/vim-fugitive'
Bundle 'mattn/gist-vim'

" read/write by sudo with `vim sudo:file.txt`
Bundle 'sudo.vim'

" shows syntax error on every save
Bundle 'scrooloose/syntastic'

" rich-formatted undo history
Bundle 'sjl/gundo.vim'
let g:gundo_right = 1

" ** neocomplcache ** {{{
" TODO
Bundle 'Shougo/neocomplcache'
" Bundle 'ujihisa/neco-look' " too heavy
" let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1
" ** }}}

" ** unite ** {{{
if unite_enabled
Bundle 'Shougo/unite.vim'
" Bundle 'tacroe/unite-mark'
Bundle 'h1mesuke/unite-outline'
" 入力モードで開始する
let g:unite_enable_start_insert=1
endif
" ** }}}

" ** textobj ** {{{
" framework
Bundle 'kana/vim-textobj-user'
" too many, refer help
" Bundle 'kana/vim-textobj-diff'
" [ai]e
" Bundle 'kana/vim-textobj-entire'
" [ai]z
" Bundle 'kana/vim-textobj-fold'
" [ai]f
Bundle 'kana/vim-textobj-function'
" [ai][iI]
Bundle 'kana/vim-textobj-indent'
" [ai][/?] 
" Bundle 'kana/vim-textobj-lastpat'
" [ai]y
Bundle 'kana/vim-textobj-syntax'
" [ai]c
Bundle 'thinca/vim-textobj-comment'
" ** }}}

" ** QuickFix ** {{{
" show quickfix text of current line on statusline
Bundle 'dannyob/quickfixstatus'
" edit quickfix lines
" Bundle 'thinca/vim-qfreplace'
" command! -nargs=+ QfArgs let b:quickrun_config = {'args': substitute(<f-args>, ',', ' ', 'g')}
" ** }}}

" ** IME ** {{{

if mlh_enabled
    Bundle 'vimtaku/vim-mlh'
    autocmd VimEnter * :ToggleVimMlhKeymap
    Bundle 'mattn/webapi-vim'
endif

if eskk_enabled
    Bundle 'tyru/eskk.vim'
    let g:eskk#no_default_mappings = 1
    let g:eskk#large_dictionary = { 'path': "~/.vim/dict/SKK-JISYO.L", 'sorted': 1, 'encoding': 'euc-jp', }
    let g:eskk#enable_completion = 1
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
endif

" ** }}}

" *** }}}

" *** Filetype *** {{{

" ** HTML / CSS / XML ** {{{
Bundle 'mattn/zencoding-vim'
let g:user_zen_settings = {
\   'lang': "ja"
\}
let g:use_zen_complete_tag = 1

Bundle 'othree/html5.vim'
Bundle 'hail2u/vim-css3-syntax'
Bundle 'sukima/xmledit'
" see http://nanasi.jp/articles/vim/xml-plugin.html
" ** }}}

" ** JavaScript ** {{{
autocmd BufNewFile,BufRead *.json set filetype=javascript
" ** }}}

" ** Perl ** {{{
autocmd FileType perl,cgi :compiler perl
Bundle 'yko/mojo.vim'
" ** }}}

" ** PHP ** {{{
" Bundle 'soh335/vim-symfony'
" ** }}}

" ** Python ** {{{
Bundle 'tmhedberg/SimpylFold'
" ** }}}

" ** Others ** {{{
autocmd BufNewFile,BufRead *.go :colorscheme go
" too large to load always
" Bundle 'AutomaticLaTexPlugin'
" ** }}}
" *** }}}

" *** Bleeding Edge *** {{{
" Bundle 'fuenor/qfixgrep'
nnoremap <C-j> :cnext<CR>
nnoremap <C-k> :cprev<CR>
" nnoremap <C-n> :lnext<CR>
" nnoremap <C-p> :lprev<CR>
" nnoremap <Leader>n :next<CR>
" nnoremap <Leader>p :prev<CR>
nnoremap <C-h> :tn<CR>
nnoremap <C-l> :tp<CR>
if unite_enabled
Bundle 'sgur/unite-qf'
nmap ,uq ,u:-auto-resize -direction=botright qf<CR>
nmap ,Uq ,U:-auto-resize -direction=botright qf<CR>
endif
Bundle 'jelera/vim-javascript-syntax'
Bundle 'nono/jquery.vim'
" reffer: http://vimwiki.net/?'viminfo'
set history=50
set viminfo='50,<50,s10,%
Bundle 'YankRing.vim'
Bundle 'buftabs'
let g:buftabs_only_basename = 1
let g:buftabs_in_statusline = 1
" Bundle 'basyura/TweetVim'
Bundle 'scrooloose/nerdcommenter'
Bundle 'kien/rainbow_parentheses.vim'
autocmd VimEnter * :RainbowParenthesesToggle
" Bundle 'vimtaku/vim-textobj-keyvalue'
" Bundle 't9md/vim-phrase'
" TODO: using at end of line causes backspace
inoremap <C-k> <C-o>D
" Maximizes current split, <C-w>= to restore
nnoremap <C-w>a <C-w>\|<C-w>_
" set showtabline=2
" Bundle 'kmnk/vim-unite-giti.git'
" nmap ,ug ,u:-auto-resize -direction=botright giti<CR>
" nmap ,Ug ,U:-auto-resize -direction=botright giti<CR>
" scroll
set scrolloff=1
Bundle 'vimtaku/vim-textobj-sigil'
" simple vim ref for .vimrc
autocmd! FileType vim call MapVimHelp()
function! MapVimHelp()
    map K :help <C-r><C-w><CR>
    " TODO: visual mode
endfunction

set ignorecase
set smartcase
set cmdheight=1
"Bundle 'Shougo/neocomplcache-snippets-complete'
imap <expr> <Tab> '<Plug>'.HandleTabKey(0)
"imap <expr> <Tab> HandleTabKey(0)
imap <expr> <S-Tab> '<Plug>'.HandleTabKey(1)
function! HandleTabKey(shift)
    if exists('g:snipPos')
        if a:shift== 0
            return 'local_SnipmateTabForward'
        else
            return 'local_SnipmateTabBackward'
        endif
    elseif a:shift!= 0
        return 'delimitMateS-Tab'
    elseif pumvisible()
        return 'local_neocomClosePopup'
    else
        return 'local_SnipmateTabForward'
    endif
endfunction
inoremap <expr> <Plug>local_neocomClosePopup neocomplcache#close_popup()
let g:snips_trigger_key='<Plug>local_SnipmateTabForward'
let g:snips_trigger_key_backwards='<Plug>local_SnipmateTabBackward'
" Bundle 'mbriggs/mark.vim'
" Bundle 'mattn/benchvimrc-vim'
let g:neocomplcache_ctags_arguments_list = {
  \ 'perl' : '-R --languages=Perl --langmap=Perl:+.t'
  \ }
" Bundle 'astashov/vim-ruby-debugger'
Bundle 'kien/ctrlp.vim'
let g:ctrlp_map = '<C-c>'
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*.so,*.swp,*.swo
nmap ,up :Unite -direction=botright -auto-resize -auto-preview -buffer-name=files file_rec<CR>
nmap ,Up :Unite -create -no-quit -toggle  -vertical -direction=botright -winwidth=30 -buffer-name=files file_rec<CR>
" Bundle 'taku-o/vim-copypath'
Bundle 'kana/vim-altr'
nmap <Leader>f <Plug>(altr-forward)
Bundle 'Smooth-Scroll'
set noeb vb t_vb=
Bundle 'mileszs/ack.vim'
Bundle 'jpalardy/vim-slime'
augroup InitNeCo
    autocmd!
    autocmd CursorMovedI * call DoInitNeco()
    autocmd CursorHold * call DoInitNeco()
augroup END
function! DoInitNeco()
    echo "Initializing NeCo..."
    augroup InitNeCo
        autocmd!
    augroup END
    :NeoComplCacheEnable
endfunction
Bundle 'altercation/vim-colors-solarized'
set t_Co=256
set background=dark
" let g:solarized_termcolors=256
" let g:solarized_degrade=1
let g:solarized_termcolors=16
let g:solarized_termtrans=1
let g:solarized_bold=1
let g:solarized_underline=1
let g:solarized_italic=1
colorscheme solarized

augroup TriggerUpdateTags
    autocmd!
    autocmd CursorHold * call g:UpdateTags()
    autocmd CursorHoldI * call g:UpdateTags()
augroup END
function! g:UpdateTags()
  NeoComplCacheCachingInclude
    for filename in neocomplcache#sources#include_complete#get_include_files(bufnr('%'))
      execute "setlocal tags+=" . neocomplcache#cache#encode_name('include_tags', filename)
    endfor
endfunction
" *** }}}
