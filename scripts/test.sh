#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repo_dir"

bash -n scripts/install.sh
bash -n scripts/doctor.sh
bash -n scripts/uninstall.sh
bash -n bin/agent-workflow-kit

test "$(scripts/install.sh --version)" = "$(cat VERSION)"
test "$(bin/agent-workflow-kit version)" = "$(cat VERSION)"

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
test -f "$project/.agent-workflow-kit/manifest"
grep -q '^profile=generic$' "$project/.agent-workflow-kit/manifest"

project=$(mktemp -d)
scripts/install.sh "$project" --profile generic --with-ci
test -f "$project/.github/workflows/agent-workflow-kit.yml"
test -x "$project/scripts/doctor.sh"
test -x "$project/scripts/uninstall.sh"
test -x "$project/scripts/agent-workflow-kit"

project=$(mktemp -d)
bin/agent-workflow-kit install "$project" --profile generic --with-tools
test -x "$project/scripts/doctor.sh"
test -x "$project/scripts/uninstall.sh"
test -x "$project/scripts/agent-workflow-kit"
bin/agent-workflow-kit doctor "$project" --min-score 60
"$project/scripts/agent-workflow-kit" doctor "$project" --min-score 60
test "$("$project/scripts/agent-workflow-kit" version)" = "$(cat VERSION)"

uninstall_project=$(mktemp -d)
bin/agent-workflow-kit install "$uninstall_project" --profile generic --with-tools
bin/agent-workflow-kit uninstall "$uninstall_project" --dry-run
test -f "$uninstall_project/AGENTS.md"
bin/agent-workflow-kit uninstall "$uninstall_project"
test ! -e "$uninstall_project/AGENTS.md"
test ! -e "$uninstall_project/.agent-workflow-kit/manifest"

uninstall_project=$(mktemp -d)
scripts/install.sh "$uninstall_project" --profile generic --with-tools
printf '\ncustom change\n' >> "$uninstall_project/AGENTS.md"
scripts/uninstall.sh "$uninstall_project" --keep-manifest
test -f "$uninstall_project/AGENTS.md"
scripts/uninstall.sh "$uninstall_project" --force
test ! -e "$uninstall_project/AGENTS.md"

project=$(mktemp -d)
scripts/install.sh "$project" --profile generic --no-docs --no-agent-files
test -f "$project/AGENTS.md"
test -f "$project/.github/pull_request_template.md"
test ! -e "$project/docs/agent-review-checklist.md"
test ! -e "$project/CLAUDE.md"

project=$(mktemp -d)
scripts/install.sh "$project" --profile generic --no-manifest
test ! -e "$project/.agent-workflow-kit/manifest"

project=$(mktemp -d)
printf 'custom\n' > "$project/AGENTS.md"
scripts/install.sh "$project" --profile generic --mode skip
grep -q '^custom$' "$project/AGENTS.md"
test ! -e "$project"/AGENTS.md.bak.*

project=$(mktemp -d)
printf 'custom\n' > "$project/AGENTS.md"
scripts/install.sh "$project" --profile generic --mode overwrite
grep -q 'Use this file as the first source of truth' "$project/AGENTS.md"
test ! -e "$project"/AGENTS.md.bak.*

project=$(mktemp -d)
printf '{"scripts":{"test":"node --test","lint":"eslint ."}}\n' > "$project/package.json"
scripts/install.sh "$project"
grep -q 'Node.js repository' "$project/AGENTS.md"
scripts/doctor.sh "$project" --profile node --min-score 50
report_file=$(mktemp)
scripts/doctor.sh "$project" --markdown --profile node --min-score 50 > "$report_file"
grep -q '# Agent Readiness Report' "$report_file"

project=$(mktemp -d)
printf '[project]\nname = "example"\n' > "$project/pyproject.toml"
mkdir -p "$project/tests"
printf 'def test_example():\n    assert True\n' > "$project/tests/test_example.py"
scripts/install.sh "$project"
grep -q 'Python repository' "$project/AGENTS.md"
json_file=$(mktemp)
scripts/doctor.sh "$project" --json --min-score 80 > "$json_file"
grep -q '"passed":true' "$json_file"
scripts/doctor.sh "$project" --json --strict --min-score 80 > "$json_file"
grep -q '"recommendations"' "$json_file"

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
