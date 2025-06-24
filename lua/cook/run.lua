local resolve = require("cook.filetype").resolve
local executor = require("cook.executor")

local M = {}

function M.run()
	local raw = vim.api.nvim_buf_get_name(0)
	if not raw or raw == "" or raw:match("^%[.+%]$") then
		vim.notify("Cannot cook unsaved or unnamed buffer.", vim.log.levels.ERROR)
		return
	end

	local cmd = resolve(raw)
	if cmd then
		executor.run(cmd)
	end
end

return M
