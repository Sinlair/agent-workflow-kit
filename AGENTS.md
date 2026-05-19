# Agent Instructions

This repository is a template kit for adding practical AI coding agent workflows to other projects.

## Project Goals

- Provide concise instructions that help coding agents make safer edits.
- Keep templates portable across common web, backend, CLI, and library projects.
- Prefer explicit commands and checklists over vague policy.
- Avoid framework-specific assumptions unless they are clearly marked as examples.

## Working Rules

- Read the relevant files before editing.
- Keep changes scoped to the requested behavior.
- Do not rewrite unrelated project history, generated files, or user changes.
- Prefer existing project conventions over new abstractions.
- Add tests or update documentation when the behavior surface changes.
- Report commands run and any checks that could not be run.

## Commands

Use these commands while developing this kit:

```bash
scripts/test.sh
tests/smoke.sh
```

There is no build step for the template files.

## Release Checklist

- Confirm the installer still copies all expected files.
- Confirm profile detection works for changed project templates.
- Confirm `scripts/doctor.sh` reports a useful score and missing signals.
- Confirm JSON output stays valid when `scripts/doctor.sh --json` changes.
- Confirm the README quick start works from a clean clone.
- Keep examples generic and avoid private project details.
