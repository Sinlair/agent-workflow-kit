#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat >&2 <<'USAGE'
Usage: scripts/doctor.sh /path/to/project [options]

Scan a repository and report how ready it is for AI coding agents.

Options:
  --profile NAME    Override detected profile: auto, generic, node, python, go, rust, nextjs
  --json            Print machine-readable JSON
  --min-score N     Exit non-zero when score is below N, default: 60
  --help            Show this help

Examples:
  scripts/doctor.sh .
  scripts/doctor.sh ../my-app --json
  scripts/doctor.sh ../my-app --min-score 80
USAGE
}

profile=auto
json=false
min_score=60
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
    --json)
      json=true
      shift
      ;;
    --min-score)
      if [ "$#" -lt 2 ]; then
        printf 'Missing value for --min-score\n' >&2
        exit 2
      fi
      min_score=$2
      shift 2
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

case "$profile" in
  auto|generic|node|python|go|rust|nextjs)
    ;;
  *)
    printf 'Unknown profile: %s\n' "$profile" >&2
    printf 'Supported profiles: auto, generic, node, python, go, rust, nextjs\n' >&2
    exit 2
    ;;
esac

case "$min_score" in
  ''|*[!0-9]*)
    printf 'Invalid --min-score value: %s\n' "$min_score" >&2
    exit 2
    ;;
esac

if [ ! -d "$target_dir" ]; then
  printf 'Target directory does not exist: %s\n' "$target_dir" >&2
  exit 1
fi

target_dir=$(CDPATH= cd -- "$target_dir" && pwd)
score=0
max_score=100
findings_file=$(mktemp)
strengths_file=$(mktemp)
trap 'rm -f "$findings_file" "$strengths_file"' EXIT

add_score() {
  score=$((score + $1))
  printf -- '- %s\n' "$2" >> "$strengths_file"
}

missing() {
  printf -- '- %s\n' "$1" >> "$findings_file"
}

has_file() {
  [ -f "$target_dir/$1" ]
}

has_dir() {
  [ -d "$target_dir/$1" ]
}

file_contains() {
  file=$1
  pattern=$2

  has_file "$file" && grep -Eq "$pattern" "$target_dir/$file"
}

detect_profile() {
  if has_file package.json; then
    if has_file next.config.js || has_file next.config.mjs || has_dir app || has_dir pages; then
      printf 'nextjs\n'
    else
      printf 'node\n'
    fi
  elif has_file pyproject.toml || has_file requirements.txt || has_file setup.py; then
    printf 'python\n'
  elif has_file go.mod; then
    printf 'go\n'
  elif has_file Cargo.toml; then
    printf 'rust\n'
  else
    printf 'generic\n'
  fi
}

if [ "$profile" = "auto" ]; then
  profile=$(detect_profile)
fi

if has_file AGENTS.md; then
  add_score 20 'AGENTS.md exists'
else
  missing 'No AGENTS.md project instruction file'
fi

if has_file .github/pull_request_template.md; then
  add_score 10 'Pull request template exists'
else
  missing 'No .github/pull_request_template.md'
fi

if has_file docs/agent-review-checklist.md; then
  add_score 10 'Agent review checklist exists'
else
  missing 'No docs/agent-review-checklist.md'
fi

if has_file docs/testing-strategy.md; then
  add_score 10 'Testing strategy exists'
else
  missing 'No docs/testing-strategy.md'
fi

if has_file CLAUDE.md || has_file GEMINI.md || has_file .github/copilot-instructions.md || has_file .cursor/rules/agent-workflow.mdc; then
  add_score 10 'At least one tool-specific agent instruction file exists'
else
  missing 'No tool-specific agent instruction files such as CLAUDE.md, GEMINI.md, Copilot, or Cursor rules'
fi

case "$profile" in
  node|nextjs)
    if has_file package.json; then
      if grep -Eq '"(test|lint|typecheck|build)"[[:space:]]*:' "$target_dir/package.json"; then
        add_score 20 'package.json has test, lint, typecheck, or build scripts'
      else
        missing 'package.json has no obvious test, lint, typecheck, or build scripts'
      fi
    fi
    ;;
  python)
    if has_file pyproject.toml || has_file requirements.txt; then
      add_score 10 'Python dependency metadata exists'
    fi
    if has_dir tests || find "$target_dir" -maxdepth 3 -type f \( -name 'test_*.py' -o -name '*_test.py' \) | grep -q .; then
      add_score 10 'Python tests exist'
    else
      missing 'No obvious Python tests found'
    fi
    ;;
  go)
    if find "$target_dir" -maxdepth 4 -type f -name '*_test.go' | grep -q .; then
      add_score 20 'Go test files exist'
    else
      missing 'No Go test files found'
    fi
    ;;
  rust)
    if file_contains Cargo.toml '(\[dev-dependencies\]|\[\[test\]\]|\[\[bench\]\])' || has_dir tests; then
      add_score 20 'Rust test configuration or tests directory exists'
    else
      missing 'No obvious Rust test configuration or tests directory found'
    fi
    ;;
  generic)
    if has_dir tests || has_dir test; then
      add_score 20 'Test directory exists'
    elif has_dir .github/workflows; then
      add_score 10 'CI workflow exists'
      missing 'No obvious test directory found; CI exists but test coverage is unclear'
    else
      missing 'No obvious test directory found'
    fi
    ;;
esac

if has_file README.md; then
  add_score 10 'README.md exists'
else
  missing 'No README.md'
fi

if has_file CONTRIBUTING.md || has_file .github/CONTRIBUTING.md; then
  add_score 10 'Contributing guide exists'
else
  missing 'No CONTRIBUTING.md'
fi

if [ "$score" -gt "$max_score" ]; then
  score=$max_score
fi

json_escape() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

print_json_array() {
  file=$1
  first=true

  printf '['
  while IFS= read -r line; do
    line=${line#- }
    if [ "$first" = true ]; then
      first=false
    else
      printf ','
    fi
    printf '"%s"' "$(json_escape "$line")"
  done < "$file"
  printf ']'
}

if [ "$json" = true ]; then
  printf '{'
  printf '"score":%s,' "$score"
  printf '"max_score":%s,' "$max_score"
  printf '"min_score":%s,' "$min_score"
  printf '"profile":"%s",' "$profile"
  printf '"passed":'
  if [ "$score" -ge "$min_score" ]; then
    printf 'true,'
  else
    printf 'false,'
  fi
  printf '"strengths":'
  print_json_array "$strengths_file"
  printf ',"findings":'
  print_json_array "$findings_file"
  printf '}\n'
else
  printf 'Agent Readiness: %s/%s\n' "$score" "$max_score"
  printf 'Detected profile: %s\n' "$profile"
  printf 'Minimum score: %s\n' "$min_score"

  if [ -s "$strengths_file" ]; then
    printf '\nStrengths:\n'
    cat "$strengths_file"
  fi

  if [ -s "$findings_file" ]; then
    printf '\nMissing or weak signals:\n'
    cat "$findings_file"
  else
    printf '\nNo missing signals found.\n'
  fi
fi

if [ "$score" -lt "$min_score" ]; then
  exit 1
fi
