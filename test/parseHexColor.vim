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
  call s:assert.equals(s:parseHexColor('#123'), '#123')
  call s:assert.equals(s:parseHexColor('#abc'), '#abc')
  call s:assert.equals(s:parseHexColor('#fe1'), '#fe1')
  call s:assert.equals(s:parseHexColor('#DEF'), '#DEF')
  call s:assert.equals(s:parseHexColor('#78A'), '#78A')
  call s:assert.equals(s:parseHexColor('#1234'), '#1234')
  call s:assert.equals(s:parseHexColor('#123a'), '#123a')
  call s:assert.equals(s:parseHexColor('#123A'), '#123A')
  call s:assert.equals(s:parseHexColor('#aBcD'), '#aBcD')
  call s:assert.equals(s:parseHexColor('AAAAAA#123'), '#123')
  call s:assert.equals(s:parseHexColor('#123ZZZZZZ'), '#123')
  call s:assert.equals(s:parseHexColor('    #123  '), '#123')
  call s:assert.equals(s:parseHexColor('#12 #123  '), '#123')
  call s:assert.equals(s:parseHexColor('#ZZZ'), '')
  call s:assert.equals(s:parseHexColor(''), '')
  call s:assert.equals(s:parseHexColor('#12 345'), '')
endfunction

function! s:suite.test_hex_6_digits()
  call s:assert.equals(s:parseHexColor('#123456'), '#123456')
  call s:assert.equals(s:parseHexColor('#abcdef'), '#abcdef')
  call s:assert.equals(s:parseHexColor('#fe12cb'), '#fe12cb')
  call s:assert.equals(s:parseHexColor('#DEF123'), '#DEF123')
  call s:assert.equals(s:parseHexColor('#78ABC9'), '#78ABC9')
  call s:assert.equals(s:parseHexColor('#12345678'), '#12345678')
  call s:assert.equals(s:parseHexColor('#112233aa'), '#112233aa')
  call s:assert.equals(s:parseHexColor('#112233AA'), '#112233AA')
  call s:assert.equals(s:parseHexColor('#aBcDeF12'), '#aBcDeF12')
  call s:assert.equals(s:parseHexColor('AAAAAA#123456'), '#123456')
  call s:assert.equals(s:parseHexColor('#123456ZZZZZZ'), '#123456')
  call s:assert.equals(s:parseHexColor('    #123456  '), '#123456')
  call s:assert.equals(s:parseHexColor('#12 #123456  '), '#123456')
  call s:assert.equals(s:parseHexColor('#GGGGGG'), '')
  call s:assert.equals(s:parseHexColor(''), '')
  call s:assert.equals(s:parseHexColor('#12 3456'), '')
endfunction

" vim:ft=vim:fdm=marker:fmr={{{,}}}:ts=8:sw=2:sts=2:et
