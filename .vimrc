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
endif
call neobundle#rc(expand('~/.vim/bundle/'))
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

source .vim/.vimrc_editor_facilities
source .vim/.vimrc_key_mappings
source .vim/.vimrc_plugins
source .vim/.vimrc_filetypes

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
" let g:neocomplcache_ctags_arguments_list = {
"   \ 'perl' : '-R -h ".pm"'
"   \ }
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

" set scrolljump=3

NeoBundle 'rson/vim-conque'

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
  return ''
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

" NeoBundleLazy 'joonty/vdebug'
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

NeoBundleLazy 'mattn/qiita-vim'

NeoBundleLazy 'dbext.vim'
" do end matchit (%)
NeoBundle 'semmons99/vim-ruby-matchit'
" NeoBundle 'vim-rsense'
NeoBundle 'tpope/vim-endwise'
" To avoid conflict with neocomplcache; refer :help neocomplcache-faq
autocmd VimEnter * imap <silent> <CR> <C-r>=neocomplcache#smart_close_popup()<CR><Plug>my_cr_function_smartinput
call smartinput#map_to_trigger('i', '<Plug>my_cr_function_smartinput', '<Enter>', '<CR>')
NeoBundleLazy 'taichouchou2/vim-rsense'

" NeoBundle 'tpope/vim-commentary'
NeoBundle 'taka84u9/unite-git'

NeoBundleLazy 'thinca/vim-prettyprint'

NeoBundleLazy 'benmills/vimux'

let g:ConqueTerm_TERM = 'xterm-256color'

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

let g:netrw_http_cmd = 'curl -L'
let g:netrw_http_xcmd = '-o'

let g:quickrun_config = {}
let g:quickrun_config._ = {
    \ 'runmode': 'async:vimproc'
    \ }
let g:quickrun_config.markdown = {
    \ 'type': 'markdown/pandoc',
    \ 'cmdopt': '-s',
    \ 'outputter': 'browser'
    \ }

NeoBundle 'kana/vim-operator-replace'


" http://d.hatena.ne.jp/heavenshell/20110228/1298899167
augroup QuickRunUnitTest
  autocmd!
  " autocmd BufWinEnter,BufNewFile *test.php setlocal filetype=php.unit
  " autocmd BufWinEnter,BufNewFile test_*.py setlocal filetype=python.unit
  autocmd BufWinEnter,BufNewFile *.t setlocal filetype=perl
augroup END
let g:quickrun_config = {}
" let g:quickrun_config['php.unit'] = {'command': 'phpunitrunner'}
" let g:quickrun_config['python.unit'] = {'command': 'nosetests', 'cmdopt': '-s -vv'}
let g:quickrun_config['perl'] = {'command': 'prove'}

autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
" autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
" autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
" autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
endif
" let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
" let g:neocomplcache_omni_patterns.perl = '[^. *\t]\.\w*\|\h\w*::'
" autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
" autocmd FileType perl setlocal omnifunc=PerlComplete

NeoBundleLazy 'Shougo/unite-ssh'
NeoBundle 't9md/vim-unite-ack'
NeoBundle 'tsukkee/unite-help'
NeoBundle 'MultipleSearch'
NeoBundle 'airblade/vim-rooter'
NeoBundleLazy 'tsukkee/lingr-vim'

" set foldopen=all
" set foldclose=all
nmap R <Plug>(operator-replace)

NeoBundle 'thinca/vim-unite-history'
NeoBundle 't9md/vim-surround_custom_mapping'

" http://hail2u.net/blog/software/only-one-line-life-changing-vimrc-setting.html
autocmd FileType html setlocal includeexpr=substitute(v:fname,'^\\/','','') | setlocal path+=;/
autocmd FileType diff setlocal includeexpr=substitute(v:fname,'^[ab]\\/','','')

" http://stackoverflow.com/questions/7672783/how-can-i-do-something-like-gf-but-in-a-new-vertical-split
noremap <Leader>f :vertical wincmd f<CR>

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

set grepprg=ag\ -a

NeoBundle 'bkad/CamelCaseMotion'

let g:neocomplcache_min_syntax_length = 3
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

set autoread
" set modelines=0
" set display=uhex " shows unprintable chars as hex

nnoremap 0 ^
nnoremap 9 $

" ** }}}

" ** vimrc reading @ 2012/11/17 {{{

" https://github.com/yomi322/config/blob/master/dot.vimrc

" http://mattn.kaoriya.net/software/vim/20121105111112.htm
NeoBundle 'mattn/multi-vim'

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

nnoremap Y y$

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

" 自動整形の実行方法 (see also :help fo-table)
set formatoptions&
set formatoptions-=o
set formatoptions+=ctrqlm

" <C-a> や <C-x> で数値を増減させるときに8進数を無効にする
set nrformats-=octal

" コマンドライン補完の方法
set wildmode=longest:full

set helplang=ja

" 行をまたいでカーソル移動
set whichwrap+=h,l

NeoBundle 't9md/vim-quickhl'

" ** }}}

" ** vimrc reading @ 2012/01/26 {{{

set shiftround " round indent with < and >
set infercase " Ignore case on insert completion.
set fillchars="vert:\ ,fold:\ ,diff:\ "
set grepprg="ack -a"
set isfname-=%,$,@,= " filename characters for gf
" set directory=~/.vim/swap

" Set tags file.
" Don't search tags file in current directory. And search upward.
set tags& tags-=tags tags+=./tags;
if v:version < 7.3 || (v:version == 7.3 && !has('patch336'))
  " Vim's bug.
  set notagbsearch
endif

set linebreak
set showbreak=>\
set breakat=\ \	;:,!?.>

" ** }}}


" ** vimrc reading @ 2012/03/23 {{{

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

" let g:quickrun_config._ = {'runner' : 'vimproc'}

NeoBundle 'itchyny/thumbnail.vim'

" @see http://d.hatena.ne.jp/itchyny/20130319/1363690268
augroup NeoBundleChecker
    autocmd VimEnter * NeoBundleCheck
augroup END

" fugitive
nnoremap <Space>ge  :<C-u>Gedit<CR>
nnoremap <Space>gs  :<C-u>Gstatus<CR>
nnoremap <Space>gd  :<C-u>Gdiff<CR>
nnoremap <Space>gw  :<C-u>Gwrite<CR>

" gitv
NeoBundle 'gregsexton/gitv'
augroup Gitv
  autocmd!
  autocmd FileType git :setlocal foldlevel=99
augroup END
nnoremap <Space>gv  :<C-u>Gitv<CR>
nnoremap <Space>gV  :<C-u>Gitv!<CR>

" ** }}}

" ** vimrc reading @ 2012/04/06 {{{

set fileencodings=iso-2022-jp-3,iso-2022-jp,euc-jisx0213,euc-jp,utf-8,ucs-bom,euc-jp,eucjp-ms,cp932
set encoding=utf-8
set fileformats=unix,dos,mac

autocmd BufReadPost *
\   if &modifiable && !search('[^\x00-\x7F]', 'cnw')
\ |   setlocal fileencoding=
\ | endif

" ペアとなる括弧の定義
set matchpairs+=<:>

set nojoinspaces

" 改行時のコメントと、自動改行を無効化
set formatoptions-=t
set formatoptions-=c
set formatoptions-=r
set formatoptions-=o
" TODO: check m flag meaning
set formatoptions+=m
set formatoptions+=M

" 前回終了したカーソル行に移動
" autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

if 0

" 必要なときのみ、カーソル行をハイライト
" http://d.hatena.ne.jp/thinca/20090530/1243615055
augroup vimrc-auto-cursorline
    autocmd!
    autocmd CursorMoved,CursorMovedI * call Auto_cursorline('CursorMoved')
    autocmd CursorHold,CursorHoldI * call Auto_cursorline('CursorHold')
    autocmd WinEnter * call Auto_cursorline('WinEnter')
    autocmd WinLeave * call Auto_cursorline('WinLeave')

    let g:cursorline_lock = 0
    function! Auto_cursorline(event)
        if a:event ==# 'WinEnter'
            setlocal cursorline
            setlocal cursorcolumn
            let g:cursorline_lock = 2
        elseif a:event ==# 'WinLeave'
            setlocal nocursorline
            setlocal nocursorcolumn
        elseif a:event ==# 'CursorMoved'
            if g:cursorline_lock
                if 1 < g:cursorline_lock
                    let g:cursorline_lock = 1
                else
                    setlocal nocursorline
                    setlocal nocursorcolumn
                    let g:cursorline_lock = 0
                endif
            endif
        elseif a:event ==# 'CursorHold'
            setlocal cursorline
            setlocal cursorcolumn
            let g:cursorline_lock = 1
        endif
    endfunction
augroup END

endif


" setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class
" IndentGuidesEnable


" grepソース
" let g:unite_source_grep_default_opts = '-Hn --include="*.vim" --include="*.txt" --include="*.php" --include="*.xml" --include="*.mkd" --include="*.hs" --include="*.js" --include="*.log" --include="*.sql" --include="*.coffee"'
let g:unite_source_grep_command = "ag"
let g:unite_source_grep_recursive_opt = ""
let g:unite_source_grep_default_opts = "--nogroup --nocolor"

let g:unite_source_grep_max_candidates = 100
" let g:unite_source_session_enable_auto_save = 1     " セッション保存

nnoremap <silent> <Leader>u<space> :<C-u>UniteResume<CR>

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
        set transparency=10
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
