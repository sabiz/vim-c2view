" =============================================================================
" Filename: autoload/c2view/c2view.vim
" Author: sabiz
" License: MIT License
" =============================================================================
let s:keepcpo = &cpo
set cpo&vim

function! s:ansiColor2DecColor(ansi) abort

  let lowRgb = [
    \[  0,   0,   0], [128,   0,   0], [  0, 128,   0],
    \[128, 128,   0], [  0,   0, 128], [128,   0, 128],
    \[  0, 128, 128], [192, 192, 192], [128, 128, 128],
    \[255,   0,   0], [  0, 255,   0], [255, 255,   0],
    \[  0,   0, 255], [255,   0, 255], [  0, 255, 255],
    \[255, 255, 255]
    \]
  if a:ansi < 0 || a:ansi > 255
    return lowRgb[0]
  endif
  if a:ansi < 16
    return lowRgb[a:ansi]
  endif
  if a:ansi > 231
    let gray = (a:ansi - 232) * 10 + 8
    return [gray, gray, gray]
  endif

  let n = str2nr(a:ansi) - 16
  let b = n % 6
  let g = (n - b) / 6 % 6
  let r = (n - b - g * 6) / 36 % 6
  let b = b ? b * 40 + 55 : 0
  let r = r ? r * 40 + 55 : 0
  let g = g ? g * 40 + 55 : 0

  return [r, g, b]

endfunction

function! s:hexColor2DecColor(hex) abort
    let hex = a:hex
    if strlen(hex) == 4
      let i = 1
      let tmp = hex
      let hex = '#'
      while i < strlen(tmp)
          let hex = hex . strpart(tmp, i, 1) . strpart(tmp, i, 1)
          let i += 1
      endwhile
    endif
    let decimal = str2nr(strpart(hex, 1, 6), 16)
    let red = and(decimal, 0xFF0000) / 0x00FFFF
    let green = and(decimal, 0x00FF00) / 0x0000FF
    let blue = and(decimal, 0x0000FF)
    if strlen(hex) == 7
      return [red, green, blue]
    endif

    " Calculate alpha blend
    let bgHilight=synIDattr(hlID('Normal'), 'bg')
    let bgColor = s:ansiColor2DecColor(bgHilight)
    let alpha = str2nr(strpart(hex, 7, 2), 16)
    return [
      \ (red * alpha / 255) + (bgColor[0] * (255 - alpha)/255),
      \ (green * alpha / 255) + (bgColor[1] * (255 - alpha)/255),
      \ (blue * alpha / 255) + (bgColor[2] * (255 - alpha)/255)
      \]
endfunction

function! c2view#color#hex2Ansi(hex) abort
    let [r, g, b] = s:hexColor2DecColor(a:hex)
    " https://github.com/Qix-/color-convert/blob/1df58eff59b30d075513860cf69f8aec4620140d/conversions.js#L567
    " Gray scale color
    if r == g && g == b
        if r < 8
            return 16
        endif

        if r > 248
            return 231
        endif

        return round(((r - 8) / 247.0) * 24) + 232
    endif

    let ansi = round(16
                \   + (36 * round(r / 255.0 * 5))
                \   + (6 * round(g / 255.0 * 5))
                \   + round(b / 255.0 * 5))
    return ansi
endfunction

let &cpo = s:keepcpo
unlet s:keepcpo
" vim:ft=vim:fdm=marker:fmr={{{,}}}:ts=8:sw=2:sts=2:et
