# GitHub Browse Neovim Extension

A small Neovim wrapper around the GitHub CLI `gh browse` tool to enable fast sharing links to lines, repos or commits in GitHub.

## Requirements

- A recent version of Vim or Neovim
- The [Github CLI](https://cli.github.com/)

## Installation

```
-- Lazy
{ 'josephwoodward/github-browse.nvim' }
```

## Usage

The plugin defines commands that wrap the functionality of zoxide:

- `:GithubBrowse repo`: Opens the current GitHub repository in your default web browser.
- `:GithubBrowse line`: Opens the current GitHub repository in your default web browser.
- `:GithubBrowse commit`: Opens given commit in GitHub in your default web browser.

## Demos

### Browse to Line (`:GithubBrowse line`)

Go to the current line in GitHub:

![browse-line](https://github.com/josephwoodward/github-browse.nvim/assets/1237341/8cfffe4d-775e-4efa-ab1b-f8aaa3db0bef)

### Browse to Line (`:GithubBrowse repo`)

Load the current repository in GitHub:

![browse-repo](https://github.com/josephwoodward/github-browse.nvim/assets/1237341/aac84232-79ab-49dc-9434-c64405695c8c)

### Browse to Line (`:GithubBrowse commit`)

Go to the current commit in GitHub:

![browse-commit](https://github.com/josephwoodward/github-browse.nvim/assets/1237341/1e455938-9a21-492e-abbe-58720cb9ee0c)

Integration with Telescope's git picker can be achived using the following snippet:

```lua
  pickers = {
    git_commits = {
      attach_mappings = function(_, map)
        map({ 'i', 'n' }, '<C-b>', function(_, _)
          local entry = require('telescope.actions.state').get_selected_entry()
          require('github-browse.browse').browse_commit { args = entry.value }
        end)

        -- needs to return true if you want to map default_mappings and
        -- false if not
        return true
      end,
    },
    ...
}
```



