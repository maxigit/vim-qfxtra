" Add to the quickfix list the given line 
" from the current buffer.
" If multiple line, the lines after the
" first one are added as general
function qfxtra#addRange(start, end, type='I')
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
  call setqflist(entries, 'a')
endfunction


function qfxtra#clear()
  call setqflist([],'r')
endfunction


