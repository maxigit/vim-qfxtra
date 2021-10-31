" Add to the quickfix list the given line 
" from the current buffer.
" If multiple line, the lines after the
" first one are added as general
function qfxtra#addRange(loc, start, end, type='I')
  let buf = bufnr()
  let entries = []
  let valid = 1
  let type = a:type
  for  l in range(a:start, a:end)
    if l == a:start
      call add(entries, {'bufnr': buf, 'lnum': l, 'text': getline(l), 'type': type, 'valid': valid})
    else
      call add(entries, {'text': getline(l)})
    endif
    " other lines are set as invalid
    let valid = 0
    let type = 'I'
    let buf = ''
  endfor
  "call add(entries, {'text': '--------------------------------'})
  call add(entries, {'text': ''})
  call add(entries, {'text': ''})
  if a:loc
    call setloclist(buf, entries, 'a')
  else
    call setqflist(entries, 'a')
  endif

endfunction

" Clean the current list
" Doesn't modify the history
function qfxtra#clear(loc)
  if a:loc
    call setloclist(bufnr(),[],'r')
  else
    call setqflist([],'r')
  endif
endfunction

" Push a new empty list 
" to the history
function qfxtra#new(loc)
  if a:loc
    lexpr []
  else
    cexpr []
  endif
endfunction

" Get a quickfix list compatible with setqflist
function qfxtra#getlist(loc)
  if a:loc
    call getloclist(bufnr())
  else
    call getqflist()
  endif
endfunction



