local M = {}
--------------------------------------------------------------------------------

function M.refreshHandler()
	---@param err table
	---@param result lsp.InlayHint[]?
	---@param ctx lsp.HandlerContext
	---@param _ table -- config
	vim.lsp.handlers["textDocument/inlayHint"] = function(err, result, ctx, _)
		local config = require("lsp-endhints.config").config
		local bufnr = ctx.bufnr or -1
		if not vim.api.nvim_buf_is_valid(bufnr) then return end

		-- GUARD
		if not result then return end
		local client = vim.lsp.get_client_by_id(ctx.client_id)
		if not client then return end
		local inlayHintProvider = client.server_capabilities.inlayHintProvider
		if not inlayHintProvider then return end
		if err then
			vim.notify(vim.inspect(err), vim.log.levels.ERROR)
			return
		end

		local inlayHintNs = vim.api.nvim_create_namespace("lspEndhints")
		vim.api.nvim_buf_clear_namespace(bufnr, inlayHintNs, 0, -1)

		-- Collect all hints for each line, so we can sort them by column in the loop
		-- below. This ensures that the hints are displayed in the correct order.
		local hintLines = vim.iter(result):fold({}, function(acc, hint)
			local lnum = hint.position.line
			local col = hint.position.character
			-- label is either string or `InlayHintLabelPart[]` https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#inlayHint
			local label = hint.label
			if type(label) ~= "string" then
				label = vim.iter(hint.label)
					:map(function(labelPart) return labelPart.value end)
					:join("")
			end
			label = vim.trim(label:gsub("^:", ""):gsub(":$", ""))

			-- 1: type, 2: parameter -- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#inlayHintKind
			local kind = "unknown"
			if hint.kind == 1 then kind = "type" end
			if hint.kind == 2 then kind = "parameter" end

			if not acc[lnum] then acc[lnum] = {} end
			table.insert(acc[lnum], { label = label, col = col, kind = kind })
			return acc
		end)

		-- add hints as extmarks for each line
		for lnum, hints in pairs(hintLines) do
			table.sort(hints, function(a, b) return a.col < b.col end)

			-- merge hints
			-- add icon only when parameter kind is different from the previous one
			local hintsMerged = ""
			for i = 1, #hints do
				local hint = hints[i]
				local lastKind = hints[i - 1] and hints[i - 1].kind

				if config.label.bracketedParameters and hint.kind == "parameter" then
					local nextKind = hints[i + 1] and hints[i + 1].kind
					if lastKind ~= "parameter" then hint.label = "(" .. hint.label end
					if nextKind ~= "parameter" then hint.label = hint.label .. ")" end
				end

				if lastKind == hint.kind then
					hintsMerged = hintsMerged .. ", " .. hint.label
				else
					local icon = config.icons[hint.kind] or "[?]"
					local pad = i ~= 1 and " " or ""
					hintsMerged = hintsMerged .. pad .. icon .. hint.label
				end
			end

			-- add padding & margin
			local padding = (" "):rep(config.label.padding)
			local marginLeft = (" "):rep(config.label.marginLeft)
			local virtText = {
				{ marginLeft, "None" },
				{ padding .. hintsMerged .. padding, "LspInlayHint" },
			}

			vim.api.nvim_buf_set_extmark(bufnr, inlayHintNs, lnum, 0, {
				virt_text = virtText,
				virt_text_pos = "eol",
				hl_mode = "combine", -- ensures highlights are combined with the background, see #2
				strict = false, -- prevents error on quick buffer changes (e.g. many undos)
			})
		end
	end
end

function M.disableHandler()
	local originalDisableHandler = vim.lsp.inlay_hint.enable
	local inlayHintNs = vim.api.nvim_create_namespace("lspEndhints")

	---@param enable boolean|nil true/nil to enable, false to disable
	---@param filter? vim.lsp.inlay_hint.enable.Filter
	---@diagnostic disable-next-line: duplicate-set-field intentional override
	vim.lsp.inlay_hint.enable = function(enable, filter)
		if enable == false then
			local buffers = (filter and filter.bufnr) and { filter.bufnr }

			-- if no buffer filter provided, disable in all buffers
			if not buffers then
				buffers = vim.iter(vim.lsp.get_clients())
					:map(function(client) return vim.lsp.get_buffers_by_client_id(client.id) end)
					:flatten()
					:totable()
			end

			for _, bufnr in pairs(buffers) do
				vim.api.nvim_buf_clear_namespace(bufnr, inlayHintNs, 0, -1)
			end
		end

		originalDisableHandler(enable, filter)
	end
end

--------------------------------------------------------------------------------
return M
