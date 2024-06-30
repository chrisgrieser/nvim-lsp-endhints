local M = {}
local inlayHintNs = vim.api.nvim_create_namespace("EolInlayHints")
--------------------------------------------------------------------------------

---@param config? EolLspHints.config
function M.setup(config) require("eol-lsp-hints.config").setup(config) end

require("eol-lsp-hints.override-handler")(inlayHintNs)

-- lsp attach/detach
local group = vim.api.nvim_create_augroup("EolInlayHints", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
	group = group,
	callback = function(ctx) vim.lsp.inlay_hint.enable(true, { bufnr = ctx.buf }) end,
})
vim.api.nvim_create_autocmd("LspDetach", {
	group = group,
	callback = function(ctx)
		vim.api.nvim_buf_clear_namespace(ctx.buf, inlayHintNs, 0, -1)
		vim.lsp.inlay_hint.enable(false, { bufnr = ctx.buf })
	end,
})

-- initialize in already open buffers (in case of lazy-loading, etc.)
for _, client in pairs(vim.lsp.get_clients()) do
	local buffers = vim.lsp.get_buffers_by_client_id(client.id)
	for _, bufnr in pairs(buffers) do
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end
end

--------------------------------------------------------------------------------
return M
