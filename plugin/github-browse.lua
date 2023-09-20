local gh = require("github-browse.browse")
vim.api.nvim_create_user_command("GithubBrowse",gh.browse,{})
