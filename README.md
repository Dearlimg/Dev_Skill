# Dev_Skill

个人 CodeBuddy Skill 仓库，集中管理可复用的 skill，通过软链接同步到用户级目录 `~/.codebuddy/skills/`，供所有项目使用。

## 目录结构

```
Dev_Skill/
├── skills/              # skill 文件存放处
│   ├── _template.md     # skill 模板
│   └── ...              # 你的 skill
├── README.md
└── sync.ps1             # 同步脚本（可选）
```

## 快速使用

### 1. 创建新 skill

复制 `skills/_template.md`，改名后编辑内容即可。

### 2. 同步到 CodeBuddy

首次使用需建立软链接（需管理员权限运行 PowerShell）：

```powershell
.\sync.ps1
```

或手动执行：

```powershell
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.codebuddy\skills" -Target "$PWD\skills" -Force
```

之后仓库内 skill 的增删改会**实时生效**，无需再次同步。

## Skill 文件格式

每个 skill 是一个 `.md` 文件，包含 frontmatter 元数据和指令正文：

```markdown
---
description: "一句话描述 skill 的用途"
globs: ["*.go", "*.py"]   # 可选：适用的文件类型
---

# Skill 名称

具体指令内容...
```

## 注意事项

- 软链接需在**管理员权限**的 PowerShell 中创建
- skill 文件名建议用英文小写 + 连字符，如 `code-review.md`
- 修改 skill 后无需重启，CodeBuddy 会自动重新加载
