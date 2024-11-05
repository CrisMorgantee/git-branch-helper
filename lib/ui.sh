#!/usr/bin/env bash
# lib/ui.sh

show_help() {
  cat <<EOF
Usage: git-brancher [options] [branch_name]

Options:
  -n          Do not execute 'git pull' after checkout.
  -a          Execute 'git fetch --all'.
  -c DURATION Set cache duration in minutes (default: 30).
  -p          Prune local branches that no longer exist on the remote.
  -h          Show this help message.
EOF
}