local M = {}
--------------------------------------------------------------------------------

---@class LspEndhints.config
local defaultConfig = {
	icons = {
		type = "󰜁 ",
		parameter = "󰏪 ",
	},
	label = {
		padding = 1,
		marginLeft = 0,
		bracketedParameters = true,
	},
	autoEnableHints = true,
}
M.config = defaultConfig

---@param config? LspEndhints.config
function M.setup(config) M.config = vim.tbl_deep_extend("force", defaultConfig, config or {}) end

--------------------------------------------------------------------------------
return M
