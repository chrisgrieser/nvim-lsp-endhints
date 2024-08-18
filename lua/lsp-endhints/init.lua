local M = {}
--------------------------------------------------------------------------------

---@param userConfig? LspEndhints.config
function M.setup(userConfig)
	require("lsp-endhints.config").setup(userConfig)
	require("lsp-endhints.override-handler").enable()
	require("lsp-endhints.auto-enable")()
end

--------------------------------------------------------------------------------

---@param action function
local function doOnAllBuffer(action)
	local enabledBuffers = vim.iter(vim.lsp.get_clients())
		:filter(function(client) return client.server_capabilities.inlayHintProvider end)
		:map(function(client) return vim.lsp.get_buffers_by_client_id(client.id) end)
		:flatten()
		:filter(function(bufnr) return vim.lsp.inlay_hint.is_enabled { bufnr = bufnr } end)
		:totable()

	for _, bufnr in pairs(enabledBuffers) do
		vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
	end

	action()

	for _, bufnr in pairs(enabledBuffers) do
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end
end

function M.enable() doOnAllBuffer(require("lsp-endhints.override-handler").enable) end
function M.disable() doOnAllBuffer(require("lsp-endhints.override-handler").disable) end
function M.toggle() doOnAllBuffer(require("lsp-endhints.override-handler").toggle) end

--------------------------------------------------------------------------------
return M
