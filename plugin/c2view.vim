" =============================================================================
" Filename: plugin/c2view.vim
" Author: sabiz
" License: MIT License
" =============================================================================


if exists('g:loaded_c2view') || !has('patch-8.1.1517') || has("gui_running")
  finish
endif

let g:loaded_c2view = 1

let s:save_cpo = &cpo
set cpo&vim

 augroup c2view
    autocmd!
    autocmd CursorHold,CursorHoldI * call c2view#Run()
augroup END

let &cpo = s:save_cpo
" vim:ft=vim:fdm=marker:fmr={{{,}}}:ts=8:sw=2:sts=2:
