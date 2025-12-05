# 文档索引 (Documentation Index)

## 📚 快速导航

根据你的需求选择合适的文档：

### 🚀 我是新手，想快速开始
👉 阅读 [快速开始.md](快速开始.md)
- 5步完成测试的简明指南
- 包含预期结果和常见问题解答
- 推荐首次使用者阅读

### 📖 我需要详细的安装步骤
👉 阅读 [SETUP.md](SETUP.md)
- 完整的 Ubuntu 24.04 配置指南
- Hadoop 和 Hive 详细安装步骤
- 配置文件详解

### 🧪 我想了解测试流程
👉 阅读 [TESTING_GUIDE.md](TESTING_GUIDE.md)
- 详细的测试方法论
- 结果解读指南
- 实验报告建议
- 进阶测试选项

### 🔄 我想了解完整的工作流程
👉 阅读 [WORKFLOW.md](WORKFLOW.md)
- 完整的流程图和决策树
- 各阶段的时间和资源估算
- 脚本依赖关系图
- 故障排查流程

### 📝 我需要项目概述
👉 阅读 [README.md](README.md) 或 [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)
- 项目结构说明
- 功能特性总览
- 技术亮点

### 🔧 我遇到了问题
👉 按顺序尝试：
1. 运行 [scripts/verify-setup.sh](scripts/verify-setup.sh) - 自动验证配置
2. 查看 [TESTING_GUIDE.md#常见问题排查](TESTING_GUIDE.md#常见问题排查)
3. 查看 [WORKFLOW.md#故障排查决策树](WORKFLOW.md#故障排查决策树)

---

## 📑 文档清单

### 主要文档

| 文件名 | 描述 | 适合人群 |
|--------|------|----------|
| [快速开始.md](快速开始.md) | 中文快速开始指南 | 新手 |
| [README.md](README.md) | 英文项目说明 | 所有人 |
| [SETUP.md](SETUP.md) | 详细安装配置指南 | 系统管理员 |
| [TESTING_GUIDE.md](TESTING_GUIDE.md) | 测试方法和指南 | 测试人员 |
| [WORKFLOW.md](WORKFLOW.md) | 工作流程和架构 | 开发人员 |
| [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) | 项目总结 | 项目经理 |

### 配置文件

| 目录/文件 | 描述 |
|-----------|------|
| [config/core-site.xml](config/core-site.xml) | Hadoop 核心配置 |
| [config/hdfs-site.xml](config/hdfs-site.xml) | HDFS 配置 |
| [config/hive-site.xml](config/hive-site.xml) | Hive 配置 |

### 安装脚本

| 脚本 | 功能 | 运行顺序 |
|------|------|----------|
| [setup/01-install-prerequisites.sh](setup/01-install-prerequisites.sh) | 安装系统依赖 | 1 |
| [setup/02-install-hadoop.sh](setup/02-install-hadoop.sh) | 安装 Hadoop | 2 |
| [setup/03-install-hive.sh](setup/03-install-hive.sh) | 安装 Hive | 3 |
| [setup/04-setup-testbench.sh](setup/04-setup-testbench.sh) | 设置数据生成器 | 4 |

### 测试脚本

| 脚本 | 功能 | 运行顺序 |
|------|------|----------|
| [scripts/verify-setup.sh](scripts/verify-setup.sh) | 验证系统配置 | 可选 |
| [scripts/generate-data.sh](scripts/generate-data.sh) | 生成测试数据 | 1 |
| [scripts/create-tables.sh](scripts/create-tables.sh) | 创建表 | 2 |
| [scripts/run-queries.sh](scripts/run-queries.sh) | 执行查询 | 3 |
| [scripts/compare-results.sh](scripts/compare-results.sh) | 对比结果 | 4 |

### SQL 查询

| 查询文件 | 描述 | 测试重点 |
|----------|------|----------|
| [queries/query1.sql](queries/query1.sql) | 价格汇总报告 | 聚合性能 |
| [queries/query2.sql](queries/query2.sql) | 最小成本供应商 | 复杂 JOIN |
| [queries/query3.sql](queries/query3.sql) | 运输优先级 | 多表 JOIN |
| [queries/query4.sql](queries/query4.sql) | 订单优先级检查 | 子查询 |
| [queries/query5.sql](queries/query5.sql) | 本地供应商销量 | 综合查询 |

---

## 📖 阅读顺序建议

### 对于初学者

```
第一次阅读:
1. 快速开始.md              (15分钟)
2. SETUP.md                 (30分钟)
   ├─ 跟随安装步骤
   └─ 运行 setup/ 目录下的脚本

实际操作:
3. 运行 verify-setup.sh     (2分钟)
4. TESTING_GUIDE.md         (20分钟)
5. 运行 scripts/ 目录下的测试脚本

完成测试后:
6. PROJECT_SUMMARY.md       (10分钟)
7. 准备实验报告
```

### 对于有经验的用户

```
1. README.md                (5分钟)
2. WORKFLOW.md              (10分钟)
3. 直接运行脚本
4. 如遇问题，查阅相关章节
```

### 对于教师/评审人员

```
1. PROJECT_SUMMARY.md       (完整理解项目范围)
2. README.md                (了解项目结构)
3. WORKFLOW.md              (理解技术实现)
4. 查看具体的脚本和查询文件
```

---

## 🎯 按任务查找

### 任务：安装和配置环境
📄 查看：
- SETUP.md (完整指南)
- setup/ 目录下的脚本
- config/ 目录下的配置文件

### 任务：生成和加载数据
📄 查看：
- TESTING_GUIDE.md (第二步)
- scripts/generate-data.sh
- scripts/create-tables.sh

### 任务：执行性能测试
📄 查看：
- TESTING_GUIDE.md (第四步)
- scripts/run-queries.sh
- queries/ 目录下的 SQL 文件

### 任务：分析结果
📄 查看：
- TESTING_GUIDE.md (理解测试结果)
- scripts/compare-results.sh
- results/ 目录

### 任务：撰写实验报告
📄 查看：
- TESTING_GUIDE.md (实验报告建议)
- PROJECT_SUMMARY.md (项目总结)
- WORKFLOW.md (技术细节)

### 任务：故障排查
📄 查看：
- scripts/verify-setup.sh (自动检查)
- TESTING_GUIDE.md (常见问题)
- WORKFLOW.md (故障排查决策树)

---

## 🔗 外部参考资料

### 官方文档
- [Apache Hadoop 文档](https://hadoop.apache.org/docs/current/)
- [Apache Hive 文档](https://hive.apache.org/)
- [ORC 文件格式](https://orc.apache.org/)
- [Parquet 文件格式](https://parquet.apache.org/)

### TPC-H 基准测试
- [TPC-H 官方规范](http://www.tpc.org/tpch/)
- [TPC-H 数据生成器](https://github.com/electrum/tpch-dbgen)

### 相关教程
- [Hadoop 入门教程](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html)
- [Hive 快速入门](https://cwiki.apache.org/confluence/display/Hive/GettingStarted)

---

## 💡 使用技巧

### 1. 搜索功能
在任何文档中，使用 Ctrl+F (或 Cmd+F) 搜索关键词：
- 错误信息
- 配置参数
- 命令名称

### 2. 交叉引用
文档之间有大量交叉引用，点击链接快速导航。

### 3. 代码块
所有代码块都可以直接复制使用，无需修改（除非另有说明）。

### 4. 标注说明
- ✅ 已完成的项目
- 📝 需要注意的内容
- ⚠️ 警告信息
- 💡 提示和技巧
- 🔧 需要配置的项目

---

## 📞 获取帮助

如果你在使用过程中遇到问题：

1. **首先**：运行 `scripts/verify-setup.sh` 检查配置
2. **然后**：查看相关文档的故障排查部分
3. **最后**：查看日志文件了解详细错误信息

常见日志位置：
- Hadoop 日志：`$HADOOP_HOME/logs/`
- Hive 日志：`/tmp/$USER/hive.log`
- 测试结果：`results/` 目录

---

## 📊 文档统计

- 主要文档：6 个
- 配置文件：3 个
- 安装脚本：4 个
- 测试脚本：5 个
- SQL 查询：5 个
- 总代码行数：~2000+ 行
- 总文档字数：~15000+ 字

---

## 🎓 学习路径

### 初级（1-2天）
- [ ] 完成环境安装
- [ ] 理解 Hadoop 和 Hive 基础
- [ ] 成功运行一个测试

### 中级（3-5天）
- [ ] 完成所有测试
- [ ] 理解不同存储格式的特点
- [ ] 分析测试结果

### 高级（5-7天）
- [ ] 优化查询性能
- [ ] 测试不同数据规模
- [ ] 自定义测试查询
- [ ] 撰写详细的分析报告

---

## 📝 文档更新日志

- 2024-12: 创建初始文档集
  - 完整的安装和测试流程
  - 4种存储格式支持
  - 5个TPC-H查询
  - 中英文双语文档

---

**提示**：将此文件加入书签，方便快速查找所需文档！
