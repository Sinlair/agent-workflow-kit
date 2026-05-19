#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repo_dir"

bash -n scripts/install.sh
bash -n scripts/doctor.sh

profiles=$(scripts/install.sh --list-profiles | tr '\n' ' ')
for expected_profile in auto generic node python go rust nextjs; do
  case " $profiles " in
    *" $expected_profile "*)
      ;;
    *)
      printf 'Profile list is missing %s: %s\n' "$expected_profile" "$profiles" >&2
      exit 1
      ;;
  esac
done

project=$(mktemp -d)
scripts/install.sh "$project" --profile generic
test -f "$project/AGENTS.md"
test -f "$project/docs/agent-review-checklist.md"
test -f "$project/docs/testing-strategy.md"
test -f "$project/.github/pull_request_template.md"
test -f "$project/CLAUDE.md"
test -f "$project/GEMINI.md"
test -f "$project/.github/copilot-instructions.md"
test -f "$project/.cursor/rules/agent-workflow.mdc"
test ! -f "$project/.github/workflows/agent-workflow-kit.yml"

project=$(mktemp -d)
scripts/install.sh "$project" --profile generic --with-ci
test -f "$project/.github/workflows/agent-workflow-kit.yml"

project=$(mktemp -d)
scripts/install.sh "$project" --profile generic --no-docs --no-agent-files
test -f "$project/AGENTS.md"
test -f "$project/.github/pull_request_template.md"
test ! -e "$project/docs/agent-review-checklist.md"
test ! -e "$project/CLAUDE.md"

project=$(mktemp -d)
printf '{"scripts":{"test":"node --test","lint":"eslint ."}}\n' > "$project/package.json"
scripts/install.sh "$project"
grep -q 'Node.js repository' "$project/AGENTS.md"
scripts/doctor.sh "$project" --profile node --min-score 50

project=$(mktemp -d)
printf '[project]\nname = "example"\n' > "$project/pyproject.toml"
mkdir -p "$project/tests"
printf 'def test_example():\n    assert True\n' > "$project/tests/test_example.py"
scripts/install.sh "$project"
grep -q 'Python repository' "$project/AGENTS.md"
scripts/doctor.sh "$project" --json --min-score 80 | grep -q '"passed":true'

project=$(mktemp -d)
scripts/install.sh "$project" --dry-run
test ! -f "$project/AGENTS.md"

project=$(mktemp -d)
printf '# Example\n' > "$project/README.md"
printf '# Contributing\n' > "$project/CONTRIBUTING.md"
mkdir -p "$project/tests"
scripts/install.sh "$project" --profile generic
scripts/doctor.sh "$project" --min-score 90

scripts/doctor.sh . --min-score 80

printf 'All checks passed.\n'
