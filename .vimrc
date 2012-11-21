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
            \ if (has('gui_running') && filereadable($MYGVIMRC)) | source $MYGVIMRC
" TODO: should :colorscheme manually and fire ColorScheme autocmd
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
endif
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc', {
\   'build' : {
\       'windows' : 'echo "Sorry, cannot update vimproc binary file in Windows."',
\       'cygwin'  : 'make -f make_cygwin.mak',
\       'mac'     : 'make -f make_mac.mak',
\       'unix'    : 'make -f make_unix.mak',
\      },
\   }

" *** }}}

" *** Editor Functionality *** {{{1

" ** Language / Encoding ** {{{2

try
    :language en
catch
    :language C
endtry

set encoding=utf-8
" FIXME maybe below line has some bug
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
    \ html,scss,javascript,ruby,tex,xml
    \ set shiftwidth=2 softtabstop=2 nosmartindent
autocmd FileType python     setlocal nosmartindent
" Use smarter auto indent for C-languages
autocmd FileType c,cpp,java setlocal cindent

" * }}}

" ** }}}

" ** Undo / Backup / History / Session ** {{{2

set undofile            " Save undo history to file
set undodir=~/.vim/undo " Specify where to save
set nobackup            " Don't create backup files (foobar~)

" reffer: http://vimwiki.net/?'viminfo'
set history=100
set viminfo='100,<100,s10

" Jump to the last known cursos position when opening file
" Refer: :help last-position-jump
" 'zv' and 'zz' was added by ypresto
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif |
  \ execute "normal! zv" | " open fold under cursor
  \ execute "normal! zz"   " Move current line on center of window

set sessionoptions-=options

" ** }}}

" ** Editing / Search ** {{{2

" Editing
set backspace=indent,eol,start " go to previous line with backspace
set textwidth=0                " don't insert break automatically

set foldmethod=marker " Use '{{{' and '}}}' for marker
set foldlevelstart=0  " Start with all folds closed
set noeb vb t_vb=     " no beep
set scrolloff=1       " show N more next line when scrolling

" Search
set incsearch         " Use 'incremental search'
set hlsearch          " Highlight search result
set ignorecase        " Ignore case when searching
set smartcase         " Do not ignorecase if keyword contains uppercase

" ** }}}

" ** Status Line / Command Line** {{{2

" status line and line number
set number            " Show number of line on left
set showcmd           " Show what keys input for command, but too slow on terminal
set laststatus=2      " Always show statusline
" using powerline, not setting statusline
" if skk_enabled
"     set statusline=%<%f\ %h%m%r\ %{SkkGetModeStr()}%=%-14.(%l,%c%V%)\ %P
" else
"     set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
" endif

" command line
set cmdheight=2                " Set height of command line
set wildmode=longest,list,full " command line completion order
set nowildmenu                 " Enhanced completion: disabled
" Don't use matched files for completion
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*.so,*.swp,*.swo

" ** }}}

" ** Highlighting ** {{{2

set cursorline              " Highlight current line
set colorcolumn=73,74,81,82 " Highlight border of 'long line'
set list                    " highlight garbage characters (see below)
set listchars=tab:»-,trail:~,extends:»,precedes:«,nbsp:%

function! s:HighlightSetup()
    " Change highlight color of current line
    highlight clear CursorLine
    highlight CursorLine ctermbg=black guibg=black
    highlight SignColumn ctermfg=white ctermbg=black cterm=none

    highlight SpecialKey   ctermbg=darkyellow guibg=darkyellow
    highlight ZenkakuSpace ctermbg=darkgray   guibg=darkgray
endfunction

augroup HighlightSetup
    autocmd!

    " Highlight current line only on current window
    autocmd WinLeave * set nocursorline
    autocmd WinEnter,BufRead * set cursorline

    " activates custom highlight settings
    autocmd ColorScheme * call s:HighlightSetup()
    autocmd VimEnter,WinEnter * call matchadd('ZenkakuSpace', '　')
augroup END

" ** }}}

" ** Window / Buffer / Tab ** {{{2

" Switch buffer without saving changes
" set hidden

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
set shortmess+=I      " Surpress intro message when starting vim
" ** }}}

" *** }}}

" *** Keymapping *** {{{1

if has('gui_mac')
    set notimeout  " to avoid Esc+Key waiting bug
    set nottimeout " blah, no effect on gui...
    " below lines are problematic on MacVim with Alt+Key physically mapped to Esc+Key
else
    " Wait for slow input of key combination
    set timeout
    set timeoutlen=1000
    " Activate alt key power on terminal,
    " wait [ttimeoutlen]ms for following keys after <Esc> for Alt-* keys
    set ttimeout
    set ttimeoutlen=150
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
snoremap <C-a> <Home>
noremap! <C-e> <End>
snoremap <C-e> <End>
noremap! <C-d> <Del>
snoremap <C-d> <Del>
noremap! <Esc>f <S-Right>
snoremap <Esc>f <S-Right>
noremap! <Esc>b <S-Left>
snoremap <Esc>b <S-Left>
inoremap <Esc>d <C-o>de
" Degraded map for commandline / select mode
cnoremap <Esc>d <Del>
snoremap <Esc>d <Del>
" Remap <C-d> de-indentation to Alt-t
inoremap <Esc>t <C-d>
" TODO using at end of line causes backspace
inoremap <C-k> <C-o>D
" delimitMate requires below binding
imap <C-h> <BS>
" ** }}}

" Maximizes current split, <C-w>= to restore
nnoremap <C-w>a <C-w>\|<C-w>_

" QuickFix Toggle
nmap <silent> <leader>l :call ToggleList("Location List", 'l')<CR>
nmap <silent> <leader>q :call ToggleList("Quickfix List", 'c')<CR>

" ZenCoding
let g:user_zen_leader_key = '<Esc>y'
if has('gui_running')
    " Workaround for gui meta
    let g:user_zen_expandabbr_key = '<M-y><M-y>'
else
    let g:user_zen_expandabbr_key = '<Esc>y<Esc>y'
endif

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
nmap <Leader>uf :UniteWithBufferDir -buffer-name=files file file/new<CR>
nmap <Leader>Uf :UniteWithCurrentDir -create -no-quit -toggle  -vertical -winwidth=30 -buffer-name=files file file/new<CR>
" レジスタ一覧
nmap <Leader>ur :Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
nmap <Leader>us <Leader>u:file_mru<CR>
nmap <Leader>Us <Leader>U:file_mru -winwidth=80<CR>
" 全部乗せ
nmap <Leader>ua :Unite buffer file_mru bookmark<CR>
" コマンド
nmap <Leader>uc <Leader>u:command<CR>
nmap <Leader>Uc <Leader>U:command -winwidth=80<CR>
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

nmap <Leader>up <Leader>u: git_cached git_untracked<CR>
nmap <Leader>Up <Leader>U: git_cached git_untracked<CR>
" nmap <Leader>up <Leader>u: -buffer-name=files file_rec/async<CR>
" nmap <Leader>Up <Leader>u: -buffer-name=files file_rec/async<CR>

nmap <Leader>ut <Leader>u: tab<CR>
nmap <Leader>Ut <Leader>U: tab<CR>

nmap <Leader>ug <Leader>u: git_modified git_untracked<CR>
nmap <Leader>Ug <Leader>U: git_modified git_untracked<CR>
nmap <Leader>uG <Leader>u: giti<CR>
nmap <Leader>UG <Leader>U: giti<CR>

nmap <Leader>uS <Leader>u: session<CR>
nmap <Leader>US <Leader>U: session<CR>

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

" FIXME
command! -nargs=? SQ call UniteSessionSaveAndQAll(<args>)
function! UniteSessionSaveAndQAll(session)
    execute "UniteSessionSave " + a:session
endfunction
command! -nargs=? SL UniteSessionLoad <args>

nmap <Leader>udp <Leader>u: ref/perldoc<CR>
nmap <Leader>udr <Leader>u: ref/refe<CR>

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

NeoBundle 'maxbrunsfeld/vim-yankstack'
nmap <C-p> <Plug>yankstack_substitute_older_paste
nmap <C-n> <Plug>yankstack_substitute_newer_paste

" deprecates below

" C-[np] after paste, textobj [ai]'"()[]{} , and more, more!!
" NeoBundle 'YankRing.vim'
" let g:yankring_n_keys = 'Y D' " refuse x and X
" let g:yankring_o_keys = 'b B w W e E d y $ G ; iw iW aw aW' " refuse ,
" let g:yankring_manual_clipboard_check = 0
" let g:yankring_max_history = 30
" let g:yankring_max_display = 70
" " Yankの履歴参照
" nmap ,y ;YRShow<CR>


" autocompletes parenthesis, braces and more
NeoBundle 'kana/vim-smartinput'
call smartinput#define_rule({ 'at': '\[\_s*\%#\_s*\]', 'char': '<Enter>', 'input': '<Enter><C-o>O' })
call smartinput#define_rule({ 'at': '{\_s*\%#\_s*}'  , 'char': '<Enter>', 'input': '<Enter><C-o>O' })
call smartinput#define_rule({ 'at': '(\_s*\%#\_s*)'  , 'char': '<Enter>', 'input': '<Enter><C-o>O' })

" smartinput deprecates belows
" NeoBundle 'Raimondi/delimitMate'
" imap <Esc>g <Plug>delimitMateS-Tab
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
NeoBundle 'soh335/vim-ref-jquery'
let g:ref_perldoc_auto_append_f = 1

" git support
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'mattn/gist-vim'

" read/write by sudo with `vim sudo:file.txt`
NeoBundle 'sudo.vim'

" shows syntax error on every save
NeoBundle 'scrooloose/syntastic'
let g:syntastic_mode_map = { 'mode': 'active',
            \ 'active_filetypes' : [],
            \ 'passive_filetypes': [] }
let g:syntastic_error_symbol='E>' " ✗
let g:syntastic_warning_symbol='W>' " ⚠
let g:syntastic_echo_current_error=0 " too heavy, use below one
" show quickfix text of current line on statusline
NeoBundle 'dannyob/quickfixstatus'

" rich-formatted undo history
NeoBundle 'sjl/gundo.vim'
let g:gundo_right = 1
let g:gundo_close_on_revert = 1

" " SnipMate, TextMate like snippet use with <Tab>
" NeoBundle 'garbas/vim-snipmate', { 'depends' : [
" \   'MarcWeber/vim-addon-mw-utils',
" \   'tomtom/tlib_vim',
" \]}
NeoBundle 'honza/snipmate-snippets'

" Run current file by <Leader>r and get result in another buffer
NeoBundle 'thinca/vim-quickrun'

" Highlight indent by its levels, must have for pythonist
NeoBundle 'nathanaelkane/vim-indent-guides'
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1

" Search word with * and # also on Visual Mode
NeoBundle 'thinca/vim-visualstar'

" Move among buffer, quickfix, loclist, ...so many... and encode/decode.
" ]e to exchange line, ]n to go to next SCM conflict marker.
NeoBundle 'tpope/vim-unimpaired'

" Add repeat support to some plugins, like surround.vim
NeoBundle 'tpope/vim-repeat'

" ** }}}

" ** neocomplcache ** {{{2

NeoBundle 'Shougo/neocomplcache'
NeoBundleLazy 'Shougo/neosnippet'
" English spell completion with 'look' command
NeoBundleLazy 'ujihisa/neco-look'
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_prefetch = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_enable_wildcard = 1
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default'    : '',
    \ 'perl'       : $HOME . '/.vim/dict/perl.dict'
    \ }

" too heavy when launching vim, make initializing delayed
augroup InitNeCo
    autocmd!
    autocmd CursorMovedI,CursorHold * call DoInitNeco()
    " Workaround for bug neocon would not be disabled in unite
    autocmd FileType unite call DoInitNeco()
augroup END
function! DoInitNeco()
    echo "Initializing NeCo..."
    augroup InitNeCo
        autocmd!
    augroup END
    NeoBundleSource neosnippet
    NeoBundleSource neco-look
    :NeoComplCacheEnable
    echo "Initializing NeCo... Completed."
endfunction

" ** }}}

" ** unite ** {{{2

NeoBundle 'Shougo/unite.vim'
let g:unite_enable_start_insert=1
let g:unite_split_rule="botright"
let g:unite_winheight="10"

NeoBundle 'tacroe/unite-mark'
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'kmnk/vim-unite-giti.git'
NeoBundle 'Shougo/unite-session'
let g:unite_source_session_options = &sessionoptions

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

" Perl very like /slash braces/
omap i/ <Plug>(textobj-between-i)/
omap a/ <Plug>(textobj-between-a)/
vmap i/ <Plug>(textobj-between-i)/
vmap a/ <Plug>(textobj-between-a)/

" [ai]u / 'this_is_a_word' will be 4 'words in word'
NeoBundle 'vimtaku/textobj-wiw'

" * Almost For Perl * {{{3
" [ai]g / a: includes index/key/arrow, i: symbol only
NeoBundle 'vimtaku/vim-textobj-sigil'
" [ai][kv]
NeoBundle 'vimtaku/vim-textobj-keyvalue'
" [ai]:
NeoBundle 'vimtaku/vim-textobj-doublecolon'
" * }}}

" ** }}}

" ** Misc ** {{{2

" List or Highlight all todo, fixme, xxx comments
NeoBundle 'TaskList.vim'

" Indent comments and expressions
NeoBundle 'godlygeek/tabular'
vnoremap <Leader>t=  :Tab/=<CR>
vnoremap <Leader>th  :Tab/=><CR>
vnoremap <Leader>t#  :Tab/#<CR>
vnoremap <Leader>t\| :Tab/\|<CR>
" JavaScript-style
vnoremap <Leader>t:  :Tab/:<CR>
" YAML-style
vnoremap <Leader>t;  :Tab/:\zs<CR>

" extended % key matching
NeoBundle "tmhedberg/matchit.git"

" moving more far easily
NeoBundle 'Lokaltog/vim-easymotion'

" Smooth <C-{f,b,u,d}> scrolls
" not work with macvim
NeoBundleLazy 'Smooth-Scroll'
if !(has('gui_macvim') && has('gui_running'))
    NeoBundleSource Smooth-Scroll
endif

" Alternative for vimgrep, :Ack and :LAck
NeoBundle 'mileszs/ack.vim'

" :Rename current file on disk
NeoBundle 'danro/rename.vim'

" Bulk renamer
NeoBundle 'renamer.vim'

" Buffer list in bottom of window
" NeoBundle 'buftabs'
" (You can use status line with option
"  or you can expand command line with 'set cmdheight')

" Micro <C-i> and <C-o>
" NeoBundle 'thinca/vim-poslist'
" map <Esc>, <Plug>(poslist-next-pos)
" map <Esc>. <Plug>(poslist-prev-pos)
" imap <Esc>, <C-o><Plug>(poslist-next-pos)
" imap <Esc>. <C-o><Plug>(poslist-prev-pos)

" ** }}}

" ** nerdcommenter ** {{{
" NeoBundle 'scrooloose/nerdcommenter'
" let NERDSpaceDelims = 1
" xmap <Leader>cj <Plug>NERDCommenterToggle
" nmap <Leader>cj <Plug>NERDCommenterToggle
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

NeoBundleLazy 'vimtaku/vim-mlh', { 'depends' : [
\   'mattn/webapi-vim',
\]}
if mlh_enabled
    NeoBundleSource vim-mlh
    autocmd VimEnter * :ToggleVimMlhKeymap
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

" Too hard to setup not-degraded-mode...
" (You should setup your term emulator first)
" So please try it first with degrade=1, then setup if you like it.

NeoBundle 'altercation/vim-colors-solarized'
" let g:solarized_termcolors=256
" let g:solarized_degrade=1
let g:solarized_termcolors=16
let g:solarized_termtrans=1
let g:solarized_bold=1
let g:solarized_underline=1
let g:solarized_italic=1
colorscheme solarized
set background=dark

" ** }}}

" *** }}}

" *** Filetypes *** {{{1

" ** HTML / CSS / XML ** {{{2

" NeoBundle 'mattn/zencoding-vim'
" let g:user_zen_settings = {
" \   'lang': "ja"
" \}
" let g:use_zen_complete_tag = 1

NeoBundleLazy 'othree/html5.vim'
NeoBundleLazy 'hail2u/vim-css3-syntax'
" NeoBundleLazy 'skammer/vim-css-color' " conflicts with html syntax
NeoBundleLazy 'mattn/zencoding-vim'
NeoBundleLazy 'sukima/xmledit'
" see http://nanasi.jp/articles/vim/xml-plugin.html

autocmd BufNew,BufReadPost *.tmpl set filetype=html
function! SourceHTML()
    NeoBundleSource html5.vim
    NeoBundleSource vim-css3-syntax
    " NeoBundleSource vim-css-color
    NeoBundleSource zencoding-vim
    NeoBundleSource xmledit
    autocmd! SourceHTML
endfunction
augroup SourceHTML
    autocmd!
    autocmd FileType html,css,xml call SourceHTML()
augroup END

" haml / sass / scss
NeoBundleLazy 'tpope/vim-haml'

function! SourceHaml()
    NeoBundleSource vim-haml
    autocmd! SourceHaml
endfunction
augroup SourceHaml
    autocmd!
    autocmd FileType haml,sass,scss call SourceHaml()
augroup END

" ** }}}

" ** JavaScript ** {{{2

autocmd BufNewFile,BufRead *.json set filetype=javascript
NeoBundleLazy 'jelera/vim-javascript-syntax'
NeoBundleLazy 'pangloss/vim-javascript' " indent
NeoBundleLazy 'nono/jquery.vim'
NeoBundleLazy 'mklabs/grunt.vim'
" NeoBundleLazy 'wookiehangover/jshint.vim'

function! SourceJavaScript()
    " source order of these plugins is important
    NeoBundleSource vim-javascript-syntax
    NeoBundleSource vim-javascript

    NeoBundleSource jquery.vim
    NeoBundleSource grunt.vim
    " NeoBundleSource jshint.vim
    autocmd! SourceJavaScript
endfunction
augroup SourceJavaScript
    autocmd!
    autocmd FileType javascript call SourceJavaScript()
    autocmd BufNew,BufReadPost *.tmpl call SourceJavaScript()
augroup END

" http://wozozo.hatenablog.com/entry/2012/02/08/121504
map <Leader>FJ !python -m json.tool<CR>

" ** }}}

" ** Perl ** {{{2

" use new perl syntax and indent!
NeoBundleLazy 'vim-perl/vim-perl'
" Enable perl specific rich fold
let perl_fold=1
let perl_fold_blocks=1
" let perl_nofold_packages = 1
" let perl_include_pod=1

NeoBundleLazy 'c9s/perlomni.vim'
NeoBundleLazy 'mattn/perlvalidate-vim'

NeoBundleLazy 'yko/mojo.vim'
let mojo_highlight_data = 1

function! SourcePerl()
    NeoBundleSource vim-perl
    NeoBundleSource perlomni.vim
    NeoBundleSource perlvalidate-vim
    NeoBundleSource mojo.vim
    autocmd! SourcePerl
endfunction
augroup SourcePerl
    autocmd!
    autocmd FileType perl call SourcePerl()
augroup END

augroup PerlKeys
    autocmd!
    autocmd FileType perl inoremap <buffer> <C-l> $
    autocmd FileType perl snoremap <buffer> <C-l> $
augroup END

" Open perl file by package name under the cursor
NeoBundle 'nakatakeshi/jump2pm.vim'
noremap <Leader>pv :call Jump2pm('vne')<CR>
noremap <Leader>pf :call Jump2pm('e')<CR>
noremap <Leader>ps :call Jump2pm('sp')<CR>
noremap <Leader>pt :call Jump2pm('tabe')<CR>
vnoremap <Leader>pv :call Jump2pmV('vne')<CR>
vnoremap <Leader>pf :call Jump2pmV('e')<CR>
vnoremap <Leader>ps :call Jump2pmV('sp')<CR>
vnoremap <Leader>pt :call Jump2pmV('tabe')<CR>

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
NeoBundleLazy 'tmhedberg/SimpylFold'
NeoBundleLazy 'davidhalter/jedi-vim'
function! SourcePython()
    NeoBundleSource SimpylFold
    NeoBundleSource jedi-vim
    autocmd! SourcePython
endfunction
augroup SourcePython
    autocmd!
    autocmd FileType python call SourcePython()
augroup END
" ** }}}

" ** VimScript ** {{{

" vim-ref alternative for .vimrc and VimScripts
autocmd! FileType vim,help call MapVimHelp()
function! MapVimHelp()
    nmap <buffer> K :help <C-r><C-w><CR>
    vmap <buffer> K :<C-u>help <C-r>=GetVisualText()<CR><CR>
endfunction
function! GetVisualText()
    return getline("'<")[getpos("'<")[2]-1:getpos("'>")[2]-1]
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
    autocmd! DelayedExecutor
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

augroup FoldRenewer
    autocmd!

    " VimEnter: for delayed stashing
    " WinEnter: because foldmethod is window-specific
    autocmd VimEnter,WinEnter * call FoldRenewerInit()

    " open fold under the cursor after re-generating folds
    " Recalculate only on saving buffer to reduce freeze
    autocmd BufWritePost * call RestoreFoldMethod() | call StashFoldMethod()

    " workaround for buffer change from outside of current window,
    " like gundo plugin and multi split of single file
    autocmd WinLeave * call StashFoldMethod()
augroup END

" Initialize on current window
function! FoldRenewerInit()
    if !exists('w:fold_renewer_init_done')
        " Set original fdm after splitting window
        if exists('b:orig_fdm')
            let &l:foldmethod=b:orig_fdm
        endif
        let w:fold_renewer_init_done = 1
        " Delay for permit other plugins to initialize
        " FIXME: this autocmd should be WINDOW SPECIFIC
        augroup DelayedStashFoldMethod
            autocmd!
            " CursorMoved: called at start of editting, after ready to edit
            autocmd CursorMoved,CursorMovedI * call StashFoldMethod()
        augroup END
    endif
endfunction

" Let foldmethod calculate folds
function! RestoreFoldMethod()
    if &filetype == 'ref-perldoc'
        " black list
        setlocal foldmethod=manual
        return
    endif
    if exists('w:last_fdm')
        if &foldmethod == 'manual'
            let &l:foldmethod=w:last_fdm
            " open folds under the cursor
            execute "normal" "zv"
        endif
        unlet w:last_fdm
    endif
endfunction

" Preserve foldmethod and set it to 'manual'
function! StashFoldMethod()
    if !exists('w:last_fdm') && (&foldmethod == 'expr' || &foldmethod == 'syntax')
        let b:orig_fdm=&foldmethod
        let w:last_fdm=&foldmethod
        setlocal foldmethod=manual
    endif
    autocmd! DelayedStashFoldMethod
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

NeoBundle 'taku-o/vim-copypath'
let g:copypath_copy_to_unnamed_register = 1

NeoBundle 'kana/vim-altr'
nmap ]r <Plug>(altr-forward)
nmap [r <Plug>(altr-back)

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

if has('mac') && !has('gui_running')
    nnoremap <silent> <Space>y :.w !pbcopy<CR><CR>
    vnoremap <silent> <Space>y :w !pbcopy<CR><CR>
    nnoremap <silent> <Space>p :r !pbpaste<CR>
    vnoremap <silent> <Space>p :r !pbpaste<CR>
endif

map <Leader>tl <Plug>TaskList

NeoBundle 'tpope/vim-abolish'

" TweetVim
NeoBundleLazy 'basyura/TweetVim', { 'depends' : [
\   'basyura/twibill.vim',
\   'basyura/bitly.vim',
\   'mattn/webapi-vim',
\   'tyru/open-browser.vim',
\]}
command! TweetVimLoad call InitTweetVim()
function! InitTweetVim()
    NeoBundleSource TweetVim
endfunction

" NeoBundle 'fuzzyjump.vim'
" use H / M / L motion instead

" NeoBundle 'mikewest/vimroom'

NeoBundle 'Lokaltog/vim-powerline'
if has('gui_macvim') && has('gui_running')
    let g:Powerline_symbols = 'fancy'
else
    let g:Powerline_symbols = 'unicode'
endif

" set scrolljump=3

NeoBundle 'rson/vim-conque'
NeoBundle 'Shougo/vimshell'

" until unite being fast
NeoBundle 'kien/ctrlp.vim'
let g:ctrlp_map = '<Leader><C-p>'
let g:ctrlp_max_files = 0
nmap <Leader><C-q> :CtrlPQuickfix<CR>
nmap <Leader><C-m> :CtrlPMRU<CR>
nmap <Leader><C-c> :CtrlPChangeAll<CR>
nmap <Leader><C-l> :CtrlPLine<CR>
nmap <Leader><C-t> :CtrlPTag<CR>

" nmap <Esc>; A;<Esc><Plug>(poslist-prev-pos)
" imap <Esc>; <C-o><Esc>;

" http://stackoverflow.com/questions/7187477/vim-smart-insert-semicolon
vmap <Esc>; :normal A;<Esc><CR>
nmap <Esc>; :call Semicolonfun(';')<CR>
imap <Esc>; <C-R>=Semicolonfun(';')<CR>
vmap <Esc>, :normal A,<Esc><CR>
nmap <Esc>, :call Semicolonfun(',')<CR>
imap <Esc>, <C-R>=Semicolonfun(',')<CR>
function! Semicolonfun(char)
  call setline(line('.'), substitute(getline('.'), '\s*$', a:char, ''))
endfunction

NeoBundle 'thinca/vim-scouter'

NeoBundle 'kana/vim-operator-user'
NeoBundle 'tyru/operator-camelize.vim'
map <Leader>L <Plug>(operator-camelize-toggle)
map <Leader>_L <Plug>(operator-upper-camelize)
let g:operator_camelize_word_case = "lower"

" NeoBundle 'chikatoike/activefix.vim'

let g:gist_open_browser_after_post = 1

NeoBundle 'mbbill/fencview'

command! Uall :bufdo :update

" NeoBundle 'ZoomWin'

let g:ConqueTerm_ReadUnfocused = 1

" NeoBundle 'majutsushi/tagbar'
" nmap <Leader>tb :TagbarToggle<CR>
" let g:tagbar_ctags_bin = '~/homebrew/bin/ctags'

NeoBundleLazy 'joonty/vdebug'
NeoBundle 'ypresto/vdebug', { 'directory' : 'my_vdebug' }

" autocmd VimEnter * let g:vdebug_options['exec_perl']   = $HOME.'/dotfiles/bin/komodo-perl.sh %s'
" autocmd VimEnter * let g:vdebug_options['exec_python'] = $HOME.'/dotfiles/bin/komodo-python.sh %s'
" autocmd VimEnter * let g:vdebug_options['exec_ruby']   = $HOME.'/dotfiles/bin/komodo-ruby.sh %s'
autocmd VimEnter * let g:vdebug_options['command_perl']   = ':call OpenDebugTerminal("'.$HOME.'/dotfiles/bin/komodo-perl.sh %s")'
autocmd VimEnter * let g:vdebug_options['command_python'] = ':call OpenDebugTerminal("'.$HOME.'/dotfiles/bin/komodo-python.sh %s")'
autocmd VimEnter * let g:vdebug_options['command_ruby']   = ':call OpenDebugTerminal("'.$HOME.'/dotfiles/bin/komodo-ruby.sh %s")'

let s:debug_terminal = 0
function! OpenDebugTerminal(cmd)
    if !has('gui_running') && $TMUX
        call VimuxRunCommand(a:cmd)
    else
        if !s:debug_terminal
            let s:debug_terminal = conque_term#open(a:cmd)
        else
            call s:debug_terminal.writeln(a:cmd)
        endif
    endif
endfunction
let g:ConqueTerm_InsertOnEnter = 0

let g:ruby_debugger_progname = 'mvim'

NeoBundleLazy 'tell-k/vim-browsereload-mac'
NeoBundleLazy 'lordm/vim-browser-reload-linux'
if has('mac')
    NeoBundleSource vim-browsereload-mac
elseif has('linux')
    NeoBundleSource vim-browser-reload-linux
endif

" NeoBundle 'AndrewRadev/splitjoin.vim'
" nmap <Esc>i      :SplitjoinJoin<cr>
" imap <Esc>i <C-o>:SplitjoinJoin<cr>
" smap <Esc>i      :SplitjoinJoin<cr>
" nmap <Esc>p      :SplitjoinSplit<cr>
" imap <Esc>p <C-o>:SplitjoinSplit<cr>
" smap <Esc>p      :SplitjoinSplit<cr>

NeoBundleLazy 'reinh/vim-makegreen'
NeoBundleLazy 'sontek/rope-vim'
augroup SourcePython
    autocmd FileType python NeoBundleSource vim-makegreen
    autocmd FileType python NeoBundleSource rope-vim | nmap <Leader>mg <Plug>MakeGreen
augroup END

NeoBundleLazy 'vim-ruby/vim-ruby'
NeoBundleLazy 'ecomba/vim-ruby-refactoring'
augroup SourceRuby
    autocmd FileType ruby NeoBundleSource vim-ruby
    autocmd FileType ruby NeoBundleSource vim-ruby-refactoring
augroup END

NeoBundle 'mattn/qiita-vim'

NeoBundleLazy 'dbext.vim'
" do end matchit (%)
NeoBundle 'semmons99/vim-ruby-matchit'
" NeoBundle 'vim-rsense'
NeoBundle 'tpope/vim-endwise'
" To avoid conflict with neocomplcache; refer :help neocomplcache-faq
autocmd VimEnter * imap <silent> <CR> <C-r>=neocomplcache#smart_close_popup()<CR><Plug>my_cr_function_smartinput
call smartinput#map_to_trigger('i', '<Plug>my_cr_function_smartinput', '<Enter>', '<CR>')
NeoBundleLazy 'taichouchou2/vim-rsense'

NeoBundle 'tpope/vim-commentary'
NeoBundle 'taka84u9/unite-git'

NeoBundle 'thinca/vim-prettyprint'

" speedup ctrlp
" https://twitter.com/ltw_/status/248097120140271616
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files --exclude-standard']

NeoBundle 'benmills/vimux'

let g:ConqueTerm_TERM = 'xterm-256color'

nmap <expr><TAB> neosnippet#expandable() ?
 \ "i<TAB>"
 \: pumvisible() ? "\<C-n>" : "\<TAB>"
" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable() ?
 \ "\<Plug>(neosnippet_expand_or_jump)"
 \: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable() ?
 \ "\<Plug>(neosnippet_expand_or_jump)"
 \: "\<TAB>"
imap <Esc>s i_<Plug>(neosnippet_start_unite_snippet)

" ** vimrc reading @ 2012/11/03 {{{
    " https://github.com/cpfaff/vim-my-setup/blob/master/vimrc
    set lazyredraw
    set spelllang=en
    nnoremap U <C-r>
    " Move lines up and down (bubbling) left and right (indent)
    nmap <Esc>K [e
    nmap <Esc>J ]e,
    vmap <Esc>K [egv
    vmap <Esc>J ]egv
    nnoremap <Esc>L >>
    nnoremap <Esc>H <<
    vnoremap <Esc>L >gv
    vnoremap <Esc>H <gv

   " Small helper
    function! CmdLine(str)
       exe "menu Foo.Bar :" . a:str
       emenu Foo.Bar
       unmenu Foo
    endfunction
   "

" ** }}}

" ** vimrc reading @ 2012/11/10 {{{

" https://github.com/kazuph/dotfiles/blob/master/_vimrc

set grepprg=ack\ -a

NeoBundle 'bkad/CamelCaseMotion'

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
" autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

let g:neocomplcache_min_syntax_length = 2
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" =と押して = となるようにする他
NeoBundle "kana/vim-smartchr"
" inoremap <expr> = smartchr#one_of(' = ', ' == ', ' === ', '=', '==')
inoremap <expr> > smartchr#one_of('>', ' => ', '>>', '>>>')
" inoremap <expr> < smartchr#one_of(' < ', '<', '<<')
inoremap <expr> - smartchr#one_of('-',  '->', '--', '---')
inoremap <expr> , smartchr#one_of(',', ' => ')

set autoread
set modelines=0
set display=uhex

nnoremap 0 ^
nnoremap 9 $

" visualmodeでインテントを＞＜の連打で変更できるようにする
vnoremap < <gv
vnoremap > >gv

" OSのクリップボードを使用する
" set clipboard+=unnamed

nnoremap / /\V
nnoremap ? ?\V
NeoBundle 'othree/eregex.vim'

" ** }}}

" http://mattn.kaoriya.net/software/vim/20121105111112.htm
NeoBundle 'mattn/multi-vim'

NeoBundle 'rhysd/accelerated-jk'
nmap j <Plug>(accelerated_jk_gj)
nmap k <Plug>(accelerated_jk_gk)
let g:accelerated_jk_anable_deceleration = 1
" let g:accelerated_jk_acceleration_table = [10,7,5,4,3,2,2,2]
let g:accelerated_jk_acceleration_table = [10,20,15,15]

NeoBundle 'rhysd/vim-textobj-ruby' " [ai]r
" g:textobj_ruby_more_mappings = 1 " ro rl rc rd rr

NeoBundle 'sgur/unite-qf'
NeoBundle 'osyo-manga/unite-quickfix'
nmap <Leader>uq <Leader>u: qf<CR>
nmap <Leader>Uq <Leader>U: qf<CR>
nmap <Leader>uQ <Leader>u: quickfix<CR>
nmap <Leader>UQ <Leader>U: quickfix<CR>

" *** }}}

" *** Debug *** {{{1

" Refer: http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
command! CurHl :echo
    \ "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
    \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
    \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"

NeoBundleLazy 'mattn/benchvimrc-vim'

" *** }}}

" *** GUI Specific *** {{{1

NeoBundleLazy 'thinca/vim-fontzoom'

if has('gui_running')
    if has('gui_macvim')
        set macmeta " Use alt as meta on MacVim like on terminal
        set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h12
        " set guifontwide=
        set transparency=10
        set fuoptions=maxvert,maxhorz
        NeoBundleSource 'thinca/vim-fontzoom'
    elseif has('gui_gtk2')
        set guioptions-=m " to avoid menu accelerator being bound
        set guifont="DejaVu Sans Mono 10"
        " set guifontwide=
        set guioptions+=c " no dialog / buggy on mac
    endif
    set guicursor=a:block,a:blinkon0,i:ver10
    set guioptions-=T " no toolbar
endif

" ** Meta+Key to ESC and Key Mapping ** {{{2

" Fix meta-keys to MAKE SURE to generate <Esc>a .. <Esc>z
" This is almost for gvim which does not translate meta to esc
" refer: http://vim.wikia.com/wiki/Fix_meta-keys_that_break_out_of_Insert_mode
let nr=0x21 " ASCII Space
while nr <= 0x7E
    let c = nr2char(nr)
    if c == '|' | let nr += 1 | continue | endif
    exec "map <M-".tolower(c)."> <Esc>".tolower(c)
    exec "map! <M-".tolower(c)."> <Esc>".tolower(c)
    if (0x41 <= nr && nr <= 0x5A) || (0x61 <= nr && nr <= 0x7A)
        " ascii; uppercases are required for at least on linux
        exec "map <M-".toupper(c)."> <Esc>".toupper(c)
        exec "map! <M-".toupper(c)."> <Esc>".toupper(c)
    endif
    let nr += 1
endwhile
" and space, keep from <M-<Space>> :)
map <M-Space> <Esc><Space>
map! <M-Space> <Esc><Space>

" ** }}}

" *** }}}

" *** Local Script *** {{{1
" You can put on '~/.vimlocal/*' anything you don't want to publish.
set rtp+=~/.vimlocal
if filereadable(expand('~/.vimlocal/.vimrc'))
    source $HOME/.vimlocal/.vimrc
endif
" *** }}}

" *** Enable Filetype Plugins *** {{{1
" for neobundle, these are disabled in start up section
filetype plugin indent on " XXX maybe better to disable this, testing
" for speedup
syntax on " for os x
" *** }}}

" vim:set foldmethod=marker:
