local config = require("cook.config")
local executor = require("cook.executor")
local filetype = require("cook.filetype")
local recipes = require("cook.recipes")
local M = {}

function M.setup(user_config)
	config.setup(user_config or {})
end

function M.cook(args)
	local recipes_list = recipes.load_recipes()
	local raw = vim.api.nvim_buf_get_name(0)
	if not raw or raw == "" or raw:match("^%[.+%]$") and not tasks_list then
		vim.notify("Cannot cook unsaved or unnamed buffer.", vim.log.levels.ERROR)
		return
	end

	if args.args and args.args ~= "" and recipes_list then
		local task = recipes_list[args.args]
		if not task then
			vim.notify("Task '" .. args.args .. "' not found.", vim.log.levels.ERROR)
			return
		end
		print("Cmd: " .. task)
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

vim.api.nvim_create_user_command("Cook", M.cook, {
	nargs = "?",
	complete = function()
		local recipes_list = recipes.load_recipes()
		return recipes_list and vim.tbl_keys(recipes_list) or {}
	end,
})
vim.api.nvim_create_user_command("CookToggle", function()
	require("cook.executor").toggle_terminal()
end, {})

return M
