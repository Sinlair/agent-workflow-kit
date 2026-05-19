# Agent Instructions

Use this file as the first source of truth before editing this Rust CLI.

## Project Overview

- Runtime: Rust
- Package metadata: `Cargo.toml`
- Source: `src/`
- Integration tests: `tests/`

## Commands

```bash
cargo fetch
cargo test
cargo clippy --all-targets --all-features -- -D warnings
cargo fmt --check
cargo build
```

## Coding Conventions

- Keep parsing, command execution, and output formatting separate.
- Avoid panics for user input errors.
- Keep public behavior documented in CLI help and examples.

## Testing Guidance

- Add unit tests for parsing and formatting.
- Add integration tests for command output and exit codes.

## Handoff Format

Include changed modules, Cargo commands run, and any platform-specific behavior not verified.
