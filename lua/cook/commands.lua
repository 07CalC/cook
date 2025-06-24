-- this module defines commands for the plugin

local recipes = require("cook.recipes")
local executor = require("cook.executor")
local filetype = require("cook.filetype")

local M = {}

-- this allows users to run tasks defined in recipes.lua or execute commands based on the current file
-- @param args table: Arguments passed to the command
-- args only required if a user defined per-project task is to be executed
-- example:
-- M.cook({args = "my_task"})
function M.cook(args)
	local recipes_list = recipes.load_recipes()
	local raw = vim.api.nvim_buf_get_name(0)
	if not raw or raw == "" or raw:match("^%[.+%]$") and not recipes_list then
		vim.notify("Cannot cook unsaved or unnamed buffer.", vim.log.levels.ERROR)
		return
	end

	if args.args and args.args ~= "" and recipes_list then
		local task = recipes_list[args.args]
		if not task then
			vim.notify("Task '" .. args.args .. "' not found.", vim.log.levels.ERROR)
			return
		end
		executor.run(task)
		return
	end

	if recipes_list then
		local task_names = vim.tbl_keys(recipes_list)
		table.sort(task_names)
		vim.ui.select(task_names, { prompt = "Cook task: " }, function(selected_task)
			if selected_task then
				print("Selected task: " .. recipes_list[selected_task])
				executor.run(recipes_list[selected_task])
				return
			else
				vim.notify("No task selected.", vim.log.levels.INFO)
				return
			end
		end)
		return
	end

	local cmd = filetype.resolve(raw)
	if not cmd then
		return
	end

	executor.run(cmd)
end

-- this allows users to run the current file with clipboard as input, helpful for CP
function M.Coop()
	local raw = vim.api.nvim_buf_get_name(0)

	if not raw or raw == "" or raw:match("^%[.+%]$") then
		vim.notify("Cannot cook unsaved or unnamed buffer.", vim.log.levels.ERROR)
		return
	end
	local exec_cmd = filetype.resolve(raw)
	if not exec_cmd then
		return
	end
	local input = vim.fn.getreg("+")
	if not input or input == "" then
		vim.notify("No input provided in the clipboard", vim.log.levels.ERROR)
		return
	end
	local tmp_file = vim.fn.tempname() .. ".in"
	local file = io.open(tmp_file, "w")
	if not file then
		vim.notify("Could not create temporary file for input", vim.log.levels.ERROR)
		return
	end
	file:write(input)
	file:close()
	local cmd = exec_cmd .. " < " .. tmp_file
	executor.run(cmd)
end

return M
