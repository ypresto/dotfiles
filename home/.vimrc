" **
" * .vimrc for yuya_presto
" *
" * Please checkout 'Plugins' section for recommended plugins.
" *

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
call neobundle#begin(expand('~/.vim/bundle'))
let g:neobundle#types#git#enable_submodule = 1
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc', {
\   'build' : {
\       'windows' : 'echo "Sorry, cannot update vimproc binary file in Windows."',
\       'cygwin'  : 'make -f make_cygwin.mak',
\       'mac'     : 'make -f make_mac.mak',
\       'unix'    : 'make -f make_unix.mak',
\      },
\   }

" *** }}}

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

" *** Editor Functionality *** {{{1

" ** Language / Encoding ** {{{2

try
    :language en
catch
    :language C
endtry

set helplang=ja

set encoding=utf-8
set fileencodings=iso-2022-jp-3,iso-2022-jp,utf-8,euc-jisx0213,euc-jp,ucs-bom,euc-jp,eucjp-ms,cp932
set fileformats=unix,dos,mac
autocmd VimrcGlobal BufReadPost *
\   if &modifiable && !search('[^\x00-\x7F]', 'cnw')
\ |   setlocal fileencoding=
\ | endif

" ** }}}

" ** Indent / Tab ** {{{2

set tabstop=8     " <Tab>s are shown with this num of <Space>s
set softtabstop=2 " Use this num of spaces as <Tab> on insert and delete
set shiftwidth=2  " Use this num of spaces for auto indent
set shiftround    " round indent with < and >
set expandtab     " Always use <Tab> for indent and insert
set smarttab      " Use shiftwidth on beginning of line when <Tab> key
set autoindent    " Use same indent level on next line
set smartindent   " Auto indent for C-like code with '{...}' blocks
set shiftround    " Round indent when < or > is used

" * Filetype specific indent * {{{

augroup VimrcGlobal
    autocmd FileType make setlocal softtabstop=8 shiftwidth=8 noexpandtab
    autocmd FileType perl,python,groovy,vim setlocal softtabstop=4 shiftwidth=4
    autocmd FileType python setlocal nosmartindent
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
set virtualedit=block

set foldmethod=marker " Use '{{{' and '}}}' for marker
set foldlevelstart=1  " Start with some folds closed
set foldcolumn=2
set noeb vb t_vb=     " no beep
set scrolloff=1       " show N more next line when scrolling

" Complete
set complete=.,w,b,u,U,s,i,d,t
set completeopt=menu,menuone
set pumheight=10
set infercase         " Ignore case on insert completion.

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

    highlight SpecialKey   ctermbg=black      guibg=black
    highlight ZenkakuSpace ctermbg=darkyellow guibg=darkyellow
endfunction

augroup VimrcGlobal
    " Highlight current line only on current window
    autocmd WinLeave * set nocursorline
    autocmd WinEnter,BufRead * set cursorline

    " activates custom highlight settings
    autocmd VimEnter,WinEnter,ColorScheme * call s:HighlightSetup()
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
nmap <silent> <Esc><Esc> :nohlsearch<CR>:set nopaste<CR><Esc>

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
"" Ctrl-a Ctrl-eで移動できるようにする
function! MoveCursorToHome()
    let c = col(".")
    exec "normal! ^"
    if col(".") == c
        exec "normal! 0"
    endif
endfunction
inoremap <silent> <C-a> <C-o>:call MoveCursorToHome()<CR>
" <C-o> and <Home> is different on indented line
inoremap <C-a> <C-o>:call MoveCursorToHome()<CR>
cnoremap <C-a> <C-o>:call MoveCursorToHome()<CR>
snoremap <C-a> <C-o>:call MoveCursorToHome()<CR>
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
" thanks!: thinca
inoremap <expr> <C-k> col('.') == col('$') ? "" : "\<C-o>D"

" emacs in command mode (vimrc reading @ 2012/03/23)
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-d> <Del>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>
cnoremap <C-k> <C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>
cnoremap <C-y> <C-r>*

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
" Open file under cursor in vertical window
" http://stackoverflow.com/questions/7672783/how-can-i-do-something-like-gf-but-in-a-new-vertical-split
nnoremap <C-w><C-f> :vertical wincmd f<CR>
noremap <Leader>f :vertical wincmd f<CR>


" QuickFix Toggle
nmap <silent> <leader>l :call ToggleList("Location List", 'l')<CR>
nmap <silent> <leader>q :call ToggleList("Quickfix List", 'c')<CR>

" ZenCoding
let g:user_emmet_leader_key = '<Esc>y'
if has('gui_running')
    " Workaround for gui meta
    let g:user_emmet_expandabbr_key = '<M-y><M-y>'
else
    let g:user_emmet_expandabbr_key = '<Esc>y<Esc>y'
endif

" Gundo
nnoremap <Leader>G :GundoToggle<CR>


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
let s:yankstack_bundle = neobundle#get('vim-yankstack')
function! s:yankstack_bundle.hooks.on_post_source(bundle)
    call yankstack#setup()
    nmap Y y$
endfunction

nmap <C-p> <Plug>yankstack_substitute_older_paste
nmap <C-n> <Plug>yankstack_substitute_newer_paste

" autocompletes parenthesis, braces and more
NeoBundle 'kana/vim-smartinput'
"call smartinput#define_rule({ 'at': '\[\_s*\%#\_s*\]', 'char': '<Enter>', 'input': '<Enter><C-o>O' })
"call smartinput#define_rule({ 'at': '{\_s*\%#\_s*}'  , 'char': '<Enter>', 'input': '<Enter><C-o>O' })
"call smartinput#define_rule({ 'at': '(\_s*\%#\_s*)'  , 'char': '<Enter>', 'input': '<Enter><C-o>O' })

" surrounding with braces or quotes with s and S key
NeoBundle 'tpope/vim-surround'

" open reference manual with K key
NeoBundle 'thinca/vim-ref'
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
let g:syntastic_ruby_checkers = ['mri', 'rubocop']
let g:syntastic_perl_checkers = ['perl', 'perlcritic', 'podchecker']
let g:syntastic_perl_perlcritic_thres = 4
let g:syntastic_enable_perl_checker = 1
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

" Switch between related files.
NeoBundle 'kana/vim-altr'
nmap ]r <Plug>(altr-forward)
nmap [r <Plug>(altr-back)

let s:altr_bundle = neobundle#get('vim-altr')
function! s:altr_bundle.hooks.on_post_source(bundle)
    " rails
    call altr#define('app/models/%.rb', 'spec/models/%_spec.rb', 'spec/factories/%s.rb')
    call altr#define('app/controllers/%.rb', 'spec/controllers/%_spec.rb')
    call altr#define('app/helpers/%.rb', 'spec/helpers/%_spec.rb')
    call altr#define('app/mailers/%.rb', 'spec/mailers/%_spec.rb')
    call altr#define('spec/routing/%_spec.rb', 'config/routes.rb')
    call altr#define('lib/%.rb', 'spec/lib/%_spec.rb')
    call altr#define('lib/%.rb', 'spec/%_spec.rb')
endfunction

" Add repeat support to some plugins, like surround.vim
NeoBundle 'tpope/vim-repeat'

" Speedup j and k key
NeoBundle 'rhysd/accelerated-jk'
nmap j <Plug>(accelerated_jk_gj)
nmap k <Plug>(accelerated_jk_gk)
let g:accelerated_jk_anable_deceleration = 1
let g:accelerated_jk_acceleration_table = [10,20,15,15]

NeoBundle 'bling/vim-airline'

if 0

let s:airline_bundle = neobundle#get('vim-airline')
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

endif

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

if has('gui_running') && has('gui_macvim')
    let g:airline_powerline_fonts = 1
endif

" Fast file selector
NeoBundle 'kien/ctrlp.vim'
let g:ctrlp_map = '<Leader><C-p>'
let g:ctrlp_max_files = 0
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files --cached --others --exclude-standard'] " speedup
nmap <Leader><C-q> :CtrlPQuickfix<CR>
nmap <Leader><C-u> :CtrlPMRU<CR>
nmap <Leader><C-c> :CtrlPChangeAll<CR>
nmap <Leader><C-l> :CtrlPLine<CR>
nmap <Leader><C-t> :CtrlPTag<CR>
" for unite keymap compatibility
nmap <Leader>us :CtrlPMRU<CR>
nmap <Leader>uq :CtrlPQuickfix<CR>

" TODO
" experimental mappings
nmap <Esc><C-p> <Leader><C-p>
nmap <Esc><C-q> <Leader><C-q>
nmap <Esc><C-u> <Leader><C-u>
nmap <Esc><C-c> <Leader><C-c>
nmap <Esc><C-l> <Leader><C-l>
nmap <Esc><C-t> <Leader><C-t>

NeoBundle 'jasoncodes/ctrlp-modified.vim'
nmap <Leader><C-m> :CtrlPModified<CR>
nmap <Leader><C-b> :CtrlPBranch<CR>

NeoBundle 'tacahiroy/ctrlp-funky'
let g:ctrlp_funky_syntax_highlight = 1
nmap <Leader><C-f> :CtrlPFunky<CR>

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

" Paste with textobj, use this instead of vi"p
NeoBundle 'kana/vim-operator-replace', {
\   'depends' : [
\       'kana/vim-operator-user',
\   ]
\}
nmap R <Plug>(operator-replace)
nnoremap <Leader>R R

" ** }}}

" ** unite ** {{{2

NeoBundle 'Shougo/unite.vim', {
\   'autoload' : {
\       'commands' : ['Unite', 'UniteSessionLoad', 'UniteSessionSave']
\   }
\}
let g:unite_enable_start_insert=1
let g:unite_split_rule="botright"
let g:unite_winheight="10"

let s:unite_bundle = neobundle#get('unite.vim')
function! s:unite_bundle.hooks.on_post_source(bundle)
    call unite#custom#source('outline,outline:folding', 'sorters', 'sorter_reverse')
endfunction

NeoBundle 'kmnk/vim-unite-giti.git'
" NeoBundle 'Shougo/unite-session'
" let g:unite_source_session_options = &sessionoptions
" NeoBundleLazy 'tacroe/unite-mark',    { 'autoload' : { 'unite_sources' : ['mark'] } }
NeoBundleLazy 'Shougo/unite-outline', { 'autoload' : { 'unite_sources' : ['outline', 'outline:folding'] } }
NeoBundleLazy 'taka84u9/unite-git',   { 'autoload' : { 'unite_sources' : ['git_untracked', 'git_cached', 'git_modified'] } }
" NeoBundleLazy 'tsukkee/unite-help',   { 'autoload' : { 'unite_sources' : ['help'] } }

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
NeoBundle 'kana/vim-textobj-syntax'          " [ai]sy
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
map <Leader>tl <Plug>TaskList

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

" ** }}}

" ** Color Scheme ** {{{2

NeoBundle 'chriskempson/vim-tomorrow-theme'

if 0

" Too hard to setup not-degraded-mode...
" (You should setup your term emulator first)
" So please try it first with termcolors=256, then setup if you like it.

NeoBundle 'altercation/vim-colors-solarized'
let g:solarized_termcolors=16
let g:solarized_termtrans=1
let g:solarized_bold=1
let g:solarized_underline=1
let g:solarized_italic=1

endif

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
" NeoBundleLazy 'skammer/vim-css-color',  '', 'htmlcss' " too heavy

" zencoding
NeoBundleLazy 'mattn/emmet-vim',        '', 'htmlcss'
let g:user_emmet_settings = {
\   'lang': "ja"
\}
let g:use_zen_complete_tag = 1

NeoBundleLazy 'sukima/xmledit', '', 'htmlcss'
" see http://nanasi.jp/articles/vim/xml-plugin.html

" highlight matching tags
NeoBundleLazy 'Valloric/MatchTagAlways', '', 'htmlcss'

autocmd VimrcGlobal FileType html setlocal matchpairs+=<:>

" haml / sass / scss
call s:NeoBundleAutoloadFiletypes('hamlsass', ['haml', 'sass', 'scss'])
NeoBundleLazy 'tpope/vim-haml', '', 'hamlsass'
let g:syntastic_sass_check_partials=1

" slim
call s:NeoBundleAutoloadFiletypes('slim', ['slim'])
NeoBundleLazy 'slim-template/vim-slim', '', 'slim'

" ** }}}

" ** JavaScript ** {{{2

call s:NeoBundleAutoloadFiletypes('javascript', ['javascript', 'json', 'coffee'])

autocmd VimrcGlobal BufNewFile,BufRead *.json setf json

NeoBundleLazy 'jelera/vim-javascript-syntax',         '', 'javascript'
NeoBundleLazy 'jiangmiao/simple-javascript-indenter', '', 'javascript'
let g:SimpleJsIndenter_BriefMode = 1 " one indent per any number of parentheses
let g:vim_json_syntax_conceal = 0
NeoBundleLazy 'elzr/vim-json', '', 'javascript'

NeoBundleLazy 'kchmck/vim-coffee-script', '', 'javascript'

" NeoBundleLazy 'nono/jquery.vim',                      '', 'javascript' "

" NeoBundleLazy 'mklabs/grunt.vim', '', 'javascript'
" NeoBundleLazy 'pangloss/vim-javascript', '', 'javascript' " indent, conflicts with lazyloaded vim-javascript-syntax

" syntax conflicts with something...
" autocmd VimrcGlobal FileType javascript call DelayedExecute('set syntax=jquery')

NeoBundleLazy 'marijnh/tern_for_vim', '', 'javascript'
" Use below instead to use tern.js bundled in vim plugin
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

function! s:MapTernForVim()
    command! -buffer TernDefVSplitLocal py tern_lookupDefinition("vsplit")
    nmap <buffer> <Leader>jf :<C-U>TernDef<CR>
    nmap <buffer> <Leader>js :<C-U>TernDefSplit<CR>
    nmap <buffer> <Leader>jv :<C-U>TernDefVSplitLocal<CR>
    nmap <buffer> <Leader>jt :<C-U>TernDefTab<CR>
    nmap <buffer> <Leader>jp :<C-U>TernDefPreview<CR>
    nmap <buffer> <Leader>jt :<C-U>TernType<CR>
    nmap <buffer> <Leader>jr :<C-U>TernRefs<CR>
    nmap <buffer> <Leader>jd :<C-U>TernDoc<CR>
    nmap <buffer> <Leader>jb :<C-U>TernDocBrowse<CR>
    nmap <buffer> <Leader>jR :<C-U>TernRename<CR>
endfunction
autocmd VimrcGlobal FileType javascript call s:MapTernForVim()

" http://wozozo.hatenablog.com/entry/2012/02/08/121504
map <Leader>FJ !python -m json.tool<CR>

" ** }}}

" ** Ruby ** {{{2

call s:NeoBundleAutoloadFiletypes('ruby', ['ruby'])

NeoBundleLazy 'vim-ruby/vim-ruby',           '', 'ruby'
" NeoBundleLazy 'ecomba/vim-ruby-refactoring', '', 'ruby'
" NeoBundleLazy 'tpope/vim-rails',             '', 'ruby'
NeoBundleLazy 'ruby-matchit',                '', 'ruby'
NeoBundleLazy 'thoughtbot/vim-rspec',        '', 'ruby' " TODO

" https://github.com/CocoaPods/CocoaPods/wiki/Make-your-text-editor-recognize-the-CocoaPods-files
autocmd VimrcGlobal BufNewFile,BufRead Podfile,*.podspec setf ruby

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

" ** }}}

" ** Objective-C / iOS ** {{{

call s:NeoBundleAutoloadFiletypes('objc', ['objc'])

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

command! PurgeTrailingSpace :%s/\v\s+$//
command! TwoIndent  set softtabstop=2 shiftwidth=2 | :IndentGuidesToggle | :IndentGuidesToggle
command! FourIndent set softtabstop=4 shiftwidth=4 | :IndentGuidesToggle | :IndentGuidesToggle

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

let g:gist_post_private = 1
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


NeoBundle 'AndrewRadev/splitjoin.vim' " gS and gJ

NeoBundleLazy 'reinh/vim-makegreen', '', 'python'
NeoBundleLazy 'python-rope/ropevim', '', 'python'

let g:quickrun_config.markdown = {
    \ 'type': 'markdown/pandoc',
    \ 'cmdopt': '-s',
    \ 'outputter': 'browser'
    \ }

autocmd VimrcGlobal FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd VimrcGlobal FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags

NeoBundle 'thinca/vim-unite-history'
" NeoBundle 't9md/vim-surround_custom_mapping'

" http://hail2u.net/blog/software/only-one-line-life-changing-vimrc-setting.html
autocmd VimrcGlobal FileType html setlocal includeexpr=substitute(v:fname,'^\\/','','') path+=;/
autocmd VimrcGlobal FileType diff setlocal includeexpr=substitute(v:fname,'^[ab]\\/','','')

" [ai], : argument than parameter
NeoBundle 'sgur/vim-textobj-parameter'

" let g:indent_guides_auto_colors = 0
" autocmd VimrcGlobal VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=3
" autocmd VimrcGlobal VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=4


NeoBundle 'kana/vim-fakeclip' " TODO

NeoBundleLazy 'mattn/mkdpreview-vim', {
\   'autoload' : {
\       'filetypes' : ['markdown']
\   }
\}

" " highlight matching open and close parentheses pair
" let g:loaded_matchparen = 1
" NeoBundle 'haruyama/vim-matchopen'
" above is good but too slow on large file...

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


NeoBundle 'vim-scripts/argtextobj.vim'

NeoBundle 'alpaca-tc/alpaca_powertabline', 'align_center_or_not'
let g:alpaca_powertabline_align_center = 0
let g:alpaca_powertabline_sep1 = ' > '
let g:alpaca_powertabline_sep2 = ': '

" TODO
NeoBundle 'koron/codic-vim'
NeoBundle 'rhysd/unite-codic.vim'

" http://d.hatena.ne.jp/joker1007/20111208/1323324569
let g:quickrun_config = {}
let g:quickrun_config._ = {'runner' : 'vimproc'}
let g:quickrun_config['rspec/bundle/cwd'] = {
  \ 'type': 'rspec/bundle/cwd',
  \ 'command': 'rspec',
  \ 'exec': 'bundle exec bin/rspec %s'
  \}
let g:quickrun_config['rspec/bundle'] = {
  \ 'type': 'rspec/bundle',
  \ 'command': 'rspec',
  \ 'exec': 'bundle exec %c %s'
  \}
let g:quickrun_config['rspec/normal'] = {
  \ 'type': 'rspec/normal',
  \ 'command': 'rspec',
  \ 'exec': '%c %s'
  \}
function! RSpecQuickrun()
  let b:quickrun_config = {'type' : 'rspec/bundle'}
endfunction
autocmd BufReadPost *_spec.rb call RSpecQuickrun()

NeoBundleLazy 'alpaca-tc/alpaca_tags'
let g:alpaca_tags#config = {
            \ '_' : '-R --sort=yes --languages=+Ruby',
            \ }
if executable("ctags")
    NeoBundleSource 'alpaca-tc/alpaca_tags'
    autocmd VimrcGlobal BufReadPost * call DelayedExecute('normal :AlpacaTagsSet')
endif

NeoBundle 'Valloric/YouCompleteMe', {
    \   'build' : {
    \       'windows' : 'echo "Sorry, cannot compile YouCompleteMe binary file in Windows."',
    \       'cygwin'  : 'git submodule update --init --recursive && ./install.sh --clang-completer',
    \       'mac'     : 'git submodule update --init --recursive && ./install.sh --clang-completer',
    \       'unix'    : 'git submodule update --init --recursive && ./install.sh --clang-completer',
    \      },
    \   }

" Track the engine.
NeoBundle 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
NeoBundle 'honza/vim-snippets'

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<C-j>"
let g:UltiSnipsJumpForwardTrigger="<Esc>f"
let g:UltiSnipsJumpBackwardTrigger="<Esc>b"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

let $LANG = 'en_US.UTF-8'

autocmd VimrcGlobal BufNewFile,BufRead *.gradle setf groovy

" bash-like search and replacement
NeoBundle 'tpope/vim-abolish'

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
" http://saihoooooooo.hatenablog.com/entry/2013/07/18/013400

if executable("ag")
    let &grepprg='ag --search-binary --nogroup -S $* /dev/null'
    set grepformat=%f:%l:%m
elseif executable("ack")
    let &grepprg='ack $* /dev/null'
    set grepformat=%f:%l:%m
endif

set autoread
" set modelines=0
" set display=uhex " shows unprintable chars as hex

" below conflict with repeatation
" nnoremap 0 ^
" nnoremap 9 $

" ** }}}

" ** vimrc reading @ 2012/11/17 {{{

" https://github.com/yomi322/config/blob/master/dot.vimrc

NeoBundle 'rhysd/vim-textobj-ruby' " [ai]r
" g:textobj_ruby_more_mappings = 1 " ro rl rc rd rr

" ** }}}

" ** vimrc reading @ 2012/11/24 {{{

" https://github.com/tsukkee/config/blob/master/vimrc

" nmap s  <Plug>Ysurround
" nmap S  <Plug>YSurround
" nmap ss <Plug>Yssurround
" nmap Ss <Plug>YSsurround
" nmap SS <Plug>YSsurround

nmap s  <Plug>Ysurroundiw
nmap S  <Plug>YsurroundiW

let g:yankstack_yank_keys = ['c', 'C', 'd', 'D', 'x', 'X', 'y', 'Y'] " without s and S

" ** }}}

" ** vimrc reading @ 2012/12/15 {{{

" set ambiwidth=double

if has('gui_running')
    "# yankとclipboardを同期する
    set clipboard+=unnamed
    " not work corect
    " set iminsert
    set imdisable
else
    let g:fakeclip_provide_clipboard_key_mappings = 1
endif

" ** }}}

" ** vimrc reading @ 2012/03/23 {{{

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

" タブページの位置を移動
nnoremap <silent> <S-Left>    :<C-u>execute 'tabmove' tabpagenr() - 2<CR>
nnoremap <silent> <S-Right>   :<C-u>execute 'tabmove' tabpagenr()<CR>

" http://nanabit.net/blog/2007/11/01/vim-fullscreen/

set winaltkeys=no

" ** vimrc reading @ 2012/04/06 {{{

set nojoinspaces


" grepソース
" let g:unite_source_grep_default_opts = '-Hn --include="*.vim" --include="*.txt" --include="*.php" --include="*.xml" --include="*.mkd" --include="*.hs" --include="*.js" --include="*.log" --include="*.sql" --include="*.coffee"'
let g:unite_source_grep_command = "ag"
let g:unite_source_grep_recursive_opt = ""
let g:unite_source_grep_default_opts = "--nogroup --nocolor"

let g:unite_source_grep_max_candidates = 100
" let g:unite_source_session_enable_auto_save = 1     " セッション保存

" ** }}}

" ** vimrc reading @ 2012/04/27 {{{

" TODO
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

" Enable blocked I in non-visual-block mode
NeoBundle 'kana/vim-niceblock'
xmap I  <Plug>(niceblock-I)
xmap A  <Plug>(niceblock-A)

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
" refer: http://blog.remora.cx/2012/07/using-alt-as-meta-in-vim.html
let nr=0x21 " ASCII exclamation
while nr <= 0x7E " ASCII tilde
    let c = nr2char(nr)
    if c == '|' | let nr += 1 | continue | endif
    exec printf('map <M-%s> <Esc>%s', tolower(c), tolower(c))
    exec printf('map! <M-%s> <Esc>%s', tolower(c), tolower(c))
    if (0x41 <= nr && nr <= 0x5A) || (0x61 <= nr && nr <= 0x7A)
        " ascii; uppercases are required for at least on linux
        exec printf('map <M-S-%s> <Esc>%s', tolower(c), toupper(c))
        exec printf('map! <M-S-%s> <Esc>%s', tolower(c), toupper(c))
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

call neobundle#end()

" colorscheme solarized
colorscheme tomorrow-night-bright
set background=light " by design of tomorrow theme.

" *** Enable Filetype Plugins *** {{{1
" for neobundle, these are disabled in start up section
filetype plugin indent on " XXX maybe better to disable this, testing
" for speedup
syntax on " for os x
" *** }}}

set secure

" call vimproc#popen3("")

" vim:set foldmethod=marker:
