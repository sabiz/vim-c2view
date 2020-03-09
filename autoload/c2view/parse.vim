" =============================================================================
" Filename: autoload/c2view/parse.vim
" Author: sabiz
" License: MIT License
" =============================================================================
let s:keepcpo = &cpo
set cpo&vim

let g:c2view_parsed_type_hex = 'HEX'
let g:c2view_parsed_type_rgb = 'RGB'
let g:c2view_parsed_type_hsl = 'HSL'
let g:c2view_parsed_type_none = 'NONE'

function! s:parseHexColor(text)
  return matchstrpos(a:text, '#\(\x\{8\}\|\x\{6\}\|\x\{4\}\|\x\{3\}\)')
endfunction

function! s:parseRgbColor(text)
  " 0 - 255
  let numberRegex = '^\(255\(\.\d\+\)\?\|25[0-4]\(\.\d\+\)\?\|2[0-4]\d\(\.\d\+\)\?\|1\d\{2\}\(\.\d\+\)\?\|\d\{1,2\}\(\.\d\+\)\?\|\d\d\(\.\d\+\)\?\|[1-9]\(\.\d\+\)\?\)'
  " 0% - 100%
  let parcentRegex = '^\(100\(\.0\+\)\?\|[1-9]\d\(\.\d\+\)\?\|\d\(\.\d\+\)\?\)%'
  " 0 -1
  let alphaRegex = '0\?\.\d\+\|1\|0'
  " Not support floats value syntax
  " rgba(1e2, .5e1, .5e0, +.25e2%)

  let rgbaPos = matchstrpos(a:text, 'rgba\?(\s*')
  if rgbaPos[1] == -1
    return ['', -1, -1]
  endif
  let searchPos = rgbaPos[2]
  let start = rgbaPos[1]

  let isParcentStyle = 0
  let i = 0
  let rgba = [-1, -1, -1, -1]
  while i < 3
    let val =  matchstrpos(a:text, numberRegex, searchPos)

    if val[0] == ''
      return ['', -1, -1]
    endif
    let searchPos = val[2]
    " Invalid number length ?  (e.g. rgb(2567, 1, 1)
    if match(a:text, '\d', searchPos) == searchPos
      return ['', -1, -1]
    endif
    " Check parcent style
    let parcentPos = matchstrpos(a:text, '%', searchPos)
    if parcentPos[1] == searchPos
      let isParcentStyle = 1
      let searchPos = parcentPos[2]
    elseif isParcentStyle && parcentPos[1] == -1 && i > 0
      " Invalid parcent style (e.g. rgb(255, 100%, 128)
      return ['', -1, -1]
    endif
    if i < 2 " Check separater
      let separaterPos = matchstrpos(a:text, '^\s\+\|^\s*,\s*', searchPos)
      if separaterPos[1] == -1
        return ['', -1, -1]
      endif
      let searchPos = separaterPos[2]
    endif
    let rgba[i] = val[0]
    let i += 1
  endwhile

  if isParcentStyle
    let rgba = map(rgba, "printf('%.0f',str2float(v:val)/100*255)")
    let rgba[3] = -1
  endif

  "End ?
  let endPos = matchstrpos(a:text, '\s*)', searchPos)
  if endPos[1] == searchPos
    return [join(rgba[0: -2], ','), start, searchPos[2]]
  endif

  let separaterPos = matchstrpos(a:text, '\s*\(,\|\/\)\s*\|\s*', searchPos)
  if separaterPos[1] == -1
    return ['', -1, -1]
  endif
  let searchPos = separaterPos[2]

  " parcent style alpha value?
  let parcentStyleAlpha =  matchstrpos(a:text, parcentRegex, searchPos)
  if parcentStyleAlpha[1] != -1
    let rgba[3] = substitute(parcentStyleAlpha[0], '%', '', '')
    let rgba[3] = str2float(rgba[3]) / 100.0 " Scale to 0-1
    let endPos = matchstrpos(a:text, '\s*)', parcentStyleAlpha[2])
    if endPos[1] == parcentStyleAlpha[2]
      return [join(rgba, ','), start, endPos[2]]
    endif
  endif

  let alpha =  matchstrpos(a:text, alphaRegex, searchPos)
  if alpha[1] != -1
    let rgba[3] = alpha[0]
    let endPos = matchstrpos(a:text, '\s*)', alpha[2])
    if endPos[1] == alpha[2]
      return [join(rgba, ','), start, endPos[2]]
    endif
  endif

  return ['', -1, -1]
endfunction

function! s:parseHslColor(text)
  let hslaPos = matchstrpos(a:text, 'hsla\?(\s*')
  if hslaPos[2] == -1
    return ['', -1, -1]
  endif
    return ''
  endif

  return ['', -1, -1]
endfunction

function! c2view#parse#getColor(text) abort
    let hexColor = s:parseHexColor(a:text)
    if hexColor[0] != ''
      return #{
            \color: hexColor[0],
            \type: g:c2view_parsed_type_hex,
            \start: hexColor[1],
            \end: hexColor[2]
            \}
    endif

    let rgbColor = s:parseRgbColor(a:text)
    if rgbColor[0] != ''
      return #{
            \color: rgbColor[0],
            \type: g:c2view_parsed_type_rgb,
            \start: rgbColor[1],
            \end: rgbColor[2]
            \}
    endif

    let hslColor = s:parseHslColor(a:text)
    if hslColor[0] != ''
      return #{
            \color: hslColor[0],
            \type: g:c2view_parsed_type_hsl,
            \start: hslColor[1],
            \end: hslColor[2]
            \}
    endif

    " Not found
    return #{
          \color: '',
          \type: g:c2view_parsed_type_none,
          \start: -1,
          \end: -1
          \}
endfunction


let &cpo = s:keepcpo
unlet s:keepcpo
" vim:ft=vim:fdm=marker:fmr={{{,}}}:ts=8:sw=2:sts=2:et
