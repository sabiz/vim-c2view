" =============================================================================
" Filename: autoload/c2view.vim
" Author: sabiz
" License: MIT License
" =============================================================================
let s:keepcpo = &cpo
set cpo&vim

function! c2view#Run()
  let currentLine  = getline(".")
  let parsedLine = c2view#parse#getColor(currentLine)
  if parsedLine['type'] is# g:c2view_parsed_type_none
    return
  endif

  let cursorCol = col(".")
  if parsedLine['start'] > cursorCol || parsedLine['end'] < cursorCol
    return
  endif

  if parsedLine['type'] is# g:c2view_parsed_type_hex
    let colorCode = c2view#color#hex2Ansi(parsedLine['color'])
  elseif parsedLine['type'] is# g:c2view_parsed_type_rgb
    let colorCode = c2view#color#rgba2Ansi(parsedLine['color'])
    if colorCode == -1
      return
    endif
  elseif parsedLine['type'] is# g:c2view_parsed_type_hsl
    let colorCode = c2view#color#hsla2Ansi(parsedLine['color'])
    if colorCode == -1
       return
    endif
  else
    return
  endif
  execute printf("highlight C2ViewHighLight ctermfg=%s ctermbg=%s", colorCode, colorCode)

  call popup_atcursor("_____", #{
        \ moved: 'any',
        \ highlight: 'C2ViewHighLight',
        \})
endfunction


let &cpo = s:keepcpo
unlet s:keepcpo
" vim:ft=vim:fdm=marker:fmr={{{,}}}:ts=8:sw=2:sts=2:et
