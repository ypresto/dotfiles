" **
" * .vimrc for yuya_presto
" *
" * Please checkout 'Plugins' section for recommended plugins.
" *

set nocompatible
let mapleader=" "

" *** Make This Reloadable *** {{{1
" reset global autocmd
augroup VimrcGlobal
    autocmd!
    " reload when writing .vimrc
    autocmd BufWritePost $MYVIMRC,$HOME/dotfiles/.vimrc source $MYVIMRC |
                \ if (has('gui_running') && filereadable($MYGVIMRC)) | source $MYGVIMRC
    " TODO: should :colorscheme manually and fire ColorScheme autocmd
    autocmd BufWritePost $MYGVIMRC,$HOME/dotfiles/.gvimrc if has('gui_running') | source $MYGVIMRC
augroup END
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
endif
call neobundle#rc(expand('~/.vim/bundle'))
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

set helplang=ja

set encoding=utf-8
set fileencodings=iso-2022-jp-3,iso-2022-jp,euc-jisx0213,euc-jp,utf-8,ucs-bom,euc-jp,eucjp-ms,cp932
set fileformats=unix,dos,mac
autocmd VimrcGlobal BufReadPost *
\   if &modifiable && !search('[^\x00-\x7F]', 'cnw')
\ |   setlocal fileencoding=
\ | endif

" ** }}}

" ** Indent / Tab ** {{{2

set tabstop=8     " <Tab>s are shown with this num of <Space>s
set softtabstop=4 " Use this num of spaces as <Tab> on insert and delete
set shiftwidth=4  " Use this num of spaces for auto indent
set shiftround    " round indent with < and >
set expandtab     " Always use <Tab> for indent and insert
set smarttab      " Use shiftwidth on beginning of line when <Tab> key
set autoindent    " Use same indent level on next line
set smartindent   " Auto indent for C-like code with '{...}' blocks
set shiftround    " Round indent when < or > is used

" * Filetype specific indent * {{{

augroup VimrcGlobal
    " Force using <Tab>, not <Space>s
    autocmd FileType make setlocal softtabstop=8 shiftwidth=8 noexpandtab
    " 2-space indent
    autocmd FileType
        \ html,scss,javascript,json,ruby,tex,xml
        \ setlocal shiftwidth=2 softtabstop=2 nosmartindent
    autocmd FileType python     setlocal nosmartindent
    " Use smarter auto indent for C-languages
    autocmd FileType c,cpp,java setlocal cindent
augroup END

" * }}}

" ** }}}

" ** Undo / Backup / History / Session ** {{{2

if has('persistent_undo')
    set undofile            " Save undo history to file
    set undodir=~/.vim/undo " Specify where to save
endif
set nobackup            " Don't create backup files (foobar~)

" reffer: http://vimwiki.net/?'viminfo'
set history=1000
set viminfo='1000,<800,s300,\"1000,f1,:1000,/1000

" Jump to the last known cursos position when opening file
" Refer: :help last-position-jump
" 'zv' and 'zz' was added by ypresto
autocmd VimrcGlobal BufReadPost * call s:MoveToLastPosition()

function! s:MoveToLastPosition()
    if line("'\"") > 1 && line("'\"") <= line("$")
        exe "normal! g`\""
    endif
    " open fold under cursor
    execute "normal! zv"
    " Move current line on center of window
    execute "normal! zz"
endfunction

set sessionoptions-=options

" ** }}}

" ** Editing / Search ** {{{2

" Editing
set backspace=indent,eol,start " go to previous line with backspace
set whichwrap+=h,l             " 行をまたいでカーソル移動
set textwidth=0                " don't insert break automatically

set foldmethod=marker " Use '{{{' and '}}}' for marker
set foldlevelstart=1  " Start with some folds closed
set foldcolumn=2
set noeb vb t_vb=     " no beep
set scrolloff=1       " show N more next line when scrolling

" Complete
set complete=.,w,b,u,U,s,i,d,t
set completeopt=menu,menuone
set pumheight=10

" Format
" 自動整形の実行方法 (see also :help fo-table)
set formatoptions&
set formatoptions-=o
set formatoptions+=ctrqlmM

" Long line wrapping
set linebreak
let &showbreak='»'
let &breakat=' ;:,!?.>'

" Search
set incsearch         " Use 'incremental search'
set hlsearch          " Highlight search result
set ignorecase        " Ignore case when searching
set smartcase         " Do not ignorecase if keyword contains uppercase
set infercase         " Ignore case on insert completion.

" Misc
set nrformats-=octal  " <c-a> や <c-x> で数値を増減させるときに8進数を無効にする

" ** }}}

" ** Status Line / Command Line** {{{2

" status line and line number
set number            " Show number of line on left
set showcmd           " Show what keys input for command, but too slow on terminal
set laststatus=2      " Always show statusline

" command line
set cmdheight=2                " Set height of command line
set wildmode=longest:full,full " command line completion order
set wildmenu                   " Enhanced completion
" Don't use matched files for completion
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*.so,*.swp,*.swo

" ** }}}

" ** Highlighting ** {{{2

set cursorline              " Highlight current line
if exists("+colorcolumn")
    set colorcolumn=73,74,81,82 " Highlight border of 'long line'
endif
set list                    " highlight garbage characters (see below)
set listchars=tab:»-,trail:\ ,extends:»,precedes:«,nbsp:%

function! s:HighlightSetup()
    " Change highlight color of current line
    highlight clear CursorLine
    highlight CursorLine ctermbg=black guibg=black
    highlight SignColumn ctermfg=white ctermbg=black cterm=none

    highlight SpecialKey   ctermbg=darkyellow guibg=darkyellow
    highlight ZenkakuSpace ctermbg=darkgray   guibg=darkgray
endfunction

augroup VimrcGlobal
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

set isfname-=%,$,@,= " filename characters for gf
let &fillchars='vert: ,fold: ,diff: '
set shortmess+=I      " Surpress intro message when starting vim

" enforce to use curl over links for http urls
let g:netrw_http_cmd = 'curl -L'
let g:netrw_http_xcmd = '-o'

" ** }}}

" *** }}}

" *** Keymapping *** {{{1

if has('gui_running')
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

" Fast saving
noremap ZJ :update<CR>
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
inoremap <C-k> <C-o>D
" ** }}}

" Move lines up and down (bubbling) left and right (indent)
nmap <Esc>K [e
nmap <Esc>J ]e,
vmap <Esc>K [egv
vmap <Esc>J ]egv
nnoremap <Esc>L >>
nnoremap <Esc>H <<
vnoremap <Esc>L >gv
vnoremap <Esc>H <gv
" visualmodeでインテントを＞＜の連打で変更できるようにする
vnoremap < <gv
vnoremap > >gv

" http://stackoverflow.com/questions/7187477/vim-smart-insert-semicolon
vmap <Esc>; :normal A;<Esc><CR>
nmap <Esc>; :call AppendSemicolon(';')<CR>
imap <Esc>; <C-R>=AppendSemicolon(';')<CR>
vmap <Esc>, :normal A,<Esc><CR>
nmap <Esc>, :call AppendSemicolon(',')<CR>
imap <Esc>, <C-R>=AppendSemicolon(',')<CR>
vmap <Esc>: :normal A:<Esc><CR>
nmap <Esc>: :call AppendSemicolon(':')<CR>
imap <Esc>: <C-R>=AppendSemicolon(':')<CR>
function! AppendSemicolon(char)
  call setline(line('.'), substitute(getline('.'), '\s*$', a:char, ''))
  return ''
endfunction

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
nnoremap <Leader>G :GundoToggle<CR>

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
" 補完候補が表示されている場合は確定。そうでない場合は改行
imap <expr> <C-j>  pumvisible() ? neocomplete#close_popup() : "\<CR>"

" ** }}}

" ** unite ** {{{2

nnoremap <Leader>u: :<C-u>Unite<Space>
nmap <Leader>ub <Leader>u:buffer<CR>
nmap <Leader>uf :UniteWithBufferDir -buffer-name=files file file/new<CR>
nmap <Leader>ur <Leader>u:-buffer-name=register register<CR>
nmap <Leader>us <Leader>u:file_mru<CR>
nmap <Leader>ua :Unite buffer file_mru bookmark<CR>
nmap <Leader>uc <Leader>u:command<CR>
nmap <Leader>um <Leader>u:mark<CR>
nmap <Leader>uo <Leader>u:outline<CR>
nmap <Leader>uz <Leader>u:outline:folding<CR>
nmap <Leader>uC <Leader>u:history/command<CR>
nmap <Leader>ut <Leader>u:tab<CR>
nmap <Leader>up <Leader>u:git_cached git_untracked<CR>
nmap <Leader>ug <Leader>u:git_modified git_untracked<CR>
nmap <Leader>uG <Leader>u:giti<CR>
nmap <Leader>uS <Leader>u:session<CR>
nmap <Leader>uh <Leader>u:help<CR>
nmap <Leader>uu <Leader>u:source<CR>
nmap <Leader>udp <Leader>u:ref/perldoc<CR>
nmap <Leader>udr <Leader>u:ref/refe<CR>
nnoremap <silent> <Leader>u<space> :<C-u>UniteResume<CR>

augroup VimrcGlobal
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

" ** }}}

" *** }}}

" *** Plugins *** {{{1

" ** Recommended: YOU SHOULD USE THESE AND BE IMproved! *** {{{2

NeoBundle 'maxbrunsfeld/vim-yankstack'
nmap <C-p> <Plug>yankstack_substitute_older_paste
nmap <C-n> <Plug>yankstack_substitute_newer_paste

" autocompletes parenthesis, braces and more
NeoBundle 'kana/vim-smartinput'
"call smartinput#define_rule({ 'at': '\[\_s*\%#\_s*\]', 'char': '<Enter>', 'input': '<Enter><C-o>O' })
"call smartinput#define_rule({ 'at': '{\_s*\%#\_s*}'  , 'char': '<Enter>', 'input': '<Enter><C-o>O' })
"call smartinput#define_rule({ 'at': '(\_s*\%#\_s*)'  , 'char': '<Enter>', 'input': '<Enter><C-o>O' })
" To avoid conflict with neocomplcache; refer :help neocomplcache-faq
autocmd VimrcGlobal VimEnter * call s:SetupCRMapping()
function! s:SetupCRMapping()
    if s:is_neocomplete_available
        execute printf('imap <silent> <CR> <C-r>=%ssmart_close_popup()<CR><Plug>my_cr_function_smartinput', s:neocompl_function_prefix)
    endif
    call smartinput#map_to_trigger('i', '<Plug>my_cr_function_smartinput', '<Enter>', '<CR>')
endfunction

" surrounding with braces or quotes with s and S key
NeoBundle 'tpope/vim-surround'

" open reference manual with K key
NeoBundle 'thinca/vim-ref'
NeoBundle 'soh335/vim-ref-jquery'
let g:ref_perldoc_auto_append_f = 1

" git support
NeoBundle 'tpope/vim-fugitive', { 'augroup' : 'fugitive' }
NeoBundle 'mattn/gist-vim', {
\   'depends' : [
\       'mattn/webapi-vim',
\   ],
\}

" show marker on edited lines
NeoBundle 'airblade/vim-gitgutter'
let g:gitgutter_sign_removed = "-"
map ]g :GitGutterNextHunk<CR>
map [g :GitGutterPrevHunk<CR>

" read/write by sudo with `vim sudo:file.txt`
NeoBundle 'sudo.vim'

" shows syntax error on every save
NeoBundle 'scrooloose/syntastic'
let g:syntastic_mode_map = {
\   'mode': 'active',
\   'active_filetypes' : [],
\   'passive_filetypes': ['java']
\}
let g:syntastic_error_symbol='E>' " ✗
let g:syntastic_warning_symbol='W>' " ⚠
let g:syntastic_always_populate_loc_list=1
let g:syntastic_perl_checkers = ['perl', 'perlcritic', 'podchecker']
let g:syntastic_perl_perlcritic_thres = 4
nmap <Leader>s :SyntasticCheck<CR>

" rich-formatted undo history
NeoBundle 'sjl/gundo.vim'
let g:gundo_right = 1
let g:gundo_close_on_revert = 1

" Run current file by <Leader>r and get result in another buffer
NeoBundle 'thinca/vim-quickrun', {
\   'depends' : [
\      'tyru/open-browser.vim',
\   ]
\}
let g:quickrun_config = {}
let g:quickrun_config._ = {
\   'runner' : 'vimproc',
\   'runner/vimproc/updatetime' : '500',
\}

let g:quickrun_config.perl = {'command': 'prove'}

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

" Speedup j and k key
NeoBundle 'rhysd/accelerated-jk'
nmap j <Plug>(accelerated_jk_gj)
nmap k <Plug>(accelerated_jk_gk)
let g:accelerated_jk_anable_deceleration = 1
let g:accelerated_jk_acceleration_table = [10,20,15,15]

NeoBundle 'bling/vim-airline'
" patch airline solarized theme, make blue
let g:airline_theme_patch_func = 'AirlineThemePatch'
function! AirlineThemePatch(palette)
    if g:airline_theme == 'solarized'
        let background  = get(g:, 'airline_solarized_bg', &background)
        let ansi_colors = get(g:, 'solarized_termcolors', 16) != 256 && &t_Co >= 16 ? 1 : 0
        let tty         = &t_Co == 8

        let violet  = {'t': ansi_colors ?  13 : (tty ? '5' : 61 ), 'g': '#6c71c4'}
        let blue    = {'t': ansi_colors ?   4 : (tty ? '4' : 33 ), 'g': '#268bd2'}
        let cyan    = {'t': ansi_colors ?   6 : (tty ? '6' : 37 ), 'g': '#2aa198'}
        let green   = {'t': ansi_colors ?   2 : (tty ? '2' : 64 ), 'g': '#859900'}
        let normal_color = violet

        let a:palette.normal.airline_a[1] = normal_color.g
        let a:palette.normal.airline_a[3] = normal_color.t
        let a:palette.normal.airline_z[1] = normal_color.g
        let a:palette.normal.airline_z[3] = normal_color.t
    endif
endfunction

let g:airline_mode_map = {
\   '__' : '-',
\   'n'  : 'N',
\   'i'  : 'I',
\   'R'  : 'R',
\   'c'  : 'C',
\   'v'  : 'V',
\   'V'  : 'L',
\   '' : 'B',
\   's'  : 'S',
\   'S'  : 'S',
\   '' : 'S',
\}

" let g:airline_powerline_fonts = 1

" Fast file selector
NeoBundle 'kien/ctrlp.vim'
let g:ctrlp_map = '<Leader><C-p>'
let g:ctrlp_max_files = 0
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files --cached --others --exclude-standard'] " speedup
nmap <Leader><C-q> :CtrlPQuickfix<CR>
nmap <Leader><C-m> :CtrlPMRU<CR>
nmap <Leader><C-c> :CtrlPChangeAll<CR>
nmap <Leader><C-l> :CtrlPLine<CR>
nmap <Leader><C-t> :CtrlPTag<CR>

" Indent comments and expressions
NeoBundle 'godlygeek/tabular'
vnoremap <Leader>t=  :Tabular /=/<CR>
vnoremap <Leader>th  :Tabular /=>/<CR>
vnoremap <Leader>t#  :Tabular /#/<CR>
vnoremap <Leader>t\| :Tabular /\|/<CR>
" JavaScript-style
vnoremap <Leader>t:  :Tabular /:/<CR>
" YAML-style
vnoremap <Leader>t;  :Tabular/:\zs/<CR>
vnoremap <Leader>t,  :Tabular/,\zs/<CR>
" Vim
vnoremap <Leader>t"  :Tabular/"/<CR>

vnoremap <Leader>t<Space> :Tabular multiple_spaces<CR>

" Move between buffers, diff hunks, etc places with bracket keys
NeoBundle 'tpope/vim-abolish'

" Paste with textobj, use this instead of vi"p
NeoBundle 'kana/vim-operator-replace', {
\   'depends' : [
\       'kana/vim-operator-user',
\   ]
\}
nmap R <Plug>(operator-replace)

" :grep by ag
NeoBundle 'rking/ag.vim'

" ** }}}

" ** neocomplcache ** {{{2

if has('lua')
    NeoBundleLazy 'Shougo/neocomplete', {
    \   'autoload' : {
    \       'insert' : 1
    \   }
    \}
    let s:is_neocomplete_available = 1
    let s:neocompl_config_prefix   = 'neocomplete#'
    let s:neocompl_function_prefix = 'neocomplete#'
else
    NeoBundleLazy 'Shougo/neocomplcache', {
    \   'autoload' : {
    \       'insert' : 1
    \   }
    \}
    let s:is_neocomplete_available = 0
    let s:neocompl_config_prefix   = 'neocomplcache_'
    let s:neocompl_function_prefix = 'neocomplcache#'
endif
NeoBundle 'Shougo/neosnippet'
NeoBundle 'honza/vim-snippets'
" English spell completion with 'look' command
NeoBundle 'ujihisa/neco-look'

let s:neocompl_options = {
\   'enable_at_startup'             : 1,
\   'enable_prefetch'               : 1,
\   'enable_fuzzy_completion'       : 1,
\   'fuzzy_completion_start_length' : 3,
\   'enable_auto_delimiter'         : 1,
\   'enable_refresh_always'         : 1,
\   'max_list'                      : 100,
\   'source_disable' : {
\       'tags_complete' : 1,
\   },
\   'dictionary_filetype_lists' : {
\       'default'    : '',
\       'perl'       : $HOME . '/.vim/dict/perl.dict'
\   },
\}

for s:k in keys(s:neocompl_options)
    execute printf('let g:%s%s = s:neocompl_options[s:k]', s:neocompl_config_prefix, s:k)
endfor

" ** }}}

" ** unite ** {{{2

" Cannot make it lazy: vim path/to/file.txt doesn't update file_mru list
NeoBundle 'Shougo/unite.vim', {
\   'autoload' : {
\       'commands' : ['Unite', 'UniteSessionLoad', 'UniteSessionSave']
\   }
\}
let g:unite_enable_start_insert=1
let g:unite_split_rule="botright"
let g:unite_winheight="10"

NeoBundle 'kmnk/vim-unite-giti.git'
NeoBundle 'Shougo/unite-session'
NeoBundleLazy 'tacroe/unite-mark',    { 'autoload' : { 'unite_sources' : ['mark'] } }
NeoBundleLazy 'Shougo/unite-outline', { 'autoload' : { 'unite_sources' : ['outline', 'outline:folding'] } }
NeoBundleLazy 'taka84u9/unite-git',   { 'autoload' : { 'unite_sources' : ['git_untracked', 'git_cached', 'git_modified'] } }
NeoBundleLazy 'tsukkee/unite-help',   { 'autoload' : { 'unite_sources' : ['help'] } }
let g:unite_source_session_options = &sessionoptions

" ** }}}

" ** textobj ** {{{2

" select range of text with only two or three keys
" For example: [ai]w
" @see http://d.hatena.ne.jp/osyo-manga/20130717/1374069987

NeoBundle 'kana/vim-textobj-user'            " framework for all belows
NeoBundle 'kana/vim-textobj-entire'          " [ai]e
NeoBundle 'kana/vim-textobj-fold'            " [ai]z
NeoBundle 'kana/vim-textobj-function'        " [ai]f
NeoBundle 'kana/vim-textobj-indent'          " [ai][iI]
NeoBundle 'kana/vim-textobj-syntax'          " [ai]y
NeoBundle 'kana/vim-textobj-line'            " [ai]l
NeoBundle 'vimtaku/vim-textobj-sigil'        " [ai]g / a: includes index/key/arrow, i: symbol only
NeoBundle 'vimtaku/vim-textobj-keyvalue'     " [ai][kv]
NeoBundle 'vimtaku/vim-textobj-doublecolon'  " [ai]:
NeoBundle 'thinca/vim-textobj-comment'       " [ai]c
NeoBundle 'deris/vim-textobj-enclosedsyntax' " [ai]q / perl/ruby regex and literal, eruby

NeoBundle 'thinca/vim-textobj-function-javascript'
NeoBundle 'thinca/vim-textobj-function-perl'

" function: [ai]f / class: [ai]c
NeoBundle 'bps/vim-textobj-python'
function! s:MapTextobjPython()
    omap <silent><buffer> iC <Plug>(textobj-python-class-i)
    omap <silent><buffer> aC <Plug>(textobj-python-class-a)
    vmap <silent><buffer> iC <Plug>(textobj-python-class-i)
    vmap <silent><buffer> aC <Plug>(textobj-python-class-a)
endfunction
autocmd VimrcGlobal FileType python call s:MapTextobjPython()

" [ai]u / under_bar or CamelCase
" Also provides motions: ,[wbe]
" (default: [ai],[bew])
NeoBundle 'bkad/CamelCaseMotion'
omap <silent> iu <Plug>CamelCaseMotion_iw
xmap <silent> iu <Plug>CamelCaseMotion_iw
omap <silent> <Plug>disabled_CamelCaseMotion_ib <Plug>CamelCaseMotion_ib
xmap <silent> <Plug>disabled_CamelCaseMotion_ib <Plug>CamelCaseMotion_ib
omap <silent> <Plug>disabled_CamelCaseMotion_ie <Plug>CamelCaseMotion_ie
xmap <silent> <Plug>disabled_CamelCaseMotion_ie <Plug>CamelCaseMotion_ie

" ** }}}

" ** Misc ** {{{2

" List or Highlight all todo, fixme, xxx comments
NeoBundleLazy 'TaskList.vim', { 'autoload' : { 'mappings' : ['<Plug>TaskList'] } }

" extended % key matching
NeoBundle "tmhedberg/matchit"
NeoBundle 'tpope/vim-endwise' " supports ruby, vimscript

" :Rename current file on disk
NeoBundleLazy 'danro/rename.vim', { 'autoload' : { 'commands' : 'Rename' } }

" Bulk renamer
NeoBundleLazy 'renamer.vim', { 'autoload' : { 'commands' : 'Renamer' } }

" Colorize any parenthesis or brackets
NeoBundle 'kien/rainbow_parentheses.vim'
augroup VimrcGlobal
    autocmd VimEnter * :RainbowParenthesesToggle
    autocmd Syntax * call DelayedExecute('RainbowParenthesesLoadRound')
    autocmd Syntax * call DelayedExecute('call rainbow_parentheses#activate()')
augroup END

" IME
NeoBundleLazy 'vimtaku/vim-mlh', {
\   'depends' : [
\       'mattn/webapi-vim',
\   ]
\}
command! LoadMlh NeoBundleSource vim-mlh

" ** }}}

" ** Color Scheme ** {{{2

" Too hard to setup not-degraded-mode...
" (You should setup your term emulator first)
" So please try it first with termcolors=256, then setup if you like it.

NeoBundle 'altercation/vim-colors-solarized'
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

function! s:NeoBundleAutoloadFiletypes(name, filetypes)
    let g:neobundle#default_options[a:name] = {
    \   'autoload' : {
    \       'filetypes' : a:filetypes
    \   },
    \ }
endfunction

" ** HTML / CSS / XML ** {{{2

call s:NeoBundleAutoloadFiletypes('htmlcss', ['html', 'css', 'xml', 'htmlcheetah'])

NeoBundleLazy 'othree/html5.vim',       '', 'htmlcss'
NeoBundleLazy 'hail2u/vim-css3-syntax', '', 'htmlcss'
NeoBundleLazy 'skammer/vim-css-color',  '', 'htmlcss'
NeoBundleLazy 'mattn/zencoding-vim',    '', 'htmlcss'
let g:user_zen_settings = {
\   'lang': "ja"
\}
let g:use_zen_complete_tag = 1

NeoBundleLazy 'sukima/xmledit', '', 'htmlcss'
" see http://nanasi.jp/articles/vim/xml-plugin.html

" haml / sass / scss
call s:NeoBundleAutoloadFiletypes('hamlsass', ['haml', 'sass', 'scss'])
NeoBundleLazy 'tpope/vim-haml', '', 'hamlsass'

" ** }}}

" ** JavaScript ** {{{2

call s:NeoBundleAutoloadFiletypes('javascript', ['javascript', 'json'])

autocmd VimrcGlobal FileType json call DelayedExecute('set syntax=javascript')
autocmd VimrcGlobal BufNewFile,BufRead *.json setf json

NeoBundleLazy 'jelera/vim-javascript-syntax',         '', 'javascript'
NeoBundleLazy 'jiangmiao/simple-javascript-indenter', '', 'javascript'
NeoBundleLazy 'nono/jquery.vim',                      '', 'javascript'

" NeoBundleLazy 'mklabs/grunt.vim', '', 'javascript'
" NeoBundleLazy 'pangloss/vim-javascript', '', 'javascript' " indent, conflicts with lazyloaded vim-javascript-syntax

autocmd VimrcGlobal FileType javascript call DelayedExecute('set syntax=jquery')

NeoBundleLazy 'marijnh/tern_for_vim', '', 'javascript'
" NeoBundleLazy 'marijnh/tern_for_vim', '', 'javascript', {
" \   'build' : {
" \       'windows' : 'npm install',
" \       'cygwin'  : 'npm install',
" \       'mac'     : 'npm install',
" \       'unix'    : 'npm install',
" \   }
" \}

let g:tern#command = ['node', $HOME.'/dotfiles/node_modules/.bin/tern']
" let g:tern#is_show_argument_hints_enabled = 0

" http://wozozo.hatenablog.com/entry/2012/02/08/121504
map <Leader>FJ !python -m json.tool<CR>

" ** }}}

" ** Perl ** {{{2

call s:NeoBundleAutoloadFiletypes('perl', ['perl'])

autocmd VimrcGlobal BufNewFile,BufRead *.t setf perl

" use new perl syntax and indent!
NeoBundleLazy 'vim-perl/vim-perl', '', 'perl'
" Enable perl specific rich fold
let perl_fold=1
let perl_fold_blocks=1
" let perl_nofold_packages = 1
" let perl_include_pod=1

NeoBundleLazy 'c9s/perlomni.vim',       '', 'perl'
NeoBundleLazy 'mattn/perlvalidate-vim', '', 'perl'

" NeoBundleLazy 'yko/mojo.vim', '', 'perl'
" let mojo_highlight_data = 1

augroup VimrcGlobal
    autocmd FileType perl inoremap <buffer> <C-l> $
    autocmd FileType perl snoremap <buffer> <C-l> $
augroup END

" vim-ref for perldoc
cnoreabbrev Pod Ref perldoc
command! Upod :Unite ref/perldoc

" Refer: Also refer textobj section

" ** }}}

" ** Python ** {{{2

call s:NeoBundleAutoloadFiletypes('python', ['python'])

NeoBundleLazy 'tmhedberg/SimpylFold', '', 'python'
NeoBundleLazy 'yuroyoro/vim-python',  '', 'python'
NeoBundleLazy 'davidhalter/jedi-vim', '', 'python', {
\   'build' : {
\       'windows' : 'git submodule update --init',
\       'mac'     : 'git submodule update --init',
\       'unix'    : 'git submodule update --init',
\      },
\   }

" ** }}}

" ** Objective-C / iOS ** {{{

call s:NeoBundleAutoloadFiletypes('objc', ['objc'])

" TODO check out [here]( http://d.hatena.ne.jp/thinca/20130522/1369234427 )
" NeoBundleLazy 'Rip-Rip/clang_complete', '', 'objc'
" NeoBundleLazy 'osyo-manga/neocomplcache-clang_complete', { 'autoload' : {
"      \ 'filetypes' : g:my.ft.c_files,
"      \ }}
NeoBundleLazy 'eraserhd/vim-ios',       '', 'objc'
NeoBundleLazy 'msanders/cocoa.vim',     '', 'objc'

" ** }}}

" ** Markdown ** {{{

autocmd VimrcGlobal BufNewFile,BufRead *.md setf markdown

" ** }}}

" ** Shell ** {{{

call s:NeoBundleAutoloadFiletypes('sh', ['sh'])
NeoBundleLazy 'sh.vim', '', 'sh'

" ** }}}

" ** VimScript ** {{{

autocmd VimrcGlobal FileType vim,help set keywordprg=":help"

" ** }}}

" *** }}}

" *** Custom Commands *** {{{1

" vimdiff between current buffer and last saved state
" Refer: :help DiffOrig
command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_
                \ | diffthis | wincmd p | diffthis

" *** }}}

" *** Utility Function *** {{{1

" ** DelayedExecute ** {{{2

" Promising the order of autocmd executions, e.g. set hl after main syntax
function! DelayedExecute(command)
    if !exists('s:delayed_execute_queue')
        let s:delayed_execute_queue = []
        augroup DelayedExecutor
            autocmd!
            autocmd CursorHold,CursorHoldI,CursorMoved,CursorMovedI * call RunDelayedExecute()
        augroup END
    endif
    call add(s:delayed_execute_queue, a:command)
endfunction
function! RunDelayedExecute()
    autocmd! DelayedExecutor
    for cmd in s:delayed_execute_queue
        execute cmd
    endfor
    unlet cmd s:delayed_execute_queue
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
        " CursorMoved: called at start of editting, after ready to edit
        augroup DelayedStashFoldMethod
            autocmd!
            autocmd CursorMoved,CursorMovedI <buffer> call StashFoldMethodAfterInit()
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

function! StashFoldMethodAfterInit()
    call StashFoldMethod()
    autocmd! DelayedStashFoldMethod
endfunction

" Preserve foldmethod and set it to 'manual'
function! StashFoldMethod()
    if !exists('w:last_fdm') && (&foldmethod == 'expr' || &foldmethod == 'syntax')
        let b:orig_fdm=&foldmethod
        let w:last_fdm=&foldmethod
        setlocal foldmethod=manual
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

NeoBundle 'fuenor/qfixgrep'

NeoBundle 'taku-o/vim-copypath'
let g:copypath_copy_to_unnamed_register = 1

NeoBundle 'kana/vim-altr'
nmap ]r <Plug>(altr-forward)
nmap [r <Plug>(altr-back)

" Bundle 'jpalardy/vim-slime' " TODO

if has('mac')
    nnoremap <silent> <Space>y :.w !pbcopy<CR><CR>
    vnoremap <silent> <Space>y :w !pbcopy<CR><CR>
    nnoremap <silent> <Space>p :r !pbpaste<CR>
    vnoremap <silent> <Space>p :r !pbpaste<CR>
endif

map <Leader>tl <Plug>TaskList

NeoBundleLazy 'http://conque.googlecode.com/svn/trunk/', {
\   'name' : 'vim-conque',
\   'type' : 'svn',
\   'autoload' : {
\       'commands' : ['ConqueTerm', 'ConqueTermSplit', 'ConqueTermTab', 'ConqueTermVSplit']
\   },
\}
let g:ConqueTerm_ReadUnfocused = 1
let g:ConqueTerm_InsertOnEnter = 0
let g:ConqueTerm_TERM = 'xterm-256color'

NeoBundle 'thinca/vim-scouter'

NeoBundle 'tyru/operator-camelize.vim', {
\   'depends' : [
\       'kana/vim-operator-user',
\   ]
\}
map <Leader>L <Plug>(operator-camelize-toggle)
" map <Leader>_L <Plug>(operator-upper-camelize)
" let g:operator_camelize_word_case = "lower"

" NeoBundle 'chikatoike/activefix.vim'

let g:gist_open_browser_after_post = 1

NeoBundleLazy 'mbbill/fencview', {
\   'autoload' : {
\       'commands' : ['FencAutoDetect', 'FencManualEncoding', 'FencView']
\   }
\}

command! Uall :bufdo :update

" NeoBundleLazy 'joonty/vdebug'
NeoBundleLazy 'ypresto/vdebug', { 'directory' : 'my_vdebug' }

if !exists("g:vdebug_options")
    let g:vdebug_options = {}
endif
" let g:vdebug_options['exec_perl']   = $HOME.'/dotfiles/bin/komodo-perl.sh %s'
" let g:vdebug_options['exec_python'] = $HOME.'/dotfiles/bin/komodo-python.sh %s'
" let g:vdebug_options['exec_ruby']   = $HOME.'/dotfiles/bin/komodo-ruby.sh %s'
let g:vdebug_options['command_perl']   = ':call OpenDebugTerminal("'.$HOME.'/dotfiles/bin/komodo-perl.sh %s")'
let g:vdebug_options['command_python'] = ':call OpenDebugTerminal("'.$HOME.'/dotfiles/bin/komodo-python.sh %s")'
let g:vdebug_options['command_ruby']   = ':call OpenDebugTerminal("'.$HOME.'/dotfiles/bin/komodo-ruby.sh %s")'

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


NeoBundleLazy 'tell-k/vim-browsereload-mac'
NeoBundleLazy 'lordm/vim-browser-reload-linux'
if has('mac')
    NeoBundleSource vim-browsereload-mac
elseif has('linux')
    NeoBundleSource vim-browser-reload-linux
endif


NeoBundle 'AndrewRadev/splitjoin.vim' " improve gS and gJ mappings

NeoBundleLazy 'reinh/vim-makegreen', '', 'python'
NeoBundleLazy 'sontek/rope-vim', '', 'python'

call s:NeoBundleAutoloadFiletypes('ruby', ['ruby'])
NeoBundleLazy 'vim-ruby/vim-ruby',           '', 'ruby'
NeoBundleLazy 'ecomba/vim-ruby-refactoring', '', 'ruby'
NeoBundleLazy 'taichouchou2/vim-rsense',     '', 'ruby'

" https://github.com/CocoaPods/CocoaPods/wiki/Make-your-text-editor-recognize-the-CocoaPods-files
autocmd VimrcGlobal BufNewFile,BufRead Podfile,*.podspec setf ruby

NeoBundleLazy 'dbext.vim' " TODO
NeoBundleLazy 'mattn/qiita-vim' " TODO
NeoBundleLazy 'thinca/vim-prettyprint'
NeoBundleLazy 'benmills/vimux' " TODO

nmap <expr><TAB> neosnippet#jumpable() ?
 \ "i<TAB>" : "\<TAB>"
" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable() ?
 \ "\<Plug>(neosnippet_expand_or_jump)"
 \: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable() ?
 \ "\<Plug>i_(neosnippet_expand_or_jump)"
 \: "\<TAB>"
nmap <Esc>s i_<Plug>(neosnippet_start_unite_snippet)
imap <Esc>s i_<Plug>(neosnippet_start_unite_snippet)

let g:quickrun_config.markdown = {
    \ 'type': 'markdown/pandoc',
    \ 'cmdopt': '-s',
    \ 'outputter': 'browser'
    \ }

autocmd VimrcGlobal FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd VimrcGlobal FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags

if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.perl =
\   '[^. \t]->\%(\h\w*\)\?'
" \   '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

NeoBundle 'MultipleSearch' " TODO
" NeoBundle 'airblade/vim-rooter'

NeoBundle 'thinca/vim-unite-history'
" NeoBundle 't9md/vim-surround_custom_mapping'

" http://hail2u.net/blog/software/only-one-line-life-changing-vimrc-setting.html
autocmd VimrcGlobal FileType html setlocal includeexpr=substitute(v:fname,'^\\/','','') path+=;/
autocmd VimrcGlobal FileType diff setlocal includeexpr=substitute(v:fname,'^[ab]\\/','','')

" http://stackoverflow.com/questions/7672783/how-can-i-do-something-like-gf-but-in-a-new-vertical-split
noremap <Leader>f :vertical wincmd f<CR>

" [ai], : argument than parameter
NeoBundle 'sgur/vim-textobj-parameter'

" let g:indent_guides_auto_colors = 0
" autocmd VimrcGlobal VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=3
" autocmd VimrcGlobal VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=4

call s:NeoBundleAutoloadFiletypes('xmlbased', ['html', 'xhtml', 'xml'])
" highlight matching tags
NeoBundleLazy 'Valloric/MatchTagAlways', '', 'xmlbased'

NeoBundle 'kana/vim-fakeclip' " TODO

NeoBundleLazy 'mattn/mkdpreview-vim', {
\   'autoload' : {
\       'filetypes' : ['markdown']
\   }
\}

" highlight matching open and close parentheses pair
let g:loaded_matchparen = 1
NeoBundle 'haruyama/vim-matchopen'

noremap <C-w><C-f> :vertical wincmd f<CR>

command! PurgeTrailingSpace :%s/\v\s+$//

command! TwoIndent  set softtabstop=2 shiftwidth=2 | :IndentGuidesToggle | :IndentGuidesToggle
command! FourIndent set softtabstop=4 shiftwidth=4 | :IndentGuidesToggle | :IndentGuidesToggle

" Reflection
" @see http://mattn.kaoriya.net/software/vim/20110728094347.htm

function! GetSidForScript(script_name)
    silent! redir => scriptname_text
    silent! scriptnames
    silent! redir END
    return matchstr(matchstr(split(scriptname_text, '\n'), '\W'.a:script_name), '\d\+')
endfunction

function! FunctionForSID(sid, func_name)
    return function('<SNR>'.a:sid.'_'.a:func_name)
endfunction

nnoremap <Leader>R R

NeoBundle 'vim-scripts/argtextobj.vim'

NeoBundle 'ypresto/alpaca_powertabline', 'align_center_or_not'
let g:alpaca_powertabline_align_center = 0
let g:alpaca_powertabline_sep1 = ' > '
let g:alpaca_powertabline_sep2 = ': '

" HERE

" ** vimrc reading @ 2012/11/03 {{{
    " https://github.com/cpfaff/vim-my-setup/blob/master/vimrc
    set lazyredraw
    set spelllang=en
    " nnoremap U <C-r>

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

let &grepprg='ag --search-binary'

let g:neocomplcache_min_syntax_length = 3
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

set autoread
" set modelines=0
" set display=uhex " shows unprintable chars as hex

" below conflict with repeatation
" nnoremap 0 ^
" nnoremap 9 $

" ** }}}

" ** vimrc reading @ 2012/11/17 {{{

" https://github.com/yomi322/config/blob/master/dot.vimrc

" " http://mattn.kaoriya.net/software/vim/20121105111112.htm
" NeoBundle 'mattn/multi-vim'

NeoBundle 'rhysd/vim-textobj-ruby' " [ai]r
" g:textobj_ruby_more_mappings = 1 " ro rl rc rd rr

NeoBundle 'sgur/unite-qf'
NeoBundle 'osyo-manga/unite-quickfix'
nmap <Leader>uq <Leader>u: qf<CR>
nmap <Leader>Uq <Leader>U: qf<CR>
nmap <Leader>uQ <Leader>u: quickfix<CR>
nmap <Leader>UQ <Leader>U: quickfix<CR>

" ** }}}

" ** vimrc reading @ 2012/11/24 {{{

" https://github.com/tsukkee/config/blob/master/vimrc

nmap s  <Plug>Ysurround
nmap S  <Plug>YSurround
nmap ss <Plug>Yssurround
nmap Ss <Plug>YSsurround
nmap SS <Plug>YSsurround

" set directory-=. " don't save tmp swap file in current directory

call yankstack#setup()
nmap Y y$

" ** }}}

" ** vimrc reading @ 2012/12/15 {{{

set virtualedit=block
" set ambiwidth=double

" thanks!: thinca
inoremap <expr> <C-k> col('.') == col('$') ? "" : "\<C-o>D"

if has('gui_running')
    "# yankとclipboardを同期する
    set clipboard+=unnamed
    " not work corect
    " set iminsert
    set imdisable
endif

" ** }}}

" ** vimrc reading @ 2012/01/19 {{{

"UUB NeoBundle 't9md/vim-quickhl'

" ** }}}

" ** vimrc reading @ 2012/03/23 {{{

if 0
" buggy on relative paths?

" @see http://vim-users.jp/2011/02/hack202/
" 保存時に対象ディレクトリが存在しなければ作成する(作成有無は確認できる)
augroup AutoMkdir
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
  function! s:auto_mkdir(dir, force)
    if !isdirectory(a:dir) && (a:force ||
          \    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
      call mkdir(a:dir, 'p')
    endif
  endfunction
augroup END

endif

" command mode
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-d> <Del>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>
cnoremap <C-k> <C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>
cnoremap <C-y> <C-r>*

" タブページの位置を移動
nnoremap <silent> <S-Left>    :<C-u>execute 'tabmove' tabpagenr() - 2<CR>
nnoremap <silent> <S-Right>   :<C-u>execute 'tabmove' tabpagenr()<CR>

" http://nanabit.net/blog/2007/11/01/vim-fullscreen/

set winaltkeys=no

" mail
NeoBundleLazy 'yuratomo/gmail.vim'
let g:gmail_user_name = 'yuya.presto@gmail.com'

"UUB NeoBundle 'itchyny/thumbnail.vim'

" @see http://d.hatena.ne.jp/itchyny/20130319/1363690268
augroup VimrcGlobal
    autocmd VimEnter * NeoBundleCheck
augroup END

" fugitive
nnoremap <Space>ge  :<C-u>Gedit<CR>
nnoremap <Space>gs  :<C-u>Gstatus<CR>
nnoremap <Space>gd  :<C-u>Gdiff<CR>
nnoremap <Space>gw  :<C-u>Gwrite<CR>

"UUB " gitv
"UUB NeoBundle 'gregsexton/gitv'
"UUB autocmd VimrcGlobal FileType git :setlocal foldlevel=99
"UUB nnoremap <Space>gv  :<C-u>Gitv<CR>
"UUB nnoremap <Space>gV  :<C-u>Gitv!<CR>

" ** }}}

" ** vimrc reading @ 2012/04/06 {{{

" ペアとなる括弧の定義
autocmd VimrcGlobal FileType html setlocal matchpairs+=<:>

set nojoinspaces


" grepソース
" let g:unite_source_grep_default_opts = '-Hn --include="*.vim" --include="*.txt" --include="*.php" --include="*.xml" --include="*.mkd" --include="*.hs" --include="*.js" --include="*.log" --include="*.sql" --include="*.coffee"'
let g:unite_source_grep_command = "ag"
let g:unite_source_grep_recursive_opt = ""
let g:unite_source_grep_default_opts = "--nogroup --nocolor"

let g:unite_source_grep_max_candidates = 100
" let g:unite_source_session_enable_auto_save = 1     " セッション保存

if 0

" http://d.hatena.ne.jp/thinca/20120201/1328099090
NeoBundleLazy 'thinca/vim-singleton'
if has('clientserver')
    NeoBundleSource thinca/vim-singleton
    call singleton#enable()
endif

endif

" ** }}}

" ** vimrc reading @ 2012/04/27 {{{

let g:neobundle#default_options['java'] = {
\   'autoload' : {
\       'filetypes' : ['java']
\   }
\}

NeoBundle 'yuratomo/dbg.vim.git'

NeoBundleLazy 'teramako/jscomplete-vim.git', '', 'javascript'

augroup VimrcGlobal
    autocmd FileType java       set foldmarker={,} foldmethod=marker
    autocmd FileType cpp        set foldmarker={,} foldmethod=marker
    autocmd FileType c          set foldmarker={,} foldmethod=marker
    autocmd FileType java       set omnifunc=javaapi#complete
    autocmd FileType cpp        set omnifunc=cppapi#complete
    autocmd FileType c          set omnifunc=cppapi#complete
    "autocmd CompleteDone *.java call javaapi#showRef()

    " use tern instead
    " autocmd FileType javascript set omnifunc=jscomplete#CompleteJS
    " let g:jscomplete_use = ['dom', 'webkit']

    if has("balloon_eval") && has("balloon_multiline")
    autocmd FileType java  set ballooneval bexpr=javaapi#balloon()
    autocmd FileType cpp   set ballooneval bexpr=cppapi#balloon()
    autocmd FileType c     set ballooneval bexpr=cppapi#balloon()
    autocmd FileType h     set ballooneval bexpr=cppapi#balloon()
    endif
augroup END

" 今開いているウィンドウを新しいタブで開きなおす
command! OpenNewTab  :call OpenNewTab()
function! OpenNewTab()
  let l:f = expand("%:p")
  if winnr('$') != 1 || tabpagenr('$') != 1
    execute ":q"
    execute ":tabnew ".l:f
  endif
endfunction

" ** }}}

" ** vimrc reading @ 2013/10/27 {{{

" Complement command in command-line like zsh
cnoremap <C-P> <UP>
cnoremap <C-N> <Down>

nnoremap <silent>gM :Gcommit --amend<CR>
nnoremap <silent>gb :Gblame<CR>
nnoremap <silent>gB :Gbrowse<CR>
nnoremap <silent>gm :Gcommit<CR>

autocmd FileType gitcommit,git-diff nnoremap <buffer>q :q<CR>

" Enable blocked I in non-visual-block mode
NeoBundle 'kana/vim-niceblock'
xmap I  <Plug>(niceblock-I)
xmap A  <Plug>(niceblock-A)

let bundle = neobundle#get('neocomplete')
function! bundle.hooks.on_source(bundle)
    if !exists("g:neocomplete#sources#omni#functions")
        let g:neocomplete#sources#omni#functions = {}
    endif
    let g:neocomplete#sources#omni#functions.java = 'eclim#java#complete#CodeComplete'

    let g:neocomplete#keyword_patterns = {
    \   '_' : '[0-9a-zA-Z:#_]\+',
    \   'c' : '[^.[:digit:]*\t]\%(\.\|->\)',
    \}
endfunction

let g:surround_no_imappings = 1
imap <expr><C-G> pumvisible() ? neocomplete#undo_completion() : "\<Esc>"

let g:echodoc_enable_at_startup = 1
NeoBundle 'Shougo/echodoc', {
\   'autoload' : { 'insert' : 1 }
\}

command! UnwatchBuffer setlocal buftype=nofile nobuflisted noswapfile bufhidden=hide

" ** }}}

" vimrc reading HERE

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
        set transparency=5
        set fuoptions=maxvert,maxhorz
        NeoBundleSource 'thinca/vim-fontzoom'
    elseif has('gui_gtk2')
        set guioptions-=m " to avoid menu accelerator being bound
        set guifont="DejaVu Sans Mono 10"
        " set guifontwide=
        " FIXME: no prompt text like "swp exists" shown on macvim when use script like UniteSession
        set guioptions+=c " no dialog
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

set secure

" vim:set foldmethod=marker:
