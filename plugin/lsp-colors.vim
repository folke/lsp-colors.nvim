augroup LspColors
  autocmd!
  autocmd ColorScheme * lua require("lsp-colors").fix("ColorScheme")
  autocmd VimEnter * lua require("lsp-colors").fix("VimEnter")
augroup end
