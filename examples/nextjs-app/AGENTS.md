# Agent Instructions

Use this file as the first source of truth before editing this Next.js app.

## Project Overview

- Framework: Next.js
- Router: App Router
- Routes: `app/`
- Shared UI: `components/`
- Server utilities: `lib/`

## Commands

```bash
npm install
npm run dev
npm test
npm run lint
npm run typecheck
npm run build
```

## Coding Conventions

- Keep server and client component boundaries explicit.
- Use existing design system components before creating new primitives.
- Preserve accessible labels, focus behavior, and keyboard navigation.
- Avoid adding client-side state when URL state or server data is enough.

## Testing Guidance

- Run route or component tests for user-facing behavior.
- Run `npm run build` after changing routing, middleware, server actions, or config.
- Check responsive layout when editing visible UI.

## Handoff Format

Include changed routes/components, commands run, and any viewport or browser checks not performed.
