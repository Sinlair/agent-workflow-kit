# Agent Workflow Kit

面向 AI 编程 Agent 的项目工作流模板包。

它可以给任意仓库补齐一套轻量但实用的 Agent 工作方式，包括项目说明、测试策略、代码审查清单、PR 模板，以及 Claude Code、Cursor、Copilot、Gemini CLI 等工具可读取的指令文件。

## 包含内容

- `AGENTS.md`：项目级 Agent 指令文件。
- `CLAUDE.md`、`GEMINI.md`、Copilot instructions、Cursor rules。
- `docs/agent-review-checklist.md`：偏风险和缺陷的代码审查清单。
- `docs/testing-strategy.md`：Agent 辅助开发时的测试策略。
- `.github/pull_request_template.md`：适合人类和 Agent 协作的 PR 模板。
- `scripts/install.sh`：支持自动识别项目类型、dry-run、force 的安装脚本。
- `scripts/doctor.sh`：扫描仓库的 Agent 友好度，支持文本和 JSON 输出。
- `examples/`：常见项目形态的 `AGENTS.md` 示例。

## 快速开始

```bash
git clone https://github.com/Sinlair/agent-workflow-kit.git
cd agent-workflow-kit
./scripts/install.sh /path/to/your/project
```

安装器会自动识别常见项目类型：

- `node`
- `python`
- `go`
- `rust`
- `nextjs`
- `generic`

也可以手动指定：

```bash
./scripts/install.sh /path/to/your/project --profile python
```

安装后，编辑目标项目里的 `AGENTS.md`，把占位内容替换成真实命令、目录结构和代码约定。

## 常用参数

```bash
./scripts/install.sh /path/to/project [options]

Options:
  --profile NAME    模板类型：auto, generic, node, python, go, rust, nextjs
  --dry-run         只展示将要写入的文件，不实际修改
  --force           直接覆盖已有文件，不创建备份
  --mode MODE       已有文件处理方式：backup, skip, overwrite
  --no-agent-files  不安装 CLAUDE.md、GEMINI.md、Copilot、Cursor 文件
  --no-docs         不安装 review/testing 文档
  --with-ci         安装 GitHub Actions readiness workflow
  --list-profiles   列出可用模板
  --help            显示帮助
```

示例：

```bash
./scripts/install.sh ../my-app --dry-run
./scripts/install.sh ../my-app --profile node
./scripts/install.sh ../my-app --force
./scripts/install.sh ../my-app --mode skip
./scripts/install.sh ../my-app --no-agent-files
./scripts/install.sh ../my-app --with-ci
```

## 检查项目是否适合 Agent

```bash
./scripts/doctor.sh /path/to/your/project
```

自动化场景可以使用 JSON 输出，也可以设置最低分；需要贴到 PR 或 issue 时可以用 Markdown 输出。

```bash
./scripts/doctor.sh /path/to/your/project --json
./scripts/doctor.sh /path/to/your/project --markdown
./scripts/doctor.sh /path/to/your/project --min-score 80
./scripts/doctor.sh /path/to/your/project --strict
```

示例输出：

```text
Agent Readiness: 72/100
Detected profile: node
Minimum score: 60

Strengths:
- AGENTS.md exists
- Pull request template exists

Missing or weak signals:
- No CONTRIBUTING.md
- No docs/testing-strategy.md
```

## 本地检查

```bash
./scripts/test.sh
./tests/smoke.sh
```

评分规则见 [docs/doctor-scoring.md](docs/doctor-scoring.md)，模板识别规则见 [docs/profiles.md](docs/profiles.md)。

## 推荐工作流

1. 先读 `AGENTS.md`。
2. 改代码前先看相关上下文。
3. 保持改动范围和用户需求一致。
4. 先跑最小但有效的测试。
5. 交付时说明改了什么、跑了什么检查、还有什么没验证。

## 适合谁

适合已经在真实项目里使用 Codex、Claude Code、Cursor、Copilot、Gemini CLI 等 AI 编程工具的开发者。这个项目不是一个复杂 Agent 平台，而是一套可以马上复制到项目里的协作规范。

## License

MIT
