scriptencoding uft-8

" Subset from plugin/statusline.vim (can't comment inline with line continuation
" markers without Vim freaking out).
let g:joshblackQuickfixStatusline =
      \ 'Quickfix'
      \ . '%<'
      \ . '\ '
      \ . '%='
      \ . '\ '
      \ . 'ℓ'
      \ . '\ '
      \ . '%l'
      \ . '/'
      \ . '%L'
      \ . '\ '
      \ . '@'
      \ . '\ '
      \ . '%c'
      \ . '%V'
      \ . '\ '
      \ . '%1*'
      \ . '%p'
      \ . '%%'
      \ . '%*'

call joshblack#defer#defer('call joshblack#variables#init()')