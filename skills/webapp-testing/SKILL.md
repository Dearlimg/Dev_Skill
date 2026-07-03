---
name: webapp-testing
description: "Web 应用测试规范：基于 Playwright 进行本地 Web 应用的功能验证、UI 调试、截图与日志捕获。当用户需要测试前端功能、调试页面行为、验证交互逻辑时触发"
globs: ["*.py", "*.ts", "*.js", "*.html"]
---

# Web 应用测试规范

## 核心定位

测试本地 Web 应用时，编写**原生 Playwright 脚本**进行自动化验证。优先 headless 模式，操作完成后关闭浏览器。

---

## 决策树：选择执行路径

```
用户任务 → 是否为静态 HTML？
├─ 是 → 直接读取 HTML 文件，识别选择器
│   ├─ 成功 → 编写 Playwright 脚本（可用 file:// 协议）
│   └─ 失败/不完整 → 按动态应用处理
│
└─ 否（动态 Web 应用）→ 服务器是否已运行？
    ├─ 否 → 先启动服务（npm run dev / python server.py 等），
    │        确认端口可用后再编写脚本
    └─ 是 → 进入「侦察-后行动」模式（见下）
```

---

## 侦察-后行动模式

动态应用的 DOM 由 JS 渲染，**不能假设初始 HTML 就是最终结构**。必须先侦察再操作：

| 步骤 | 操作 | 目的 |
|-----|------|------|
| ① 等待渲染 | `page.wait_for_load_state('networkidle')` | 确保 JS 执行完毕 |
| ② 检查 DOM | 截图 `page.screenshot()` + `page.content()` | 了解当前页面结构 |
| ③ 识别选择器 | 从渲染结果中提取 `button`/`a`/`input` 等 | 获取真实可用的选择器 |
| ④ 执行操作 | 用发现的选择器执行点击/输入/断言 | 完成测试逻辑 |

---

## 脚本模板

```python
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page()
    page.goto('http://localhost:5173')
    page.wait_for_load_state('networkidle')  # 关键：等待 JS 执行
    # ... 自动化逻辑
    browser.close()
```

---

## 常见陷阱

| ❌ 错误做法 | ✅ 正确做法 |
|------------|-----------|
| 动态应用未等待就检查 DOM | 先 `wait_for_load_state('networkidle')` |
| 凭记忆/源码猜选择器 | 先截图或读 DOM 再定选择器 |
| 多服务器场景只起一个 | 后端+前端都要启动，分别指定端口 |
| 忘记关闭浏览器 | 用 `with` 上下文或显式 `browser.close()` |

---

## 最佳实践

1. **始终 headless**：测试场景无需可视化界面
2. **描述性选择器**：优先 `text=`、`role=`，其次 CSS、ID
3. **适当等待**：`wait_for_selector()` 或 `wait_for_timeout()`，避免竞态
4. **同步 API 优先**：用 `sync_playwright()`，逻辑清晰易调试
5. **捕获控制台日志**：`page.on('console', ...)` 帮助排查前端错误
6. **多服务器场景**：后端 + 前端分别启动，确认各自端口就绪

---

## 八荣八耻（测试准则）

| 以…为耻 | 以…为荣 |
|---------|---------|
| 臆猜页面结构 | 侦察后行动 |
| 跳过等待 | 确保渲染完成 |
| 猜测选择器 | 从 DOM 实证获取 |
| 遗留浏览器进程 | 用完即关闭 |
| 忽略控制台报错 | 捕获并排查日志 |
