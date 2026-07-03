# Dev_Skill

个人 Skill 仓库，采用 [Anthropic Agent Skills](https://github.com/anthropics/skills) 标准目录结构，集中管理可复用的 skill，兼容 CodeBuddy 等多种工具。

## 目录结构

```
Dev_Skill/
├── skills/                    # Skill 主目录（标准目录形式）
│   ├── dev-discipline/        # 开发规范
│   │   └── SKILL.md
│   ├── code-review/           # 代码审查规范
│   │   └── SKILL.md
│   ├── webapp-testing/        # Web 应用测试（借鉴 anthropics/skills）
│   │   └── SKILL.md
│   ├── mcp-builder/           # MCP 服务器开发（借鉴 anthropics/skills）
│   │   └── SKILL.md
│   └── skill-creator/         # Skill 创建与优化（借鉴 anthropics/skills）
│       └── SKILL.md
├── codebuddy/                 # CodeBuddy 扁平兼容层（自动生成，勿手改）
│   ├── dev-discipline.md
│   └── ...
├── template/                  # Skill 创建模板
│   └── SKILL.md
├── references/                # 参考来源索引
│   └── anthropic-skills.md    # anthropics/skills 仓库索引
├── sync.ps1                   # 同步脚本（生成 codebuddy/ + 管理 junction）
├── .gitignore
└── README.md
```

## 设计说明

### 标准目录形式

每个 skill 是一个目录，内含 `SKILL.md`，遵循 Anthropic Agent Skills 规范：

```
skill-name/
└── SKILL.md          # frontmatter(name, description, globs) + 指令正文
```

这种形式对人类友好、对多种 AI 工具通用。

### CodeBuddy 兼容层

CodeBuddy 只认扁平 `.md` 文件（直接放在 `~/.codebuddy/skills/` 下），不识别子目录中的 `SKILL.md`。因此通过 `codebuddy/` 目录作为兼容层：

- `codebuddy/*.md` 由 `sync.ps1` 从 `skills/*/SKILL.md` 自动生成
- `~/.codebuddy/skills` 通过 junction 指向 `codebuddy/`
- **编辑 skill 时只改 `skills/*/SKILL.md`，再运行同步脚本**

## 快速使用

### 创建新 skill

1. 复制 `template/` 目录，改名为你的 skill 名（英文小写 + 连字符）
2. 编辑 `SKILL.md` 的 frontmatter（`name`、`description`、`globs`）和正文
3. 运行同步脚本

### 同步到 CodeBuddy

```powershell
.\sync.ps1
```

脚本会：
1. 从 `skills/*/SKILL.md` 生成 `codebuddy/*.md`
2. 确保 `~/.codebuddy/skills` junction 指向 `codebuddy/`（普通用户权限即可）

之后 skill 的增删改**重新运行脚本即可生效**。

## Skill 列表

| Skill | 用途 | 来源 |
|-------|------|------|
| `dev-discipline` | 开发规范：文档先行、编码、自检三阶段 + 八荣八耻 | 原创 |
| `code-review` | 代码审查：8 大维度 + 分级反馈 + 八荣八耻 | 原创 |
| `webapp-testing` | Web 应用测试：Playwright 决策树 + 侦察后行动 | 借鉴 anthropics/skills |
| `mcp-builder` | MCP 服务器开发：四阶段流程 + 评估驱动 | 借鉴 anthropics/skills |
| `skill-creator` | Skill 创建优化：七步迭代 + 触发率优化 | 借鉴 anthropics/skills |

## SKILL.md 格式

```markdown
---
name: skill-name
description: "做什么 + 何时触发，写得略带推动性"
globs: ["*.go"]
---

# Skill 名称

指令正文（祈使句，解释为什么，< 500 行）...
```

## 参考来源

- [anthropics/skills](https://github.com/anthropics/skills) 仓库索引见 `references/anthropic-skills.md`
- 借鉴改写遵循 Apache-2.0 许可，借鉴思路不照搬代码

## 注意事项

- `codebuddy/` 目录是自动生成的，**不要手动编辑**，改 `skills/` 后跑 `sync.ps1`
- skill 名用英文小写 + 连字符
- junction 用 `mklink /J`（目录联接），普通用户权限即可，无需管理员
