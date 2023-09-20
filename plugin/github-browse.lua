local gh = require("github-browse.init")
vim.api.nvim_create_user_command("GithubBrowse",gh.browse,{})
