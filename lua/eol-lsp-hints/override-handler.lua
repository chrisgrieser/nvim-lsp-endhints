---@param inlayHintNs number namespace
return function(inlayHintNs)
	vim.lsp.handlers["textDocument/inlayHint"] = function(err, result, ctx, _)
		local config = require("eol-lsp-hints.config").config

		-- GUARD
		if not result then return end
		local client = vim.lsp.get_client_by_id(ctx.client_id)
		if not client then return end
		if err then
			vim.notify(vim.inspect(err), vim.log.levels.ERROR)
			return
		end

		-- clear existing hints
		vim.api.nvim_buf_clear_namespace(ctx.bufnr, inlayHintNs, 0, -1)

		-- Collect all hints for each line, so we can sort them by column in the loop
		-- below. This ensures that the hints are displayed in the correct order.
		local hintLines = vim.iter(result):fold({}, function(acc, hint)
			local lnum = hint.position.line
			local col = hint.position.character
			local label = hint.label[1].value:gsub("^:", ""):gsub(":$", "")
			-- 1: Type, 2: Parameter -- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#inlayHintKind
			local kind = hint.kind == 1 and "Type" or "Parameter"

			if not acc[lnum] then acc[lnum] = {} end
			table.insert(acc[lnum], { label = label, col = col, kind = kind })
			return acc
		end)

		-- add hints as extmarks for each line
		for lnum, hints in pairs(hintLines) do
			table.sort(hints, function(a, b) return a.col < b.col end)

			-- merge all labels in a line
			-- all hints of same type: prepend icons to merged label
			-- hints of different types: prepend icons to individual label
			local hintsAllTypes = vim.iter(hints):all(function(hint) return hint.kind == "Type" end)
			local hintsAllParams = vim.iter(hints)
				:all(function(hint) return hint.kind == "Parameter" end)
			local allOfSameKind = hintsAllTypes or hintsAllParams

			local mergedLabels = vim.iter(hints)
				:map(function(hint)
					if allOfSameKind then return hint.label end
					local icon = hint.kind == "Type" and config.icons.type or config.icons.parameter
					return icon .. hint.label
				end)
				:join(allOfSameKind and ", " or " ")
			if hintsAllTypes then mergedLabels = config.icons.type .. mergedLabels end
			if hintsAllParams then mergedLabels = config.icons.parameter .. mergedLabels end

			-- add padding & margin
			local padding = (" "):rep(config.label.padding)
			local marginLeft = (" "):rep(config.label.marginLeft)
			local virtText = {
				{ marginLeft, "None" },
				{ padding .. mergedLabels .. padding, "LspInlayHint" },
			}

			vim.api.nvim_buf_set_extmark(ctx.bufnr, inlayHintNs, lnum, 0, {
				virt_text = virtText,
				virt_text_pos = "eol",
			})
		end
	end
end
