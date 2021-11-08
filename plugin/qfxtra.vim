vmap <silent> <space>ln :<C-U>call qfxtra#addRange(1, line("'<"), line("'>"))<CR>
vmap <silent> <space>cn :<C-U>call qfxtra#addRange(0, line("'<"), line("'>"))<CR>
nnoremap <silent> <space>ln :<C-U>call qfxtra#addCurrentLine(1)<CR>
nnoremap <silent> <space>cn :<C-U>call qfxtra#addCurrentLine(0)<CR>

nnoremap <silent> <space>lN :<C-U>call qfxtra#new(1)<Cr>
nnoremap <silent> <space>lC :<C-U>call qfxtra#clear(1)<Cr>
nnoremap <silent> <space>cN :<C-U>call qfxtra#new(0)<Cr>
nnoremap <silent> <space>cC :<C-U>call qfxtra#clear(0)<Cr>
" Get from other
nnoremap <silent> <space>lG :<C-U>call qfxtra#copyToLoc(1)<Cr>
nnoremap <silent> <space>cG :<C-U>call qfxtra#copyToLoc(0)<Cr>

nnoremap <silent> <space>lT :<C-U>call qfxtra#setTitle(1, input("Title: "))<Cr>
nnoremap <silent> <space>cT :<C-U>call qfxtra#setTitle(0, input("Title: "))<Cr>


nnoremap <silent> <space>la :ladd [input("Annotation: ")]<Cr>
nnoremap <silent> <space>l<space> :ladd ['']<Cr>
nnoremap <silent> <space>l- :ladd ['--------------------------------------------------']<Cr>
nnoremap <silent> <space>ca :cadd [input("Annotation: ")]<Cr>
nnoremap <silent> <space>c<space> :ladd ['']<Cr>
nnoremap <silent> <space>c- :cadd ['--------------------------------------------------']<Cr>


nnoremap <silent> <space>l> :<C-U>call qfxtra#setContext(1,v:count1,'i')<Cr>
nnoremap <silent> <space>l< :<C-U>call qfxtra#setContext(1,-v:count1,'i')<Cr>
nnoremap <silent> <space>c> :<C-U>call qfxtra#setContext(0,v:count1,'i')<Cr>
nnoremap <silent> <space>c< :<C-U>call qfxtra#setContext(0,-v:count1,'i')<Cr>
nnoremap <silent> <space>ld :<C-U>call qfxtra#setContext(1,-1,'s')<Cr>
nnoremap <silent> <space>cd :<C-U>call qfxtra#setContext(0,-1,'s')<Cr>


command QSort call qfxtra#sort(0)
command LSort call qfxtra#sort(1)

autocmd FileType qf nnoremap <silent><buffer> > :<C-U>call qfxtra#setContext(-1,v:count1,'i')<Cr>
autocmd FileType qf nnoremap <silent><buffer> < :<C-U>call qfxtra#setContext(-1,-v:count1,'i')<Cr>
autocmd FileType qf nnoremap <silent><buffer> d :<C-U>call qfxtra#setContext(-1,-1,'s')<Cr>
