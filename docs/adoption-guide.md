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

## 5. Add CI When Ready

```bash
scripts/install.sh ../my-project --with-ci
```

The CI template runs `scripts/doctor.sh . --min-score 80` when the target repository includes the doctor script.
