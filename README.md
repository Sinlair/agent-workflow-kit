# Agent Workflow Kit

Project-ready instructions and templates for AI coding agents.

Agent Workflow Kit gives any repository a small, practical operating system for Codex, Claude Code, Cursor, and other coding agents. It focuses on the parts that usually make agent work fragile: missing project context, unclear commands, weak review habits, and inconsistent handoffs.

## What It Includes

- `AGENTS.md`: a project instruction file agents can read before editing code.
- `docs/agent-review-checklist.md`: a risk-focused code review checklist.
- `docs/testing-strategy.md`: a lightweight test planning guide.
- `.github/pull_request_template.md`: a PR template designed for human and agent contributors.
- `scripts/install.sh`: an installer that copies the kit into another repository.

## Quick Start

Install the kit into another repository:

```bash
git clone https://github.com/Sinlair/agent-workflow-kit.git
cd agent-workflow-kit
./scripts/install.sh /path/to/your/project
```

Then edit `/path/to/your/project/AGENTS.md` and replace the placeholders with your project's real commands and conventions.

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
├── LICENSE
├── README.md
├── docs
│   ├── agent-review-checklist.md
│   └── testing-strategy.md
├── scripts
│   └── install.sh
└── templates
    ├── AGENTS.md
    └── github
        └── pull_request_template.md
```

## Who This Is For

This kit is for developers who use AI coding tools on real projects and want repeatable behavior without building a large agent platform. It works best when the instructions stay short, specific, and close to the repository's actual commands.

## License

MIT
