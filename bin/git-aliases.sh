#!/usr/bin/env bash

# Commit with a message
gc() {
  git commit -m "$*"
}

# Git log with decorations
alias gl='git log --oneline --decorate --color --graph'

# Checkout previous branch
alias gkt='git checkout -'

# Reset hard and clean untracked files
alias nah='git reset --hard && git clean -df'

# Undo last commit but keep changes staged
alias putz='git reset --soft HEAD~1'

# Commit all changes with message 'wip'
wip() {
  git add .
  git commit -m "wip" >/dev/null
}

# Commit all changes with 'wip' message and push
wips() {
  git add .
  git commit -m "wip" >/dev/null
  git push
}

# Clear branch cache (from configuration)
alias clrgkb="rm -f '$cache_file' && echo 'Branch cache cleared.'"