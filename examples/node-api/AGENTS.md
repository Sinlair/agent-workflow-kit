# Agent Instructions

Use this file as the first source of truth before editing this Node.js API.

## Project Overview

- Runtime: Node.js
- Package manager: npm
- Source: `src/`
- Tests: `test/`
- Main API entry point: `src/server.ts`

## Commands

```bash
npm install
npm test
npm run lint
npm run typecheck
npm run dev
```

## Coding Conventions

- Keep route handlers thin and move business logic into services.
- Validate request input at the HTTP boundary.
- Do not log secrets, tokens, or full request bodies.
- Prefer existing middleware and error helpers.

## Testing Guidance

- Add unit tests for service logic.
- Add integration tests for new or changed API routes.
- Include failure cases for validation and authorization changes.

## Handoff Format

Include changed routes or services, commands run, and any API behavior that still needs manual verification.
