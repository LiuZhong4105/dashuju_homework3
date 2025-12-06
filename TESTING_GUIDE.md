# Hive Storage Format Testing Guide

## 测试目标

本指南提供完整的 Hive 存储格式性能测试流程，用于完成大数据课程作业3。

## 测试环境要求

- Ubuntu 24.04 (全新安装)
- 至少 10GB 可用磁盘空间
- Java 11
- 网络连接

## 完整测试流程

### 第一步：系统准备和软件安装

#### 1.1 安装系统依赖

```bash
cd setup
sudo bash 01-install-prerequisites.sh
```

这个脚本会安装：
- OpenJDK 11
- SSH 和相关工具
- 配置 SSH 免密登录

#### 1.2 安装和配置 Hadoop

```bash
bash 02-install-hadoop.sh
```

安装完成后，启动 Hadoop：

```bash
source ~/.bashrc
hdfs namenode -format
start-dfs.sh
start-yarn.sh
```

验证 Hadoop 运行状态：

```bash
jps
# 应该看到: NameNode, DataNode, SecondaryNameNode, ResourceManager, NodeManager
```

访问 Web 界面：
- NameNode UI: http://localhost:9870
- ResourceManager UI: http://localhost:8088

#### 1.3 安装和配置 Hive

```bash
bash 03-install-hive.sh
```

初始化 Hive：

```bash
source ~/.bashrc

# 创建 HDFS 目录
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -mkdir -p /tmp/hive
hdfs dfs -chmod g+w /user/hive/warehouse
hdfs dfs -chmod 777 /tmp/hive

# 初始化元数据库
schematool -initSchema -dbType derby
```

测试 Hive：

```bash
hive
# 在 Hive 提示符下:
show databases;
quit;
```

#### 1.4 设置测试数据生成器

```bash
bash 04-setup-testbench.sh
```

### 第二步：生成测试数据

```bash
cd ../scripts
bash generate-data.sh 1
```

参数说明：
- `1` = 生成约 1GB 数据（推荐用于测试）
- `10` = 生成约 10GB 数据
- `100` = 生成约 100GB 数据

生成的数据会自动上传到 HDFS 的 `/user/$USER/tpch/data/` 目录。

### 第三步：创建不同格式的表

```bash
bash create-tables.sh
```

这个脚本会：
1. 创建 4 个数据库，每个使用不同的存储格式
2. 在每个数据库中创建 8 个 TPC-H 表
3. 将数据加载到各个表中

创建的数据库：
- `tpch_text` - TextFile 格式
- `tpch_orc` - ORC 格式
- `tpch_parquet` - Parquet 格式
- `tpch_rc` - RCFile 格式

### 第四步：执行基准测试查询

```bash
bash run-queries.sh
```

这个脚本会：
1. 在所有 4 种存储格式上运行 5 个 TPC-H 查询
2. 测量每个查询的执行时间
3. 将结果保存到 `results/` 目录

测试的查询：
- Query 1: 价格汇总报告（聚合查询）
- Query 2: 最小成本供应商（复杂 JOIN 和子查询）
- Query 3: 运输优先级（多表 JOIN）
- Query 4: 订单优先级检查（EXISTS 子查询）
- Query 5: 本地供应商销量（多表 JOIN 和聚合）

### 第五步：分析和比较结果

```bash
bash compare-results.sh
```

这个脚本会生成完整的比较报告，包括：
1. 存储空间对比
2. 查询性能对比
3. 平均执行时间
4. 格式特性总结和建议

## 理解测试结果

### 存储格式特性

#### TextFile
- **优点**：人类可读，易于调试
- **缺点**：无压缩，占用空间最大，查询最慢
- **适用场景**：临时数据交换，调试

#### RCFile (Record Columnar File)
- **优点**：行列混合存储，支持追加
- **缺点**：中等性能，已逐渐被淘汰
- **适用场景**：遗留系统维护

#### ORC (Optimized Row Columnar)
- **优点**：
  - 最高压缩率（通常比 TextFile 小 75%）
  - 最快的查询性能
  - 支持谓词下推
  - 内置索引和统计信息
  - Hive 原生优化
- **缺点**：仅限 Hive 生态系统
- **适用场景**：Hive 分析工作负载，大数据集

#### Parquet
- **优点**：
  - 高压缩率
  - 快速查询性能
  - 跨平台支持（Spark, Impala 等）
  - 优化嵌套数据结构
- **缺点**：不如 ORC 在 Hive 中优化好
- **适用场景**：跨平台大数据处理，Spark 集成

### 预期结果

典型的测试结果应该显示：

**存储大小（相对于 1GB 原始数据）：**
- TextFile: ~1.0GB (100%)
- RCFile: ~0.6GB (60%)
- Parquet: ~0.3GB (30%)
- ORC: ~0.25GB (25%)

**查询性能（相对速度）：**
- TextFile: 最慢 (基准 100%)
- RCFile: 中等 (~70% 的 TextFile 时间)
- Parquet: 快速 (~40% 的 TextFile 时间)
- ORC: 最快 (~30% 的 TextFile 时间)

## 常见问题排查

### Hadoop 服务未启动

```bash
jps
# 如果服务缺失，重启:
stop-all.sh
start-all.sh
```

### Hive 连接错误

```bash
# 检查 HDFS 目录权限
hdfs dfs -ls -R /user/hive/
hdfs dfs -chmod -R 777 /tmp/hive
```

### 内存不足错误

编辑 Hadoop 配置以减少内存使用：

```bash
# 在 yarn-site.xml 中添加:
<property>
    <name>yarn.nodemanager.resource.memory-mb</name>
    <value>2048</value>
</property>
```

### 查询运行缓慢

对于小规模测试，可以在 Hive 中设置：

```sql
SET mapreduce.framework.name=local;
SET hive.exec.mode.local.auto=true;
```

## 实验报告建议

实验报告应包括：

1. **环境配置**
   - 系统规格
   - Hadoop/Hive 版本
   - 配置参数

2. **测试数据**
   - 数据规模
   - 表结构
   - 记录数量

3. **存储对比**
   - 各格式的存储大小
   - 压缩比对比表
   - 存储效率分析

4. **性能对比**
   - 各查询的执行时间表
   - 性能对比图表
   - 平均性能分析

5. **结论和建议**
   - 各格式的优缺点总结
   - 使用场景建议
   - 性能优化建议

## 高级测试选项

### 测试更大的数据集

```bash
bash generate-data.sh 10  # 10GB 数据
```

### 添加更多查询

在 `queries/` 目录中创建新的 SQL 文件，然后更新 `run-queries.sh` 脚本。

### 测试压缩选项

在 Hive 中测试不同的压缩编解码器：

```sql
SET hive.exec.compress.output=true;
SET mapreduce.output.fileoutputformat.compress.codec=org.apache.hadoop.io.compress.GzipCodec;
```

### 监控资源使用

```bash
# 监控 HDFS 使用情况
hdfs dfsadmin -report

# 监控 YARN 应用
yarn application -list

# 系统资源监控
htop  # 需要安装: sudo apt install htop
```

## 参考资料

- [Apache Hive 官方文档](https://hive.apache.org/)
- [ORC 文件格式](https://orc.apache.org/)
- [Parquet 文件格式](https://parquet.apache.org/)
- [TPC-H 基准测试](http://www.tpc.org/tpch/)
- [Hadoop 官方文档](https://hadoop.apache.org/)

## 清理环境

如果需要重新开始测试：

```bash
# 停止所有服务
stop-all.sh

# 删除 HDFS 数据
hdfs dfs -rm -r -f /user/hive/warehouse/*
hdfs dfs -rm -r -f /user/$USER/tpch/

# 删除本地 Hadoop 数据
rm -rf ~/hadoop/

# 重新格式化 NameNode（警告：会删除所有数据）
hdfs namenode -format

# 重新启动
start-all.sh
```

## 作业提交清单

确保你的作业包含：

- [ ] 完整的安装和配置步骤文档
- [ ] 至少 2 种存储格式的对比（建议 4 种）
- [ ] 至少 5 个 SQL 查询的测试结果
- [ ] 存储大小对比数据和图表
- [ ] 查询性能对比数据和图表
- [ ] 详细的分析和结论
- [ ] 遇到的问题及解决方案
- [ ] 截图和日志证据
