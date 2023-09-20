local browse = require("github-browse.browse")

---@class Config
---@field opt string Your config option
local config = {
	opt = "Hello!",
}

---@class Browse
local M = {}

---@type Config
M.config = config

---@param args Config?
M.setup = function(args)
	M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

M.browse = function()
	browse.my_first_function()
end

vim.api.nvim_create_user_command("ghbrowse", M.browse, {})
