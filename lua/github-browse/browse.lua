---@class Config
---@field opt string Your config option
local config = {
  opt = "Hello!",
}

---@class BrowseModule
local M = {}

---@type Config
M.config = config

---@param args Config?
M.setup = function(args)
  M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

---@return string
M.browse = function()
  return M.config.opt
end

return M
