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

local function callback(_, data, event)
  if event == "exit" then
  elseif event == "stdout" or event == "stderr" then
    -- vim.inspect(type(data))
    -- print(vim.inspect(type(data)))
    for i = 1, #data do
      -- print(data[i])
      print(vim.inspect(type(data[i])))
    end
    -- for k, v in pairs(data) do
    --   print(k, v[0], v[1], v[2])
    -- end
    -- print(data)
  end
end

M.browse_prs = function()

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values

  local list_prs = function(opts, data)
    opts = opts or {}
    pickers
        .new(opts, {
          prompt_title = "View Pull Requests",
          -- finder = finders.new_table({
          --   -- results = { "red", "green", "blue" },
          --   results = data
          -- }),
   finder = finders.new_table {
      results = {
        { "red", "#ff0000" },
        { "green", "#00ff00" },
        { "blue", "#0000ff" },
      },
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry[1],
          ordinal = entry[1],
        }
      end
    },
          sorter = conf.generic_sorter(opts),
        })
        :find()
  end

  local cb = function(_, data, event)
    if event == "exit" then
      -- TODO: handle this gracefully
    elseif event == "stdout" or event == "stderr" then
      list_prs({}, data)
    end
  end

  vim.fn.jobwait({
    vim.fn.jobstart("gh pr list --jq '.[] | .url' --json url", {
      on_stdout = cb,
      stdout_buffered = true,
      stderr_buffered = true,
    }),
  })

  -- local colors = function(opts)
  --   opts = opts or {}
  --   pickers.new(opts, {
  --     prompt_title = "colors",
  --     finder = finders.new_table {
  --       results = { "red", "green", "blue" }
  --     },
  --     sorter = conf.generic_sorter(opts),
  --   }):find()
  -- end
  -- colors()
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
---@param opts object
M.browse_line = function(opts)
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

M.copy_line = function(opts)
  local cursor_pos, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local file = vim.fn.expand("%:.")

  -- vim.fn.jobstart({ "gh", "browse", string.format("gh browse %s:%s --no-brower", file, cursor_pos))
  local cb = function(_, data, event)
    if event == "exit" then
      -- TODO: handle this gracefully
    elseif event == "stdout" or event == "stderr" then
      vim.fn.setreg('"', data)
      vim.fn.setreg("+", data)
      vim.notify("-> line copied to clipboard")
    end
  end

  vim.fn.jobwait({
    vim.fn.jobstart(string.format("gh browse %s:%s --no-browser", file, cursor_pos), {
      on_stdout = cb,
      stdout_buffered = true,
      stderr_buffered = true,
    }),
  })
end

return M
