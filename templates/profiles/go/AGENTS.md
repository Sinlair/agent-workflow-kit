# Agent Instructions

Use this file as the first source of truth before editing this Go repository.

## Project Overview

- Runtime: Go
- Module file: `go.mod`
- Main packages: replace with this project's real paths.
- Command packages: replace with this project's real paths.

## Commands

```bash
# Download dependencies
go mod download

# Run tests
go test ./...

# Run vet
go vet ./...

# Format code
gofmt -w .
```

## Coding Conventions

- Keep package boundaries small and explicit.
- Prefer table-driven tests for branching logic.
- Return errors with enough context for callers to diagnose failures.
- Do not add global state unless the package already uses that pattern.

## Testing Guidance

- Run `go test ./...` for shared packages.
- Add tests near the package that owns the behavior.
- Include concurrency or cancellation tests when changing goroutines, contexts, or retries.

## Handoff Format

When reporting work, include:

- Packages changed.
- Commands run.
- Any race, integration, or external-service checks that remain unverified.
