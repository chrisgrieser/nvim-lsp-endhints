local M = {}
--------------------------------------------------------------------------------

---@class EolLspHints.config
local defaultConfig = {
	icons = {
		type = "󰜁 ",
		parameter = "󰏪 ",
	},
	label = {
		padding = 1,
		marginLeft = 0,
	},
}
M.config = defaultConfig

---@param config? EolLspHints.config
function M.setup(config) M.config = vim.tbl_deep_extend("force", defaultConfig, config or {}) end

--------------------------------------------------------------------------------
return M
