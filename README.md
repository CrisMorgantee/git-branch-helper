# gkb - Git Branch Management Utility

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

`gkb` is a utility script to simplify the management of Git branches. It allows you to quickly switch between branches,
create new branches, fetch updates, and prune outdated branches. It handles uncommitted changes gracefully by prompting
the user before switching branches.

## Features

- Quickly switch to the latest remote branch matching specified criteria.
- Automatically create new local branches from remote or specified base branches.
- Fetch updates from the remote repository.
- Prune local branches that no longer exist on the remote.
- Clear cached branch information.
- Includes useful Git aliases for common commands.

## Installation

### Using Homebrew

You can install `gkb` using Homebrew:

```sh
brew tap crismorgantee/git-branch-helper
brew install gkb