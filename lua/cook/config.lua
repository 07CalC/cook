-- this module configures the Cook plugin
-- it allows users to set custom runners and UI options

local M = {}

-- default configuration options for the Cook plugin
-- these can be overridden by the user in their setup function
local defaults = {
	float = {
		width = 0.8,
		height = 0.8,
		border = "rounded",
	},
	runners = {
		py = "python3 %s",
		c = "gcc %s -o %s && .%s",
		cpp = "g++ %s -o %s && .%s",
		rs = "cargo run",
		js = "bun %s",
		ts = "bun %s",
		go = "go run %s",
	},
}

-- Initialize the options table with defaults
M.options = vim.deepcopy(defaults)

-- Setup function to initialize the plugin with user configuration
function M.setup(user_config)
	M.options = vim.tbl_deep_extend("force", M.options, user_config or {})
end

return M
