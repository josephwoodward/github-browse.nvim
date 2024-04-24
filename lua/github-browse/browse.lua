---@class Config
---@field opt string Your config option
local config = {
  opt = "Hello!",
}

---@class BrowseModule
local M = {}

-- Show current line in GitHub {{{1
local function trim_space(s)
  return string.gsub(s, "%s+$", "")
end

local function get_github_repo()
  local url = trim_space(vim.fn.system("git config --get remote.origin.url"))
  if string.find(url, "^git@") then
    local parts = {}
    for part in string.gmatch(url, "([^:]+)") do
      table.insert(parts, part)
    end

    url = "https://github.com/" .. parts[2]
  end

  return string.gsub(url, ".git$", "")
end

local function get_current_branch()
  -- local result = trim_space(vim.fn.system("git symbolic-ref refs/remotes/origin/HEAD"))
  -- local parts = {}
  -- for part in string.gmatch(result, "([^/]+)") do
  --   table.insert(parts, part)
  -- end
  -- return parts[#parts]

  local result = trim_space(vim.fn.system("git branch --show-current"))
  return result
end

local function generate_github_link()
  local repo_root = vim.fs.dirname(vim.fs.find(".git", { upward = true })[1])
  local repo = get_github_repo()
  local branch = get_current_branch()
  local path = string.sub(vim.fn.expand("%:p"), string.len(repo_root .. "/") + 1)
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local url = string.format("%s/blob/%s/%s?plain=1#L%s", repo, branch, path, cursor_pos[1])
  return url
end

local function open_program()
  local platform = trim_space(vim.fn.system("uname"))
  local exe = "xdg-open"
  if platform == "Darwin" then
    exe = "open"
  end
  return exe
end

---@type Config
M.config = config

---@param args Config?
M.setup = function(args)
  M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

---@return string
M.browse = function()
  local url = generate_github_link()
  local open = open_program()
  os.execute(string.format('%s "%s" >/dev/null 2>&1', open, url))
  return M.config.opt
end

return M
