local M = {}

M.load_project_tasks = function()
  local root = vim.fs.root(0, { "tasks.lua", ".git" })
  if not root then
    return nill
  end

  local path = root .. "/tasks.lua"
  if vim.fn.filereadable(path) == 0 then
    return nil
  end

  local ok, data = pcall(dofile, path)
  if not ok or type(data) ~= "table" then
    return nil
  end

  return data.tasks or nil
end

return M
