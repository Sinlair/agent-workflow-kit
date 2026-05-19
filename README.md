# Agent Workflow Kit

Project-ready instructions and templates for AI coding agents.

Agent Workflow Kit gives any repository a small, practical operating system for Codex, Claude Code, Cursor, Copilot, Gemini CLI, and other coding agents. It focuses on the parts that usually make agent work fragile: missing project context, unclear commands, weak review habits, and inconsistent handoffs.

[中文说明](README.zh-CN.md)

## What It Includes

- `AGENTS.md`: a project instruction file agents can read before editing code.
- `CLAUDE.md`, `GEMINI.md`, Copilot instructions, and Cursor rules.
- `docs/agent-review-checklist.md`: a risk-focused code review checklist.
- `docs/testing-strategy.md`: a lightweight test planning guide.
- `.github/pull_request_template.md`: a PR template designed for human and agent contributors.
- `scripts/install.sh`: an installer with profile detection, dry-run, and overwrite controls.
- `scripts/doctor.sh`: an agent-readiness scanner with text and JSON output.
- `bin/agent-workflow-kit`: a small command dispatcher for install, doctor, profiles, and version.
- `examples/`: sample `AGENTS.md` files for common project shapes.

## Quick Start

Install the kit into another repository:

```bash
git clone https://github.com/Sinlair/agent-workflow-kit.git
cd agent-workflow-kit
./scripts/install.sh /path/to/your/project
```

Or use the unified CLI:

```bash
./bin/agent-workflow-kit install /path/to/your/project
./bin/agent-workflow-kit doctor /path/to/your/project --markdown --strict
```

The installer auto-detects common project types:

- `node`
- `python`
- `go`
- `rust`
- `nextjs`
- `generic`

You can also select a profile explicitly:

```bash
./scripts/install.sh /path/to/your/project --profile node
```

Then edit `/path/to/your/project/AGENTS.md` and replace the placeholders with your project's real commands and conventions.

## Installer Options

```bash
./scripts/install.sh /path/to/project [options]

Options:
  --profile NAME    Template profile: auto, generic, node, python, go, rust, nextjs
  --dry-run         Show what would be installed without writing files
  --force           Overwrite existing files without creating backups
  --mode MODE       Existing-file behavior: backup, skip, overwrite
  --no-agent-files  Do not install CLAUDE.md, GEMINI.md, Copilot, or Cursor files
  --no-docs         Do not install review and testing docs
  --with-ci         Install a GitHub Actions readiness workflow
  --with-tools      Install helper scripts into the target project
  --no-manifest     Do not write .agent-workflow-kit/manifest
  --list-profiles   List available template profiles
  --version         Print Agent Workflow Kit version
  --help            Show help
```

Examples:

```bash
./scripts/install.sh ../my-app --dry-run
./scripts/install.sh ../my-app --profile python
./scripts/install.sh ../my-app --force
./scripts/install.sh ../my-app --mode skip
./scripts/install.sh ../my-app --no-agent-files
./scripts/install.sh ../my-app --with-ci
./scripts/install.sh ../my-app --with-tools
```

The installer writes `.agent-workflow-kit/manifest` by default so teams can audit the installed version, profile, mode, and copied files. Use `--no-manifest` only when you do not want that audit trail.

When `--with-tools` or `--with-ci` is used, the target project also gets:

- `scripts/doctor.sh`
- `scripts/agent-workflow-kit`

The installed wrapper supports `doctor` and `version` inside the target project.

## Agent Readiness Scan

Run `doctor.sh` to see whether a project has enough structure for AI coding agents:

```bash
./scripts/doctor.sh /path/to/your/project
```

Use `--json` for automation and `--min-score` to enforce a threshold:
Use `--markdown` when pasting a report into a pull request or issue.

```bash
./scripts/doctor.sh /path/to/your/project --json
./scripts/doctor.sh /path/to/your/project --markdown
./scripts/doctor.sh /path/to/your/project --min-score 80
./scripts/doctor.sh /path/to/your/project --strict
```

Example output:

```text
Agent Readiness: 72/100
Detected profile: node
Minimum score: 60

Strengths:
- AGENTS.md exists
- Pull request template exists

Missing or weak signals:
- No CONTRIBUTING.md
- No docs/testing-strategy.md
```

Scoring details are documented in [docs/doctor-scoring.md](docs/doctor-scoring.md).

## Recommended Agent Workflow

1. Read `AGENTS.md` first.
2. Inspect the code before changing it.
3. Keep changes scoped to the user request.
4. Run the narrowest useful checks first.
5. Report exactly what changed and what was verified.

## Repository Layout

```text
.
├── AGENTS.md
├── README.md
├── README.zh-CN.md
├── VERSION
├── bin
│   └── agent-workflow-kit
├── docs
│   ├── agent-review-checklist.md
│   ├── adoption-guide.md
│   ├── doctor-scoring.md
│   ├── profiles.md
│   └── testing-strategy.md
├── scripts
│   ├── doctor.sh
│   ├── install.sh
│   └── test.sh
├── examples
│   ├── go-service
│   ├── nextjs-app
│   ├── node-api
│   ├── python-cli
│   └── rust-cli
└── templates
    ├── agents
    ├── github
    └── profiles
```

## Local Checks

```bash
./scripts/test.sh
./tests/smoke.sh
```

## Who This Is For

This kit is for developers who use AI coding tools on real projects and want repeatable behavior without building a large agent platform. It works best when the instructions stay short, specific, and close to the repository's actual commands.

## License

MIT
