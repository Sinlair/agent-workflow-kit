# Agent Instructions

Use this file as the first source of truth before editing this Python CLI.

## Project Overview

- Runtime: Python
- Package metadata: `pyproject.toml`
- Source: `src/example_cli/`
- Tests: `tests/`
- CLI entry point: `src/example_cli/__main__.py`

## Commands

```bash
python -m pip install -e ".[dev]"
pytest
ruff check .
ruff format --check .
mypy src
```

## Coding Conventions

- Keep command parsing separate from business logic.
- Return clear user-facing errors without tracebacks for expected failures.
- Avoid network or filesystem side effects in unit tests unless isolated with fixtures.

## Testing Guidance

- Add tests for command arguments, output, and exit codes.
- Include malformed input and missing file cases.

## Handoff Format

Include changed commands, checks run, and any platform-specific behavior not verified.
