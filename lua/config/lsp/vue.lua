-- Vue LSP configuration module
local M = {}

M.server_name = "volar"

M.filetypes = { "vue" }

M.settings = {}

M.on_attach = function(client, bufnr)
  -- Vue specific keymaps and configurations
end

return M
