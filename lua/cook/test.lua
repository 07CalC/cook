local executor = require("cook.executor")
local resolve = require("cook.filetype").resolve

local M = {}

function M.test()
	local raw = vim.api.nvim_buf_get_name(0)
	if not raw or raw == "" or raw:match("^%[.+%]$") then
		vim.notify("Cannot cook unsaved or unnamed buffer.", vim.log.levels.ERROR)
		return
	end

	local cmd = resolve(raw)
	if not cmd then
		return
	end

	local input = vim.fn.getreg("+")
	if input == "" then
		return vim.notify("Clipboard Is Empty", vim.log.levels.WARN)
	end

	local tmp = vim.fn.tempname() .. ".inp"
	vim.fn.writefile(vim.split(input, "\n"), tmp)

	cmd = cmd .. " < " .. vim.fn.shellescape(tmp)

	executor.run(cmd)
end

return M
