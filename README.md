# Hive Storage Format Benchmark (作业3)

This project evaluates different Hive storage formats using TPC-H benchmark data and queries.

## Overview

This homework tests Hive performance across different storage formats:
- **TextFile** - Default text format
- **ORC (Optimized Row Columnar)** - Optimized columnar format
- **Parquet** - Column-oriented format
- **RCFile (Record Columnar File)** - Row-columnar format

## Project Structure

```
.
├── README.md                    # This file
├── setup/                       # Installation and configuration scripts
│   ├── 01-install-prerequisites.sh
│   ├── 02-install-hadoop.sh
│   ├── 03-install-hive.sh
│   └── 04-setup-testbench.sh
├── scripts/                     # Testing scripts
│   ├── generate-data.sh         # Generate TPC-H data
│   ├── create-tables.sh         # Create tables in different formats
│   ├── run-queries.sh           # Execute benchmark queries
│   └── compare-results.sh       # Compare storage and performance
├── queries/                     # TPC-H SQL queries
│   ├── query1.sql
│   ├── query2.sql
│   ├── query3.sql
│   ├── query4.sql
│   └── query5.sql
├── config/                      # Configuration files
│   ├── hadoop-env.sh
│   ├── core-site.xml
│   ├── hdfs-site.xml
│   └── hive-site.xml
└── results/                     # Test results output directory

```

## Requirements

- Ubuntu 24.04 (fresh installation)
- At least 10GB free disk space
- Java 8
- Internet connection for downloading dependencies

## Quick Start

### 1. Run Setup Scripts

Execute the setup scripts in order:

```bash
# Install prerequisites (Java, SSH, etc.)
cd setup
sudo bash 01-install-prerequisites.sh

# Install and configure Hadoop
bash 02-install-hadoop.sh

# Install and configure Hive
bash 03-install-hive.sh

# Setup hive-testbench
bash 04-setup-testbench.sh
```

### 2. Generate Test Data

```bash
cd scripts
bash generate-data.sh 1  # Generate 1GB TPC-H data
```

### 3. Create Tables in Different Formats

```bash
bash create-tables.sh
```

### 4. Run Benchmark Queries

```bash
bash run-queries.sh
```

### 5. View Results

```bash
bash compare-results.sh
```

## Detailed Setup Guide

See [SETUP.md](SETUP.md) for detailed step-by-step installation and configuration instructions.

## Testing Methodology

### Storage Comparison
- Measure HDFS storage space used by each format
- Compare compression ratios
- Analyze file sizes and block distribution

### Query Performance
- Execute 5 TPC-H benchmark queries
- Measure execution time for each query in each format
- Compare CPU and I/O usage
- Analyze query optimization effects

### Metrics Collected
- Storage size (bytes)
- Query execution time (seconds)
- Rows processed per second
- Compression ratio

## Expected Results

Different storage formats have different characteristics:

- **TextFile**: Largest size, slowest queries, human-readable
- **RCFile**: Medium size, medium performance, good for append operations
- **ORC**: Small size, fast queries, excellent compression, optimized for Hive
- **Parquet**: Small size, fast queries, optimized for nested data

## References

- [Apache Hive Documentation](https://hive.apache.org/)
- [Hive-Testbench](https://github.com/hortonworks/hive-testbench)
- [TPC-H Benchmark](http://www.tpc.org/tpch/)
- [Hadoop Documentation](https://hadoop.apache.org/)

## License

Educational project for Big Data course assignment.
