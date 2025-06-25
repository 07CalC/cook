-- this module executes commands in a floating terminal

-- keymap to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<c-\\><c-n>")
local config = require("cook.config")

local M = {}

-- State to keep track of the floating terminal
M.state = {
	floating = {
		win = -1,
		buf = -1,
	},
}

-- Creates a floating terminal with the given command
local function create_floating_terminal(cmd)
	local opts = config.options.terminal or {}
	local layout = opts.layout or "float"
	local width = math.floor(vim.o.columns * opts.width)
	local height = math.floor(vim.o.lines * opts.height)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local buf
	local is_new_buf
	if vim.api.nvim_buf_is_valid(M.state.floating.buf) then
		buf = M.state.floating.buf
		is_new_buf = true
	else
		buf = vim.api.nvim_create_buf(false, true)
	end

	local win
	if layout == "bottom" then
		vim.cmd("botright split")
		win = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_height(win, height)
		vim.api.nvim_win_set_buf(win, buf)
	elseif layout == "vertical" then
		vim.cmd("vsplit")
		win = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_width(win, width)
		vim.api.nvim_win_set_buf(win, buf)
	else
		win = vim.api.nvim_open_win(buf, true, {
			relative = "editor",
			row = row,
			col = col,
			width = width,
			height = height,
			style = "minimal",
			border = opts.border or "rounded",
		})
	end

	M.state.floating.buf = buf
	M.state.floating.win = win

	if not is_new_buf then
		cmd = string.format("echo -e \"\\x1b[0;32m[RUN]: '%s'\\x1b[0m\\n\"  && %s", cmd, cmd)

		vim.api.nvim_buf_call(buf, function()
			vim.cmd({ cmd = "term", args = { cmd } })
		end)
		vim.bo[M.state.floating.buf].buflisted = false
	end

	vim.cmd("startinsert")
end

-- toggles the floating terminal
-- If the terminal is already open, it hides it.
-- use <Esc><Esc> to exit terminal mode
-- use :Cookt in normal mode to toggle the terminal
-- user can also use keymap `<leader><leader>t` in both normal and terminal modes to toggle
function M.toggle_terminal()
	if vim.api.nvim_win_is_valid(M.state.floating.win) then
		vim.api.nvim_win_close(M.state.floating.win, true)
	else
		if vim.api.nvim_buf_is_valid(M.state.floating.buf) then
			create_floating_terminal("") -- reopen existing terminal
		else
			vim.notify("[Cook] No previous terminal found. Use :Cook instead.", vim.log.levels.INFO)
		end
	end
end

-- Runs a command in a floating terminal
-- @param cmd string: The command to run in the terminal
-- example:
-- M.run("python3 /path/to/script.py")
function M.run(cmd)
	if type(cmd) ~= "string" or cmd == "" then
		vim.notify("[Cook] Invalid or empty command", vim.log.levels.ERROR)
		return
	end

	if string.sub(cmd, 1, 1) == "!" then
		vim.cmd(string.sub(cmd, 2, -1))
		return
	end

	create_floating_terminal(cmd)
end

return M
