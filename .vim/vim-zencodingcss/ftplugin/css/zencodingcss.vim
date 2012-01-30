" ZenCodingCSS
" File: zencodingcss.vim
" file created in 2010/02/18 14:28:17.
" LastUpdated :2010/02/23 11:09:54.
" Author: iNo
" WebPage: http://www.serendip.ws/
" Description: vim plugins for CSS coding with Zen Coding style.
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
" Version: 0.2
"
" Usage: See http://www.serendip.ws/software/vim-zencodingcss
"

if exists('g:loaded_zencodingcss_vim') && g:loaded_zencodingcss_vim
    finish
endif
let g:loaded_zencodingcss_vim = 1

if !exists('g:zencodingcssExecuteMapping')
    let g:zencodingcssExecuteMapping = '<c-e>'
endif

if !exists('g:zencodingcssNextMapping')
    let g:zencodingcssNextMapping = '<c-n>'
endif

if !exists('g:zencodingcssSeparation')
    let g:zencodingcssSeparation = ''
endif

if !exists('g:zencodingcssColorFormat')
    let g:zencodingcssColorFormat = '#000'
endif

if !exists('g:zencodingcssBackgroundColorFormat')
    let g:zencodingcssBackgroundColorFormat = '#FFF'
endif

if !exists('g:zencodingcssUserDict')
    let g:zencodingcssUserDict = {}
endif

exec 'nmap <buffer> ' . g:zencodingcssExecuteMapping . ' :call <SID>ZenCodingCss()<cr>'
exec 'imap <buffer> ' . g:zencodingcssExecuteMapping . ' <c-g>u<Esc>:call <SID>ZenCodingCss()<cr>'
exec 'nmap <buffer> ' . g:zencodingcssNextMapping . ' :call <SID>ZenCodingCssNext()<cr>'
exec 'imap <buffer> ' . g:zencodingcssNextMapping . ' <c-g>u<Esc>:call <SID>ZenCodingCssNext()<cr>'

let s:sp = g:zencodingcssSeparation
let s:cf = g:zencodingcssColorFormat
let s:bf = g:zencodingcssBackgroundColorFormat

" s:dict={} {{{
let s:dict = {
\               '@i'            : '@import url();',
\               '@m'            : '@media print {}',
\               '@f'            : '@font-face { font-family:'.s:sp.'; src:'.s:sp.'url(); }',
\               '!'             : '!important',
\               'exp'           : 'expression()',
\               'pos'           : 'position:'.s:sp.';',
\               'pos:s'         : 'position:'.s:sp.'static;',
\               'pos:a'         : 'position:'.s:sp.'absolute;',
\               'pos:r'         : 'position:'.s:sp.'relative;',
\               'pos:f'         : 'position:'.s:sp.'fixed;',
\               't'             : 'top:'.s:sp.';',
\               't:a'           : 'top:'.s:sp.'auto;',
\               'r'             : 'right:'.s:sp.';',
\               'r:a'           : 'right:'.s:sp.'auto;',
\               'b'             : 'bottom:'.s:sp.';',
\               'b:a'           : 'bottom:'.s:sp.'auto;',
\               'l'             : 'left:'.s:sp.';',
\               'l:a'           : 'left:'.s:sp.'auto;',
\               'z'             : 'z-index:'.s:sp.';',
\               'z:a'           : 'z-index:'.s:sp.'auto;',
\               'fl'            : 'float:'.s:sp.';',
\               'fl:n'          : 'float:'.s:sp.'none;',
\               'fl:l'          : 'float:'.s:sp.'left;',
\               'fl:r'          : 'float:'.s:sp.'right;',
\               'cl'            : 'clear:'.s:sp.';',
\               'cl:n'          : 'clear:'.s:sp.'none;',
\               'cl:l'          : 'clear:'.s:sp.'left;',
\               'cl:r'          : 'clear:'.s:sp.'right;',
\               'cl:b'          : 'clear:'.s:sp.'both;',
\               'd'             : 'display:'.s:sp.';',
\               'd:n'           : 'display:'.s:sp.'none;',
\               'd:b'           : 'display:'.s:sp.'block;',
\               'd:i'           : 'display:'.s:sp.'inline;',
\               'd:ib'          : 'display:'.s:sp.'inline-block;',
\               'd:mib'         : 'display:'.s:sp.'-moz-inline-box:;',
\               'd:mis'         : 'display:'.s:sp.'-moz-inline-stack:;',
\               'd:li'          : 'display:'.s:sp.'list-item;',
\               'd:ri'          : 'display:'.s:sp.'run-in;',
\               'd:cp'          : 'display:'.s:sp.'compact;',
\               'd:tb'          : 'display:'.s:sp.'table;',
\               'd:itb'         : 'display:'.s:sp.'inline-table;',
\               'd:tbcp'        : 'display:'.s:sp.'table-caption;',
\               'd:tbcl'        : 'display:'.s:sp.'table-column;',
\               'd:tbclg'       : 'display:'.s:sp.'table-column-group;',
\               'd:tbhg'        : 'display:'.s:sp.'table-header-group;',
\               'd:tbfg'        : 'display:'.s:sp.'table-footer-group;',
\               'd:tbr'         : 'display:'.s:sp.'table-row;',
\               'd:tbrg'        : 'display:'.s:sp.'table-row-group;',
\               'd:tbc'         : 'display:'.s:sp.'table-cell;',
\               'v'             : 'visibility:'.s:sp.';',
\               'v:v'           : 'visibility:'.s:sp.'visible;',
\               'v:h'           : 'visibility:'.s:sp.'hidden;',
\               'v:c'           : 'visibility:'.s:sp.'collapse;',
\               'ov'            : 'overflow:'.s:sp.';',
\               'ov:v'          : 'overflow:'.s:sp.'visible;',
\               'ov:h'          : 'overflow:'.s:sp.'hidden;',
\               'ov:s'          : 'overflow:'.s:sp.'scroll;',
\               'ov:a'          : 'overflow:'.s:sp.'auto;',
\               'ovx'           : 'overflow-x:'.s:sp.';',
\               'ovx:v'         : 'overflow-x:'.s:sp.'visible;',
\               'ovx:h'         : 'overflow-x:'.s:sp.'hidden;',
\               'ovx:s'         : 'overflow-x:'.s:sp.'scroll;',
\               'ovx:a'         : 'overflow-x:'.s:sp.'auto;',
\               'ovy'           : 'overflow-y:'.s:sp.';',
\               'ovy:v'         : 'overflow-y:'.s:sp.'visible;',
\               'ovy:h'         : 'overflow-y:'.s:sp.'hidden;',
\               'ovy:s'         : 'overflow-y:'.s:sp.'scroll;',
\               'ovy:a'         : 'overflow-y:'.s:sp.'auto;',
\               'ovs'           : 'overflow-style:'.s:sp.';',
\               'ovs:a'         : 'overflow-style:'.s:sp.'auto;',
\               'ovs:s'         : 'overflow-style:'.s:sp.'scrollbar;',
\               'ovs:p'         : 'overflow-style:'.s:sp.'panner;',
\               'ovs:m'         : 'overflow-style:'.s:sp.'move;',
\               'ovs:mq'        : 'overflow-style:'.s:sp.'marquee;',
\               'zoo'           : 'zoom:'.s:sp.'1;',
\               'cp'            : 'clip:'.s:sp.';',
\               'cp:a'          : 'clip:'.s:sp.'auto;',
\               'cp:r'          : 'clip:'.s:sp.'rect(0 0 0 0);',
\               'bxz'           : 'box-sizing:'.s:sp.';',
\               'bxz:cb'        : 'box-sizing:'.s:sp.'content-box;',
\               'bxz:bb'        : 'box-sizing:'.s:sp.'border-box;',
\               'bxsh'          : 'box-shadow:'.s:sp.';',
\               'bxsh:n'        : 'box-shadow:'.s:sp.'none;',
\               'bxsh+'         : 'box-shadow:'.s:sp.'0 0 0 '.s:cf.';',
\               'bxsh:w'        : '-webkit-box-shadow:'.s:sp.';',
\               'bxsh:w+'       : '-webkit-box-shadow:'.s:sp.'0 0 0 '.s:cf.';',
\               'bxsh:m'        : '-moz-box-shadow:'.s:sp.';',
\               'bxsh:m+'       : '-moz-box-shadow:'.s:sp.'0 0 0 0 '.s:cf.';',
\               'm'             : 'margin:'.s:sp.';',
\               'm:a'           : 'margin:'.s:sp.'auto;',
\               'm:0'           : 'margin:'.s:sp.'0;',
\               'm:2'           : 'margin:'.s:sp.'0 0;',
\               'm:3'           : 'margin:'.s:sp.'0 0 0;',
\               'm:4'           : 'margin:'.s:sp.'0 0 0 0;',
\               'mt'            : 'margin-top:'.s:sp.';',
\               'mt:a'          : 'margin-top:'.s:sp.'auto;',
\               'mr'            : 'margin-right:'.s:sp.';',
\               'mr:a'          : 'margin-right:'.s:sp.'auto;',
\               'mb'            : 'margin-bottom:'.s:sp.';',
\               'mb:a'          : 'margin-bottom:'.s:sp.'auto;',
\               'ml'            : 'margin-left:'.s:sp.';',
\               'ml:a'          : 'margin-left:'.s:sp.'auto;',
\               'p'             : 'padding:'.s:sp.';',
\               'p:0'           : 'padding:'.s:sp.'0;',
\               'p:2'           : 'padding:'.s:sp.'0 0;',
\               'p:3'           : 'padding:'.s:sp.'0 0 0;',
\               'p:4'           : 'padding:'.s:sp.'0 0 0 0;',
\               'pt'            : 'padding-top:'.s:sp.';',
\               'pr'            : 'padding-right:'.s:sp.';',
\               'pb'            : 'padding-bottom:'.s:sp.';',
\               'pl'            : 'padding-left:'.s:sp.';',
\               'w'             : 'width:'.s:sp.';',
\               'w:a'           : 'width:'.s:sp.'auto;',
\               'h'             : 'height:'.s:sp.';',
\               'h:a'           : 'height:'.s:sp.'auto;',
\               'maw'           : 'max-width:'.s:sp.';',
\               'maw:n'         : 'max-width:'.s:sp.'none;',
\               'mah'           : 'max-height:'.s:sp.';',
\               'mah:n'         : 'max-height:'.s:sp.'none;',
\               'miw'           : 'min-width:'.s:sp.';',
\               'mih'           : 'min-height:'.s:sp.';',
\               'o'             : 'outline:'.s:sp.';',
\               'o:n'           : 'outline:'.s:sp.'none;',
\               'o+'            : 'outline:'.s:sp.'1px solid '.s:cf.';',
\               'oo'            : 'outline-offset:'.s:sp.';',
\               'ow'            : 'outline-width:'.s:sp.';',
\               'os'            : 'outline-style:'.s:sp.';',
\               'oc'            : 'outline-color:'.s:sp.s:cf.';',
\               'oc:i'          : 'outline-color:'.s:sp.'invert;',
\               'bd'            : 'border:'.s:sp.';',
\               'bd:n'          : 'border:'.s:sp.'none;',
\               'bd+'           : 'border:'.s:sp.'1px solid '.s:cf.';',
\               'bdbk'          : 'border-break:'.s:sp.';',
\               'bdbk:c'        : 'border-break:'.s:sp.'close;',
\               'bdcl'          : 'border-collapse:'.s:sp.';',
\               'bdcl:c'        : 'border-collapse:'.s:sp.'collapse;',
\               'bdcl:s'        : 'border-collapse:'.s:sp.'separate;',
\               'bdc'           : 'border-color:'.s:sp.s:cf.';',
\               'bdi'           : 'border-image:'.s:sp.'url();',
\               'bdi:n'         : 'border-image:'.s:sp.'none;',
\               'bdi:w'         : '-webkit-border-image:'.s:sp.';',
\               'bdi:w+'        : '-webkit-border-image:'.s:sp.'url() 0 0 0 0 stretch stretch;',
\               'bdi:m'         : '-moz-border-image:'.s:sp.';',
\               'bdi:m+'        : '-moz-border-image:'.s:sp.'url() 0 0 0 0 stretch stretch;',
\               'bdti'          : 'border-top-image:'.s:sp.'url();',
\               'bdti:n'        : 'border-top-image:'.s:sp.'none;',
\               'bdri'          : 'border-right-image:'.s:sp.'url();',
\               'bdri:n'        : 'border-right-image:'.s:sp.'none;',
\               'bdbi'          : 'border-bottom-image:'.s:sp.'url();',
\               'bdbi:n'        : 'border-bottom-image:'.s:sp.'none;',
\               'bdli'          : 'border-left-image:'.s:sp.'url();',
\               'bdli:n'        : 'border-left-image:'.s:sp.'none;',
\               'bdci'          : 'border-corner-image:'.s:sp.'url();',
\               'bdci:n'        : 'border-corner-image:'.s:sp.'none;',
\               'bdci:c'        : 'border-corner-image:'.s:sp.'continue;',
\               'bdtli'         : 'border-top-left-image:'.s:sp.'url();',
\               'bdtli:n'       : 'border-top-left-image:'.s:sp.'none;',
\               'bdtli:c'       : 'border-top-left-image:'.s:sp.'continue;',
\               'bdtri'         : 'border-top-right-image:'.s:sp.'url();',
\               'bdtri:n'       : 'border-top-right-image:'.s:sp.'none;',
\               'bdtri:c'       : 'border-top-right-image:'.s:sp.'continue;',
\               'bdbri'         : 'border-bottom-right-image:'.s:sp.'url();',
\               'bdbri:n'       : 'border-bottom-right-image:'.s:sp.'none;',
\               'bdbri:c'       : 'border-bottom-right-image:'.s:sp.'continue;',
\               'bdbli'         : 'border-bottom-left-image:'.s:sp.'url();',
\               'bdbli:n'       : 'border-bottom-left-image:'.s:sp.'none;',
\               'bdbli:c'       : 'border-bottom-left-image:'.s:sp.'continue;',
\               'bdf'           : 'border-fit:'.s:sp.';',
\               'bdf:c'         : 'border-fit:'.s:sp.'clip;',
\               'bdf:r'         : 'border-fit:'.s:sp.'repeat;',
\               'bdf:sc'        : 'border-fit:'.s:sp.'scale;',
\               'bdf:st'        : 'border-fit:'.s:sp.'stretch;',
\               'bdf:ow'        : 'border-fit:'.s:sp.'overwrite;',
\               'bdf:of'        : 'border-fit:'.s:sp.'overflow;',
\               'bdf:sp'        : 'border-fit:'.s:sp.'space;',
\               'bdlt'          : 'border-length:'.s:sp.';',
\               'bdlt:a'        : 'border-length:'.s:sp.'auto;',
\               'bdsp'          : 'border-spacing:'.s:sp.';',
\               'bds'           : 'border-style:'.s:sp.';',
\               'bds:n'         : 'border-style:'.s:sp.'none;',
\               'bds:h'         : 'border-style:'.s:sp.'hidden;',
\               'bds:dt'        : 'border-style:'.s:sp.'dotted;',
\               'bds:ds'        : 'border-style:'.s:sp.'dashed;',
\               'bds:s'         : 'border-style:'.s:sp.'solid;',
\               'bds:db'        : 'border-style:'.s:sp.'double;',
\               'bds:dtds'      : 'border-style:'.s:sp.'dot-dash;',
\               'bds:dtdtds'    : 'border-style:'.s:sp.'dot-dot-dash;',
\               'bds:w'         : 'border-style:'.s:sp.'wave;',
\               'bds:g'         : 'border-style:'.s:sp.'groove;',
\               'bds:r'         : 'border-style:'.s:sp.'ridge;',
\               'bds:i'         : 'border-style:'.s:sp.'inset;',
\               'bds:o'         : 'border-style:'.s:sp.'outset;',
\               'bdw'           : 'border-width:'.s:sp.';',
\               'bdt'           : 'border-top:'.s:sp.';',
\               'bdt:n'         : 'border-top:'.s:sp.'none;',
\               'bdt+'          : 'border-top:'.s:sp.'1px solid '.s:cf.';',
\               'bdtw'          : 'border-top-width:'.s:sp.';',
\               'bdts'          : 'border-top-style:'.s:sp.';',
\               'bdts:n'        : 'border-top-style:'.s:sp.'none;',
\               'bdtc'          : 'border-top-color:'.s:sp.s:cf.';',
\               'bdr'           : 'border-right:'.s:sp.';',
\               'bdr:n'         : 'border-right:'.s:sp.'none;',
\               'bdr+'          : 'border-right:'.s:sp.'1px solid '.s:cf.';',
\               'bdrw'          : 'border-right-width:'.s:sp.';',
\               'bdrs'          : 'border-right-style:'.s:sp.';',
\               'bdrs:n'        : 'border-right-style:'.s:sp.'none;',
\               'bdrc'          : 'border-right-color:'.s:sp.s:cf.';',
\               'bdb'           : 'border-bottom:'.s:sp.';',
\               'bdb:n'         : 'border-bottom:'.s:sp.'none;',
\               'bdb+'          : 'border-bottom:'.s:sp.'1px solid '.s:cf.';',
\               'bdbw'          : 'border-bottom-width:'.s:sp.';',
\               'bdbs'          : 'border-bottom-style:'.s:sp.';',
\               'bdbs:n'        : 'border-bottom-style:'.s:sp.'none;',
\               'bdbc'          : 'border-bottom-color:'.s:sp.s:cf.';',
\               'bdl'           : 'border-left:'.s:sp.';',
\               'bdl:n'         : 'border-left:'.s:sp.'none;',
\               'bdl+'          : 'border-left:'.s:sp.'1px solid '.s:cf.';',
\               'bdlw'          : 'border-left-width:'.s:sp.';',
\               'bdls'          : 'border-left-style:'.s:sp.';',
\               'bdls:n'        : 'border-left-style:'.s:sp.'none;',
\               'bdlc'          : 'border-left-color:'.s:sp.s:cf.';',
\               'bdrz'          : 'border-radius:'.s:sp.';',
\               'bdrz:w'        : '-webkit-border-radius:'.s:sp.';',
\               'bdrz:m'        : '-moz-border-radius:'.s:sp.';',
\               'bdtrrz'        : 'border-top-right-radius:'.s:sp.';',
\               'bdtlrz'        : 'border-top-left-radius:'.s:sp.';',
\               'bdbrrz'        : 'border-bottom-right-radius:'.s:sp.';',
\               'bdblrz'        : 'border-bottom-left-radius:'.s:sp.';',
\               'bg'            : 'background:'.s:sp.';',
\               'bg:n'          : 'background:'.s:sp.'none;',
\               'bg+'           : 'background:'.s:sp.s:bf.' url() 0 0 no-repeat;',
\               'bg:ie'         : 'filter:'.s:sp.'progid:DXImageTransform.Microsoft.AlphaImageLoader(src='''',sizingMethod=''crop'');',
\               'bgc'           : 'background-color:'.s:sp.s:bf.';',
\               'bgc:t'         : 'background-color:'.s:sp.'transparent;',
\               'bgi'           : 'background-image:'.s:sp.'url();',
\               'bgi:n'         : 'background-image:'.s:sp.'none;',
\               'bgr'           : 'background-repeat:'.s:sp.';',
\               'bgr:r'         : 'background-repeat:'.s:sp.'repeat;',
\               'bgr:x'         : 'background-repeat:'.s:sp.'repeat-x;',
\               'bgr:y'         : 'background-repeat:'.s:sp.'repeat-y;',
\               'bgr:n'         : 'background-repeat:'.s:sp.'no-repeat;',
\               'bga'           : 'background-attachment:'.s:sp.';',
\               'bga:f'         : 'background-attachment:'.s:sp.'fixed;',
\               'bga:s'         : 'background-attachment:'.s:sp.'scroll;',
\               'bgp'           : 'background-position:'.s:sp.'0 0;',
\               'bgpx'          : 'background-position-x:'.s:sp.';',
\               'bgpy'          : 'background-position-y:'.s:sp.';',
\               'bgbk'          : 'background-break:'.s:sp.';',
\               'bgbk:bb'       : 'background-break:'.s:sp.'bounding-box;',
\               'bgbk:eb'       : 'background-break:'.s:sp.'each-box;',
\               'bgbk:c'        : 'background-break:'.s:sp.'continuous;',
\               'bgcp'          : 'background-clip:'.s:sp.';',
\               'bgcp:bb'       : 'background-clip:'.s:sp.'border-box;',
\               'bgcp:pb'       : 'background-clip:'.s:sp.'padding-box;',
\               'bgcp:cb'       : 'background-clip:'.s:sp.'content-box;',
\               'bgcp:nc'       : 'background-clip:'.s:sp.'no-clip;',
\               'bgo'           : 'background-origin:'.s:sp.';',
\               'bgo:pb'        : 'background-origin:'.s:sp.'padding-box;',
\               'bgo:bb'        : 'background-origin:'.s:sp.'border-box;',
\               'bgo:cb'        : 'background-origin:'.s:sp.'content-box;',
\               'bgz'           : 'background-size:'.s:sp.';',
\               'bgz:a'         : 'background-size:'.s:sp.'auto;',
\               'bgz:ct'        : 'background-size:'.s:sp.'contain;',
\               'bgz:cv'        : 'background-size:'.s:sp.'cover;',
\               'c'             : 'color:'.s:sp.s:cf.';',
\               'tbl'           : 'table-layout:'.s:sp.';',
\               'tbl:a'         : 'table-layout:'.s:sp.'auto;',
\               'tbl:f'         : 'table-layout:'.s:sp.'fixed;',
\               'cps'           : 'caption-side:'.s:sp.';',
\               'cps:t'         : 'caption-side:'.s:sp.'top;',
\               'cps:b'         : 'caption-side:'.s:sp.'bottom;',
\               'ec'            : 'empty-cells:'.s:sp.';',
\               'ec:s'          : 'empty-cells:'.s:sp.'show;',
\               'ec:h'          : 'empty-cells:'.s:sp.'hide;',
\               'lis'           : 'list-style:'.s:sp.';',
\               'lis:n'         : 'list-style:'.s:sp.'none;',
\               'lisp'          : 'list-style-position:'.s:sp.';',
\               'lisp:i'        : 'list-style-position:'.s:sp.'inside;',
\               'lisp:o'        : 'list-style-position:'.s:sp.'outside;',
\               'list'          : 'list-style-type:'.s:sp.';',
\               'list:n'        : 'list-style-type:'.s:sp.'none;',
\               'list:d'        : 'list-style-type:'.s:sp.'disc;',
\               'list:c'        : 'list-style-type:'.s:sp.'circle;',
\               'list:s'        : 'list-style-type:'.s:sp.'square;',
\               'list:dc'       : 'list-style-type:'.s:sp.'decimal;',
\               'list:dclz'     : 'list-style-type:'.s:sp.'decimal-leading-zero;',
\               'list:lr'       : 'list-style-type:'.s:sp.'lower-roman;',
\               'list:ur'       : 'list-style-type:'.s:sp.'upper-roman;',
\               'lisi'          : 'list-style-image:'.s:sp.';',
\               'lisi:n'        : 'list-style-image:'.s:sp.'none;',
\               'q'             : 'quotes:'.s:sp.';',
\               'q:n'           : 'quotes:'.s:sp.'none;',
\               'q:ru'          : 'quotes:'.s:sp.'''\00AB'' ''\00BB'' ''\201E'' ''\201C'';',
\               'q:en'          : 'quotes:'.s:sp.'''\201C'' ''\201D'' ''\2018'' ''\2019'';',
\               'ct'            : 'content:'.s:sp.';',
\               'ct:n'          : 'content:'.s:sp.'normal;',
\               'ct:oq'         : 'content:'.s:sp.'open-quote;',
\               'ct:noq'        : 'content:'.s:sp.'no-open-quote;',
\               'ct:cq'         : 'content:'.s:sp.'close-quote;',
\               'ct:ncq'        : 'content:'.s:sp.'no-close-quote;',
\               'ct:a'          : 'content:'.s:sp.'attr();',
\               'ct:c'          : 'content:'.s:sp.'counter();',
\               'ct:cs'         : 'content:'.s:sp.'counters();',
\               'coi'           : 'counter-increment:'.s:sp.';',
\               'cor'           : 'counter-reset:'.s:sp.';',
\               'va'            : 'vertical-align:'.s:sp.';',
\               'va:sup'        : 'vertical-align:'.s:sp.'super;',
\               'va:t'          : 'vertical-align:'.s:sp.'top;',
\               'va:tt'         : 'vertical-align:'.s:sp.'text-top;',
\               'va:m'          : 'vertical-align:'.s:sp.'middle;',
\               'va:bl'         : 'vertical-align:'.s:sp.'baseline;',
\               'va:b'          : 'vertical-align:'.s:sp.'bottom;',
\               'va:tb'         : 'vertical-align:'.s:sp.'text-bottom;',
\               'va:sub'        : 'vertical-align:'.s:sp.'sub;',
\               'ta'            : 'text-align:'.s:sp.';',
\               'ta:l'          : 'text-align:'.s:sp.'left;',
\               'ta:c'          : 'text-align:'.s:sp.'center;',
\               'ta:r'          : 'text-align:'.s:sp.'right;',
\               'ta:j'          : 'text-align:'.s:sp.'justify;',
\               'tal'           : 'text-align-last:'.s:sp.';',
\               'tal:a'         : 'text-align-last:'.s:sp.'auto;',
\               'tal:l'         : 'text-align-last:'.s:sp.'left;',
\               'tal:c'         : 'text-align-last:'.s:sp.'center;',
\               'tal:r'         : 'text-align-last:'.s:sp.'right;',
\               'td'            : 'text-decoration:'.s:sp.';',
\               'td:n'          : 'text-decoration:'.s:sp.'none;',
\               'td:o'          : 'text-decoration:'.s:sp.'overline;',
\               'td:l'          : 'text-decoration:'.s:sp.'line-through;',
\               'td:u'          : 'text-decoration:'.s:sp.'underline;',
\               'te'            : 'text-emphasis:'.s:sp.';',
\               'te:n'          : 'text-emphasis:'.s:sp.'none;',
\               'te:ac'         : 'text-emphasis:'.s:sp.'accent;',
\               'te:dt'         : 'text-emphasis:'.s:sp.'dot;',
\               'te:c'          : 'text-emphasis:'.s:sp.'circle;',
\               'te:ds'         : 'text-emphasis:'.s:sp.'disc;',
\               'te:b'          : 'text-emphasis:'.s:sp.'before;',
\               'te:a'          : 'text-emphasis:'.s:sp.'after;',
\               'th'            : 'text-height:'.s:sp.';',
\               'th:a'          : 'text-height:'.s:sp.'auto;',
\               'th:f'          : 'text-height:'.s:sp.'font-size;',
\               'th:t'          : 'text-height:'.s:sp.'text-size;',
\               'th:m'          : 'text-height:'.s:sp.'max-size;',
\               'ti'            : 'text-indent:'.s:sp.';',
\               'ti:-'          : 'text-indent:'.s:sp.'-9999px;',
\               'tj'            : 'text-justify:'.s:sp.';',
\               'tj:a'          : 'text-justify:'.s:sp.'auto;',
\               'tj:iw'         : 'text-justify:'.s:sp.'inter-word;',
\               'tj:ii'         : 'text-justify:'.s:sp.'inter-ideograph;',
\               'tj:ic'         : 'text-justify:'.s:sp.'inter-cluster;',
\               'tj:d'          : 'text-justify:'.s:sp.'distribute;',
\               'tj:k'          : 'text-justify:'.s:sp.'kashida;',
\               'tj:t'          : 'text-justify:'.s:sp.'tibetan;',
\               'to'            : 'text-outline:'.s:sp.';',
\               'to:n'          : 'text-outline:'.s:sp.'none;',
\               'to+'           : 'text-outline:'.s:sp.'0 0 '.s:cf.';',
\               'tr'            : 'text-replace:'.s:sp.';',
\               'tr:n'          : 'text-replace:'.s:sp.'none;',
\               'tt'            : 'text-transform:'.s:sp.';',
\               'tt:n'          : 'text-transform:'.s:sp.'none;',
\               'tt:u'          : 'text-transform:'.s:sp.'uppercase;',
\               'tt:c'          : 'text-transform:'.s:sp.'capitalize;',
\               'tt:l'          : 'text-transform:'.s:sp.'lowercase;',
\               'tw'            : 'text-wrap:'.s:sp.';',
\               'tw:n'          : 'text-wrap:'.s:sp.'normal;',
\               'tw:no'         : 'text-wrap:'.s:sp.'none;',
\               'tw:u'          : 'text-wrap:'.s:sp.'unrestricted;',
\               'tw:s'          : 'text-wrap:'.s:sp.'suppress;',
\               'tsh'           : 'text-shadow:'.s:sp.';',
\               'tsh:n'         : 'text-shadow:'.s:sp.'none;',
\               'tsh+'          : 'text-shadow:'.s:sp.'0 0 0 '.s:cf.';',
\               'lh'            : 'line-height:'.s:sp.';',
\               'whs'           : 'white-space:'.s:sp.';',
\               'whs:n'         : 'white-space:'.s:sp.'normal;',
\               'whs:p'         : 'white-space:'.s:sp.'pre;',
\               'whs:nw'        : 'white-space:'.s:sp.'nowrap;',
\               'whs:pw'        : 'white-space:'.s:sp.'pre-wrap;',
\               'whs:pl'        : 'white-space:'.s:sp.'pre-line;',
\               'whsc'          : 'white-space-collapse:'.s:sp.';',
\               'whsc:n'        : 'white-space-collapse:'.s:sp.'normal;',
\               'whsc:k'        : 'white-space-collapse:'.s:sp.'keep-all;',
\               'whsc:l'        : 'white-space-collapse:'.s:sp.'loose;',
\               'whsc:bs'       : 'white-space-collapse:'.s:sp.'break-strict;',
\               'whsc:ba'       : 'white-space-collapse:'.s:sp.'break-all;',
\               'wob'           : 'word-break:'.s:sp.';',
\               'wob:n'         : 'word-break:'.s:sp.'normal;',
\               'wob:k'         : 'word-break:'.s:sp.'keep-all;',
\               'wob:l'         : 'word-break:'.s:sp.'loose;',
\               'wob:bs'        : 'word-break:'.s:sp.'break-strict;',
\               'wob:ba'        : 'word-break:'.s:sp.'break-all;',
\               'wos'           : 'word-spacing:'.s:sp.';',
\               'wow'           : 'word-wrap:'.s:sp.';',
\               'wow:n'         : 'word-wrap:'.s:sp.'normal;',
\               'wow:no'        : 'word-wrap:'.s:sp.'none;',
\               'wow:u'         : 'word-wrap:'.s:sp.'unrestricted;',
\               'wow:s'         : 'word-wrap:'.s:sp.'suppress;',
\               'lts'           : 'letter-spacing:'.s:sp.';',
\               'f'             : 'font:'.s:sp.';',
\               'f+'            : 'font:'.s:sp.'1em Arial,sans-serif;',
\               'fw'            : 'font-weight:'.s:sp.';',
\               'fw:n'          : 'font-weight:'.s:sp.'normal;',
\               'fw:b'          : 'font-weight:'.s:sp.'bold;',
\               'fw:br'         : 'font-weight:'.s:sp.'bolder;',
\               'fw:lr'         : 'font-weight:'.s:sp.'lighter;',
\               'fs'            : 'font-style:'.s:sp.';',
\               'fs:n'          : 'font-style:'.s:sp.'normal;',
\               'fs:i'          : 'font-style:'.s:sp.'italic;',
\               'fs:o'          : 'font-style:'.s:sp.'oblique;',
\               'fv'            : 'font-variant:'.s:sp.';',
\               'fv:n'          : 'font-variant:'.s:sp.'normal;',
\               'fv:sc'         : 'font-variant:'.s:sp.'small-caps;',
\               'fz'            : 'font-size:'.s:sp.';',
\               'fza'           : 'font-size-adjust:'.s:sp.';',
\               'fza:n'         : 'font-size-adjust:'.s:sp.'none;',
\               'ff'            : 'font-family:'.s:sp.';',
\               'ff:s'          : 'font-family:'.s:sp.'Georgia,''Times New Roman'',serif;',
\               'ff:ss'         : 'font-family:'.s:sp.'Helvetica,Arial,sans-serif;',
\               'ff:c'          : 'font-family:'.s:sp.'''Monotype Corsiva'',''Comic Sans MS'',cursive;',
\               'ff:f'          : 'font-family:'.s:sp.'Capitals,Impact,fantasy;',
\               'ff:m'          : 'font-family:'.s:sp.'Monaco,''Courier New'',monospace;',
\               'fef'           : 'font-effect:'.s:sp.';',
\               'fef:n'         : 'font-effect:'.s:sp.'none;',
\               'fef:eg'        : 'font-effect:'.s:sp.'engrave;',
\               'fef:eb'        : 'font-effect:'.s:sp.'emboss;',
\               'fef:o'         : 'font-effect:'.s:sp.'outline;',
\               'fem'           : 'font-emphasize:'.s:sp.';',
\               'femp'          : 'font-emphasize-position:'.s:sp.';',
\               'femp:b'        : 'font-emphasize-position:'.s:sp.'before;',
\               'femp:a'        : 'font-emphasize-position:'.s:sp.'after;',
\               'fems'          : 'font-emphasize-style:'.s:sp.';',
\               'fems:n'        : 'font-emphasize-style:'.s:sp.'none;',
\               'fems:ac'       : 'font-emphasize-style:'.s:sp.'accent;',
\               'fems:dt'       : 'font-emphasize-style:'.s:sp.'dot;',
\               'fems:c'        : 'font-emphasize-style:'.s:sp.'circle;',
\               'fems:ds'       : 'font-emphasize-style:'.s:sp.'disc;',
\               'fsm'           : 'font-smooth:'.s:sp.';',
\               'fsm:a'         : 'font-smooth:'.s:sp.'auto;',
\               'fsm:n'         : 'font-smooth:'.s:sp.'never;',
\               'fsm:aw'        : 'font-smooth:'.s:sp.'always;',
\               'fst'           : 'font-stretch:'.s:sp.';',
\               'fst:n'         : 'font-stretch:'.s:sp.'normal;',
\               'fst:uc'        : 'font-stretch:'.s:sp.'ultra-condensed;',
\               'fst:ec'        : 'font-stretch:'.s:sp.'extra-condensed;',
\               'fst:c'         : 'font-stretch:'.s:sp.'condensed;',
\               'fst:sc'        : 'font-stretch:'.s:sp.'semi-condensed;',
\               'fst:se'        : 'font-stretch:'.s:sp.'semi-expanded;',
\               'fst:e'         : 'font-stretch:'.s:sp.'expanded;',
\               'fst:ee'        : 'font-stretch:'.s:sp.'extra-expanded;',
\               'fst:ue'        : 'font-stretch:'.s:sp.'ultra-expanded;',
\               'op'            : 'opacity:'.s:sp.';',
\               'op:ie'         : 'filter:'.s:sp.'progid:DXImageTransform.Microsoft.Alpha(Opacity=100);',
\               'op:ms'         : '-ms-filter:'.s:sp.'progid:DXImageTransform.Microsoft.Alpha(Opacity=100);',
\               'rz'            : 'resize:'.s:sp.';',
\               'rz:n'          : 'resize:'.s:sp.'none;',
\               'rz:b'          : 'resize:'.s:sp.'both;',
\               'rz:h'          : 'resize:'.s:sp.'horizontal;',
\               'rz:v'          : 'resize:'.s:sp.'vertical;',
\               'cur'           : 'cursor:'.s:sp.';',
\               'cur:a'         : 'cursor:'.s:sp.'auto;',
\               'cur:d'         : 'cursor:'.s:sp.'default;',
\               'cur:c'         : 'cursor:'.s:sp.'crosshair;',
\               'cur:ha'        : 'cursor:'.s:sp.'hand;',
\               'cur:he'        : 'cursor:'.s:sp.'help;',
\               'cur:m'         : 'cursor:'.s:sp.'move;',
\               'cur:p'         : 'cursor:'.s:sp.'pointer;',
\               'cur:t'         : 'cursor:'.s:sp.'text;',
\               'pgbb'          : 'page-break-before:'.s:sp.';',
\               'pgbb:a'        : 'page-break-before:'.s:sp.'auto;',
\               'pgbb:aw'       : 'page-break-before:'.s:sp.'always;',
\               'pgbb:l'        : 'page-break-before:'.s:sp.'left;',
\               'pgbb:r'        : 'page-break-before:'.s:sp.'right;',
\               'pgbi'          : 'page-break-inside:'.s:sp.';',
\               'pgbi:a'        : 'page-break-inside:'.s:sp.'auto;',
\               'pgbi:av'       : 'page-break-inside:'.s:sp.'avoid;',
\               'pgba'          : 'page-break-after:'.s:sp.';',
\               'pgba:a'        : 'page-break-after:'.s:sp.'auto;',
\               'pgba:aw'       : 'page-break-after:'.s:sp.'always;',
\               'pgba:l'        : 'page-break-after:'.s:sp.'left;',
\               'pgba:r'        : 'page-break-after:'.s:sp.'right;',
\               'orp'           : 'orphans:'.s:sp.';',
\               'wid'           : 'widows:'.s:sp.';'
\}
" }}}

let s:is_first_label = 1

function! s:ZenCodingCss()
    let s:is_first_label = 1
    let line = getline('.')
    let cursor_pos = col('.')
    let token = s:GetToken(line, cursor_pos)

    if has_key(s:dict, token[1])
        :call setline('.', token[0].s:dict[token[1]].token[2])
    endif
    call s:ZenCodingCssNext()
endfunction

function! s:ZenCodingCssNext()
    let n = search('\(:'.s:sp.';\)\|\(()\)\|\(|\)\|\(\\\)\|^\(\s*\)$', 'Wp', line('.'))
    if n == 2
        execute 'normal f;'
        startinsert
    elseif n == 3
        execute 'normal f)'
        startinsert
    elseif n == 4
        execute 'normal x'
        startinsert
    elseif n == 5
        if s:is_first_label == 1
            execute 'normal F:'
        else
            execute 'normal df\'
            startinsert
        endif
    elseif n == 6
        startinsert!
    else
        execute 'normal $'
    endif

    let s:is_first_label = 0
endfunction

function! s:GetToken(line, cursor_pos)
    let token = ''
    let pos = a:cursor_pos - 1
    while pos >= 0 && a:line[pos] !=? ' '
        let token = a:line[pos] . token
        let pos = pos - 1
    endwhile
    let before_token = strpart(a:line, 0, pos+1)

    let pos = a:cursor_pos
    let line_length = strlen(a:line)
    while pos < line_length - 1 && a:line[pos] !=? ' '
        let token = token . a:line[pos]
        let pos = pos + 1
    endwhile
    let after_token = strpart(a:line, pos, line_length-a:cursor_pos)

    return [before_token, token, after_token]
endfunction

function! s:MergeDict()
    let keylist = keys(g:zencodingcssUserDict)
    for key in keylist
        let s:dict[key] = g:zencodingcssUserDict[key]
    endfor
endfunction

if exists('g:zencodingcssUserDict')
    call s:MergeDict()
endif

" vim:fdl=0 fdm=marker:ts=4 sw=4 sts=0:
