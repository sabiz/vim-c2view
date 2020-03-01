" =============================================================================
" Filename: autoload/c2view/parse.vim
" Author: sabiz
" License: MIT License
" =============================================================================
let s:keepcpo = &cpo
set cpo&vim

function! s:parseHexColor(text)
  return matchstr(a:text, '#\(\x\{6\}\|\x\{3\}\)')
endfunction


function! c2view#parse#getColor(text) abort
    let hexColor = s:parseHexColor(a:text)
    return hexColor

endfunction


let &cpo = s:keepcpo
unlet s:keepcpo
" vim:ft=vim:fdm=marker:fmr={{{,}}}:ts=8:sw=2:sts=2:et
