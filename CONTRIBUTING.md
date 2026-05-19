# Contributing

Contributions should keep this project lightweight, portable, and easy to install into existing repositories.

## Guidelines

- Prefer Bash and Markdown unless a stronger need exists.
- Keep templates concise and easy to edit after installation.
- Avoid adding framework-specific assumptions to generic templates.
- Add or update CI smoke tests when changing installer or doctor behavior.
- Keep examples free of private project details.

## Local Checks

```bash
scripts/test.sh
tests/smoke.sh
```
