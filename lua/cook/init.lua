-- Main entry point for the Cook plugin
-- this module sets up the plugin and registers user commands

local config = require("cook.config")
local recipes = require("cook.recipes")
local commands = require("cook.commands")
local M = {}

-- setup function to initialize the plugin with user configuration
-- @param user_config table: User-defined configuration options
-- example:
-- M.setup({
--  runners = {
--    py = "python3 %s",
--    sh = "bash %s",
--  }
-- })
function M.setup(user_config)
	config.setup(user_config or {})
end

-- register Cook command
-- this allows users to run tasks defined in recipes.lua or execute commands based on the current file
-- @see commands.lua for command implementations
vim.api.nvim_create_user_command("Cook", commands.cook, {
	nargs = "?",
	complete = function()
		local recipes_list = recipes.load_recipes()
		return recipes_list and vim.tbl_keys(recipes_list) or {}
	end,
})

-- register Coop command
-- this allows users to run the current file with clipboard as input, helpful for CP
-- @see commands.lua for command implementation
vim.api.nvim_create_user_command("Coop", commands.Coop, {})

-- not completely implemented yet
vim.api.nvim_create_user_command("Cookt", function()
	require("cook.executor").toggle_terminal()
end, {})

-- keymaps to toggle the terminal
vim.keymap.set("n", "<leader><leader>t", function()
	require("cook.executor").toggle_terminal()
end, { desc = "Toggle Cook terminal" })

vim.keymap.set("t", "<leader><leader>t", function()
	require("cook.executor").toggle_terminal()
end, { desc = "Toggle Cook terminal (terminal mode)" })

-- keymaps to run the current file with the configured runner
vim.keymap.set("n", "<leader><leader>r", function()
	commands.cook(vim.fn.expand("%:p"))
end, {
	desc = "Run current file with Cook",
	noremap = true,
	silent = true,
})

-- keymaps to run the current file with clipboard as input
vim.keymap.set("n", "<leader><leader>p", function()
	commands.Coop()
end, {
	desc = "Run current file with clipboard as input",
	noremap = true,
	silent = true,
})

return M
