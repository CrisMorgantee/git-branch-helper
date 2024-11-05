#!/usr/bin/env bash
# lib/options.sh

parse_options() {
  while getopts "nac:hpr" opt; do
    case $opt in
    n) sync=false ;;
    a) fetch_all=true ;;
    c) cache_duration="$OPTARG" ;;
    h)
      show_help
      exit 0
      ;;
    p) prune=true ;;
    *)
      show_help
      exit 1
      ;;
    esac
  done
  shift $((OPTIND - 1))
  branch_name="$1"
}