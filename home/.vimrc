" **
" * .vimrc for yuya_presto
" *
" * Please checkout 'Plugins' section for recommended plugins.
" *

" *** Start up *** {{{1

"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state(expand('~/.vim/dein'))
  call dein#begin(expand('~/.vim/dein'))

  " Let dein manage dein
  " Required:
  call dein#add(expand('~/.vim/dein/repos/github.com/Shougo/dein.vim'))

  call dein#add('kana/vim-smartinput')
  call dein#add('tpope/vim-surround')
  call dein#add('thinca/vim-ref')
  call dein#add('airblade/vim-gitgutter')
  call dein#add('vim-scripts/sudo.vim')
  call dein#add('scrooloose/syntastic')
  call dein#add('thinca/vim-visualstar')
  call dein#add('tpope/vim-unimpaired')
  call dein#add('tpope/vim-repeat')
  call dein#add('rhysd/accelerated-jk')
  call dein#add('bling/vim-airline')
  call dein#add('kien/ctrlp.vim')
  call dein#add('ajh17/VimCompletesMe')
  call dein#add('tyru/caw.vim')
  call dein#add('terryma/vim-multiple-cursors')
  call dein#add('tmhedberg/matchit')
  call dein#add('tpope/vim-endwise') " supports ruby, vimscript
  call dein#add('kien/rainbow_parentheses.vim')
  call dein#add('kana/vim-operator-user')
  call dein#add('kana/vim-operator-replace')
  call dein#add('kana/vim-textobj-user')     " framework for all belows
  call dein#add('kana/vim-textobj-fold')     " [ai]z
  call dein#add('kana/vim-textobj-function') " [ai]f
  call dein#add('kana/vim-textobj-indent')   " [ai][iI]
  call dein#add('kana/vim-textobj-syntax')   " [ai]y
  call dein#add('kana/vim-textobj-line')     " [ai]l
  call dein#add('editorconfig/editorconfig-vim')
  call dein#add('travisjeffery/vim-auto-mkdir')
  " call dein#add('maxbrunsfeld/vim-yankstack') " NOTE: Conflicting with vim-multiple-cursors keybinding
  call dein#add('joshdick/onedark.vim')
  call dein#add('danro/rename.vim', { 'on_cmd' : 'Rename' })
  call dein#add('vim-scripts/renamer.vim', { 'on_cmd' : 'Renamer' })
  call dein#add('vim-scripts/sh.vim', { 'on_ft': 'sh' })
  " call dein#add('mattn/benchvimrc-vim')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

"End dein Scripts-------------------------

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
    highlight SpecialKey   ctermbg=darkyellow guibg=darkyellow
    highlight ZenkakuSpace ctermbg=darkyellow guibg=darkyellow
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

" NOTE: Improves start up performance..!
" shell with slow start up time causes a performance issue around vim's system() func.
" https://github.com/dag/vim-fish/issues/34#issuecomment-356347752
set shell=sh

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
nmap <silent> <C-c> :nohlsearch<CR>:set nopaste<CR><Esc>

" swap g[jk] (move displayed line) and [jk] (move original line)
noremap <silent> j gj
noremap <silent> gj j
noremap <silent> k gk
noremap <silent> gk k
" inoremap <silent> <C-[> <Esc>

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

nnoremap <C-w><C-q> <C-w>q

" QuickFix Toggle
nmap <silent> <leader>l :call ToggleList("Location List", 'l')<CR>
nmap <silent> <leader>q :call ToggleList("Quickfix List", 'c')<CR>

" *** }}}

" *** Plugin Config and Keybindings *** {{{

" vim-surround
nmap s  <Plug>Ysurroundiw
nmap S  <Plug>YsurroundiW
vmap s  <Plug>VSurround

let g:gitgutter_sign_removed = "-"
map ]g :GitGutterNextHunk<CR>
map [g :GitGutterPrevHunk<CR>

let g:syntastic_error_symbol='E>'
let g:syntastic_warning_symbol='W>'
let g:syntastic_always_populate_loc_list=1
nmap <Leader>s :SyntasticCheck<CR>

nmap j <Plug>(accelerated_jk_gj)
nmap k <Plug>(accelerated_jk_gk)
let g:accelerated_jk_acceleration_table = [10,20,15,15]

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

" vim-operator-replace
nmap R <Plug>(operator-replace)
nnoremap <Leader>R R

" VimCompletesMe
let g:vcm_default_maps = 0
imap <Esc><Leader> <Plug>vim_completes_me_forward

" Toggle comment with caw.vim
nmap <Esc>/ gcc
xmap <Esc>/ gccgv
imap <Esc>/ <Esc>gcca

" rainbow_parentheses.vim
augroup VimrcGlobal
    autocmd VimEnter * :RainbowParenthesesToggle
    autocmd Syntax * call DelayedExecute('RainbowParenthesesLoadRound')
    autocmd Syntax * call DelayedExecute('call rainbow_parentheses#activate()')
augroup END

" NeoBundle 'maxbrunsfeld/vim-yankstack'
" let s:yankstack_bundle = neobundle#get('vim-yankstack')
" function! s:yankstack_bundle.hooks.on_post_source(bundle)
"     call yankstack#setup()
"     nmap Y y$
" endfunction
"
" nmap <C-p> <Plug>yankstack_substitute_older_paste
" nmap <C-n> <Plug>yankstack_substitute_newer_paste
"
" let g:yankstack_yank_keys = ['c', 'C', 'd', 'D', 'x', 'X', 'y', 'Y'] " without s and S, which are mapped to vim-surround

" *** }}}

" *** Filetypes *** {{{1

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

" *** Debug *** {{{1

" Refer: http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
command! CurHl :echo
    \ "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
    \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
    \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"

" NeoBundleLazy 'mattn/benchvimrc-vim'

" *** }}}

" *** Local Script *** {{{1
" You can put on '~/.vimlocal/*' anything you don't want to publish.
set rtp+=~/.vimlocal
if filereadable(expand('~/.vimlocal/.vimrc'))
    source $HOME/.vimlocal/.vimrc
endif
" *** }}}

" NeoBundle 'joshdick/onedark.vim'

if (has("autocmd"))
  augroup colorextend
    autocmd!
    " For terminal with transparent or one dark themed colors.
    autocmd ColorScheme * call onedark#extend_highlight("Normal", { "bg": { "cterm": 'NONE' } })
  augroup END
endif

colorscheme onedark
set background=dark
if has('termguicolors')
    set termguicolors
endif

set secure

" vim:set foldmethod=marker:
