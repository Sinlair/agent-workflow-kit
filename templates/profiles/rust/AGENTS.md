# Agent Instructions

Use this file as the first source of truth before editing this Rust repository.

## Project Overview

- Runtime: Rust
- Package metadata: `Cargo.toml`
- Workspace crates: replace with this project's real crate list.
- Binary entry points: replace with this project's real paths.

## Commands

```bash
# Fetch dependencies
cargo fetch

# Run tests
cargo test

# Run lint
cargo clippy --all-targets --all-features -- -D warnings

# Check formatting
cargo fmt --check

# Build
cargo build
```

## Coding Conventions

- Follow existing crate boundaries and error types.
- Prefer explicit error handling over panics in library code.
- Keep public API changes documented.
- Avoid new features or dependencies unless the task needs them.

## Testing Guidance

- Add unit tests for local logic and integration tests for public behavior.
- Include failure cases for parsing, IO, and protocol handling.
- Run targeted crate tests first when the workspace is large.

## Handoff Format

When reporting work, include:

- Crates changed.
- Cargo commands run.
- Any feature combinations or platform checks not verified.
