local config = require("cook.config")

local M = {}

function M.run(cmd)
	local opts = config.options.float
	local width = math.floor(vim.o.columns * opts.width)
	local height = math.floor(vim.o.lines * opts.height)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = height,
		style = "minimal",
		border = opts.border or "single",
	})

	vim.api.nvim_buf_call(buf, function()
		vim.cmd({ cmd = "term", args = { "bash", "-c", cmd } })
	end)

	vim.cmd("startinsert")
end

return M
