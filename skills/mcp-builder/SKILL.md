---
name: mcp-builder
description: "MCP 服务器开发规范：指导构建高质量的 Model Context Protocol 服务器，让 LLM 通过工具调用与外部服务交互。当用户需要构建 MCP 服务器、集成外部 API、开发 MCP 工具时触发（支持 Python/FastMCP 或 TypeScript SDK）"
globs: ["*.py", "*.ts", "*.js"]
---

# MCP 服务器开发规范

## 核心定位

构建高质量 MCP（Model Context Protocol）服务器，使 LLM 能通过设计良好的工具与外部服务交互。推荐技术栈：**TypeScript**（静态类型、SDK 完善）或 **Python（FastMCP）**。传输方式：远程服务器用 Streamable HTTP，本地服务器用 stdio。

---

## 四阶段流程

### 阶段一：深度研究与规划

> ⚠️ 不查档就动手是耻辱（查档求证）。MCP 协议和框架文档必须先读。

1. **理解 MCP 设计原则**：
   - API 覆盖 vs 工作流工具：不确定时优先全面 API 覆盖
   - 工具命名用一致前缀（如 `github_create_issue`、`github_list_repos`），面向动作
   - 上下文管理：简洁描述、支持分页、返回聚焦数据
   - 错误消息要可操作：引导代理找到解决方案，而非单纯报错
2. **研读协议文档**：`https://modelcontextprotocol.io/`，重点看规范、传输机制、工具/资源定义
3. **研读框架文档**：TypeScript SDK 或 Python FastMCP 的官方文档
4. **规划实现**：审查目标服务 API，识别端点、认证、数据模型，从最常见操作开始

### 阶段二：实现

1. **项目结构**：按语言专属指南搭建（TypeScript / Python）
2. **核心基础设施**：
   - 带认证的 API 客户端
   - 错误处理辅助函数
   - 响应格式化（JSON / Markdown）
   - 分页支持
3. **工具实现（每个工具四要素）**：

| 要素 | 要求 |
|------|------|
| 输入 Schema | TypeScript 用 Zod，Python 用 Pydantic；含约束、描述、示例 |
| 输出 Schema | 尽可能定义 `outputSchema`，用 `structuredContent` 返回结构化数据 |
| 工具描述 | 功能摘要 + 参数描述 + 返回类型 |
| 实现规范 | 异步 I/O、可操作的错误处理、支持分页、同时返回文本和结构化数据 |

4. **工具注解**：标注 `readOnlyHint`/`destructiveHint`/`idempotentHint`/`openWorldHint`

### 阶段三：审查与测试

1. **代码质量**：DRY、一致错误处理、完整类型覆盖、清晰描述
2. **构建验证**：TypeScript `npm run build`；Python `python -m py_compile`
3. **MCP Inspector 测试**：`npx @modelcontextprotocol/inspector` 验证工具可用性

### 阶段四：评估驱动验证

编写 **10 个评估问题**测试 MCP 服务器有效性。每个问题必须满足：

- **独立**：不依赖其他问题
- **只读**：仅需非破坏性操作
- **复杂**：需要多次工具调用和深度探索
- **现实**：基于真实用例
- **可验证**：单一明确答案，可字符串比较验证
- **稳定**：答案不随时间变化

---

## 八荣八耻（MCP 开发准则）

| 以…为耻 | 以…为荣 |
|---------|---------|
| 臆猜协议规范 | 查档求证再实现 |
| 模糊工具命名 | 一致前缀面向动作 |
| 报错无指引 | 可操作的错误消息 |
| 一次性返回全量 | 支持分页聚焦数据 |
| 省略输入校验 | Schema 约束完备 |
| 不测就交付 | Inspector + 评估验证 |
| 脑补 API 签名 | 查证外部服务文档 |
| 忽视类型安全 | 完整类型覆盖 |
