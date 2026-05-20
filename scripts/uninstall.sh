#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat >&2 <<'USAGE'
Usage: scripts/uninstall.sh /path/to/project [options]

Remove files previously installed by Agent Workflow Kit.

Options:
  --dry-run         Show what would be removed without deleting files
  --force           Remove listed files even when checksums changed
  --keep-manifest   Keep .agent-workflow-kit/manifest
  --help            Show this help
USAGE
}

dry_run=false
force=false
keep_manifest=false
target_dir=

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run)
      dry_run=true
      shift
      ;;
    --force)
      force=true
      shift
      ;;
    --keep-manifest)
      keep_manifest=true
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    -*)
      printf 'Unknown option: %s\n' "$1" >&2
      usage
      exit 2
      ;;
    *)
      if [ -n "$target_dir" ]; then
        printf 'Unexpected extra argument: %s\n' "$1" >&2
        usage
        exit 2
      fi
      target_dir=$1
      shift
      ;;
  esac
done

if [ -z "$target_dir" ]; then
  usage
  exit 2
fi

if [ ! -d "$target_dir" ]; then
  printf 'Target directory does not exist: %s\n' "$target_dir" >&2
  exit 1
fi

target_dir=$(CDPATH= cd -- "$target_dir" && pwd)
manifest="$target_dir/.agent-workflow-kit/manifest"

if [ ! -f "$manifest" ]; then
  printf 'Manifest not found: %s\n' "$manifest" >&2
  exit 1
fi

checksums_file=$(mktemp)
files_file=$(mktemp)
trap 'rm -f "$checksums_file" "$files_file"' EXIT

section=
while IFS= read -r line; do
  case "$line" in
    files=)
      section=files
      continue
      ;;
    checksums=)
      section=checksums
      continue
      ;;
    *=*)
      section=
      continue
      ;;
  esac

  if [ -z "$line" ]; then
    continue
  fi

  case "$section" in
    files)
      printf '%s\n' "$line" >> "$files_file"
      ;;
    checksums)
      printf '%s\n' "$line" >> "$checksums_file"
      ;;
  esac
done < "$manifest"

expected_checksum() {
  rel_path=$1
  awk -v path="$rel_path" '$2 == path { print $1; exit }' "$checksums_file"
}

remove_empty_dir() {
  dir=$1

  while [ "$dir" != "$target_dir" ] && [ "$dir" != "/" ]; do
    case "${dir#"$target_dir"/}" in
      .git|.git/*)
        return
        ;;
    esac

    if [ "$dry_run" = true ]; then
      printf '[dry-run] rmdir --ignore-fail-on-non-empty %s\n' "$dir"
      return
    fi

    if ! rmdir "$dir" 2>/dev/null; then
      return 0
    fi
    dir=$(dirname -- "$dir")
  done
}

while IFS= read -r rel_path; do
  case "$rel_path" in
    ''|/*|*'..'*)
      printf 'Skipping unsafe path from manifest: %s\n' "$rel_path" >&2
      continue
      ;;
  esac

  path="$target_dir/$rel_path"
  if [ ! -e "$path" ]; then
    printf 'Already absent %s\n' "$path"
    continue
  fi

  expected=$(expected_checksum "$rel_path")
  if [ "$force" = false ] && [ -n "$expected" ] && [ -f "$path" ]; then
    actual=$(sha256sum "$path" | awk '{print $1}')
    if [ "$actual" != "$expected" ]; then
      printf 'Skipped modified file %s\n' "$path"
      continue
    fi
  fi

  if [ "$dry_run" = true ]; then
    printf '[dry-run] rm %s\n' "$path"
  else
    rm -f "$path"
    printf 'Removed %s\n' "$path"
    remove_empty_dir "$(dirname -- "$path")"
  fi
done < "$files_file"

if [ "$keep_manifest" = false ]; then
  if [ "$dry_run" = true ]; then
    printf '[dry-run] rm %s\n' "$manifest"
  else
    rm -f "$manifest"
    printf 'Removed %s\n' "$manifest"
    remove_empty_dir "$(dirname -- "$manifest")"
  fi
fi
