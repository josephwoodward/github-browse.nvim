if vim.fn.has("nvim-0.7.0") == 0 then
  vim.api.nvim_err_writeln("github-browse requires at least nvim-0.7.0.1")
  return
end

-- make sure this file is loaded only once
if vim.g.loaded_github_browse == 1 then
  return
end
vim.g.loaded_github_browse = 1

-- create any global command that does not depend on user setup
-- usually it is better to define most commands/mappings in the setup function
-- Be careful to not overuse this file!
local commands = {
  repo = function(_)
    require("github-browse.browse").browse_repo()
  end,
  -- TODO: enable ability to copy link to clipboard
  line = function(_)
    require("github-browse.browse").browse_line()
  end,
  commit = function(opts)
    require("github-browse.browse").browse_commit(opts)
  end,
  -- TODO: Implement ability to list PRs
  pr = function()
    require("github-browse.browse").browse_prs()
  end,
}

vim.api.nvim_create_user_command("GithubBrowse", function(opts)
  local f = commands[opts.fargs[1]]
  if f ~= nil then
    f(opts.args)
    return
  end

  vim.api.nvim_err_writeln(string.format("[github-browse] unknown command: %s", opts.fargs[1]))
end, {
  nargs = 1,
  complete = function(ArgLead, CmdLine, CursorPos)
    return { "repo", "line", "commit", "pr" }
  end,
})
