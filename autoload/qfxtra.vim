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
  if a:loc
    call setloclist(buf, entries, 'a')
  else
    call setqflist(entries, 'a')
  endif

endfunction

" Add current line with count
function qfxtra#addCurrentLine(loc)
  let l = line('.')
  return qfxtra#addRange(a:loc,l, l+v:count1-1)
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
function qfxtra#new(loc, title="")
  if a:loc
    lexpr []
  else
    cexpr []
  endif
  call qfxtra#setTitle(a:loc, a:title)
endfunction

" Get a quickfix list compatible with setqflist
function qfxtra#getList(loc)
  if a:loc
    return getloclist(bufnr(),{'title':1, 'items':1})
  else
    return getqflist({'title':1, 'items':1})
  endif
endfunction

function qfxtra#setTitle(loc, title)
  if a:title == ""
    return
  endif
  if a:loc
    call setloclist(bufnr(), [], 'a', {'title': a:title})
  else
    call setqflist([], 'a', {'title': a:title})
  endif
endfunction

" Save a quickfix to loclist or vice versa
function qfxtra#copyToLoc(loc)
  let list = qfxtra#getList(!a:loc)
  call qfxtra#new(a:loc, list.title)
  if a:loc
    call setloclist(bufnr(), list.items, 'r')
  else
    echo list
    call setqflist(list.items, 'r')
  endif
endfunction

