# Adoption Guide

Use this guide to introduce Agent Workflow Kit into an existing repository without disrupting maintainers.

## 1. Preview the Change

```bash
scripts/install.sh ../my-project --dry-run
```

Dry-run mode shows every file that would be copied.

## 2. Avoid Overwriting Existing Files

For mature repositories, start with skip mode:

```bash
scripts/install.sh ../my-project --mode skip
```

Use backup mode when you want fresh templates but still want to preserve existing files:

```bash
scripts/install.sh ../my-project --mode backup
```

Use overwrite mode only when you have reviewed the existing files:

```bash
scripts/install.sh ../my-project --mode overwrite
```

`--force` is kept as a shortcut for `--mode overwrite`.

## 3. Install Gradually

For a first pass, skip optional files:

```bash
scripts/install.sh ../my-project --no-docs --no-agent-files
```

Then add docs and tool-specific files once the team agrees on the workflow.

## 4. Measure Readiness

```bash
scripts/doctor.sh ../my-project --markdown --strict
```

Paste the Markdown report into a tracking issue or pull request. The report gives concrete missing signals and recommended next steps.

## 5. Install Helper Scripts

```bash
scripts/install.sh ../my-project --with-tools
```

This copies `scripts/doctor.sh` into the target project so maintainers can run readiness checks without keeping this repository checked out.
It also installs `scripts/uninstall.sh` and `scripts/agent-workflow-kit`, a small wrapper for `doctor`, `uninstall`, and `version` inside the target project.

The installer writes `.agent-workflow-kit/manifest` by default. Keep it committed when you want a simple audit trail for installed files and version.

## 6. Add CI When Ready

```bash
scripts/install.sh ../my-project --with-ci
```

`--with-ci` also installs `scripts/doctor.sh`. The CI template runs `scripts/doctor.sh . --min-score 80`.

## 7. Roll Back If Needed

Preview removal first:

```bash
scripts/uninstall.sh ../my-project --dry-run
```

Then uninstall:

```bash
scripts/uninstall.sh ../my-project
```

The uninstall command checks manifest checksums and skips files that changed after installation. Use `--force` only when you intentionally want to remove modified files.
