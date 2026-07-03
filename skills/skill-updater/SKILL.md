---
name: skill-updater
description: "Skill 更新规范：从远程仓库拉取最新 skill，对比本地与远程差异，经用户确认后合并更新。当用户说「更新skill」「拉取skill」「同步skill」时触发"
globs: ["*.md", "*.ps1"]
---

# Skill 更新规范

## 核心定位

从远程仓库拉取最新 skill，与本地 `skills/` 目录对比差异，列出新增/修改/删除项，**经用户确认后**才执行更新。绝不静默覆盖本地内容。

---

## 更新流程

### 第一步：确定远程仓库地址

优先用 git 自动获取，不臆猜：

```powershell
git remote get-url origin
```

- 若存在 `origin`：使用该地址作为远程源
- 若不存在：**停止并向用户询问**远程仓库地址，不自行脑补

> 若用户提供了具体仓库 URL（如 `https://github.com/Dearlimg/Dev_Skill`），以用户提供的为准。

### 第二步：拉取远程变更（不合并）

```powershell
git fetch origin
```

仅拉取，不自动 merge，保留对比和确认环节。

### 第三步：对比差异

对比本地 `skills/` 与远程 `origin/master` 的 `skills/` 目录，输出三类差异：

| 类别 | 含义 | 判定方式 |
|------|------|---------|
| 🟢 **新增** | 远程有、本地无的 skill | `git diff --name-status origin/master -- skills/` 中 `A` 项 |
| 🟡 **修改** | 两边都有但内容不同 | `git diff --name-status origin/master -- skills/` 中 `M` 项 |
| 🔴 **删除** | 本地有、远程无的 skill | 本地存在但远程已移除 |

输出格式示例：

```
远程仓库: https://github.com/Dearlimg/Dev_Skill

🟢 新增 skill（2）:
  + skills/new-feature/SKILL.md

🟡 修改 skill（1）:
  ~ skills/code-review/SKILL.md

🔴 远程已删除（1）:
  - skills/old-skill/SKILL.md
```

### 第四步：等待用户确认

> ⚠️ **必须等用户明确确认后才执行更新**，不自动合并。

向用户展示差异清单，询问：
- 全部更新？
- 仅更新指定项？
- 取消？

### 第五步：执行更新

根据用户选择执行：

**全部更新：**
```powershell
git merge origin/master
```

**仅更新指定 skill：**
```powershell
git checkout origin/master -- skills/<指定skill>/
```

### 第六步：同步到 CodeBuddy

更新完成后，重新生成扁平兼容层：

```powershell
.\sync.ps1
```

### 第七步：提交本地变更

若 merge 产生变更，按开发规范提交（中文 commit，不推送）：

```powershell
git add -A
git commit -m "更新skill：从远程同步<具体说明>"
```

> 不执行 `git push`，除非用户明确要求。

---

## 八荣八耻（更新准则）

| 以…为耻 | 以…为荣 |
|---------|---------|
| 臆猜远程地址 | 查 git remote 求证 |
| 静默覆盖本地 | 列差异等确认 |
| 自动 push | 用户明确要求才推 |
| 跳过同步脚本 | 更新后跑 sync.ps1 |
| 模糊差异描述 | 分类列出增删改 |
| 全量强制合并 | 支持选择性更新 |
| 忽略冲突 | 冲突时停下请示 |
| 忘记提交变更 | 中文 commit 留痕 |

---

## 异常处理

- **fetch 失败**（网络/权限）：报告错误，不继续
- **merge 冲突**：**停止**，列出冲突文件，请用户决定如何解决，不自行取舍
- **远程无 skills/ 目录**：提示远程仓库结构异常，请用户确认仓库是否正确
- **本地有未提交变更**：先提示用户处理本地变更（commit 或 stash），再拉取
