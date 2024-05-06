# Github Browse Neovim Extension

A small Neovim wrapper around the GitHub CLI `gh browse` tool to enable fast sharing links to lines of code in GitHub.

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

- `:GithubBrowseRepo`: Opens the current GitHub repository in your default web browser.
- `:GithubBrowseToLink`: Opens the current GitHub repository in your default web browser.
