# Doctor Scoring

`scripts/doctor.sh` scores a repository from 0 to 100 based on signals that make AI coding agents easier to guide, review, and verify.

## Score Breakdown

| Signal | Points |
| --- | ---: |
| `AGENTS.md` exists | 20 |
| `.github/pull_request_template.md` exists | 10 |
| `docs/agent-review-checklist.md` exists | 10 |
| `docs/testing-strategy.md` exists | 10 |
| At least one tool-specific instruction file exists | 10 |
| Project-specific test or quality signal exists | 20 |
| `README.md` exists | 10 |
| `CONTRIBUTING.md` exists | 10 |

Tool-specific instruction files include:

- `CLAUDE.md`
- `GEMINI.md`
- `.github/copilot-instructions.md`
- `.cursor/rules/agent-workflow.mdc`

## Profile-Specific Test Signals

- Node.js and Next.js: `package.json` has a `test`, `lint`, `typecheck`, or `build` script.
- Python: dependency metadata exists and tests are present.
- Go: `*_test.go` files are present.
- Rust: test metadata or a `tests/` directory is present.
- Generic: `tests/`, `test/`, or CI workflow files are present.

## Exit Codes

The default minimum score is `60`.

```bash
scripts/doctor.sh . --min-score 80
```

The command exits non-zero when the score is below the minimum. Use `--json` when integrating with scripts or CI.
