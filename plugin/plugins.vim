call joshblack#defer#defer('call joshblack#plugins#abolish()')

call joshblack#plugin#lazy({
      \   'pack': 'undotree',
      \   'plugin': 'undotree.vim',
      \   'nnoremap': {
      \     '<silent> <Leader>u': ':UndotreeToggle<CR>'
      \   },
      \   'beforeload': [
      \     'call joshblack#undotree#init()'
      \   ]
      \ })