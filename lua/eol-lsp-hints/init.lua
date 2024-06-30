local M = {}
local inlayHintNs = vim.api.nvim_create_namespace("EolInlayHints")
--------------------------------------------------------------------------------

local function init()
	require("eol-lsp-hints.override-handler")(inlayHintNs)
	local config = require("eol-lsp-hints.config").config

	-- lsp attach/detach
	vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
		group = vim.api.nvim_create_augroup("EolInlayHints", { clear = true }),
		callback = function(ctx)
			local client = vim.lsp.get_client_by_id(ctx.data.client_id)
			local inlayHintProvider = client and client.server_capabilities.inlayHintProvider
			if not inlayHintProvider or not config.autoEnableHints then return end

			local enable = ctx.event == "LspAttach"
			vim.lsp.inlay_hint.enable(enable, { bufnr = ctx.buf })
			if not enable then vim.api.nvim_buf_clear_namespace(ctx.buf, inlayHintNs, 0, -1) end
		end,
	})

	-- initialize in already open buffers (in case of lazy-loading, etc.)
	if config.autoEnableHints then
		for _, client in pairs(vim.lsp.get_clients()) do
			local buffers = vim.lsp.get_buffers_by_client_id(client.id)
			for _, bufnr in pairs(buffers) do
				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			end
		end
	end
end

---@param config? EolLspHints.config
function M.setup(config)
	require("eol-lsp-hints.config").setup(config)
	init()
end

--------------------------------------------------------------------------------
return M
