# Agent Instructions

Use this file as the first source of truth before editing this Go service.

## Project Overview

- Runtime: Go
- Module file: `go.mod`
- Commands: `cmd/service/`
- Internal packages: `internal/`
- Tests: colocated `*_test.go` files

## Commands

```bash
go mod download
go test ./...
go vet ./...
gofmt -w .
```

## Coding Conventions

- Keep handlers, services, and storage code separated.
- Thread `context.Context` through request-scoped operations.
- Wrap errors with enough context for logs and callers.

## Testing Guidance

- Prefer table-driven tests for branching logic.
- Add integration tests around storage or HTTP behavior when contracts change.

## Handoff Format

Include changed packages, commands run, and any external service behavior not verified.
