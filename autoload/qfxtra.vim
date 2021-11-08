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
    return getloclist(0,what)
  else
    return getqflist(what)
  endif
endfunction

function qfxtra#setList(loc, list, action, what={})
  if a:loc
    if a:what == {}
      call setloclist(0, a:list, a:action)
    else
      call setloclist(0, a:list, a:action, a:what)
    endif
  else
    if a:what == {}
      call setqflist(a:list, a:action)
    else
      call setqflist(a:list, a:action, a:what)
    endif
  endif
endfunction

function qfxtra#setTitle(loc, title)
  if a:title == ""
    return
  endif
  call qfxtra#setList(a:loc,[], 'a', {'title': a:title})
endfunction

" Save a quickfix to loclist or vice versa
function qfxtra#copyToLoc(loc)
  let list = qfxtra#getList(!a:loc)
  call qfxtra#new(a:loc, list.title)
  if a:loc
    call setloclist(bufnr(), list.items, 'r')
  else
    call setqflist(list.items, 'r')
  endif
endfunction

" Insert the count lines following the line
" linked to the current error.
" Those lines are inserted just after the current error
" resulting in effectively expand the current error
function qfxtra#setContext(loc,toExpand, mode='s')
  if a:loc == -1
    let idx = qfxtra#getCurrentIdx()
    let entries = idx.items
    let start = idx.index
  else
    let list = qfxtra#getList(a:loc, {'items':1, 'idx':0})
    let start = list.idx-1
    let entries = list.items
  endif
  " find the next valid item
  " All invalid item are considered part of the current
  " error and what to expand or shrink
  let next = start+1
  let llength = len(entries)-1
  while next <= llength && !entries[next].valid
    let next=next+1
  endwhile
  let  last = next -1
  let entry = entries[start]

  "   0...1......2.....
  "       ^     ^^    ^
  "       |     ||    +-- llength
  "       |     |+------- next
  "       |     +-------- last
  "       +-------------- start

  let contextLength = last - start
  if a:mode == 's' " set
    let size = max([a:toExpand,-1])
  else
    let size = max([0,contextLength + a:toExpand])
    " can set -1 by reducing, as it will delete the entry
  endif
  let items = []
  if start+size >= 0
    let items = entries[0:start+min([size,contextLength])]
  endif

  if size > contextLength
    let lines = getbufline(entry.bufnr, entry.lnum+contextLength+1, entry.lnum+size)
    for line in lines
      call add(items, {'text':line, 'valid':0})
    endfor
  endif

  let items += entries[next:llength]

  call qfxtra#setList(a:loc, items, 'r')
endfunction


" Group all entries so that invalid
" are considered as children of valid one
" usefull to sort or delete a full set of entry
"  the headline (valid) and it's annotations
function qfxtra#group(list)
  if a:list == []
    return a:list
  endif
  let entry = remove(a:list, 0)
  let entry['annotations'] = []
  let groups = []
  for e in a:list
    if e.valid
      let groups += [entry]
      let entry = e
      let entry['annotations'] = []
    else
      let entry.annotations += [e]
    endif
  endfor
  let groups += [entry]
  return groups
endfunction

function qfxtra#ungroup(groups)
  let entries = []
  for group in a:groups
    let entries += [group]
    let entries += group.annotations
    unlet group.annotations
  endfor
  return entries
endfunction

function qfxtra#sortGroups(groups)
  return sort(a:groups, {a, b -> s:compare(a, b)})
endfunction
  
function s:compare(a,b)
  if a:a.bufnr >  a:b.bufnr
    return 1
  elseif a:a.bufnr < a:b.bufnr
    return -1
  elseif a:a.lnum > a:b.lnum
    return 1
  elseif a:a.lnum == a:b.lnum
    return -1
  else
    return 0
  endif
endfunction


function qfxtra#sort(loc)
  let entries = qfxtra#getList(a:loc).items
  let groups = qfxtra#group(entries)
  call qfxtra#sortGroups(groups)
  call qfxtra#setList(a:loc, qfxtra#ungroup(groups), 'r')
endfunction


" Find the index of the entry under the cursor
" if buffer is a location
function qfxtra#getCurrentIdx()
  let info = getwininfo(win_getid())[0]
  if info.loclist
    let loc = 1
  elseif info.quickfix
    let loc =0
  else
    return {}
  endif
  let entries = qfxtra#getList(loc).items
  let index = line('.')-1
  while !entries[index].valid && index >= 0
    let index -=1
  endwhile
  return #{index: index, loc: loc, items: entries}
endfunction
