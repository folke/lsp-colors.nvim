local M = {}

local defaults = { Error = "#db4b4b", Warning = "#e0af68", Information = "#0db9d7",
                   Hint = "#10B981" }
local config = {}

function M.hl(name) return vim.api.nvim_get_hl_by_name(name, true) end

function M.exists(name)
  if vim.fn.hlexists(name) == 1 then
    local hl = M.hl(name)
    -- this is needed for groups that only have "cleared"
    if hl[true] == 6 then return false end
    return true
  end
  return false
end

function M.link(group, fallbacks, default)
  if not M.exists(group) then
    for _, fallback in pairs(fallbacks) do
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
    local color = string.format("#%06x", M.hl("LspDiagnosticsDefault" .. lsp).foreground)
    M.link("LspDiagnosticsUnderline" .. lsp, {}, "gui=undercurl guisp=" .. color)
  end

  M.link("LspReferenceText", { "CocHighlightText", "CursorLine" })
  M.link("LspReferenceRead", { "CocHighlightRead", "LspReferenceText" })
  M.link("LspReferenceWrite", { "CocHighlightWrite", "LspReferenceText" })
end

function M.setup(options) config = vim.tbl_deep_extend("force", {}, defaults, options or {}) end

M.setup()

return M
