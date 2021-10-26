" Add to the quickfix list the given line 
" from the current buffer.
" If multiple line, the lines after the
" first one are added as general
function qfxtra#addRange(start, end, type='E')
  let buf = bufnr()
  let entries = []
  let valid = 1
  let type = a:type
  for  l in range(a:start, a:end)
    call add(entries, {'bufnr': buf, 'lnum': l, 'text': getline(l), 'type': type, 'valid': valid})
    " other lines are set as invalid
    let valid = 0
    let type = 'I'
  endfor
  call setqflist(entries, 'r')
endfunction


