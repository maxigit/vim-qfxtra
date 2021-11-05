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
  call qfxtra#setList(a:loc, entries, 'a')
endfunction

" Add current line with count
function qfxtra#addCurrentLine(loc)
  let l = line('.')
  return qfxtra#addRange(a:loc,l, l+v:count1-1)
endfunction


" Clean the current list
" Doesn't modify the history
function qfxtra#clear(loc)
  call qfxtra#setList(a:loc,[],'r')
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
function qfxtra#getList(loc, what={})
  let what = {'title':1, 'items':1}
  if a:what != {}
    let what = a:what
  endif
  if a:loc
    return getloclist(bufnr(),what)
  else
    return getqflist(what)
  endif
endfunction

function qfxtra#setList(loc, list, action, what=v:none)
  if a:loc
    if a:what == v:none
      call setloclist(bufnr(), a:list, a:action)
    else
      call setloclist(bufnr(), a:list, a:action, a:what)
    endif
  else
    call setqflist(a:list, a:action, a:what)
  endif
endfunction

function qfxtra#setTitle(loc, title)
  if a:title == ""
    return
  endif
  call qfxtra#setList(a:loc,[], 'a', {'title': a:title})
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

" Insert the count lines following the line
" linked to the current error.
" Those lines are inserted just after the current error
" resulting in effectively expand the current error
function qfxtra#setContext(loc,toExpand, mode='s')
  let list = qfxtra#getList(a:loc, {'items':1, 'idx':0})
  let start = list.idx-1
  " find the next valid item
  " All invalid item are considered part of the current
  " error and what to expand or shrink
  let next = start+1
  let llength = len(list.items)-1
  while next < llength && !list.items[next].valid
    let next=next+1
  endwhile
  let  last = next -1
  let entry = list.items[start]

  let contextLength = last - start
  if a:mode == 's' " set
    let size = a:toExpand
  else
    let size = contextLength + a:toExpand
  endif



  if size > contextLength
    let lines = getbufline(entry.bufnr, entry.lnum+1, entry.lnum+size)
    let entries = []
    for line in lines
      call add(entries, {'text':line, 'valid':0})
    endfor
    let items = list.items[0:start] + entries + list.items[next:llength]
  elseif size < contextLength
    let items = list.items[0:start+size] + list.items[next:llength]
  else
    return
  endif

  call qfxtra#setList(a:loc, items, 'r')
endfunction


" Return the current entry item for the given liste
function qfxtra#getCurrent(loc)
  let list = qfxtra#getList(a:loc,{'items':1, 'idx':1})
  echomsg "IDX" list.idx
  if list.items == []
    return {}
  else
    return list.items[list.idx-1]
  endif
endfunction

