" **
" * .vimrc for yuya_presto
" *

let mapleader=" "

" *** Reloadable config *** {{{
autocmd!
autocmd BufWritePost $MYVIMRC,$HOME/dotfiles/.vimrc source $MYVIMRC |
            \if has('gui_running') | source $MYGVIMRC
autocmd BufWritePost $MYGVIMRC,$HOME/dotfiles/.gvimrc if has('gui_running') | source $MYGVIMRC
" *** }}}

" *** Config for this script *** {{{
let unite_enabled = 1
let mlh_enabled = 1
let skk_enabled = 0
let eskk_enabled = 0
" *** }}}

" *** Start up *** {{{
if has('vim_starting')
    set nocompatible
    set rtp+=~/.vim/bundle/neobundle.vim/
    call neobundle#rc(expand('~/.vim/bundle/'))
    set rtp+=~/.vimlocal
    let $PERL5LIB='./lib:./t:./t/inc:'.expand('$PERL5LIB')
endif
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc', {
\   'build' : {
\       'windows' : 'echo "Sorry, cannot update vimproc binary file in Windows."',
\       'cygwin' : 'make -f make_cygwin.mak',
\       'mac' : 'make -f make_mac.mak',
\       'unix' : 'make -f make_unix.mak',
\      },
\   }

" }}}

" *** Edit *** {{{
set backspace=indent,eol,start
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
set smarttab
set autoindent
set smartindent
" set shiftround
autocmd FileType html,css,javascript,yaml,tex set shiftwidth=2 softtabstop=2 nosmartindent
autocmd FileType make setlocal softtabstop=8 shiftwidth=8 noexpandtab
autocmd FileType python setlocal nosmartindent
autocmd FileType c,cpp,java setlocal cindent
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
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>:set nopaste<CR>
" nnoremap ,c :cwin<CR>
" nnoremap ,C :cclose<CR>
" nnoremap ,l :lwin<CR>
" nnoremap ,L :lclose<CR>
let g:user_zen_leader_key = '<C-q>'
let g:user_zen_expandabbr_key = '<C-q><C-q>'
nnoremap <Leader>g :GundoToggle<CR>

" ** neocomplcache ** {{{
inoremap <expr> <CR>  pumvisible() ? neocomplcache#close_popup() : "<CR>"
inoremap <expr> <C-x><C-f>  neocomplcache#manual_filename_complete()
inoremap <expr> <C-m>  &filetype == 'vim' ? "\<C-x>\<C-v>\<C-p>" : neocomplcache#manual_omni_complete()
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
nnoremap <Leader>u: :Unite 
nnoremap <Leader>U: :Unite -create -no-quit -toggle  -vertical -winwidth=30 
" バッファ一覧
nmap <Leader>ub <Leader>u:buffer<CR>
nmap <Leader>Ub <Leader>U:buffer<CR>
" ファイル一覧
nmap <Leader>uf :UniteWithBufferDir -buffer-name=files file<CR>
nmap <Leader>Uf :UniteWithCurrentDir -create -no-quit -toggle  -vertical -winwidth=30 -buffer-name=files file<CR>
" レジスタ一覧
nmap <Leader>ur :Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
nmap <Leader>us <Leader>u:file_mru<CR>
nmap <Leader>Us <Leader>U:file_mru -winwidth=80<CR>
" 全部乗せ
nmap <Leader>ua :UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
" unite-mark
nmap <Leader>um <Leader>u: mark<CR>
nmap <Leader>Um <Leader>U: mark<CR>
" unite-outline
nmap <Leader>uo <Leader>u: outline<CR>
nmap <Leader>Uo <Leader>U: outline<CR>
" history/yankの有効化
let g:unite_source_history_yank_enable = 1
nmap <Leader>uy <Leader>u: history/yank<CR>
nmap <Leader>Uy <Leader>U: history/yank<CR>
augroup UniteKeys
    autocmd!
    autocmd FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
    autocmd FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
    autocmd FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
    autocmd FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
    autocmd FileType unite nmap <silent> <buffer> <ESC><ESC> q
    autocmd FileType unite imap <silent> <buffer> <ESC><ESC> <ESC>q
    autocmd FileType unite call AltUnmap()
augroup END
function! AltUnmap()
    try
        iunmap <Esc>t
    catch
    endtry
endfunction
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
" ** }}}

" ** Templates ** {{{
autocmd BufNewFile *.pl 0r $HOME/.vim/template/perl.pl
" ** }}}

" *** }}}

" *** Plugins *** {{{

" TODO: To be used {{{
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'TaskList.vim'
" Bundle 'scrooloose/nerdtree'
NeoBundle 'Align'
" required by fuzzyfinder
" Bundle 'L9'
" Bundle 'FuzzyFinder'
" Bundle 'kana/vim-smartchr'

" Bundle 'Shougo/vimshell'
" }}}

" extended % key matching
runtime macros/matchit.vim

" autocompletes parenthesis, braces and more
NeoBundle 'Raimondi/delimitMate'

" moving
" Bundle 'Lokaltog/vim-easymotion'

" convenient functions for surrounding characters [ds'], [ys'], etc.
NeoBundle 'tpope/vim-surround'

" open some reference manual with K key
NeoBundle 'thinca/vim-ref'

" git support
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'mattn/gist-vim'

" read/write by sudo with `vim sudo:file.txt`
NeoBundle 'sudo.vim'

" shows syntax error on every save
NeoBundle 'scrooloose/syntastic'

" rich-formatted undo history
NeoBundle 'sjl/gundo.vim'
let g:gundo_right = 1
let g:gundo_close_on_revert = 1

" ** neocomplcache ** {{{
" TODO
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neocomplcache-snippets-complete'
NeoBundle 'honza/snipmate-snippets'
" Bundle 'ujihisa/neco-look' " too heavy
" let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default'    : '',
    \ 'perl'       : $HOME . '/.vim/dict/perl.dict'
    \ }
" ** }}}

" ** unite ** {{{
if unite_enabled
NeoBundle 'Shougo/unite.vim'
NeoBundle 'tacroe/unite-mark'
NeoBundle 'h1mesuke/unite-outline'
" 入力モードで開始する
let g:unite_enable_start_insert=1
endif
" ** }}}

" ** textobj ** {{{
" framework
NeoBundle 'kana/vim-textobj-user'
" too many, refer help
" Bundle 'kana/vim-textobj-diff'
" [ai]e
" Bundle 'kana/vim-textobj-entire'
" [ai]z
" Bundle 'kana/vim-textobj-fold'
" [ai]f
NeoBundle 'kana/vim-textobj-function'
" [ai][iI]
NeoBundle 'kana/vim-textobj-indent'
" [ai][/?] 
" Bundle 'kana/vim-textobj-lastpat'
" [ai]y
NeoBundle 'kana/vim-textobj-syntax'
" [ai]c
NeoBundle 'thinca/vim-textobj-comment'
" ** }}}

" ** QuickFix ** {{{
" show quickfix text of current line on statusline
NeoBundle 'dannyob/quickfixstatus'
" edit quickfix lines
" Bundle 'thinca/vim-qfreplace'
" command! -nargs=+ QfArgs let b:quickrun_config = {'args': substitute(<f-args>, ',', ' ', 'g')}
" ** }}}

" ** IME ** {{{

if mlh_enabled
NeoBundle 'vimtaku/vim-mlh'
    autocmd VimEnter * :ToggleVimMlhKeymap
NeoBundle 'mattn/webapi-vim'
endif

if eskk_enabled
NeoBundle 'tyru/eskk.vim'
    let g:eskk#no_default_mappings = 1
    let g:eskk#large_dictionary = { 'path': "~/.vim/dict/SKK-JISYO.L", 'sorted': 1, 'encoding': 'euc-jp', }
    let g:eskk#enable_completion = 1
endif

if skk_enabled
NeoBundle 'anyakichi/skk.vim'
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
NeoBundle 'mattn/zencoding-vim'
let g:user_zen_settings = {
\   'lang': "ja"
\}
let g:use_zen_complete_tag = 1

NeoBundle 'othree/html5.vim'
NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'sukima/xmledit'
" see http://nanasi.jp/articles/vim/xml-plugin.html
" ** }}}

" ** JavaScript ** {{{
autocmd BufNewFile,BufRead *.json set filetype=javascript
" ** }}}

" ** Perl ** {{{
let perl_fold=1
let perl_fold_blocks=1
NeoBundle 'yko/mojo.vim'
augroup PerlKeys
    autocmd!
    autocmd FileType perl inoremap <C-l> $
    autocmd FileType perl snoremap <C-l> $
    autocmd FileType perl nmap <Esc>; A;<Esc><Plug>(poslist-prev-pos)
    autocmd FileType perl imap <Esc>; <C-o><Esc>;
augroup END
function! SigilMaps()
endfunction
" ** }}}

" ** PHP ** {{{
" Bundle 'soh335/vim-symfony'
" ** }}}

" ** Python ** {{{
NeoBundle 'tmhedberg/SimpylFold'
" ** }}}

" ** Others ** {{{
autocmd BufNewFile,BufRead *.go :colorscheme go
" too large to load always
" Bundle 'AutomaticLaTexPlugin'
" ** }}}
" *** }}}

" *** Bleeding Edge *** {{{
" Bundle 'fuenor/qfixgrep'
nnoremap <C-j> :lnext<CR>
nnoremap <C-k> :lprev<CR>
" nnoremap <C-n> :lnext<CR>
" nnoremap <C-p> :lprev<CR>
" nnoremap <Leader>n :next<CR>
" nnoremap <Leader>p :prev<CR>
nnoremap <C-h> :tn<CR>
nnoremap <C-l> :tp<CR>
if unite_enabled
NeoBundle 'sgur/unite-qf'
nmap <Leader>uq <Leader>u: qf<CR>
nmap <Leader>Uq <Leader>U: qf<CR>
endif
NeoBundle 'jelera/vim-javascript-syntax'
NeoBundle 'nono/jquery.vim'
" reffer: http://vimwiki.net/?'viminfo'
set history=100
set viminfo='100,<100,s10,%
NeoBundle 'YankRing.vim'
" Bundle 'basyura/TweetVim'
NeoBundle 'scrooloose/nerdcommenter'
let NERDSpaceDelims = 1
xmap <Leader>ct <Plug>NERDCommenterToggle
nmap <Leader>ct <Plug>NERDCommenterToggle
NeoBundle 'kien/rainbow_parentheses.vim'
augroup RainbowParentheses
    autocmd!
    autocmd VimEnter * :RainbowParenthesesToggle
    autocmd Syntax * call DelayedExecute('RainbowParenthesesLoadRound')
    autocmd Syntax * call DelayedExecute('call rainbow_parentheses#activate()')
augroup END
" [ai][kv]
NeoBundle 'vimtaku/vim-textobj-keyvalue'
" Bundle 't9md/vim-phrase'
" TODO: using at end of line causes backspace
inoremap <C-k> <C-o>D
" Maximizes current split, <C-w>= to restore
nnoremap <C-w>a <C-w>\|<C-w>_
" set showtabline=2
NeoBundle 'kmnk/vim-unite-giti.git'
nmap <Leader>ug <Leader>u: giti<CR>
nmap <Leader>Ug <Leader>U: giti<CR>
" scroll
set scrolloff=1
" [ai]g, a: includes index/key/arrow, i: symbol only
NeoBundle 'vimtaku/vim-textobj-sigil'
" simple vim ref for .vimrc
autocmd! FileType vim call MapVimHelp()
function! MapVimHelp()
    map K :help <C-r><C-w><CR>
    " TODO: visual mode
endfunction

set ignorecase
set smartcase
set cmdheight=2

" Bundle 'mbriggs/mark.vim'
" Bundle 'mattn/benchvimrc-vim'
let g:neocomplcache_ctags_arguments_list = {
  \ 'perl' : '-R -h ".pm"'
  \ }
" Bundle 'astashov/vim-ruby-debugger'
NeoBundle 'kien/ctrlp.vim'
let g:ctrlp_map = '<Leader><C-p>'
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*.so,*.swp,*.swo
nmap <Leader>up :Unite -auto-resize -auto-preview -buffer-name=files file_rec<CR>
nmap <Leader>Up :Unite -create -no-quit -toggle  -vertical -winwidth=30 -buffer-name=files file_rec<CR>
" Bundle 'taku-o/vim-copypath'
NeoBundle 'kana/vim-altr'
nmap <Leader>f <Plug>(altr-forward)
NeoBundle 'Smooth-Scroll'
set noeb vb t_vb=
NeoBundle 'mileszs/ack.vim'
" Bundle 'jpalardy/vim-slime'
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
NeoBundle 'altercation/vim-colors-solarized'
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

" http://d.hatena.ne.jp/kitak/20100830/1283180007
set splitbelow
set splitright

set hidden

" *** Utility Function *** {{{

" ** DelayedExecute ** {{{
" Promising the order of autocmd executions, e.g. set hl after main syntax
function! DelayedExecute(command)
    if !exists('s:delayed_execute_queue')
        let s:delayed_execute_queue = []
    endif
    call add(s:delayed_execute_queue, a:command)
    augroup DelayedExecutor
        autocmd!
        autocmd CursorHold,CursorHoldI,CursorMoved,CursorMovedI * call RunDelayedExecute()
    augroup END
endfunction
function! RunDelayedExecute()
    augroup DelayedExecutor
        autocmd!
    augroup END
    for cmd in s:delayed_execute_queue
        execute cmd
        unlet cmd
    endfor
    unlet s:delayed_execute_queue
endfunction

" ** }}}

" ** Fold Renewer ** {{{
" inspired by: http://vim.wikia.com/wiki/Keep_folds_closed_while_inserting_text
" work around for performance problem of expr/syntax foldmethods
augroup FoldRenewer
    autocmd!
    " VimEnter: for delayed stashing
    " WinEnter: because foldmethod is window-specific
    " CursorHold: for normal mode editing e.g. undo/redo
    autocmd VimEnter,WinEnter,InsertLeave,CursorHold,CursorHoldI * call RenewFold()
    " workaround for buffer change from outside of current window,
    " like gundo plugin and multi split of single file
    autocmd WinLeave * call StashFold()
augroup END

" Let foldmethod create folds first, then preserve it.
function! RenewFold()
    if exists('w:last_fdm')
        if &foldmethod == 'manual'
            let &l:foldmethod=w:last_fdm
        endif
        unlet w:last_fdm
    endif
    if &foldmethod != 'expr' && &foldmethod != 'syntax'
        return
    endif
    augroup DelayedStashFold
        autocmd!
        " CursorMoved: because called at start, after ready to edit
        autocmd CursorMoved,CursorMovedI * call StashFold()
    augroup END
endfunction

function! StashFold()
    if !exists('w:last_fdm') && (&foldmethod == 'expr' || &foldmethod == 'syntax')
        let w:last_fdm=&foldmethod
        setlocal foldmethod=manual
    endif
    augroup DelayedStashFold
        autocmd!
    augroup END
endfunction

" ** }}}

" *** }}}
 
inoremap <C-f> <C-o>l
inoremap <C-b> <C-o>h
" TODO: current search pattern
" XXX: ack.vim is recommended
" command! -nargs=+ G :vimgrep /<args>/ % | cwin
" command! -nargs=+ GB :cexpr "" | :cwin | :bufdo vimgrepadd /<args>/ %

if 0
NeoBundle 'kana/vim-smartword.git'
map w <Plug>(smartword-w)
map b <Plug>(smartword-b)
map e <Plug>(smartword-e)
map ge <Plug>(smartword-ge)
endif

" :rename
NeoBundle 'danro/rename.vim'

set foldlevelstart=0

command! F :echo expand('%')

" [ai]l
NeoBundle 'kana/vim-textobj-line'
set shortmess+=I
set textwidth=0
set colorcolumn=+1,+2,+3,+4
if has('mouse')
    " use {shift|command}+drag to use terminal side mouse
    set mouse=a
    " http://www.machu.jp/diary/20070310.html#p01
    if &term == 'screen'
        set ttymouse=xterm2
    endif
endif

set modelines=0

set timeout
set timeoutlen=1000
set ttimeout
set ttimeoutlen=150

NeoBundle 'kablamo/VimDebug'

" if has('mac') pbcopy

" QuickFix Toggle {{{
" refer: http://vim.wikia.com/wiki/Toggle_to_open_or_close_the_quickfix_window

function! GetBufferList()
  redir =>buflist
  silent! ls
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
      echohl ErrorMsg
      echo "Location List is Empty."
      return
  endif
  let winnr = winnr()
  exec('botright '.a:pfx.'open')
  if winnr() != winnr
    wincmd p
  endif
endfunction

nmap <silent> <leader>l :call ToggleList("Location List", 'l')<CR>
nmap <silent> <leader>q :call ToggleList("Quickfix List", 'c')<CR>

" }}}

command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_
                \ | diffthis | wincmd p | diffthis

nmap <Leader>ut <Leader>u: tab<CR>
nmap <Leader>Ut <Leader>U: tab<CR>

NeoBundle 'buftabs'

" TODO
vnoremap <Leader>th :<c-u>AlignCtrl l-l<cr>gv:Align =><cr>

let g:unite_update_time=50
nmap <Leader>ud :Unite -auto-preview -buffer-name=files file_rec<CR>
nmap <Leader>Ud :Unite -create -no-quit -toggle  -vertical -winwidth=30 -buffer-name=files file_rec<CR>
inoremap <Esc>t <C-d>
map <Leader>ta <Plug>TaskList
" *** }}}

NeoBundle 'tpope/vim-repeat'
NeoBundle 'nathanaelkane/vim-indent-guides'
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
NeoBundle 'vimtaku/vim-textobj-doublecolon'
NeoBundle 'vimtaku/textobj-wiw'
NeoBundle 'thinca/vim-poslist'
map <Esc>, <Plug>(poslist-next-pos)
map <Esc>. <Plug>(poslist-prev-pos)
imap <Esc>, <C-o><Plug>(poslist-next-pos)
imap <Esc>. <C-o><Plug>(poslist-prev-pos)
NeoBundle 'garbas/vim-snipmate'
NeoBundle 'MarcWeber/vim-addon-mw-utils'
NeoBundle 'tomtom/tlib_vim'
NeoBundle 'thinca/vim-visualstar'

imap <C-g><S-Tab> <Plug>delimitMateS-Tab
inoremap <silent> <C-g><Tab> <C-r>=delimitMate#JumpAny('')<CR>

NeoBundle 'nakatakeshi/jump2pm.vim'
noremap <Leader>pg :call Jump2pm('vne')<CR>
noremap <Leader>pf :call Jump2pm('e')<CR>
noremap <Leader>pd :call Jump2pm('sp')<CR>
noremap <Leader>pt :call Jump2pm('tabe')<CR>

cnoreabbrev Pod Ref perldoc
command! Upod :Unite ref/perldoc

" *** Local Script *** {{{
if filereadable(expand('~/.vimlocal/.vimrc'))
    source $HOME/.vimlocal/.vimrc
endif
" *** }}}
