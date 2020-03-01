" =============================================================================
" Filename: autoload/c2view/c2view.vim
" Author: sabiz
" License: MIT License
" =============================================================================
let s:keepcpo = &cpo
set cpo&vim

function! s:hexColor2DecColor(rgb) abort
    let rgb = a:rgb
    if strlen(rgb) < 7
        let i = 1
        let tmp = rgb
        let rgb = '#'
        while i < strlen(tmp)
            let rgb = rgb . strpart(tmp, i, 1) . strpart(tmp, i, 1)
            let i += 1
        endwhile
    endif
    let dRgb = str2nr(strpart(rgb, 1), 16)
    return [
    \   and(dRgb, 0xFF0000) / 0x00FFFF,
    \   and(dRgb, 0x00FF00) / 0x0000FF,
    \   and(dRgb, 0x0000FF)
    \   ]
endfunction


function! c2view#color#rgbHex2Ansi(rgb) abort
    let [r, g, b] = s:hexColor2DecColor(a:rgb)
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
