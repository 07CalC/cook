-- this module loads recipes from a lua file in the root of the project
-- it expects a table with a key "recipes" containing the project specific tasks
-- example:
-- recipes = {
--    my_task = "echo hello world"
-- }
local M = {}

M.load_recipes = function()
	-- find the root of the project by looking for recipes.lua or .git
	local root = vim.fs.root(0, { "recipes.lua", ".git" })
	if not root then
		return nil
	end

	-- construct the path to recipes.lua
	local path = root .. "/recipes.lua"
	if vim.fn.filereadable(path) == 0 then
		return nil
	end

	local ok, data = pcall(dofile, path)
	if not ok or type(data) ~= "table" then
		return nil
	end

	-- return the recipes table if it exists, otherwise return nil
	return data.recipes or nil
end

return M
