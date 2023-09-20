---@class BrowseModule
local M = {}

-- function M.setup()
--     vim.api.nvim_create_user_command("GithubBrowse", M.browse,{})
-- end

---@return string
M.browse = function()
	return "hello world!"
end

return M
