local M = {}

local defaults = { Error = "#db4b4b", Warning = "#e0af68", Information = "#0db9d7",
                   Hint = "#10B981" }
local config = {}

function M.translate(group)
  if vim.fn.has("nvim-0.6.0") == 0 then
    return group
  end

  if not string.match(group, "^LspDiagnostics") then
    return group
  end

  local translated = group
  translated = string.gsub(translated, "^LspDiagnosticsDefault", "Diagnostic")
  translated = string.gsub(translated, "^LspDiagnostics", "Diagnostic")
  translated = string.gsub(translated, "Warning$", "Warn")
  translated = string.gsub(translated, "Information$", "Info")
  return translated
end

function M.hl(name)
  name = M.translate(name)
  return vim.api.nvim_get_hl_by_name(name, true)
end

function M.exists(name)
  if vim.fn.hlexists(name) == 1 then
    local hl = M.hl(name)
    local count = 0
    for key, value in pairs(hl) do
      -- this is needed for groups that only have "cleared"
      if not (key == true and value == 6) then count = count + 1 end
    end
    return count > 0
  end
  return false
end

function M.link(group, fallbacks, default)
  group = M.translate(group)
  if not M.exists(group) then
    for _, fallback in pairs(fallbacks) do
      fallback = M.translate(fallback)
      if M.exists(fallback) then
        vim.cmd("hi link " .. group .. " " .. fallback)
        return
      end
    end
    if default then vim.cmd("hi " .. group .. " " .. default) end
  end
end

function M.fix(event)
  -- dump({ fix = event })
  -- Default Groups
  for _, lsp in pairs({ "Error", "Warning", "Information", "Hint" }) do
    local coc = lsp
    if lsp == "Information" then coc = "Info" end
    M.link("LspDiagnosticsDefault" .. lsp, { "Coc" .. coc .. "Sign" }, "guifg=" .. config[lsp])
    M.link("LspDiagnosticsVirtualText" .. lsp, { "LspDiagnosticsDefault" .. lsp })

    local color = defaults[lsp]
    local hl = M.hl("LspDiagnosticsDefault" .. lsp)
    if hl and hl.foreground then color = string.format("#%06x", hl.foreground) end
    M.link("LspDiagnosticsUnderline" .. lsp, {}, "gui=undercurl guisp=" .. color)
  end

  M.link("LspReferenceText", { "CocHighlightText", "CursorLine" })
  M.link("LspReferenceRead", { "CocHighlightRead", "LspReferenceText" })
  M.link("LspReferenceWrite", { "CocHighlightWrite", "LspReferenceText" })
end

function M.setup(options) config = vim.tbl_deep_extend("force", {}, defaults, options or {}) end

M.setup()

return M
