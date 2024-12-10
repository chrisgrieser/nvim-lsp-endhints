local M = {}
--------------------------------------------------------------------------------

---@class LspEndhints.config
local defaultConfig = {
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
	autoEnableHints = true,
}
M.config = defaultConfig

---@param config? LspEndhints.config
function M.setup(config) M.config = vim.tbl_deep_extend("force", defaultConfig, config or {}) end

--------------------------------------------------------------------------------
return M
