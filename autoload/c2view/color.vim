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

function! s:alphaBlend(r, g, b, a)
    let bgHilight=synIDattr(hlID('Normal'), 'bg')
    let bgColor = s:ansiColor2DecColor(bgHilight)
    return [
      \ (a:r * a:a) + (bgColor[0] * (1.0 - a:a)),
      \ (a:g * a:a) + (bgColor[1] * (1.0 - a:a)),
      \ (a:b * a:a) + (bgColor[2] * (1.0 - a:a))
      \]

endfunction

function! s:hexColor2DecColor(hex) abort
    let hex = a:hex
    if strlen(hex) == 4 || strlen(hex) == 5
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
    let alpha = str2nr(strpart(hex, 7, 2), 16)
    return s:alphaBlend(red, green, blue, alpha/255.0)
endfunction

function! s:rgb2Ansi(rgb) abort
    let [r, g, b] = a:rgb
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

function! s:hsl2Rgb(hsl)abort
  let [h,s,l] = a:hsl
  let h = fmod(h, 360.0)
  if h < 0
    let h = 360.0 + h
  endif

  let c = (1-abs(2*l-1))*s
  let hp = h / 60.0
  let x = c*(1-abs(fmod(hp, 2)-1))
  let m = l - c/2

  let cs = (c+m)*255.0
  let xs = (x+m)*255.0
  let o = m*255.0

  if hp <= 1
    return [cs, xs, o]
  elseif hp <= 2
    return [xs, cs, o]
  elseif hp <= 3
    return [o, cs, xs]
  elseif hp <= 4
    return [o, xs, cs]
  elseif hp <= 5
    return [xs, o, cs]
  elseif hp <= 6
    return [cs, o, xs]
  endif

  return [0,0,0]
endfunction

function! c2view#color#hex2Ansi(hex) abort
    let rgb = s:hexColor2DecColor(a:hex)
    return s:rgb2Ansi(rgb)
endfunction

function! c2view#color#rgba2Ansi(rgba) abort
  let rgbaList = map(split(a:rgba, ','), 'str2float(v:val)')
  if len(rgbaList) == 3
    return s:rgb2Ansi(rgbaList)
  endif
  if len(rgbaList) == 4
    return s:rgb2Ansi(s:alphaBlend(rgbaList[0], rgbaList[1], rgbaList[2], rgbaList[3]))
  endif

  " Invalid length
  return -1
endfunction

function! c2view#color#hsla2Ansi(hsla) abort
  let hslaList = map(split(a:hsla, ','), 'str2float(v:val)')
  let hslaLength = len(hslaList)
  if hslaLength != 3 && hslaLength != 4
    " Invalid length
    return -1
  endif
  let rgb = s:hsl2Rgb(hslaList[0:2])
  if hslaLength == 3
    return s:rgb2Ansi(rgb)
  endif
  return s:rgb2Ansi(s:alphaBlend(rgb[0], rgb[1], rgb[2], hslaList[3]))
endfunction

let &cpo = s:keepcpo
unlet s:keepcpo
" vim:ft=vim:fdm=marker:fmr={{{,}}}:ts=8:sw=2:sts=2:et
