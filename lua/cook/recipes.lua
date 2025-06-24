local M = {}

M.load_recipes = function()
  local root = vim.fs.root(0, { "recipes.lua", ".git" })
  if not root then
    return nil
  end

  local path = root .. "/recipes.lua"
  if vim.fn.filereadable(path) == 0 then
    return nil
  end

  local ok, data = pcall(dofile, path)
  if not ok or type(data) ~= "table" then
    return nil
  end

  return data.recipes or nil
end

return M
