vim.keymap.set("t", "<Esc><Esc>", "<c-\\><c-n>")
local config = require("cook.config")

local M = {}
M.state = {
	floating = {
		win = -1,
		buf = -1,
	},
}

local function create_floating_terminal(cmd)
	local opts = config.options.float or {}
	local width = math.floor(vim.o.columns * opts.width)
	local height = math.floor(vim.o.lines * opts.height)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local buf
	if vim.api.nvim_buf_is_valid(M.state.floating.buf) then
		buf = M.state.floating.buf
	else
		buf = vim.api.nvim_create_buf(false, true)
	end

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = height,
		style = "minimal",
		border = opts.border or "rounded",
	})

	vim.api.nvim_buf_call(buf, function()
		vim.cmd({ cmd = "term", args = { "bash", "-c", cmd } })
	end)

	vim.cmd("startinsert")

	M.state.floating.buf = buf
	M.state.floating.win = win
end

function M.toggle_terminal()
	if vim.api.nvim_win_is_valid(M.state.floating.win) then
		vim.api.nvim_win_hide(M.state.floating.win)
	else
		if vim.api.nvim_buf_is_valid(M.state.floating.buf) then
			create_floating_terminal("") -- reopen existing terminal
		else
			vim.notify("[Cook] No previous terminal found. Use :Cook instead.", vim.log.levels.INFO)
		end
	end
end

function M.run(cmd)
	if type(cmd) ~= "string" or cmd == "" then
		vim.notify("[Cook] Invalid or empty command", vim.log.levels.ERROR)
		return
	end
	create_floating_terminal(cmd)
end

return M
