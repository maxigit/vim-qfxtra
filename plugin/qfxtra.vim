vmap <silent> <space>ln :<C-U>call qfxtra#addRange(1, line("'<"), line("'>"))<CR>
vmap <silent> <space>cn :<C-U>call qfxtra#addRange(0, line("'<"), line("'>"))<CR>
