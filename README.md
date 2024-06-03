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

## Demo

### Browse to Line

Go to the current line in GitHub:

![browse-line](https://github.com/josephwoodward/github-browse.nvim/assets/1237341/8cfffe4d-775e-4efa-ab1b-f8aaa3db0bef)

