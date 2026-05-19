# Agent Instructions

Use this file as the first source of truth before editing this Next.js repository.

## Project Overview

- Framework: Next.js
- Runtime: Node.js
- Package manager: confirm from `package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`, or `bun.lockb`.
- App router or pages router: replace with this project's real routing model.
- Important directories: replace with this project's real paths.

## Commands

Prefer the package manager already used by the project.

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Run tests
npm test

# Run lint
npm run lint

# Run type checks
npm run typecheck

# Build
npm run build
```

## Coding Conventions

- Follow existing React component and route conventions.
- Keep server/client component boundaries explicit.
- Avoid adding client-side state where server data or URL state is enough.
- Use existing design system components before creating new primitives.
- Preserve accessibility semantics for forms, navigation, dialogs, and buttons.

## Testing Guidance

- Run targeted component or route tests when available.
- Run `npm run build` when changing routing, data loading, middleware, or config.
- Verify responsive layout when changing user-facing UI.

## Handoff Format

When reporting work, include:

- Routes, components, or server actions changed.
- Commands run.
- Any browser, viewport, or build checks not verified.
