local M = {}

function M.check(opts)
	local sub = opts.fargs[1]
	if sub == "test" then
		require("cook.test").test()
	elseif sub == nil or sub == "" or sub == "run" then
		require("cook.run").run()
	else
		vim.notify("Unknown subcommand: " .. tostring(sub), vim.log.levels.ERROR)
	end
end

function M.register()
	vim.api.nvim_create_user_command("Cook", function(opts)
		M.check(opts)
	end, {
		nargs = "?",
		complete = function(arglead)
			local subs = { "run", "test" }
			return vim.tbl_filter(function(x)
				return x:match("^" .. arglead)
			end, subs)
		end,
	})
end
return M
