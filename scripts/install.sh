#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf 'Usage: %s /path/to/project\n' "$0" >&2
}

if [ "$#" -ne 1 ]; then
  usage
  exit 2
fi

target_dir=$1
script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_dir=$(CDPATH= cd -- "$script_dir/.." && pwd)

if [ ! -d "$target_dir" ]; then
  printf 'Target directory does not exist: %s\n' "$target_dir" >&2
  exit 1
fi

mkdir -p "$target_dir/docs" "$target_dir/.github"

copy_file() {
  src=$1
  dest=$2

  if [ -e "$dest" ]; then
    backup="${dest}.bak.$(date +%Y%m%d%H%M%S)"
    cp "$dest" "$backup"
    printf 'Backed up existing %s to %s\n' "$dest" "$backup"
  fi

  cp "$src" "$dest"
  printf 'Installed %s\n' "$dest"
}

copy_file "$repo_dir/templates/AGENTS.md" "$target_dir/AGENTS.md"
copy_file "$repo_dir/docs/agent-review-checklist.md" "$target_dir/docs/agent-review-checklist.md"
copy_file "$repo_dir/docs/testing-strategy.md" "$target_dir/docs/testing-strategy.md"
copy_file "$repo_dir/templates/github/pull_request_template.md" "$target_dir/.github/pull_request_template.md"

printf '\nAgent Workflow Kit installed. Edit AGENTS.md with this project'\''s real commands before relying on it.\n'
