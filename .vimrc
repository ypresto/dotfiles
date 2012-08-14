" **
" * .vimrc for yuya_presto
" *
" * Please checkout 'Plugins' section for recommended plugins.
" *

set nocompatible
let mapleader=" "

" *** Make This Reloadable *** {{{1
" reset global autocmd
autocmd!
" reload when writing .vimrc
autocmd BufWritePost $MYVIMRC,$HOME/dotfiles/.vimrc source $MYVIMRC |
            \if has('gui_running') | source $MYGVIMRC
autocmd BufWritePost $MYGVIMRC,$HOME/dotfiles/.gvimrc if has('gui_running') | source $MYGVIMRC
" *** }}}

" *** Switches  *** {{{1
" IMEs
let mlh_enabled = 1
let skk_enabled = 0
let eskk_enabled = 0
" *** }}}

" *** Start up *** {{{1

" for neobundle
filetype off
filetype plugin indent off
syntax off " seems to be faster to enable at the end

" load installed plugins
if has('vim_starting')
    set nocompatible
    set rtp+=~/.vim/bundle/neobundle.vim/
    call neobundle#rc(expand('~/.vim/bundle/'))
    " For Perl, add paths for running or test
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

" *** }}}

" *** Editor Functionality *** {{{1

" ** Encoding ** {{{2

set encoding=utf-8
" FIXME: maybe below line has some bug
set fileencodings=ucs-bom,utf-8,iso-2022-jp-3,iso-2022-jp,eucjp-ms,euc-jisx0213,euc-jp,sjis,cp932

" ** }}}

" ** Indent / Tab ** {{{2

set tabstop=8     " <Tab>s are shown with this num of <Space>s
set softtabstop=4 " Use this num of spaces as <Tab> on insert and delete
set shiftwidth=4  " Use this num of spaces for auto indent
set expandtab     " Always use <Tab> for indent and insert
set smarttab      " Use shiftwidth on beginning of line when <Tab> key
set autoindent    " Use same indent level on next line
set smartindent   " Auto indent for C-like code with '{...}' blocks
set shiftround    " Round indent when < or > is used

" * Filetype specific indent * {{{

" Force using <Tab>, not <Space>s
autocmd FileType make setlocal softtabstop=8 shiftwidth=8 noexpandtab
" 2-space indent
autocmd FileType
    \ html,css,javascript,yaml,tex,ruby
    \ set shiftwidth=2 softtabstop=2 nosmartindent
autocmd FileType python     setlocal nosmartindent
" Use smarter auto indent for C-languages
autocmd FileType c,cpp,java setlocal cindent

" * }}}

" ** }}}

" ** Undo / Backup / History ** {{{2

set undofile            " Save undo history to file
set undodir=~/.vim/undo " Specify where to save
set nobackup            " Don't create backup files (foobar~)

" reffer: http://vimwiki.net/?'viminfo'
set history=100
set viminfo='100,<100,s10,%

" Jump to the last known cursos position when opening file
" Refer: :help last-position-jump
" 'zv' and 'zz' was added by ypresto
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif |
  \ execute "normal" "zv" | " open fold under cursor
  \ execute "normal" "zz"   " Move current line on center of window

" ** }}}

" ** UI / Editing / Search ** {{{2

" Editing
set backspace=indent,eol,start " go to previous line with backspace

set foldmethod=marker " Use '{{{' and '}}}' for marker 
set foldlevelstart=0  " Start with all folds closed
set noeb vb t_vb=     " no beep
set scrolloff=1       " show N more next line when scrolling

" status line and line number
set number            " Show number of line on left
set showcmd           " Show what keys input for command, but too slow on terminal
set laststatus=2      " Always show statusline
" using powerline for status
" if skk_enabled
"     set statusline=%<%f\ %h%m%r\ %{SkkGetModeStr()}%=%-14.(%l,%c%V%)\ %P
" else
"     set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
" endif

" search
set incsearch         " Use 'incremental search'
set hlsearch          " Highlight search result
set ignorecase        " Ignore case when searching
set smartcase         " Do not ignorecase if keyword contains uppercase

" command line
set wildmenu          " Enhanced command line completion
set cmdheight=2       " Set height of command line

set shortmess+=I      " Surpress intro message when starting vim

" ** }}}

" ** Highlighting ** {{{2

set cursorline " Highlight current line
" Highlight current line only on current window
augroup cch
    autocmd! cch
    autocmd WinLeave * set nocursorline
    autocmd WinEnter,BufRead * set cursorline
augroup END
" Change highlight color of current line
highlight clear CursorLine
highlight CursorLine ctermbg=black guibg=black
highlight SignColumn ctermfg=white ctermbg=black cterm=none

set colorcolumn=73,74,81,82 " Highlight border of 'long line'

set nolist " Don't highlight garbage characters (see below)
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%

" * ZenkakuSpace * {{{3

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

" ** Window / Buffer / Tab ** {{{2

" Switch buffer without saving changes
set hidden

" Refer: http://d.hatena.ne.jp/kitak/20100830/1283180007
set splitbelow
set splitright

" ** }}}

" ** Mouse ** {{{2

if has('mouse')

    " Enable mouse for split, buffer, cursor, etc.
    " use {shift|command}+drag to use original, terminal side mouse
    set mouse=a

    " Refer: http://www.machu.jp/diary/20070310.html#p01
    if &term == 'screen' || &term == 'screen-256color'
        set ttymouse=xterm2
    endif

endif

" ** }}}

" ** Misc ** {{{2
" Don't use matched files for completion
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*.so,*.swp,*.swo
" ** }}}

" *** }}}

" *** Keymapping *** {{{1

" below lines are problematic on MacVim with Alt+Key physically mapped to Esc+Key
if !has('gui_running')
    " Wait for slow input of key combination
    set timeout
    set timeoutlen=1000
    " Activate alt key power,
    " wait [ttimeoutlen]ms for following keys after <Esc> for Alt-* keys
    set ttimeout
    set ttimeoutlen=150
else
    set notimeout  " to avoid Esc+Key waiting bug
    set nottimeout " blah, no effect on gui...
endif

noremap ZJ :w<CR> " Fast saving
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>:set nopaste<CR>

" swap g[jk] (move displayed line) and [jk] (move original line)
noremap <silent> j gj
noremap <silent> gj j
noremap <silent> k gk
noremap <silent> gk k
inoremap <silent> <C-[> <Esc>

" ** Partial Emacs Keybind in Insert Mode ** {{{2
" Refer: :help tcsh-style
" Note: 'map!' maps both insert and command-line mode
noremap! <C-f> <Right>
noremap! <C-b> <Left>
" <C-o> and <Home> is different on indented line
inoremap <C-a> <C-o>^
cnoremap <C-a> <Home>
" Cmdline has default map of <C-e> / See neocomplcache section for <C-e>
inoremap <C-e> <End>
noremap! <C-d> <Del>
noremap! <Esc>f <S-Right>
noremap! <Esc>b <S-Left>
inoremap <Esc>d <C-o>de
" Remap <C-d> de-indentation to Alt-t
inoremap <Esc>t <C-d>
" TODO: using at end of line causes backspace
inoremap <C-k> <C-o>D
" ** }}}

" Maximizes current split, <C-w>= to restore
nnoremap <C-w>a <C-w>\|<C-w>_

" QuickFix Toggle
nmap <silent> <leader>l :call ToggleList("Location List", 'l')<CR>
nmap <silent> <leader>q :call ToggleList("Quickfix List", 'c')<CR>

" ZenCoding
let g:user_zen_leader_key = '<C-q>'
let g:user_zen_expandabbr_key = '<C-q><C-q>'

" Gundo
nnoremap <Leader>g :GundoToggle<CR>

" ** neocomplcache ** {{{2

inoremap <expr> <C-x><C-f>  neocomplcache#manual_filename_complete()
" C-nでneocomplcache補完
inoremap <expr> <C-n>  pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>"
" C-pでkeyword補完
inoremap <expr> <C-p> pumvisible() ? "\<C-p>" : "\<C-p>\<C-n>"
" 補完候補が表示されている場合は確定。そうでない場合は改行
" inoremap <expr> <CR>  pumvisible() ? neocomplcache#close_popup() : "<CR>"
" 補完をキャンセル＋End
" inoremap <expr> <C-e>  pumvisible() ? neocomplcache#close_popup() : "\<End>"

" ** }}}

" ** unite ** {{{2

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
nmap <Leader>uz <Leader>u: outline:folding<CR>
nmap <Leader>Uz <Leader>U: outline:folding<CR>
" history/yankの有効化
" let g:unite_source_history_yank_enable = 1
nmap <Leader>uy <Leader>u: history/yank<CR>
nmap <Leader>Uy <Leader>U: history/yank<CR>

nmap <Leader>up <Leader>u: -buffer-name=files file_rec<CR>
nmap <Leader>Up <Leader>u: -buffer-name=files file_rec<CR>
" TODO: you can use file_rec/async too, but maybe beta.

nmap <Leader>ut <Leader>u: tab<CR>
nmap <Leader>Ut <Leader>U: tab<CR>

nmap <Leader>ug <Leader>u: giti<CR>
nmap <Leader>Ug <Leader>U: giti<CR>
nmap <Leader>uq <Leader>u: qf<CR>
nmap <Leader>Uq <Leader>U: qf<CR>

augroup UniteWindowKeyMaps
    autocmd!
    autocmd FileType unite nnoremap <silent><buffer><expr> <C-j> unite#do_action('split')
    autocmd FileType unite inoremap <silent><buffer><expr> <C-j> unite#do_action('split')
    autocmd FileType unite nnoremap <silent><buffer><expr> <C-l> unite#do_action('vsplit')
    autocmd FileType unite inoremap <silent><buffer><expr> <C-l> unite#do_action('vsplit')
    autocmd FileType unite nmap <silent> <buffer> <ESC><ESC> q
    autocmd FileType unite imap <silent> <buffer> <ESC><ESC> <ESC>q
    autocmd FileType unite call UnmapAltKeys()
augroup END

function! UnmapAltKeys()
    " almost for unite to avoid Alt keys does not fire normal <Esc>
    " noremap <Esc> to avoid <Esc>* mappings fired
    inoremap <buffer> <silent> <Plug>(esc) <Esc>
    imap <buffer> <Esc>t <Plug>(esc)t
    imap <buffer> <Esc>t <Plug>(esc)t
endfunction

" ** }}}

" ** IME ** {{{2
if eskk_enabled
    inoremap <expr> <C-l> eskk#toggle()
endif
if skk_enabled
    let g:skk_control_j_key = '<C-l>'
endif
" ** }}}

" *** }}}

" *** Plugins *** {{{1

" ** Recommended: YOU SHOULD USE THESE AND BE IMproved! *** {{{2

" C-[np] after paste, textobj [ai]'"()[]{} , and more, more!!
NeoBundle 'YankRing.vim'

" autocompletes parenthesis, braces and more
NeoBundle 'Raimondi/delimitMate'
imap <M-g> <Plug>delimitMateS-Tab
" " instead of above, use below one
" NeoBundle 'jiangmiao/auto-pairs'
" let g:AutoPairsShortcutToggle = '<Plug>_disabled_AutoPairsShortcutToggle'
" let g:AutoPairsShortcutFastWrap = '<Plug>_disabled_AutoPairsShortcutFastWrap'
" let g:AutoPairsShortcutJump = '<Esc>g'
" let g:AutoPairsShortcutBackInsert = '<Esc>p'

" surrounding with braces or quotes with s and S key
NeoBundle 'tpope/vim-surround'

" open reference manual with K key
NeoBundle 'thinca/vim-ref'

" git support
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'mattn/gist-vim'

" read/write by sudo with `vim sudo:file.txt`
NeoBundle 'sudo.vim'

" shows syntax error on every save
NeoBundle 'scrooloose/syntastic'
let g:syntastic_echo_current_error=0 " too heavy, use below one
" show quickfix text of current line on statusline
NeoBundle 'dannyob/quickfixstatus'

" rich-formatted undo history
NeoBundle 'sjl/gundo.vim'
let g:gundo_right = 1
let g:gundo_close_on_revert = 1

" SnipMate, TextMate like snippet use with <Tab>
NeoBundle 'garbas/vim-snipmate'
NeoBundle 'honza/snipmate-snippets'
" Dependencies
NeoBundle 'MarcWeber/vim-addon-mw-utils'
NeoBundle 'tomtom/tlib_vim'

" ** }}}

" ** neocomplcache ** {{{2

NeoBundle 'Shougo/neocomplcache'
" Below supports SnipMate!
NeoBundle 'Shougo/neocomplcache-snippets-complete'
" English spell completion with 'look' command
NeoBundle 'ujihisa/neco-look'
" let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default'    : '',
    \ 'perl'       : $HOME . '/.vim/dict/perl.dict'
    \ }

" too heavy when launching vim, make initializing delayed
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
    echo "Initializing NeCo... Completed."
endfunction

" ** }}}

" ** unite ** {{{2
NeoBundle 'Shougo/unite.vim'
NeoBundle 'tacroe/unite-mark'
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'kmnk/vim-unite-giti.git'
NeoBundle 'sgur/unite-qf'
" 入力モードで開始する
let g:unite_enable_start_insert=1
" 候補絞込みを高速化する
" CursorHold（.swpファイルの作成やイベント発火）までの時間が変化してしまうので注意
let g:unite_update_time=50

" ** }}}

" ** textobj ** {{{2

" select range of text with only two or three keys
" For example: [ai]w

" framework for all belows
NeoBundle 'kana/vim-textobj-user'

" too many, refer help
" Bundle 'kana/vim-textobj-diff'
" [ai]e
" Bundle 'kana/vim-textobj-entire'
" [ai]z
NeoBundle 'kana/vim-textobj-fold'
" [ai]f
NeoBundle 'kana/vim-textobj-function'
" [ai][iI]
NeoBundle 'kana/vim-textobj-indent'
" [ai][/?] 
" Bundle 'kana/vim-textobj-lastpat'
" [ai]y
NeoBundle 'kana/vim-textobj-syntax'
" [ai]l
NeoBundle 'kana/vim-textobj-line'

" [ai]c : textobj-comment
" [ai]f : Add perl and javascript support to textobj-function
" [ai]b : textobj-between, refer below
" http://d.hatena.ne.jp/thinca/20100614/1276448745
NeoBundle 'thinca/vim-textobj-plugins'
" damn, [ai]f mappings are overwrapping...
omap if <Plug>(textobj-function-i)
omap af <Plug>(textobj-function-a)
vmap if <Plug>(textobj-function-i)
vmap af <Plug>(textobj-function-a)
omap iF <Plug>(textobj-between-i)
omap aF <Plug>(textobj-between-a)
vmap iF <Plug>(textobj-between-i)
vmap aF <Plug>(textobj-between-a)

" [ai],w / 'this_is_a_word' will be 4 'words in word'
" also ,w ,b ,e ,ge motion defined
NeoBundle 'vimtaku/textobj-wiw'

" * Almost For Perl * {{{3
" [ai]g / a: includes index/key/arrow, i: symbol only
NeoBundle 'vimtaku/vim-textobj-sigil'
" [ai][kv]
NeoBundle 'vimtaku/vim-textobj-keyvalue'
" ???
NeoBundle 'vimtaku/vim-textobj-doublecolon'
" * }}}

" ** }}}

" ** Misc ** {{{2

" Run current file by <Leader>r and get result in another buffer
NeoBundle 'thinca/vim-quickrun'

" List or Highlight all todo, fixme, xxx comments
NeoBundle 'TaskList.vim'

" Indent comments and expressions
NeoBundle 'Align'

" extended % key matching
runtime macros/matchit.vim

" moving more far easily
NeoBundle 'Lokaltog/vim-easymotion'

" Smooth <C-{f,b,u,d}> scrolls
" NeoBundle 'Smooth-Scroll'
" not work with macvim

" Alternative for vimgrep, :Ack and :LAck
NeoBundle 'mileszs/ack.vim'

" :Rename current file on disk
NeoBundle 'danro/rename.vim'

" Bulk renamer
NeoBundle 'renamer.vim'

" Buffer list in bottom of window
NeoBundle 'buftabs'
" (You can use status line with option
"  or you can expand command line with 'set cmdheight')

" Highlight indent by its levels, must have for pythonist
NeoBundle 'nathanaelkane/vim-indent-guides'
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1

" Micro <C-i> and <C-o>
NeoBundle 'thinca/vim-poslist'
map <Esc>, <Plug>(poslist-next-pos)
map <Esc>. <Plug>(poslist-prev-pos)
imap <Esc>, <C-o><Plug>(poslist-next-pos)
imap <Esc>. <C-o><Plug>(poslist-prev-pos)

" Search word with * and # also on Visual Mode
NeoBundle 'thinca/vim-visualstar'

" ** }}}

" ** nerdcommenter ** {{{
NeoBundle 'scrooloose/nerdcommenter'
let NERDSpaceDelims = 1
xmap <Leader>cj <Plug>NERDCommenterToggle
nmap <Leader>cj <Plug>NERDCommenterToggle
NeoBundle 'kien/rainbow_parentheses.vim'
augroup RainbowParentheses
    autocmd!
    autocmd VimEnter * :RainbowParenthesesToggle
    autocmd Syntax * call DelayedExecute('RainbowParenthesesLoadRound')
    autocmd Syntax * call DelayedExecute('call rainbow_parentheses#activate()')
augroup END
" ** }}}

" ** TODO: To be used ** {{{2
" Bundle 'scrooloose/nerdtree'
" required by fuzzyfinder
" Bundle 'L9'
" Bundle 'FuzzyFinder'
" Bundle 'kana/vim-smartchr'

" Bundle 'Shougo/vimshell'
" ** }}}

" ** IME ** {{{2

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

" ** Color Scheme ** {{{2

" FIXME: below maybe required on tmux/screen
" set t_Co=256

" Too hard to setup not-degraded-mode...
" (You should setup your term emulator first)
" So please try it with degrade=1

NeoBundle 'altercation/vim-colors-solarized'
set background=dark
" let g:solarized_termcolors=256
" let g:solarized_degrade=1
let g:solarized_termcolors=16
let g:solarized_termtrans=1
let g:solarized_bold=1
let g:solarized_underline=1
let g:solarized_italic=1
colorscheme solarized

" ** }}}

" *** }}}

" *** Filetypes *** {{{1

" ** HTML / CSS / XML ** {{{2

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

" ** JavaScript ** {{{2

autocmd BufNewFile,BufRead *.json set filetype=javascript
NeoBundle 'jelera/vim-javascript-syntax'
NeoBundle 'nono/jquery.vim'

" ** }}}

" ** Perl ** {{{2

" use new perl syntax and indent!
NeoBundle 'petdance/vim-perl'

" Enable perl specific rich fold
let perl_fold=1
let perl_fold_blocks=1
" let perl_nofold_packages = 1
" let perl_include_pod=1

NeoBundle 'yko/mojo.vim'
let mojo_highlight_data = 1

augroup PerlKeys
    autocmd!
    autocmd FileType perl inoremap <C-l> $
    autocmd FileType perl snoremap <C-l> $
augroup END

" Perl hash aligning
vnoremap <Leader>th :<c-u>AlignCtrl l-l<cr>gv:Align =><cr>

" Open perl file by package name under the cursor
" NeoBundle 'nakatakeshi/jump2pm.vim'
" noremap <Leader>pv :call Jump2pm('vne')<CR>
" noremap <Leader>pf :call Jump2pm('e')<CR>
" noremap <Leader>ps :call Jump2pm('sp')<CR>
" noremap <Leader>pt :call Jump2pm('tabe')<CR>
" sometime problematic, use gf of vim-perl instead

" vim-ref for perldoc
cnoreabbrev Pod Ref perldoc
command! Upod :Unite ref/perldoc

" Refer: Also refer textobj section

" ** }}}

" ** PHP ** {{{2
" I'm not using symfony recently
" Bundle 'soh335/vim-symfony'
" ** }}}

" ** Python ** {{{2
NeoBundle 'tmhedberg/SimpylFold'
" ** }}}

" ** VimScript ** {{{

" vim-ref alternative for .vimrc and VimScripts
autocmd! FileType vim call MapVimHelp()
function! MapVimHelp()
    map <buffer> K :help <C-r><C-w><CR>
    " TODO: visual mode
endfunction

" ** }}}

" *** }}}

" *** Custom Commands *** {{{1

" vimdiff between current buffer and last saved state
" Refer: :help DiffOrig
command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_
                \ | diffthis | wincmd p | diffthis

" Show path
command! F :echo expand('%')

" *** }}}

" *** Utility Function *** {{{1

" ** DelayedExecute ** {{{2

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

" ** FoldRenewer ** {{{2

" Work around for performance problem of expr/syntax foldmethods
" Inspired by: http://vim.wikia.com/wiki/Keep_folds_closed_while_inserting_text

" black list
autocmd! FileType ref-perldoc setlocal foldmethod=manual

augroup FoldRenewer
    autocmd!
    " VimEnter: for delayed stashing
    " WinEnter: because foldmethod is window-specific
    " CursorHold: for normal mode editing e.g. undo/redo
    autocmd VimEnter,WinEnter,CursorHold,CursorHoldI * call RenewFold(0)
    " open fold under the cursor after re-generating folds
    autocmd InsertLeave * call RenewFold(1)
    " workaround for buffer change from outside of current window,
    " like gundo plugin and multi split of single file
    autocmd WinLeave * call StashFold()
augroup END

" Let foldmethod create folds first, then preserve it.
function! RenewFold(foldopen)
    if &filetype == 'ref-perldoc'
        " black list
        setlocal foldmethod=manual
        return
    endif
    if exists('w:last_fdm')
        if &foldmethod == 'manual'
            let &l:foldmethod=w:last_fdm
            if a:foldopen != 0
                " open folds under the cursor
                execute "normal" "zv"
            endif
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

" Preserve foldmethod and set it to 'manual'
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

" ** CompleteBlockBrace ** {{{2

" Eclipse like block completion
" Expand {} / () / [] block with <Enter>

inoremap <expr><CR> <SID>CompleteBlockBrace()
function! s:CompleteBlockBrace()
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

" ** QuickFix Toggle ** {{{

" Refer: http://vim.wikia.com/wiki/Toggle_to_open_or_close_the_quickfix_window

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

" ** }}}

" *** }}}
 
" *** Bleeding Edge *** {{{1

" Beta: These are currently testing/starting-to-use!

" Bundle 'fuenor/qfixgrep'
" nnoremap <C-n> :lnext<CR>
" nnoremap <C-p> :lprev<CR>
" nnoremap <Leader>n :next<CR>
" nnoremap <Leader>p :prev<CR>
" nnoremap <C-h> :tn<CR>
" nnoremap <C-l> :tp<CR>

" Bundle 't9md/vim-phrase'

" set showtabline=2

" Bundle 'mbriggs/mark.vim'
" TODO
let g:neocomplcache_ctags_arguments_list = {
  \ 'perl' : '-R -h ".pm"'
  \ }
" Bundle 'astashov/vim-ruby-debugger'
" NeoBundle 'kien/ctrlp.vim'
" let g:ctrlp_map = '<Leader><C-p>'
" Bundle 'taku-o/vim-copypath'

NeoBundle 'kana/vim-altr'
nmap <Leader>f <Plug>(altr-forward)

" Bundle 'jpalardy/vim-slime'

if 0
augroup TriggerUpdateTags
    autocmd!
    autocmd CursorHold * call g:UpdateTags()
    autocmd CursorHoldI * call g:UpdateTags()
augroup END
function! g:UpdateTags()
    if !exists(":NeoComplCacheCachingInclude") | return | endif
    NeoComplCacheCachingInclude
    for filename in neocomplcache#sources#include_complete#get_include_files(bufnr('%'))
      execute "setlocal tags+=" . neocomplcache#cache#encode_name('include_tags', filename)
    endfor
endfunction
endif

if 0
NeoBundle 'kana/vim-smartword.git'
map w <Plug>(smartword-w)
map b <Plug>(smartword-b)
map e <Plug>(smartword-e)
map ge <Plug>(smartword-ge)
endif

" require vim's perl interpreter support
NeoBundle 'kablamo/VimDebug', {
\   'rtp'   : 'vim',
\}

" if has('mac') pbcopy


map <Leader>tl <Plug>TaskList

NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-abolish'
nmap <C-j> ]
nmap <C-k> [
NeoBundle 'tpope/vim-unimpaired'

" Bundle 'basyura/TweetVim'

NeoBundle 'fuzzyjump.vim'

NeoBundle 'mikewest/vimroom'

NeoBundle 'Lokaltog/vim-powerline'

" set scrolljump=3

NeoBundle 'rson/vim-conque'
NeoBundle 'Shougo/vimshell'

" until unite being fast
NeoBundle 'kien/ctrlp.vim'
let g:ctrlp_map = '<Leader><C-p>'

nmap <Esc>; A;<Esc><Plug>(poslist-prev-pos)
imap <Esc>; <C-o><Esc>;

" *** }}}

" *** Debug *** {{{1

" Refer: http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
command! CurHl :echo
    \ "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
    \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
    \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"

" NeoBundle 'mattn/benchvimrc-vim'

" *** }}}

" *** MacVim Specific *** {{{1
if has('gui_macvim')
    set transparency=10
    set macmeta " Use alt as meta on MacVim like on terminal
    set guifont="Menlo Regular:h12"
endif
if has('gui_running')
    set guioptions+=c
endif
" }}}

" *** Local Script *** {{{1
" You can put on '~/.vimlocal/*' anything you don't want to publish.
set rtp+=~/.vimlocal
if filereadable(expand('~/.vimlocal/.vimrc'))
    source $HOME/.vimlocal/.vimrc
endif
" *** }}}

" *** Enable Filetype Plugins *** {{{1
" for neobundle, these are disabled in start up section
filetype on
filetype plugin indent on " XXX maybe better to disable this, testing
" for speedup
syntax on " for os x
" }}}

" vim:set foldmethod=marker:
