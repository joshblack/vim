command! -nargs=* -complete=file OpenInDiffusion call joshblack#commands#open_in_diffusion(<f-args>)
command! -nargs=* -complete=file Preview call joshblack#commands#preview(<f-args>)
command! -nargs=* Search call joshblack#commands#search(<q-args>)