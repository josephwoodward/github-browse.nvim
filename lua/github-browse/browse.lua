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

local function open_in_browser(path)
  local cmd
  if vim.fn.has("mac") == 1 then
    cmd = { "open", path }
  elseif vim.fn.has("unix") == 1 then
    cmd = { "xdg-open", path }
  elseif vim.fn.has("win32") == 1 then
    cmd = { "cmd.exe", "/c", "start", path }
  else
    vim.notify("GithubBrowse: Unsupported system for opening browser.", vim.log.levels.ERROR)
    return
  end

  vim.fn.jobstart(cmd, { detach = true })
end

M.browse_prs = function()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local entry_display = require("telescope.pickers.entry_display")

  local displayer = entry_display.create({
    separator = " ",
    items = {
      { width = 20 }, -- label
      { remaining = true }, -- subtext
    },
  })

  local make_display = function(entry)
    return displayer({
      entry.label,
      { entry.subtext, "Comment" },  -- Use 'Comment' or another faint highlight group
    })
  end

  local list_prs = function(opts, entries)
    opts = opts or {}
    pickers
        .new(opts, {
          prompt_title = "View Pull Requests",
          finder = finders.new_table({
            results = entries,
            entry_maker = function(entry)
              return {
                value = entry.value,
                display = "#" .. entry.number .. " - " .. entry.display,
                ordinal = entry.number,
              }
            end,
          }),
          attach_mappings = function(prompt_bufnr, _)
            actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              open_in_browser(action_state.get_selected_entry().value)
            end)
            return true
          end,
          sorter = conf.generic_sorter(opts),
        })
        :find()
  end

  local cb = function(_, data, event)
    if event == "exit" then
      -- TODO: handle this gracefully
    elseif event == "stdout" or event == "stderr" then
      local entries = {}

      local items = vim.fn.json_decode(data)
      for _, item in ipairs(items) do
        -- print(vim.inspect(item))
        table.insert(entries, {
          value = item.url,
          display = item.title,
          number = item.number,
        })
      end

      list_prs({}, entries)
    end
  end

  vim.fn.jobwait({
    vim.fn.jobstart("gh pr list --json number,title,url --limit 20", {
      on_stdout = cb,
      stdout_buffered = true,
      stderr_buffered = true,
    }),
  })
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
