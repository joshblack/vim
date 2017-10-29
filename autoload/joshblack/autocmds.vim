let g:JBColorColumnBlacklist = ['diff', 'undotree', 'nerdtree', 'qf']
let g:JBCursorlineBlacklist = ['command-t']
let g:JBMkviewFiletypeBlacklist = ['diff', 'hgcommit', 'gitcommit']

function! joshblack#autocmds#attempt_select_last_file() abort
  let l:previous=expand('#:t')
  if l:previous !=# ''
    call search('\v<' . l:previous . '>')
  endif
endfunction

function! joshblack#autocmds#should_colorcolumn() abort
  return index(g:JBColorColumnBlacklist, &filetype) == -1
endfunction

function! joshblack#autocmds#should_cursorline() abort
  return index(g:JBCursorlineBlacklist, &filetype) == -1
endfunction

" Loosely based on: http://vim.wikia.com/wiki/Make_views_automatic
function! joshblack#autocmds#should_mkview() abort
  return
        \ &buftype ==# '' &&
        \ index(g:JBMkviewFiletypeBlacklist, &filetype) == -1 &&
        \ !exists('$SUDO_USER') " Don't create root-owned files.
endfunction

function! joshblack#autocmds#mkview() abort
  if exists('*haslocaldir') && haslocaldir()
    " We never want to save an :lcd command, so hack around it...
    cd -
    mkview
    lcd -
  else
    mkview
  endif
endfunction

function! joshblack#autocmds#blur_window() abort
  if joshblack#autocmds#should_colorcolumn()
    ownsyntax off
  endif
endfunction

function! joshblack#autocmds#focus_window() abort
  if joshblack#autocmds#should_colorcolumn()
    if !empty(&ft)
      ownsyntax on
    endif
  endif
endfunction

function! joshblack#autocmds#blur_statusline() abort
  " Default blurred statusline (buffer number: filename).
  let l:blurred='%{joshblack#statusline#gutterpadding()}'
  let l:blurred.='\ ' " space
  let l:blurred.='\ ' " space
  let l:blurred.='\ ' " space
  let l:blurred.='\ ' " space
  let l:blurred.='%<' " truncation point
  let l:blurred.='%f' " filename
  let l:blurred.='%=' " split left/right halves (makes background cover whole)
  call s:update_statusline(l:blurred, 'blur')
endfunction

function! joshblack#autocmds#focus_statusline() abort
  " `setlocal statusline=` will revert to global 'statusline' setting.
  call s:update_statusline('', 'focus')
endfunction

function! s:update_statusline(default, action) abort
  let l:statusline = s:get_custom_statusline(a:action)
  if type(l:statusline) == type('')
    " Apply custom statusline.
    execute 'setlocal statusline=' . l:statusline
  elseif l:statusline == 0
    " Do nothing.
    "
    " Note that order matters here because of Vimscript's insane coercion rules:
    " when comparing a string to a number, the string gets coerced to 0, which
    " means that all strings `== 0`. So, we must check for string-ness first,
    " above.
    return
  else
    execute 'setlocal statusline=' . a:default
  endif
endfunction

function! s:get_custom_statusline(action) abort
  if &ft ==# 'command-t'
    " Will use Command-T-provided buffer name, but need to escape spaces.
    return '\ \ ' . substitute(bufname('%'), ' ', '\\ ', 'g')
  elseif &ft ==# 'diff' && exists('t:diffpanel') && t:diffpanel.bufname ==# bufname('%')
    return 'Undotree\ preview' " Less ugly, and nothing really useful to show.
  elseif &ft ==# 'undotree'
    return 0 " Don't override; undotree does its own thing.
  elseif &ft ==# 'nerdtree'
    return 0 " Don't override; NERDTree does its own thing.
  elseif &ft ==# 'qf'
    if a:action ==# 'blur'
      return 'Quickfix'
    else
      return g:JBQuickfixStatusline
    endif
  endif

  return 1 " Use default.
endfunction

function! joshblack#autocmds#idleboot() abort
  " Make sure we automatically call joshblack#autocmds#idleboot() only once.
  augroup JBIdleboot
    autocmd!
  augroup END

  " Make sure we run deferred tasks exactly once.
  doautocmd User JBDefer
  autocmd! User JBDefer
endfunction