# Agent Instructions

Use this file as the first source of truth before editing this Python repository.

## Project Overview

- Runtime: Python
- Dependency metadata: `pyproject.toml`, `requirements.txt`, or `setup.py`
- Source directories: replace with this project's real paths.
- Test directories: replace with this project's real paths.

## Commands

Adjust these commands to the project's actual tooling.

```bash
# Create virtual environment
python -m venv .venv

# Install dependencies
python -m pip install -e ".[dev]"

# Run tests
pytest

# Run lint
ruff check .

# Run format check
ruff format --check .

# Run type checks
mypy .
```

## Coding Conventions

- Follow nearby module layout and naming.
- Prefer standard library features when they keep the implementation clear.
- Keep imports organized according to the project's formatter.
- Avoid broad exception handling unless the failure mode is intentionally recoverable.

## Testing Guidance

- Add focused `pytest` coverage for changed behavior.
- Include invalid input and failure-path tests for parsing, validation, IO, and API boundaries.
- Avoid tests that depend on network access unless clearly marked.

## Handoff Format

When reporting work, include:

- Files changed and why.
- Tests or quality checks run.
- Environment assumptions such as missing optional dependencies or credentials.
