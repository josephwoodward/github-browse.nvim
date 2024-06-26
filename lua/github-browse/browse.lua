---@class Config
---@field opt string Your config option
local config = {}

---@class BrowseModule
local M = {}

local function execute_command(cmd)
  vim.fn.jobstart({ "gh", cmd })
end

---@type Config
M.config = config

---@param args Config?
M.setup = function(args)
  M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

--- Open the current GitHub repository in your default browser.
M.browse_repo = function()
  execute_command("browse")
end

---@param opts object
M.browse_commit = function(opts)
  local commit = opts.args or ""
  if commit == "" then
    -- return "Please specify commit" //TODO: Write test case for this
    vim.notify("GithubBrowse: please specify a commit", vim.log.levels.ERROR)
    return
  end

  vim.fn.jobstart({ "gh", "browse", commit })
end

--- Open file and line number under the course in your browser.
M.browse_line = function()
  -- local start_pos = vim.fn.line("v")
  -- local end_pos = vim.fn.line(".")
  -- local start_pos = vim.api.nvim_buf_get_mark(0, "<") ---@type number[]
  -- local end_pos = vim.api.nvim_buf_get_mark(0, ">") ---@type number[]
  -- print(start_pos)
  -- print(end_pos)

  local cursor_pos, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local file = vim.fn.expand("%:.")

  vim.fn.jobstart({ "gh", "browse", string.format("%s:%s", file, cursor_pos) })
end

return M
