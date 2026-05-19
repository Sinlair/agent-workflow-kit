# Agent Instructions

Use this file as the first source of truth before editing this Node.js repository.

## Project Overview

- Runtime: Node.js
- Package manager: confirm from `package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, or `bun.lockb`.
- Main configuration: `package.json`
- Source directories: replace with this project's real paths.

## Commands

Prefer the package manager already used by the project.

```bash
# Install dependencies
npm install

# Run tests
npm test

# Run lint
npm run lint

# Run type checks
npm run typecheck

# Start local development
npm run dev
```

## Coding Conventions

- Follow nearby TypeScript or JavaScript style.
- Prefer existing package scripts over ad hoc commands.
- Keep dependency changes minimal and explain why a new dependency is needed.
- Preserve public API, CLI, and configuration compatibility unless the task requires a breaking change.

## Testing Guidance

- Run the narrowest affected test first.
- Add unit tests for pure logic and integration tests for cross-module behavior.
- Update snapshots only when the output change is intentional.

## Handoff Format

When reporting work, include:

- Files changed and why.
- Package scripts or tests run.
- Any checks skipped because scripts are absent or dependencies are missing.
