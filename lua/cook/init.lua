local config = require("cook.config")
local executor = require("cook.executor")
local filetype = require("cook.filetype")

local M = {}

function M.setup(user_config)
	config.setup(user_config or {})
end

function M.cook()
	local raw = vim.api.nvim_buf_get_name(0)
	if not raw or raw == "" or raw:match("^%[.+%]$") then
		vim.notify("Cannot cook unsaved or unnamed buffer.", vim.log.levels.ERROR)
		return
	end

	local cmd = filetype.resolve(raw)
	if not cmd then
		return
	end

	executor.run(cmd)
end

vim.api.nvim_create_user_command("Cook", M.cook, {})

return M
