# Testing Strategy for Agent-Assisted Changes

Agent-assisted work is safest when tests are selected by risk, not habit. Use this guide to decide what to run and what to add.

## Start Narrow

Run the smallest check that can prove the changed behavior:

- A single unit test for local logic.
- A focused integration test for cross-module behavior.
- A type check or linter for mechanical safety.
- A snapshot or visual check only when UI output changed.

## Expand When Risk Increases

Run broader checks when the change touches:

- Authentication or authorization.
- Payment, billing, or data deletion.
- Database schemas, migrations, or serialization.
- Shared utilities used across the application.
- Public APIs, SDKs, CLIs, or config formats.
- Concurrency, retries, caching, or background jobs.

## Add Tests When Behavior Changes

Prefer tests that would fail on the original bug or missing feature. Good tests usually include:

- One normal case.
- One boundary case.
- One failure or invalid input case.

## Be Explicit About Gaps

If a check cannot be run, record why:

- Missing dependency.
- External service unavailable.
- Test suite too slow for the current task.
- Credentials or environment variables unavailable.

The handoff should make remaining risk clear enough for a maintainer to decide the next step.
