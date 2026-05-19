# Agent Instructions

Use this file as the first source of truth before editing this repository.

## Project Overview

Replace this section with a short description of the product, library, or service.

- Primary language/framework:
- Runtime/package manager:
- Main entry points:
- Important directories:

## Commands

Replace these placeholders with commands that work in this repository.

```bash
# Install dependencies

# Run tests

# Run lint/type checks

# Start local development
```

## Coding Conventions

- Follow the style already present in nearby files.
- Keep changes small and directly related to the requested task.
- Prefer existing helpers, service boundaries, and framework patterns.
- Add comments only where they clarify non-obvious decisions.
- Do not introduce new dependencies unless the task clearly needs them.

## Testing Guidance

- Run the narrowest relevant test first.
- Add or update tests when changing behavior, contracts, parsing, validation, or user-visible flows.
- If a full suite is expensive, run targeted checks and explain what remains unverified.

## Review Checklist

Before finishing, check:

- Does the change solve the requested problem?
- Are edge cases and failure paths handled?
- Are user inputs validated at the right boundary?
- Are errors useful without leaking secrets?
- Are docs, examples, or migrations updated when needed?

## Handoff Format

When reporting work, include:

- What changed.
- What commands were run.
- Any tests or checks that were skipped and why.
