augroup LspColors
  autocmd!
  autocmd ColorScheme * lua require("lsp-colors").fix("ColorScheme")
augroup end

lua require("lsp-colors").fix("VimEnter")