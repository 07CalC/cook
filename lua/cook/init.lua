local config = require("cook.config")
local recipes = require("cook.recipes")
local commands = require("cook.commands")
local M = {}

function M.setup(user_config)
	config.setup(user_config or {})
end

vim.api.nvim_create_user_command("Cook", commands.cook, {
	nargs = "?",
	complete = function()
		local recipes_list = recipes.load_recipes()
		return recipes_list and vim.tbl_keys(recipes_list) or {}
	end,
})
vim.api.nvim_create_user_command("Coop", commands.Coop, {})
vim.api.nvim_create_user_command("CookToggle", function()
	require("cook.executor").toggle_terminal()
end, {})

return M
