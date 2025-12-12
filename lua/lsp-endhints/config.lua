local M = {}
--------------------------------------------------------------------------------

---@class LspEndhints.config
local defaultConfig = {
	autoEnableHints = true,
	icons = {
		type = "󰜁 ",
		parameter = "󰏪 ",
		offspec = " ", -- hint kind not defined in official LSP spec
		unknown = " ", -- hint kind is nil
	},
	label = {
		truncateAtChars = 20,
		padding = 1,
		marginLeft = 0,
		sameKindSeparator = ", ",
	},
	extmark = {
		priority = 50,
	},

	---Function that overrides how hints are displayed.
	---expects as output a table for `virt_text` from `nvim_buf_set_extmark`,
	---that is a table of string tuples (text & highlight group)
	---@type function(hints: {label: string, col: number, kind: string}[], bufnr: number): {[1]: string, [2]: string}[]
	hintFormatFunc = nil,
}
M.config = defaultConfig

---@param config? LspEndhints.config
function M.setup(config) M.config = vim.tbl_deep_extend("force", defaultConfig, config or {}) end

--------------------------------------------------------------------------------
return M
