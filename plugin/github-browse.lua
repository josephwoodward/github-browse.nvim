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
local gh = require("github-browse.browse")
vim.api.nvim_create_user_command("GithubBrowseRepo", gh.browse_repo, {})
vim.api.nvim_create_user_command("GithubBrowseLine", gh.browse_line, {})
vim.api.nvim_create_user_command("GithubBrowseCommit", gh.browse_commit, {})
