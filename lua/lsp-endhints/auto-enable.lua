local config = require("lsp-endhints.config").config
if not config.autoEnableHints then return end
--------------------------------------------------------------------------------

local ns = vim.api.nvim_create_namespace("lspEndhints")

-- initialize in already open buffers (in case of lazy-loading, etc.)
vim.iter(vim.lsp.get_clients())
	:filter(function(client) return client.server_capabilities.inlayHintProvider end)
	:each(function(client)
		vim.iter(vim.lsp.get_buffers_by_client_id(client.id))
			:each(function(bufnr) vim.lsp.inlay_hint.enable(true, { bufnr = bufnr }) end)
	end)

-- auto-enable/disable on lsp attach/detach
vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
	group = vim.api.nvim_create_augroup("lspEndhints", { clear = true }),
	callback = function(ctx)
		local client = vim.lsp.get_client_by_id(ctx.data.client_id)
		local inlayHintProvider = client and client.server_capabilities.inlayHintProvider
		if not inlayHintProvider then return end

		local enable = ctx.event == "LspAttach"
		vim.lsp.inlay_hint.enable(enable, { bufnr = ctx.buf })
		if not enable then vim.api.nvim_buf_clear_namespace(ctx.buf, ns, 0, -1) end
	end,
})
