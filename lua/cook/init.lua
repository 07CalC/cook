local config = require("cook.config")
local commands = require("cook.commands")

local M = {}

function M.setup(user_config)
	config.setup(user_config or {})
	commands.register()
end

return M
