# Template Profiles

Agent Workflow Kit installs different `AGENTS.md` templates based on the project profile.

## Available Profiles

```bash
scripts/install.sh --list-profiles
```

## Auto Detection

When `--profile` is omitted, the installer detects a profile from files in the target project:

| Files or directories | Profile |
| --- | --- |
| `package.json` plus Next.js config, `app/`, or `pages/` | `nextjs` |
| `package.json` | `node` |
| `pyproject.toml`, `requirements.txt`, or `setup.py` | `python` |
| `go.mod` | `go` |
| `Cargo.toml` | `rust` |
| None of the above | `generic` |

## Explicit Profile

Use an explicit profile when auto detection is wrong or when bootstrapping a new project:

```bash
scripts/install.sh ../my-project --profile rust
```

## Adding a Profile

1. Add a new directory under `templates/profiles/<name>/`.
2. Add an `AGENTS.md` file inside it.
3. Update profile validation and detection in `scripts/install.sh`.
4. Update profile validation and detection in `scripts/doctor.sh`.
5. Add coverage to `scripts/test.sh`.
