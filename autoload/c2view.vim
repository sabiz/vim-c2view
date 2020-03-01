" =============================================================================
" Filename: autoload/c2view.vim
" Author: sabiz
" License: MIT License
" =============================================================================
let s:keepcpo = &cpo
set cpo&vim

function! c2view#Run()
  let currentLine  = getline(".")
  let color = c2view#parse#getColor(currentLine)

  if color is# ""
    return
  endif

  if match(color, expand("<cword>")) == -1
    return
  endif

  let colorCode = c2view#color#rgbHex2Ansi(color)
  execute printf("highlight C2ViewHighLight ctermfg=%s ctermbg=%s", colorCode, colorCode)

  call popup_atcursor("     ", #{
        \ moved: 'any',
        \ highlight: 'C2ViewHighLight',
        \})
endfunction


let &cpo = s:keepcpo
unlet s:keepcpo
" vim:ft=vim:fdm=marker:fmr={{{,}}}:ts=8:sw=2:sts=2:et
