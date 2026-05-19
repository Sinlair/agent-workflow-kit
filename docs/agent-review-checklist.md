# Agent Review Checklist

Use this checklist when asking an AI coding agent to review a pull request or its own changes. The goal is to find concrete defects, not to restate the diff.

## Correctness

- Does the implementation match the requested behavior?
- Are boundary cases handled explicitly?
- Are null, empty, missing, malformed, and duplicate inputs considered where relevant?
- Are time zones, dates, rounding, and ordering rules handled consistently?
- Are async, retry, and cancellation paths safe?

## Integration

- Does the change respect existing module boundaries?
- Are public APIs, database schemas, environment variables, or config files changed?
- Are migrations, generated clients, fixtures, or snapshots updated when needed?
- Does the code work with existing feature flags and rollout paths?

## Security

- Is user input validated at the boundary?
- Are authorization checks preserved?
- Are secrets, tokens, credentials, and internal paths kept out of logs and errors?
- Are file paths, shell commands, SQL, HTML, and URLs constructed safely?
- Are new dependencies necessary and trustworthy?

## Tests

- Is there coverage for the behavior that changed?
- Are failure paths tested, not only happy paths?
- Are tests deterministic and isolated from external services unless explicitly marked?
- Would a regression in this change fail a test?

## Maintainability

- Does the code follow nearby conventions?
- Is the change smaller than the problem requires, or larger?
- Are names specific enough to explain intent?
- Is any new abstraction justified by repeated complexity?

## Handoff

A useful review response should list findings first, ordered by severity, with file and line references. If no issues are found, say that clearly and identify any remaining test gaps.
