# PRD v2 — Langtian NATS EDA (精简与收敛)

版本：2.0
日期：2025-08-26

## 目标

构建一个以 NATS 为中心的事件驱动平台（EDA），包含：
- Windows 客户端(WebView2 + React )、nats.js、TanStack Table 、 TanStack DB
- 后端边缘采集服务：.NET Core UDP 采集器（带任务栏托盘管理）
- 中心消息总线：NATS + JetStDBream
- 持久化与分析：sql-flow（必须实现 sql-flow 原生 NATS Source ） -> DuckDB/Parquet (Duck Lake)
- 使用pandas dataFrame进行前端数据分析绑定（通过nats进行通信）
- 端到端可靠性与最小部署复杂度（MVP 路径）
- 明确的 schema 合约与轻量演化策略（proto 优先）
- 可观测与自动恢复能力，支持 HA 的简化方案
- https://duckdb.org/2025/05/27/ducklake.html#the-ducklake-duckdb-extension
- https://github.com/turbolytics/sql-flow（必须实现 sql-flow 原生 NATS Source ）
- https://tanstack.com/db/latest

## 决策要点（收敛后的核心方案）

1. MVP 消息流：物理设备/采集器 → NATS/JetStream → sql-flow → Duck Lake (Parquet on S3/MinIO) → 前端 (WebView2 React + TanStack UI)。

2. 部署形态：所有后端组件（nats-kafka 桥、sql-flow、.NET UDP 采集器）以 Windows Service / .NET Worker 形式在单机或多机上原生部署；NATS JetStream 作为集群服务（可跨机器部署）。

3. Schema 与合约：使用 protobuf 作为消息 schema（轻量 proto），所有 proto 放在专门的 Git 仓库并通过 CI 做兼容性检查与 artifacts 生成；每条事件携带 `schema_version`。

4. 事件 envelope：必须包含 event_id, event_type, event_timestamp, schema_version, source_system, 可选 partition_key, payload。

5. 数据一致性策略：MVP 使用桥接 ACK-on-Kafka-success 策略（至少一次）；长期目标是在 sql-flow 内实现 commit-after-sink 的近似 exactly-once 模型并减小对桥的依赖。

## Windows 原生部署下的简化 HA 方案（兼顾可用与简运维）

- NATS/JetStream：部署为独立 Windows 节点，启用 JetStream replication (replicas >=2)，并保证时间同步与磁盘监控。

- sql-flow (处理层)：以 Windows Service 形式部署多个实例，使用  JetStream durable consumers 保证负载与容错；实例升级前使用 drain+commit 策略。

- 对象存储（MinIO/S3）：可选择独立服务或企业 S3；Parquet 写入采用临时文件 + 原子 rename 或 Iceberg 表实现事务性写入。

## Protobuf 极简 schema 流程（设计与演化）

- 管理：所有 proto 文件放入 `proto/` 仓库，PR 必须通过 CI 的兼容性检查（例如 buf 或自定义脚本）。

- 版本：每次不兼容变更 bump major 版本并在 envelope 中写入 `schema_version`（例如 1.0 → 2.0）。

- 生成：CI 生成语言绑定与编译产物（JS/TS, Python, C#）并发布为内部 artifact 供部署使用。

## 最小 PoC 与验证计划


   
1. 在1台 Windows 机器上部署 NATS (JetStream) + SQL-flow + ducklake并验证 ACK-on-Kafka-success 的写入成功率与端到端延迟。
   
2. 实现电池测试数据的模拟UDP数据生成器

3. 实现 proto 仓库与 CI 流水线，提交一次非破坏性 schema 变更并验证兼容性检查。




(文件生成时间：2025-08-26)
