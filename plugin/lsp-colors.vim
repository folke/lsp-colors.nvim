augroup ColorFixer
  autocmd!
  autocmd ColorScheme * lua require("lsp-colors").fix()
augroup end
