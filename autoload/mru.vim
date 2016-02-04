" mru - Record MRU
" Version: 0.0.0
" Copyright (C) 2016 Kana Natsuno <http://whileimautomaton.net/>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
" Constants  "{{{1

let s:FILE_PATH = fnamemodify(split(&runtimepath, ',')[0] . '/info/mru', ':p')
let s:MAX_LIST_LENGTH = 1000








" Interface  "{{{1
function! mru#add(file_path)  "{{{2
  if a:file_path == ''
    return
  endif

  let i = index(s:list, a:file_path)
  if i != -1
    unlet s:list[i]
  endif

  call insert(s:list, a:file_path, 0)

  if s:MAX_LIST_LENGTH < len(s:list)
    unlet s:list[s:MAX_LIST_LENGTH - 1]
  endif
endfunction




function! mru#list()  "{{{2
  return s:list
endfunction

let s:list = []




function! mru#load()  "{{{2
  if !filereadable(s:FILE_PATH)
    return
  endif

  let s:list = readfile(s:FILE_PATH)
endfunction




function! mru#save()  "{{{2
  let directory = fnamemodify(s:FILE_PATH, ':h')
  if !isdirectory(directory)
    call mkdir(directory, 'p')
  endif

  call writefile(mru#list(), s:FILE_PATH)
endfunction








" Fin.  "{{{1

call mru#load()








" __END__  "{{{1
" vim: foldmethod=marker
