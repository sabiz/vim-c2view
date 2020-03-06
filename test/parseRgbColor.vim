" =============================================================================
" Filename: test/parseRgbColor.vim
" Author: sabiz
" License: MIT License
" =============================================================================

let s:suite = themis#suite('c2view parse test')
let s:assert = themis#helper('assert')

let s:testTargetFile = 'autoload/c2view/parse.vim'

function! s:parseRgbColor(text)
  return GetLocalFunction(s:testTargetFile, 'parseRgbColor')(a:text)
endfunction

function! s:suite.test_numeric()
  call s:assert.equals(s:parseRgbColor('rgb(255, 0, 255)'), '255,0,255')
  call s:assert.equals(s:parseRgbColor('rgb(255,0,255)'), '255,0,255')
  call s:assert.equals(s:parseRgbColor('rgb(25,0,255.0)'), '25,0,255.0')
  call s:assert.equals(s:parseRgbColor('rgb(25 0 255.0)'), '25,0,255.0')
  call s:assert.equals(s:parseRgbColor('rgb(25  0    255.0)'), '25,0,255.0')
  call s:assert.equals(s:parseRgbColor('rgba(25  30 255 45%)'), '25,30,255,0.45')
  call s:assert.equals(s:parseRgbColor('rgb(25,30,255,15%)'), '25,30,255,0.15')
  call s:assert.equals(s:parseRgbColor('rgba(25,30,255,0.15)'), '25,30,255,0.15')
  call s:assert.equals(s:parseRgbColor('rgb(25 30 255 .15)'), '25,30,255,.15')
  call s:assert.equals(s:parseRgbColor('rgba(25 30 255 / 15%)'), '25,30,255,0.15')
  call s:assert.equals(s:parseRgbColor('rgba(25 30 255 / 0.15)'), '25,30,255,0.15')
  call s:assert.equals(s:parseRgbColor('rgb(25,30,10,1%)'), '25,30,10,0.01')
  call s:assert.equals(s:parseRgbColor('rgba(25,30,10,1)'), '25,30,10,1')
  call s:assert.equals(s:parseRgbColor('         rgb(1, 2, 3)'), '1,2,3')
  call s:assert.equals(s:parseRgbColor('rgb(1, 2, 3)         '), '1,2,3')
  call s:assert.equals(s:parseRgbColor('       rgb(1, 2, 3)  '), '1,2,3')
  call s:assert.equals(s:parseRgbColor('rgb(25,,30,10)'), '')
  call s:assert.equals(s:parseRgbColor('rgbb(25,30,10)'), '')
  call s:assert.equals(s:parseRgbColor('rgb(25  30% 255)'), '')
  call s:assert.equals(s:parseRgbColor('rgb(925 0 255.0)'), '')
  call s:assert.equals(s:parseRgbColor('rgb(2555 0 255.0)'), '')
  call s:assert.equals(s:parseRgbColor('rgb(-25 0 255.0)'), '')
endfunction

function! s:suite.test_parcent()
  call s:assert.equals(s:parseRgbColor('rgb(100%, 0%, 100%)'), '255,0,255')
  call s:assert.equals(s:parseRgbColor('rgb(100%,0%,100%)'), '255,0,255')
  call s:assert.equals(s:parseRgbColor('rgb(25%,0%,100.0%)'), '64,0,255')
  call s:assert.equals(s:parseRgbColor('rgb(25% 0% 100.0%)'), '64,0,255')
  call s:assert.equals(s:parseRgbColor('rgb(25%  0%    100.0%)'), '64,0,255')
  call s:assert.equals(s:parseRgbColor('rgba(25%  30% 100% 45%)'), '64,76,255,0.45')
  call s:assert.equals(s:parseRgbColor('rgb(25%,30%,100%,15%)'), '64,76,255,0.15')
  call s:assert.equals(s:parseRgbColor('rgba(25%,30%,100%,0.15)'), '64,76,255,0.15')
  call s:assert.equals(s:parseRgbColor('rgb(25% 30% 100% .15)'), '64,76,255,.15')
  call s:assert.equals(s:parseRgbColor('rgba(25% 30% 100% / 15%)'), '64,76,255,0.15')
  call s:assert.equals(s:parseRgbColor('rgba(25% 30% 100% / 0.15)'), '64,76,255,0.15')
  call s:assert.equals(s:parseRgbColor('rgb(25%,30%,10%,1%)'), '64,76,26,0.01')
  call s:assert.equals(s:parseRgbColor('rgba(25%,30%,10%,1)'), '64,76,26,1')
  call s:assert.equals(s:parseRgbColor('         rgb(1%, 2%, 3%)'), '3,5,8')
  call s:assert.equals(s:parseRgbColor('rgb(1%, 2%, 3%)         '), '3,5,8')
  call s:assert.equals(s:parseRgbColor('       rgb(1%, 2%, 35%)  '), '3,5,89')
  call s:assert.equals(s:parseRgbColor('rgb(25%,,30%,10%)'), '')
  call s:assert.equals(s:parseRgbColor('rgbb(25%,30%,10%)'), '')
  call s:assert.equals(s:parseRgbColor('rgb(25%  30% 100%/)'), '')
  call s:assert.equals(s:parseRgbColor('rgb(925% 0% 100.0%)'), '')
  call s:assert.equals(s:parseRgbColor('rgb(-25% 0% 100.0%)'), '')
endfunction

" vim:ft=vim:fdm=marker:fmr={{{,}}}:ts=8:sw=2:sts=2:et
