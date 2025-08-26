# 贡献指南

感谢您对 LT-PDCS-NATS-POC 项目的关注和贡献！本文档将指导您如何参与项目开发。

## 🎯 项目概述

LT-PDCS-NATS-POC 是一个基于 NATS JetStream 的高性能事件驱动数据处理平台。我们欢迎各种形式的贡献，包括但不限于：

- 🐛 Bug 报告和修复
- ✨ 新功能开发
- 📚 文档改进
- 🧪 测试用例编写
- 🎨 UI/UX 改进
- 🔧 性能优化

## 🚀 快速开始

### 环境准备

1. **系统要求**
   - Windows 10/11 (主要开发环境)
   - Node.js 18+
   - .NET 8 SDK
   - Docker & Docker Compose
   - Git

2. **可选工具**
   - Go 1.21+ (用于 sql-flow 扩展开发)
   - Visual Studio Code 或其他 AI 编辑器
   - Postman 或类似的 API 测试工具

### 项目设置

1. **Fork 和克隆项目**
```bash
# Fork 项目到您的 GitHub 账户
# 然后克隆到本地
git clone https://github.com/YOUR_USERNAME/LT-pdcs-nats-poc.git
cd LT-pdcs-nats-poc
```

2. **运行初始化脚本**
```powershell
# Windows PowerShell
.\scripts\setup.ps1

# 或者跳过 Docker 服务
.\scripts\setup.ps1 -SkipDocker
```

3. **验证环境**
```bash
# 检查基础服务
docker-compose ps

# 访问监控面板
# NATS: http://localhost:8222
# MinIO: http://localhost:9001
# Grafana: http://localhost:3000
```

## 📋 开发流程

### 分支策略

我们采用 GitFlow 分支模型：

- `main` - 生产就绪的稳定版本
- `develop` - 开发分支，集成最新功能
- `feature/*` - 功能开发分支
- `hotfix/*` - 紧急修复分支
- `release/*` - 发布准备分支

### 提交规范

使用 [Conventional Commits](https://conventionalcommits.org/) 格式：

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**类型说明：**
- `feat`: 新功能
- `fix`: Bug 修复
- `docs`: 文档更新
- `style`: 代码格式调整
- `refactor`: 代码重构
- `test`: 测试相关
- `chore`: 构建过程或辅助工具的变动

**示例：**
```
feat(nats): 实现 NATS JetStream 基础配置

- 添加 Stream 和 Consumer 配置
- 实现消息发布和订阅功能
- 添加连接状态监控

Closes #123
```

### 开发步骤

1. **创建功能分支**
```bash
git checkout develop
git pull origin develop
git checkout -b feature/your-feature-name
```

2. **开发和测试**
```bash
# 进行开发工作
# 运行测试
npm test  # 前端测试
dotnet test  # 后端测试
```

3. **提交代码**
```bash
git add .
git commit -m "feat: 添加新功能描述"
```

4. **推送和创建 PR**
```bash
git push origin feature/your-feature-name
# 在 GitHub 上创建 Pull Request
```

## 🧪 测试指南

### 测试类型

1. **单元测试**
   - 覆盖率要求：>80%
   - 位置：`tests/unit/`
   - 运行：`npm run test:unit` 或 `dotnet test`

2. **集成测试**
   - 测试组件间交互
   - 位置：`tests/integration/`
   - 运行：`npm run test:integration`

3. **端到端测试**
   - 完整用户场景测试
   - 位置：`tests/e2e/`
   - 运行：`npm run test:e2e`

### 测试最佳实践

- 每个新功能都应包含相应的测试
- 测试应该独立且可重复运行
- 使用描述性的测试名称
- Mock 外部依赖
- 测试边界条件和错误情况

## 📝 代码规范

### 通用规范

- 使用 4 个空格缩进
- 行长度限制：120 字符
- 文件编码：UTF-8
- 行尾符：LF (Unix 风格)

### 语言特定规范

**TypeScript/JavaScript:**
- 使用 ESLint 和 Prettier
- 优先使用 TypeScript
- 使用 async/await 而非 Promise.then()
- 导出使用 named exports

**C#:**
- 遵循 Microsoft C# 编码约定
- 使用 PascalCase 命名公共成员
- 使用 camelCase 命名私有成员
- 添加 XML 文档注释

**Go:**
- 遵循 Go 官方代码风格
- 使用 gofmt 格式化代码
- 添加适当的注释
- 处理所有错误

### 文档规范

- API 文档使用 OpenAPI 3.0
- 代码注释使用英文
- README 和用户文档使用中文
- 包含使用示例和最佳实践

## 🔍 代码审查

### PR 要求

1. **描述清晰**
   - 说明变更内容和原因
   - 包含相关 Issue 链接
   - 添加截图或演示视频（如适用）

2. **代码质量**
   - 通过所有自动化检查
   - 代码覆盖率不降低
   - 遵循项目编码规范

3. **测试完整**
   - 包含相应的测试用例
   - 手动测试验证功能
   - 考虑边界情况

### 审查流程

1. 自动化检查（CI/CD）
2. 代码审查（至少一位维护者）
3. 功能验证
4. 合并到目标分支

## 🐛 问题报告

### Bug 报告

使用 GitHub Issues 报告 Bug，请包含：

- 清晰的问题描述
- 复现步骤
- 预期行为 vs 实际行为
- 环境信息（OS、版本等）
- 相关日志或截图

### 功能请求

提交功能请求时，请说明：

- 功能的业务价值
- 详细的需求描述
- 可能的实现方案
- 相关的用例场景

## 📚 资源链接

### 技术文档

- [NATS JetStream 文档](https://docs.nats.io/jetstream)
- [sql-flow 项目](https://github.com/turbolytics/sql-flow)
- [DuckDB 文档](https://duckdb.org/docs/)
- [TanStack 文档](https://tanstack.com/)

### 项目文档

- [项目规格说明书](PROJECT_SPEC.md)
- [开发日志](DEVELOPMENT_LOG.md)
- [任务计划](TASK_PLAN.md)
- [API 文档](docs/api/)

## 🤝 社区

### 沟通渠道

- GitHub Issues - 问题报告和功能请求
- GitHub Discussions - 技术讨论和问答
- Pull Requests - 代码审查和讨论

### 行为准则

我们致力于创建一个开放、友好的社区环境：

- 尊重不同观点和经验
- 接受建设性批评
- 关注对社区最有利的事情
- 对其他社区成员表示同理心

## 🏆 贡献者认可

我们感谢所有贡献者的努力！贡献者将被列入：

- README.md 致谢部分
- 项目发布说明
- 贡献者页面（计划中）

### 贡献类型

- 💻 代码贡献
- 📖 文档改进
- 🐛 Bug 报告
- 💡 功能建议
- 🎨 设计贡献
- 🧪 测试改进
- 🌍 翻译工作
- 📢 推广宣传

---

再次感谢您的贡献！如有任何问题，请随时通过 GitHub Issues 联系我们。

**Happy Coding! 🚀**
