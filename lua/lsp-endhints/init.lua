local M = {}
--------------------------------------------------------------------------------

---@param userConfig? LspEndhints.config
function M.setup(userConfig)
	require("lsp-endhints.config").setup(userConfig)
	require("lsp-endhints.override-handler").refreshHandler()
	require("lsp-endhints.override-handler").disableHandler()
	require("lsp-endhints.auto-enable")()
end

--------------------------------------------------------------------------------
return M
