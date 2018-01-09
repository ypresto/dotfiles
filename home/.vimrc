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

" *** Utility function: DelayedExecute *** {{{

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

" *** }}}

" *** Make This Reloadable *** {{{1
" reset global autocmd
augroup VimrcGlobal
    autocmd!
    " reload when writing .vimrc
    autocmd BufWritePost $MYVIMRC,$DOTFILES_PATH/home/.vimrc source $MYVIMRC
augroup END
" *** }}}

" *** Editor Functionality *** {{{1

" ** Language / Encoding ** {{{2

try
    :language en
catch
    :language C
endtry

set spelllang=en
set helplang=ja

set encoding=utf-8
set fileencodings=iso-2022-jp-3,iso-2022-jp,utf-8,euc-jisx0213,euc-jp,ucs-bom,euc-jp,eucjp-ms,cp932
set fileformats=unix,dos,mac
autocmd VimrcGlobal BufReadPost *
\   if &modifiable && !search('[^\x00-\x7F]', 'cnw')
\ |   setlocal fileencoding=
\ | endif

let $LANG = 'en_US.UTF-8'

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
set nojoinspaces

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
if executable("ag")
    let &grepprg='ag --search-binary --nogroup -S $* /dev/null'
    set grepformat=%f:%l:%m
elseif executable("ack")
    let &grepprg='ack $* /dev/null'
    set grepformat=%f:%l:%m
endif

" Highlight
set list                    " highlight garbage characters (see below)
set listchars=tab:»-,trail:\ ,extends:»,precedes:«,nbsp:%
set display=uhex " shows unprintable chars as hex

" Misc
set nrformats-=octal  " <c-a> や <c-x> で数値を増減させるときに8進数を無効にする
set autoread
set lazyredraw

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

if exists("+colorcolumn")
    set colorcolumn=73,74,81,82 " Highlight border of 'long line'
endif

function! s:HighlightSetup()
    highlight SignColumn ctermfg=white ctermbg=black cterm=none

    highlight SpecialKey   ctermbg=black
    highlight ZenkakuSpace ctermbg=darkyellow
endfunction

augroup VimrcGlobal
    " activates custom highlight settings
    autocmd VimEnter,WinEnter,ColorScheme * call s:HighlightSetup()
    autocmd VimEnter,WinEnter,ColorScheme * call matchadd('ZenkakuSpace', '　')
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

let mapleader=" "

" Wait for slow input of key combination
set timeout
set timeoutlen=1000
" Activate alt key power on terminal,
" wait [ttimeoutlen]ms for following keys after <Esc> for Alt-* keys
set ttimeout
set ttimeoutlen=150

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

" *** }}}

" *** Plugins *** {{{1

" ** Recommended: YOU SHOULD USE THESE AND BE IMproved! *** {{{2

" autocompletes parenthesis, braces and more
NeoBundle 'kana/vim-smartinput'
"call smartinput#define_rule({ 'at': '\[\_s*\%#\_s*\]', 'char': '<Enter>', 'input': '<Enter><C-o>O' })
"call smartinput#define_rule({ 'at': '{\_s*\%#\_s*}'  , 'char': '<Enter>', 'input': '<Enter><C-o>O' })
"call smartinput#define_rule({ 'at': '(\_s*\%#\_s*)'  , 'char': '<Enter>', 'input': '<Enter><C-o>O' })

" surrounding with braces or quotes with s and S key
NeoBundle 'tpope/vim-surround'
nmap s  <Plug>Ysurroundiw
nmap S  <Plug>YsurroundiW

" open reference manual with K key
NeoBundle 'thinca/vim-ref'
let g:ref_perldoc_auto_append_f = 1

" show marker on edited lines
NeoBundle 'airblade/vim-gitgutter'
let g:gitgutter_sign_removed = "-"
map ]g :GitGutterNextHunk<CR>
map [g :GitGutterPrevHunk<CR>

" read/write by sudo with `vim sudo:file.txt`
NeoBundle 'sudo.vim'

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
let g:airline_highlighting_cache = 1
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
" for unite keymap (my own) compatibility
nmap <Leader>us :CtrlPMRU<CR>
nmap <Leader>uq :CtrlPQuickfix<CR>
nmap <Leader>ub :CtrlPBuffer<CR>

" Paste with textobj, use this instead of vi"p
NeoBundle 'kana/vim-operator-replace', {
\   'depends' : [
\       'kana/vim-operator-user',
\   ]
\}
nmap R <Plug>(operator-replace)
nnoremap <Leader>R R

" Lightweight tab key completion plugin
NeoBundle 'ajh17/VimCompletesMe'
let g:vcm_default_maps = 0
imap <Esc><Leader> <Plug>vim_completes_me_forward

" Toggle comment
NeoBundle 'tyru/caw.vim'
nmap <Esc>/ gcc
xmap <Esc>/ gccgv
imap <Esc>/ <Esc>gcca

" Multiple cursors
NeoBundle 'terryma/vim-multiple-cursors'

" extended % key matching
NeoBundle "tmhedberg/matchit"
NeoBundle 'tpope/vim-endwise' " supports ruby, vimscript

" Colorize any parenthesis or brackets
NeoBundle 'kien/rainbow_parentheses.vim'
augroup VimrcGlobal
    autocmd VimEnter * :RainbowParenthesesToggle
    autocmd Syntax * call DelayedExecute('RainbowParenthesesLoadRound')
    autocmd Syntax * call DelayedExecute('call rainbow_parentheses#activate()')
augroup END

" ** }}}

" ** textobj ** {{{2

" select range of text with only two or three keys
" For example: [ai]w
" @see http://d.hatena.ne.jp/osyo-manga/20130717/1374069987

NeoBundle 'kana/vim-textobj-user'            " framework for all belows
NeoBundle 'kana/vim-textobj-fold'            " [ai]z
NeoBundle 'kana/vim-textobj-function'        " [ai]f
NeoBundle 'kana/vim-textobj-indent'          " [ai][iI]
NeoBundle 'kana/vim-textobj-syntax'          " [ai]y
NeoBundle 'kana/vim-textobj-line'            " [ai]l

" ** }}}

" ** Misc ** {{{2

" :Rename current file on disk
NeoBundleLazy 'danro/rename.vim', { 'autoload' : { 'commands' : 'Rename' } }

" Bulk renamer
NeoBundleLazy 'renamer.vim', { 'autoload' : { 'commands' : 'Renamer' } }

" Automatic mkdir on save
NeoBundle 'travisjeffery/vim-auto-mkdir'

if 0 " NOTE: Conflicting with vim-multiple-cursors keybinding

" a.k.a. yankring
NeoBundle 'maxbrunsfeld/vim-yankstack'
let s:yankstack_bundle = neobundle#get('vim-yankstack')
function! s:yankstack_bundle.hooks.on_post_source(bundle)
    call yankstack#setup()
    nmap Y y$
endfunction

nmap <C-p> <Plug>yankstack_substitute_older_paste
nmap <C-n> <Plug>yankstack_substitute_newer_paste

let g:yankstack_yank_keys = ['c', 'C', 'd', 'D', 'x', 'X', 'y', 'Y'] " without s and S, which are mapped to vim-surround

endif

" ** }}}

" ** Color Scheme ** {{{2

NeoBundle 'chriskempson/vim-tomorrow-theme'

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

" Shell
call s:NeoBundleAutoloadFiletypes('sh', ['sh'])
call s:NeoBundleAutoloadFiletypes('fish', ['fish'])
NeoBundleLazy 'sh.vim', '', 'sh'
NeoBundleLazy 'dag/vim-fish', '', 'fish'

" VimScript
autocmd VimrcGlobal FileType vim,help set keywordprg=":help"

" http://hail2u.net/blog/software/only-one-line-life-changing-vimrc-setting.html
autocmd VimrcGlobal FileType html setlocal includeexpr=substitute(v:fname,'^\\/','','') path+=;/
autocmd VimrcGlobal FileType diff setlocal includeexpr=substitute(v:fname,'^[ab]\\/','','')

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

if 0 " Remove this if unnecessary

" Enable blocked I in non-visual-block mode
NeoBundle 'kana/vim-niceblock'
xmap I  <Plug>(niceblock-I)
xmap A  <Plug>(niceblock-A)

end

" *** }}}

" *** Debug *** {{{1

" Refer: http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
command! CurHl :echo
    \ "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
    \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
    \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"

NeoBundleLazy 'mattn/benchvimrc-vim'

" *** }}}

" *** Local Script *** {{{1
" You can put on '~/.vimlocal/*' anything you don't want to publish.
set rtp+=~/.vimlocal
if filereadable(expand('~/.vimlocal/.vimrc'))
    source $HOME/.vimlocal/.vimrc
endif
" *** }}}

call neobundle#end()

colorscheme tomorrow-night-bright
set background=light " by design of tomorrow theme.

" *** Enable Filetype Plugins *** {{{1
" for neobundle, these are disabled in start up section
filetype plugin indent on " XXX maybe better to disable this, testing
" for speedup
syntax on " for os x
" *** }}}

set secure

" vim:set foldmethod=marker:
