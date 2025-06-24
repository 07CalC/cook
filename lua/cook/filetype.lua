local config = require("cook.config")

local M = {}

function M.resolve(filepath)
	filepath = vim.fn.fnamemodify(filepath, ":p")
	if type(filepath) ~= "string" then
		vim.notify("Cook error: invalid filepath", vim.log.levels.ERROR)
		return nil
	end

	local ext = filepath:match("^.+%.([%w]+)$")
	if not ext then
		vim.notify("Could not determine extension for: " .. filepath, vim.log.levels.WARN)
		return nil
	end

	local runner = config.options.runners[ext]
	if type(runner) ~= "string" then
		vim.notify("No valid recipie for ." .. ext, vim.log.levels.WARN)
		return nil
	end

	if not runner:match("%s") then
		vim.notify("Recipie for ." .. ext .. " must contain '%s'", vim.log.levels.ERROR)
		return nil
	end

	if ext == "c" or ext == "cpp" then
		local folder = vim.fn.fnamemodify(filepath, ":h")
		local name = vim.fn.fnamemodify(filepath, ":t:r")
		local exe = folder .. "/" .. name
		return string.format(runner, filepath, exe, exe)
	end

	return string.format(runner, filepath)
end

return M
