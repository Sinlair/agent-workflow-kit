#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat >&2 <<'USAGE'
Usage: scripts/install.sh /path/to/project [options]

Options:
  --profile NAME    Template profile: auto, generic, node, python, go, rust, nextjs
  --dry-run         Show what would be installed without writing files
  --force           Overwrite existing files without creating backups
  --mode MODE       Existing-file behavior: backup, skip, overwrite
  --no-agent-files  Do not install CLAUDE.md, GEMINI.md, Copilot, or Cursor files
  --no-docs         Do not install review and testing docs
  --with-ci         Install a GitHub Actions readiness workflow
  --list-profiles   List available template profiles
  --help            Show this help

Examples:
  scripts/install.sh .
  scripts/install.sh ../my-app --profile node
  scripts/install.sh ../my-app --dry-run
USAGE
}

profile=auto
dry_run=false
mode=backup
install_agent_files=true
install_docs=true
install_ci=false
target_dir=

while [ "$#" -gt 0 ]; do
  case "$1" in
    --profile)
      if [ "$#" -lt 2 ]; then
        printf 'Missing value for --profile\n' >&2
        exit 2
      fi
      profile=$2
      shift 2
      ;;
    --dry-run)
      dry_run=true
      shift
      ;;
    --force)
      mode=overwrite
      shift
      ;;
    --mode)
      if [ "$#" -lt 2 ]; then
        printf 'Missing value for --mode\n' >&2
        exit 2
      fi
      mode=$2
      shift 2
      ;;
    --no-agent-files)
      install_agent_files=false
      shift
      ;;
    --no-docs)
      install_docs=false
      shift
      ;;
    --with-ci)
      install_ci=true
      shift
      ;;
    --list-profiles)
      printf 'auto\n'
      profiles_dir=$(CDPATH= cd -- "$(dirname -- "$0")/../templates/profiles" && pwd)
      for profile_dir in "$profiles_dir"/*; do
        [ -d "$profile_dir" ] || continue
        basename -- "$profile_dir"
      done | sort
      exit 0
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

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_dir=$(CDPATH= cd -- "$script_dir/.." && pwd)

if [ ! -d "$target_dir" ]; then
  printf 'Target directory does not exist: %s\n' "$target_dir" >&2
  exit 1
fi

target_dir=$(CDPATH= cd -- "$target_dir" && pwd)

detect_profile() {
  if [ -f "$target_dir/package.json" ]; then
    if [ -f "$target_dir/next.config.js" ] || [ -f "$target_dir/next.config.mjs" ] || [ -d "$target_dir/app" ] || [ -d "$target_dir/pages" ]; then
      printf 'nextjs\n'
    else
      printf 'node\n'
    fi
  elif [ -f "$target_dir/pyproject.toml" ] || [ -f "$target_dir/requirements.txt" ] || [ -f "$target_dir/setup.py" ]; then
    printf 'python\n'
  elif [ -f "$target_dir/go.mod" ]; then
    printf 'go\n'
  elif [ -f "$target_dir/Cargo.toml" ]; then
    printf 'rust\n'
  else
    printf 'generic\n'
  fi
}

if [ "$profile" = "auto" ]; then
  profile=$(detect_profile)
fi

case "$profile" in
  generic|node|python|go|rust|nextjs)
    ;;
  *)
    printf 'Unknown profile: %s\n' "$profile" >&2
    printf 'Supported profiles: auto, generic, node, python, go, rust, nextjs\n' >&2
    exit 2
    ;;
esac

case "$mode" in
  backup|skip|overwrite)
    ;;
  *)
    printf 'Unknown mode: %s\n' "$mode" >&2
    printf 'Supported modes: backup, skip, overwrite\n' >&2
    exit 2
    ;;
esac

template_dir="$repo_dir/templates/profiles/$profile"
if [ ! -d "$template_dir" ]; then
  printf 'Template profile is missing: %s\n' "$template_dir" >&2
  exit 1
fi

ensure_dir() {
  dir=$1
  if [ "$dry_run" = true ]; then
    printf '[dry-run] mkdir -p %s\n' "$dir"
  else
    mkdir -p "$dir"
  fi
}

copy_file() {
  src=$1
  dest=$2

  ensure_dir "$(dirname -- "$dest")"

  if [ -e "$dest" ]; then
    case "$mode" in
      backup)
        backup="${dest}.bak.$(date +%Y%m%d%H%M%S)"
        if [ "$dry_run" = true ]; then
          printf '[dry-run] cp %s %s\n' "$dest" "$backup"
        else
          cp "$dest" "$backup"
          printf 'Backed up existing %s to %s\n' "$dest" "$backup"
        fi
        ;;
      skip)
        if [ "$dry_run" = true ]; then
          printf '[dry-run] skip existing %s\n' "$dest"
        else
          printf 'Skipped existing %s\n' "$dest"
        fi
        return 0
        ;;
      overwrite)
        ;;
    esac
  fi

  if [ "$dry_run" = true ]; then
    printf '[dry-run] cp %s %s\n' "$src" "$dest"
  else
    cp "$src" "$dest"
    printf 'Installed %s\n' "$dest"
  fi
}

copy_optional_file() {
  src=$1
  dest=$2

  if [ -f "$src" ]; then
    copy_file "$src" "$dest"
  fi
}

copy_file "$template_dir/AGENTS.md" "$target_dir/AGENTS.md"

if [ "$install_docs" = true ]; then
  copy_file "$repo_dir/docs/agent-review-checklist.md" "$target_dir/docs/agent-review-checklist.md"
  copy_file "$repo_dir/docs/testing-strategy.md" "$target_dir/docs/testing-strategy.md"
fi

copy_file "$repo_dir/templates/github/pull_request_template.md" "$target_dir/.github/pull_request_template.md"

if [ "$install_ci" = true ]; then
  copy_file "$repo_dir/templates/github/workflows/agent-workflow-kit.yml" "$target_dir/.github/workflows/agent-workflow-kit.yml"
fi

if [ "$install_agent_files" = true ]; then
  copy_optional_file "$repo_dir/templates/agents/CLAUDE.md" "$target_dir/CLAUDE.md"
  copy_optional_file "$repo_dir/templates/agents/GEMINI.md" "$target_dir/GEMINI.md"
  copy_optional_file "$repo_dir/templates/agents/copilot-instructions.md" "$target_dir/.github/copilot-instructions.md"
  copy_optional_file "$repo_dir/templates/agents/cursor-agent-workflow.mdc" "$target_dir/.cursor/rules/agent-workflow.mdc"
fi

if [ "$dry_run" = true ]; then
  printf '\nDry run complete. Detected profile: %s\n' "$profile"
  printf 'Existing-file mode: %s\n' "$mode"
else
  printf '\nAgent Workflow Kit installed with profile: %s\n' "$profile"
  printf 'Existing-file mode: %s\n' "$mode"
  printf 'Edit AGENTS.md with this project'\''s real commands before relying on it.\n'
fi
