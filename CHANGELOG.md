# Changelog

## Unreleased

- Added installer profile detection for generic, Node.js, Python, Go, Rust, and Next.js projects.
- Added installer options for dry runs, forced overwrites, skipping docs, skipping tool-specific agent files, and listing profiles.
- Added optional installer support for a GitHub Actions readiness workflow template.
- Added tool-specific instruction templates for Claude Code, Gemini CLI, GitHub Copilot, and Cursor.
- Added `scripts/doctor.sh` with readiness scoring, profile detection, JSON output, and minimum score enforcement.
- Added CI and local smoke tests.
- Added example `AGENTS.md` files for common project shapes.
- Added Chinese documentation.
- Added documentation for doctor scoring and profile detection.
