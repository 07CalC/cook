local M = {}

local defaults = {
	float = {
		width = 0.8,
		height = 0.8,
		border = "rounded",
	},
	runners = {
		py = "'python3 %s'",
		c = "'gcc %s -o %s && %s'",
		cpp = "'g++ %s -o %s && %s'",
		rs = "'cargo run'",
		js = "'bun %s'",
		ts = "'bun %s'",
		go = "'go run %s'",
	},
}

M.options = vim.deepcopy(defaults)

function M.setup(user_config)
	M.options = vim.tbl_deep_extend("force", M.options, user_config or {})
end

return M
