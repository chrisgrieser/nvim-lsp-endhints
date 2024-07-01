local M = {}
local inlayHintNs = vim.api.nvim_create_namespace("lspEndhints")
--------------------------------------------------------------------------------

---@param userConfig? LspEndhints.config
function M.setup(userConfig)
	require("lsp-endhints.config").setup(userConfig)
	require("lsp-endhints.override-handler")(inlayHintNs)
	require("lsp-endhints.auto-enable")(inlayHintNs)
end

--------------------------------------------------------------------------------
return M
