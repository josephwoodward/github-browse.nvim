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
  line = function(_)
    require("github-browse.browse").browse_line()
  end,
  commit = function(opts)
    require("github-browse.browse").browse_commit(opts)
  end,
}

vim.api.nvim_create_user_command("GithubBrowse", function(opts)
  commands[opts.fargs[1]](opts.args)
end, {
  nargs = 1,
  complete = function(ArgLead, CmdLine, CursorPos)
    -- return completion candidates as a list-like table
    return { "repo", "line", "commit" }
  end,
})
