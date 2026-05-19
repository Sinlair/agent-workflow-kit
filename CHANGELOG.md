# Changelog

## Unreleased

- Added `VERSION` and a unified `bin/agent-workflow-kit` CLI.
- Added installer manifest output at `.agent-workflow-kit/manifest`.
- Added `--with-tools` to install helper scripts and a project-local wrapper into target projects.
- Added installer profile detection for generic, Node.js, Python, Go, Rust, and Next.js projects.
- Added installer options for dry runs, forced overwrites, skipping docs, skipping tool-specific agent files, and listing profiles.
- Added optional installer support for a GitHub Actions readiness workflow template.
- Added installer existing-file modes: backup, skip, and overwrite.
- Added tool-specific instruction templates for Claude Code, Gemini CLI, GitHub Copilot, and Cursor.
- Added `scripts/doctor.sh` with readiness scoring, profile detection, JSON/Markdown output, strict mode, recommendations, and minimum score enforcement.
- Added CI and local smoke tests.
- Added example `AGENTS.md` files for common project shapes.
- Added Chinese documentation.
- Added documentation for doctor scoring and profile detection.
- Added an adoption guide for introducing the kit into existing repositories.
