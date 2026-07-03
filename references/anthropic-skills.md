# Anthropic Skills 仓库参考索引

> 来源：[github.com/anthropics/skills](https://github.com/anthropics/skills)
> 用途：查阅借鉴，不直接搬用。本仓库已将部分开发类 skill 借鉴改写为自有版本。

## 许可证说明

| 类型 | 说明 |
|------|------|
| **Apache-2.0** | 开源，可借鉴改写（不可照搬，需注明来源） |
| **Source-Available** | 源码可查看但非开源，仅供参考，**不可复制** |

---

## Skill 完整列表（17 个）

### 开发与技术类（Apache-2.0）✅ 可借鉴

| Skill | 用途 | 本仓库是否已转化 |
|-------|------|----------------|
| [mcp-builder](https://github.com/anthropics/skills/tree/main/skills/mcp-builder) | 构建 MCP 服务器，集成外部 API | ✅ `skills/mcp-builder` |
| [webapp-testing](https://github.com/anthropics/skills/tree/main/skills/webapp-testing) | 基于 Playwright 测试 Web 应用 | ✅ `skills/webapp-testing` |
| [skill-creator](https://github.com/anthropics/skills/tree/main/skills/skill-creator) | 创建/优化/评估 skill | ✅ `skills/skill-creator` |
| [web-artifacts-builder](https://github.com/anthropics/skills/tree/main/skills/web-artifacts-builder) | 构建 Web 组件/页面制品 | ❌ 待转化 |
| [claude-api](https://github.com/anthropics/skills/tree/main/skills/claude-api) | Claude API 交互与集成 | ❌ 待转化 |

### 创意与设计类（Apache-2.0）

| Skill | 用途 |
|-------|------|
| [algorithmic-art](https://github.com/anthropics/skills/tree/main/skills/algorithmic-art) | 算法艺术生成 |
| [canvas-design](https://github.com/anthropics/skills/tree/main/skills/canvas-design) | 画布视觉设计 |
| [frontend-design](https://github.com/anthropics/skills/tree/main/skills/frontend-design) | 前端界面与 UI 设计 |
| [theme-factory](https://github.com/anthropics/skills/tree/main/skills/theme-factory) | 视觉主题生成与定制 |
| [slack-gif-creator](https://github.com/anthropics/skills/tree/main/skills/slack-gif-creator) | Slack GIF 动画生成 |

### 企业与沟通类（Apache-2.0）

| Skill | 用途 |
|-------|------|
| [brand-guidelines](https://github.com/anthropics/skills/tree/main/skills/brand-guidelines) | 品牌规范设计 |
| [internal-comms](https://github.com/anthropics/skills/tree/main/skills/internal-comms) | 内部沟通材料撰写 |
| [doc-coauthoring](https://github.com/anthropics/skills/tree/main/skills/doc-coauthoring) | 文档协作撰写 |

### 文档创建与编辑类（Source-Available）⚠️ 不可复制

| Skill | 用途 | 说明 |
|-------|------|------|
| [docx](https://github.com/anthropics/skills/tree/main/skills/docx) | Word 文档创建编辑 | source-available，仅参考 |
| [pdf](https://github.com/anthropics/skills/tree/main/skills/pdf) | PDF 文档处理 | source-available，仅参考 |
| [pptx](https://github.com/anthropics/skills/tree/main/skills/pptx) | PowerPoint 演示文稿 | source-available，仅参考 |
| [xlsx](https://github.com/anthropics/skills/tree/main/skills/xlsx) | Excel 表格处理 | source-available，仅参考 |

---

## 仓库其他资源

| 路径 | 内容 |
|------|------|
| [spec/](https://github.com/anthropics/skills/tree/main/spec) | Agent Skills 规范定义 |
| [template/](https://github.com/anthropics/skills/tree/main/template) | 官方 skill 创建模板 |

---

## 借鉴改写原则

1. **借鉴思路，不照搬代码**：学习结构、工作流、设计模式，用自己的话重写
2. **遵守许可证**：Apache-2.0 可借鉴改写并注明来源；source-available 不可复制
3. **本地化适配**：原为英文 Claude 场景，改写时适配中文环境和自有工具链
4. **融入自有准则**：改写时结合本仓库的「八荣八耻」精神
