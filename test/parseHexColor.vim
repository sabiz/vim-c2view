" =============================================================================
" Filename: test/parseHexColor.vim
" Author: sabiz
" License: MIT License
" =============================================================================

let s:suite = themis#suite('c2view parse test')
let s:assert = themis#helper('assert')

let s:testTargetFile = 'autoload/c2view/parse.vim'

function! s:parseHexColor(text)
  return GetLocalFunction(s:testTargetFile, 'parseHexColor')(a:text)
endfunction

function! s:suite.test_hex_3_digits()
  call s:assert.equals(s:parseHexColor('#123')[0], '#123')
  call s:assert.equals(s:parseHexColor('#abc')[0], '#abc')
  call s:assert.equals(s:parseHexColor('#fe1')[0], '#fe1')
  call s:assert.equals(s:parseHexColor('#DEF')[0], '#DEF')
  call s:assert.equals(s:parseHexColor('#78A')[0], '#78A')
  call s:assert.equals(s:parseHexColor('#1234')[0], '#1234')
  call s:assert.equals(s:parseHexColor('#123a')[0], '#123a')
  call s:assert.equals(s:parseHexColor('#123A')[0], '#123A')
  call s:assert.equals(s:parseHexColor('#aBcD')[0], '#aBcD')
  call s:assert.equals(s:parseHexColor('AAAAAA#123')[0], '#123')
  call s:assert.equals(s:parseHexColor('#123ZZZZZZ')[0], '#123')
  call s:assert.equals(s:parseHexColor('    #123  ')[0], '#123')
  call s:assert.equals(s:parseHexColor('#12 #123  ')[0], '#123')
  call s:assert.equals(s:parseHexColor('#ZZZ')[0], '')
  call s:assert.equals(s:parseHexColor('')[0], '')
  call s:assert.equals(s:parseHexColor('#12 345')[0], '')
endfunction

function! s:suite.test_hex_6_digits()
  call s:assert.equals(s:parseHexColor('#123456')[0], '#123456')
  call s:assert.equals(s:parseHexColor('#abcdef')[0], '#abcdef')
  call s:assert.equals(s:parseHexColor('#fe12cb')[0], '#fe12cb')
  call s:assert.equals(s:parseHexColor('#DEF123')[0], '#DEF123')
  call s:assert.equals(s:parseHexColor('#78ABC9')[0], '#78ABC9')
  call s:assert.equals(s:parseHexColor('#12345678')[0], '#12345678')
  call s:assert.equals(s:parseHexColor('#112233aa')[0], '#112233aa')
  call s:assert.equals(s:parseHexColor('#112233AA')[0], '#112233AA')
  call s:assert.equals(s:parseHexColor('#aBcDeF12')[0], '#aBcDeF12')
  call s:assert.equals(s:parseHexColor('AAAAAA#123456')[0], '#123456')
  call s:assert.equals(s:parseHexColor('#123456ZZZZZZ')[0], '#123456')
  call s:assert.equals(s:parseHexColor('    #123456  ')[0], '#123456')
  call s:assert.equals(s:parseHexColor('#12 #123456  ')[0], '#123456')
  call s:assert.equals(s:parseHexColor('#GGGGGG')[0], '')
  call s:assert.equals(s:parseHexColor('')[0], '')
  call s:assert.equals(s:parseHexColor('#12 3456')[0], '')
endfunction

" vim:ft=vim:fdm=marker:fmr={{{,}}}:ts=8:sw=2:sts=2:et
