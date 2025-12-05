# Project Summary - Hive Storage Format Benchmark

## 项目概述

本项目为大数据课程作业3的完整解决方案，提供从零开始在 Ubuntu 24.04 上搭建 Hadoop + Hive 环境，并使用 TPC-H 基准测试对比不同存储格式的完整流程。

## 已完成内容

### 1. 文档 (Documentation)

#### 主要文档
- **README.md** - 项目英文说明，包括项目结构、快速开始和参考资料
- **快速开始.md** - 中文快速开始指南，提供5步完成测试的流程
- **SETUP.md** - 详细的安装配置指南，包括 Hadoop 和 Hive 的完整设置步骤
- **TESTING_GUIDE.md** - 详细的测试指南，包括测试流程、问题排查和报告建议

### 2. 自动化安装脚本 (Setup Scripts)

位于 `setup/` 目录：

1. **01-install-prerequisites.sh**
   - 安装 Java 11
   - 安装 SSH、git、wget 等必要工具
   - 安装 bc 计算器（用于性能测试）
   - 配置 SSH 免密登录

2. **02-install-hadoop.sh**
   - 下载并安装 Hadoop 3.3.4
   - 配置环境变量
   - 配置 Hadoop 核心文件（core-site.xml, hdfs-site.xml, mapred-site.xml, yarn-site.xml）
   - 创建必要的目录结构

3. **03-install-hive.sh**
   - 下载并安装 Hive 3.1.3
   - 配置环境变量
   - 配置 hive-site.xml
   - 设置元数据存储

4. **04-setup-testbench.sh**
   - 克隆并编译 TPC-H 数据生成器
   - 准备数据生成环境

### 3. 测试脚本 (Testing Scripts)

位于 `scripts/` 目录：

1. **generate-data.sh**
   - 生成指定规模的 TPC-H 测试数据
   - 自动上传数据到 HDFS
   - 支持自定义数据规模（scale factor）

2. **create-tables.sh**
   - 创建 4 个数据库，对应 4 种存储格式
   - 在每个数据库中创建 8 个 TPC-H 表
   - 自动将数据加载到不同格式的表中
   - 支持的格式：TextFile, ORC, Parquet, RCFile

3. **run-queries.sh**
   - 在所有 4 种存储格式上执行 5 个 TPC-H 查询
   - 自动测量每个查询的执行时间
   - 保存查询结果和性能数据

4. **compare-results.sh**
   - 对比不同格式的存储空间占用
   - 对比查询执行性能
   - 计算平均性能
   - 生成详细的分析报告和建议

### 4. TPC-H 基准查询 (Benchmark Queries)

位于 `queries/` 目录，包含 5 个标准 TPC-H 查询：

1. **query1.sql** - 价格汇总报告
   - 测试：简单聚合查询
   - 考察：基础查询性能和压缩效率

2. **query2.sql** - 最小成本供应商
   - 测试：复杂 JOIN 和子查询
   - 考察：多表关联性能

3. **query3.sql** - 运输优先级
   - 测试：多表 JOIN 和排序
   - 考察：JOIN 优化和排序性能

4. **query4.sql** - 订单优先级检查
   - 测试：EXISTS 子查询
   - 考察：子查询优化能力

5. **query5.sql** - 本地供应商销量
   - 测试：多表 JOIN 和聚合
   - 考察：复杂查询综合性能

### 5. 配置文件模板 (Configuration Templates)

位于 `config/` 目录：

- **core-site.xml** - Hadoop 核心配置
- **hdfs-site.xml** - HDFS 配置
- **hive-site.xml** - Hive 配置

这些文件提供了标准的配置模板，在安装脚本中会自动使用。

### 6. 结果目录 (Results Directory)

位于 `results/` 目录：

- 包含 README.md 说明结果文件的结构和命名规则
- 运行测试后会存储所有查询结果和性能数据

## 满足作业要求

### 要求 1: 至少测试 2 种存储格式
✅ **已完成：测试 4 种格式**
- TextFile
- ORC
- Parquet
- RCFile

### 要求 2: 至少 5 条 SQL 查询
✅ **已完成：提供 5 个 TPC-H 查询**
- Query 1: 聚合查询
- Query 2: 复杂 JOIN 和子查询
- Query 3: 多表 JOIN
- Query 4: EXISTS 子查询
- Query 5: 多表 JOIN 和聚合

### 要求 3: 对比存储空间大小
✅ **已完成：compare-results.sh 脚本**
- 自动测量每种格式的 HDFS 存储大小
- 显示详细的表级别存储信息
- 生成对比报告

### 要求 4: 对比查询执行效率
✅ **已完成：run-queries.sh 和 compare-results.sh**
- 精确测量每个查询的执行时间
- 对比不同格式的查询性能
- 计算平均性能指标

### 要求 5: 从头配置 Ubuntu 24.04 系统
✅ **已完成：完整的安装文档和脚本**
- 详细的步骤文档（SETUP.md, TESTING_GUIDE.md）
- 自动化安装脚本（4 个 setup 脚本）
- 适用于全新的 Ubuntu 24.04 系统

## 技术亮点

1. **全自动化流程**
   - 一键式安装脚本
   - 自动化测试流程
   - 自动化结果分析

2. **完善的文档**
   - 中英文双语文档
   - 详细的故障排查指南
   - 实验报告建议

3. **灵活的配置**
   - 支持自定义数据规模
   - 可扩展的查询集
   - 模块化的脚本设计

4. **标准的基准测试**
   - 使用业界标准的 TPC-H 基准
   - 涵盖多种查询类型
   - 真实的性能对比

## 使用流程

### 简化版（推荐新手）

```bash
# 1. 安装
cd setup
sudo bash 01-install-prerequisites.sh
bash 02-install-hadoop.sh && source ~/.bashrc
hdfs namenode -format && start-dfs.sh && start-yarn.sh
bash 03-install-hive.sh && source ~/.bashrc
hdfs dfs -mkdir -p /user/hive/warehouse /tmp/hive
hdfs dfs -chmod g+w /user/hive/warehouse && hdfs dfs -chmod 777 /tmp/hive
schematool -initSchema -dbType derby
bash 04-setup-testbench.sh

# 2. 测试
cd ../scripts
bash generate-data.sh 1
bash create-tables.sh
bash run-queries.sh
bash compare-results.sh
```

### 详细版

参见 TESTING_GUIDE.md 或快速开始.md

## 预期输出

运行完成后，你将得到：

1. **存储对比数据**
   - 每种格式的总存储大小
   - 每个表的存储大小
   - 压缩比对比

2. **性能对比数据**
   - 每个查询在每种格式上的执行时间
   - 平均查询性能
   - 性能排名

3. **详细分析报告**
   - 格式特性总结
   - 使用场景建议
   - 优化建议

## 文件清单

```
.
├── .gitignore                       # Git 忽略文件配置
├── README.md                        # 项目英文说明
├── 快速开始.md                      # 中文快速开始指南
├── SETUP.md                         # 详细安装指南
├── TESTING_GUIDE.md                 # 详细测试指南
├── PROJECT_SUMMARY.md               # 本文件
├── setup/                           # 安装脚本目录
│   ├── 01-install-prerequisites.sh
│   ├── 02-install-hadoop.sh
│   ├── 03-install-hive.sh
│   └── 04-setup-testbench.sh
├── scripts/                         # 测试脚本目录
│   ├── generate-data.sh
│   ├── create-tables.sh
│   ├── run-queries.sh
│   └── compare-results.sh
├── queries/                         # SQL 查询目录
│   ├── query1.sql
│   ├── query2.sql
│   ├── query3.sql
│   ├── query4.sql
│   └── query5.sql
├── config/                          # 配置文件模板
│   ├── core-site.xml
│   ├── hdfs-site.xml
│   └── hive-site.xml
└── results/                         # 结果输出目录
    └── README.md
```

## 注意事项

1. **系统要求**
   - 至少 10GB 可用空间
   - 建议 4GB+ 内存
   - Ubuntu 24.04 系统

2. **执行时间**
   - 安装过程：约 20-30 分钟
   - 数据生成（1GB）：约 5-10 分钟
   - 查询测试：约 30-60 分钟

3. **网络要求**
   - 需要下载 Hadoop (~500MB)
   - 需要下载 Hive (~300MB)
   - 需要克隆 Git 仓库

## 进阶使用

1. **测试更大数据集**
   ```bash
   bash generate-data.sh 10  # 10GB 数据
   ```

2. **添加自定义查询**
   - 在 queries/ 目录添加新的 .sql 文件
   - 修改 run-queries.sh 中的 QUERIES 数组

3. **调优建议**
   - 查看 TESTING_GUIDE.md 的高级选项部分
   - 参考 Hadoop/Hive 官方文档

## 结论

本项目提供了一个完整、自动化、易于使用的 Hive 存储格式基准测试解决方案，完全满足作业要求并超出预期。所有脚本都经过设计，确保在全新的 Ubuntu 24.04 系统上能够顺利运行。

## 参考文档

- 快速开始：快速开始.md
- 详细安装：SETUP.md
- 测试指南：TESTING_GUIDE.md
- 项目说明：README.md
