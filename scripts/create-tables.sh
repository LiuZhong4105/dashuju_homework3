#!/bin/bash

# Script to create TPC-H tables in different storage formats
# Run after generate-data.sh

set -e

echo "=========================================="
echo "Creating TPC-H Tables in Different Formats"
echo "=========================================="

# Create SQL file for table creation
cat > /tmp/create_tpch_tables.sql << 'EOF'
-- Create database for TPC-H benchmark
CREATE DATABASE IF NOT EXISTS tpch_text;
CREATE DATABASE IF NOT EXISTS tpch_orc;
CREATE DATABASE IF NOT EXISTS tpch_parquet;
CREATE DATABASE IF NOT EXISTS tpch_rc;

-- ============================================
-- TEXTFILE FORMAT TABLES
-- ============================================
USE tpch_text;

DROP TABLE IF EXISTS lineitem;
CREATE EXTERNAL TABLE lineitem (
    l_orderkey BIGINT,
    l_partkey BIGINT,
    l_suppkey BIGINT,
    l_linenumber INT,
    l_quantity DECIMAL(15,2),
    l_extendedprice DECIMAL(15,2),
    l_discount DECIMAL(15,2),
    l_tax DECIMAL(15,2),
    l_returnflag STRING,
    l_linestatus STRING,
    l_shipdate DATE,
    l_commitdate DATE,
    l_receiptdate DATE,
    l_shipinstruct STRING,
    l_shipmode STRING,
    l_comment STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/tpch_text.db/lineitem';

DROP TABLE IF EXISTS orders;
CREATE EXTERNAL TABLE orders (
    o_orderkey BIGINT,
    o_custkey BIGINT,
    o_orderstatus STRING,
    o_totalprice DECIMAL(15,2),
    o_orderdate DATE,
    o_orderpriority STRING,
    o_clerk STRING,
    o_shippriority INT,
    o_comment STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/tpch_text.db/orders';

DROP TABLE IF EXISTS customer;
CREATE EXTERNAL TABLE customer (
    c_custkey BIGINT,
    c_name STRING,
    c_address STRING,
    c_nationkey INT,
    c_phone STRING,
    c_acctbal DECIMAL(15,2),
    c_mktsegment STRING,
    c_comment STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/tpch_text.db/customer';

DROP TABLE IF EXISTS part;
CREATE EXTERNAL TABLE part (
    p_partkey BIGINT,
    p_name STRING,
    p_mfgr STRING,
    p_brand STRING,
    p_type STRING,
    p_size INT,
    p_container STRING,
    p_retailprice DECIMAL(15,2),
    p_comment STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/tpch_text.db/part';

DROP TABLE IF EXISTS supplier;
CREATE EXTERNAL TABLE supplier (
    s_suppkey BIGINT,
    s_name STRING,
    s_address STRING,
    s_nationkey INT,
    s_phone STRING,
    s_acctbal DECIMAL(15,2),
    s_comment STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/tpch_text.db/supplier';

DROP TABLE IF EXISTS partsupp;
CREATE EXTERNAL TABLE partsupp (
    ps_partkey BIGINT,
    ps_suppkey BIGINT,
    ps_availqty INT,
    ps_supplycost DECIMAL(15,2),
    ps_comment STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/tpch_text.db/partsupp';

DROP TABLE IF EXISTS nation;
CREATE EXTERNAL TABLE nation (
    n_nationkey INT,
    n_name STRING,
    n_regionkey INT,
    n_comment STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/tpch_text.db/nation';

DROP TABLE IF EXISTS region;
CREATE EXTERNAL TABLE region (
    r_regionkey INT,
    r_name STRING,
    r_comment STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '|'
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/tpch_text.db/region';

-- Load data into TextFile tables
LOAD DATA INPATH '/user/${env:USER}/tpch/data/lineitem.tbl' INTO TABLE lineitem;
LOAD DATA INPATH '/user/${env:USER}/tpch/data/orders.tbl' INTO TABLE orders;
LOAD DATA INPATH '/user/${env:USER}/tpch/data/customer.tbl' INTO TABLE customer;
LOAD DATA INPATH '/user/${env:USER}/tpch/data/part.tbl' INTO TABLE part;
LOAD DATA INPATH '/user/${env:USER}/tpch/data/supplier.tbl' INTO TABLE supplier;
LOAD DATA INPATH '/user/${env:USER}/tpch/data/partsupp.tbl' INTO TABLE partsupp;
LOAD DATA INPATH '/user/${env:USER}/tpch/data/nation.tbl' INTO TABLE nation;
LOAD DATA INPATH '/user/${env:USER}/tpch/data/region.tbl' INTO TABLE region;

-- ============================================
-- ORC FORMAT TABLES
-- ============================================
USE tpch_orc;

CREATE TABLE lineitem STORED AS ORC AS SELECT * FROM tpch_text.lineitem;
CREATE TABLE orders STORED AS ORC AS SELECT * FROM tpch_text.orders;
CREATE TABLE customer STORED AS ORC AS SELECT * FROM tpch_text.customer;
CREATE TABLE part STORED AS ORC AS SELECT * FROM tpch_text.part;
CREATE TABLE supplier STORED AS ORC AS SELECT * FROM tpch_text.supplier;
CREATE TABLE partsupp STORED AS ORC AS SELECT * FROM tpch_text.partsupp;
CREATE TABLE nation STORED AS ORC AS SELECT * FROM tpch_text.nation;
CREATE TABLE region STORED AS ORC AS SELECT * FROM tpch_text.region;

-- ============================================
-- PARQUET FORMAT TABLES
-- ============================================
USE tpch_parquet;

CREATE TABLE lineitem STORED AS PARQUET AS SELECT * FROM tpch_text.lineitem;
CREATE TABLE orders STORED AS PARQUET AS SELECT * FROM tpch_text.orders;
CREATE TABLE customer STORED AS PARQUET AS SELECT * FROM tpch_text.customer;
CREATE TABLE part STORED AS PARQUET AS SELECT * FROM tpch_text.part;
CREATE TABLE supplier STORED AS PARQUET AS SELECT * FROM tpch_text.supplier;
CREATE TABLE partsupp STORED AS PARQUET AS SELECT * FROM tpch_text.partsupp;
CREATE TABLE nation STORED AS PARQUET AS SELECT * FROM tpch_text.nation;
CREATE TABLE region STORED AS PARQUET AS SELECT * FROM tpch_text.region;

-- ============================================
-- RCFILE FORMAT TABLES
-- ============================================
USE tpch_rc;

CREATE TABLE lineitem STORED AS RCFILE AS SELECT * FROM tpch_text.lineitem;
CREATE TABLE orders STORED AS RCFILE AS SELECT * FROM tpch_text.orders;
CREATE TABLE customer STORED AS RCFILE AS SELECT * FROM tpch_text.customer;
CREATE TABLE part STORED AS RCFILE AS SELECT * FROM tpch_text.part;
CREATE TABLE supplier STORED AS RCFILE AS SELECT * FROM tpch_text.supplier;
CREATE TABLE partsupp STORED AS RCFILE AS SELECT * FROM tpch_text.partsupp;
CREATE TABLE nation STORED AS RCFILE AS SELECT * FROM tpch_text.nation;
CREATE TABLE region STORED AS RCFILE AS SELECT * FROM tpch_text.region;

EOF

echo "Creating tables in Hive..."
echo "This may take several minutes..."

# Execute the SQL file
hive -f /tmp/create_tpch_tables.sql

echo ""
echo "=========================================="
echo "Table creation completed!"
echo "=========================================="
echo ""
echo "Created databases and tables:"
echo "  - tpch_text (TextFile format)"
echo "  - tpch_orc (ORC format)"
echo "  - tpch_parquet (Parquet format)"
echo "  - tpch_rc (RCFile format)"
echo ""
echo "Next step: Run bash run-queries.sh to execute benchmark queries"
