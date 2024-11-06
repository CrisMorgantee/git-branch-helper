#!/usr/bin/env bash

# ━━━━━━ GIT ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╸
alias gc="git commit -m $1"
alias gl="git log --oneline --decorate --color --graph"
alias gkt='git checkout -'
alias nah="git reset --hard && git clean -df"
alias putz="git reset --soft HEAD~1"
alias wip="git add .; git commit -m 'wip' > /dev/null"
alias wips="git add .; git commit -m 'wip' > /dev/null; git push"

# Commit with a message
#gc() {
#  git commit -m "$*"
#}

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

alias gst='git status'
alias gss='git status --short'
alias gsb='git status --short --branch'
alias gc='git commit --message'
alias gca='git commit --verbose --all --message'
alias gcaa='git commit --verbose --all --message --amend'

alias gcb='git checkout -b'
alias gcB='git checkout -B'
alias gcd='git checkout $(git_develop_branch)'
alias gcm='git checkout $(git_main_branch)'
alias gco='git checkout'
alias gb='git branch'
alias gba='git branch --all'
alias gbd='git branch --delete'

alias ga='git add'
alias gaa='git add --all'

function grename() {
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: $0 old_branch new_branch"
    return 1
  fi

  # Rename branch locally
  git branch -m "$1" "$2"
  # Rename branch in origin remote
  if git push origin :"$1"; then
    git push --set-upstream origin "$2"
  fi
}

# Check if main exists and use instead of master
function git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local ref
  for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default,stable,master}; do
    if command git show-ref -q --verify $ref; then
      echo ${ref:t}
      return 0
    fi
  done

  # If no main branch was found, fall back to master but return error
  echo master
  return 1
}

# Check for develop and similarly named branches
function git_develop_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local branch
  for branch in dev devel develop development; do
    if command git show-ref -q --verify refs/heads/$branch; then
      echo $branch
      return 0
    fi
  done

  echo develop
  return 1
}

# ━━━━━━ CHANGE DEFAULT ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╸
alias c="ditto"                   # similar `cp`
alias bat='bat --theme="Dracula"' # similar `cat`

# ━━━━━━ LARAVEL ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╸
alias a="php artisan"
alias m="a migrate"
alias mm="a make:model"
alias mc="a make:controller"
alias mr="a -r make:controller"
alias ma="a make:model -cmrfs"
alias mf="a migrate:fresh"
alias mfs="a migrate:fresh --seed"
alias mrs="a migrate:refresh --seed" # Migrar e semear
alias rl="a route:list"
alias horizon="a horizon"
alias key="a key:generate"
alias pint="./vendor/bin/pint"
alias slink="a storage:link"
alias tk="a tinker"
alias tp="a test --parallel"

# ━━━━━━ SYSTEM ADMIN ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╸
alias mkdir="mkdir -pv"
alias ping="ping -c 5"
alias clr="clear; echo Currently logged in on $TTY, as $USERNAME in directory $PWD."
alias hist="history | grep" # Pesquisa rápida no histórico

# ━━━━━━ USER ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╸

# ╔════════════════════════════════════╗
# ║ FUNCTIONS                         ║
# ╚════════════════════════════════════╝

# ━━━━━━ Function to create a symbolic link to the project in Herd Valet ━━━━━━╸
function link_project() {
  project=$1
  full_dir=$(pwd)

  if [[ -z "$project" ]]; then
    project=$(basename "$PWD")
  fi

  eval "ln -s $full_dir ~/projects/herd-valet-links/$project"
  open "https://$project.test"
}

# ━━━━━━ Function to create a new Git branch with validation ━━━━━━━━━━━━━━━━━━╸
function new_branch() {
  # === Checks if it is in a Git repository =================================
  git rev-parse --is-inside-work-tree &>/dev/null || {
    echo "Error: It's not a Git repository."
    return 1
  }

  # === Check parameters ====================================================
  if [ $# -ne 2 ]; then
    echo "Usage: new_branch <type> <task>"
    echo "Please, provide a type and task for the new branch. Example: type ('feature', 'fix'), task ('task-1', 'task-2')"
    return 1
  fi

  type=$1
  task_name=$2
  branch_name="$type/$task_name"

  # === Checks if the branch already exists =========================================
  if git show-ref --quiet refs/heads/"$branch_name"; then
    echo "Branch '$branch_name' already exists."
    return 1
  fi

  # === Create the new branch =====================================================
  git checkout -b "$branch_name"
  echo "Branch '$branch_name' successfully created."
}