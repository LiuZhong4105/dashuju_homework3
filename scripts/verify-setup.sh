#!/bin/bash

# Script to verify that Hadoop and Hive are properly set up
# Run this after completing the setup scripts

set -e

echo "=========================================="
echo "Verifying Hadoop and Hive Setup"
echo "=========================================="
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $2"
    else
        echo -e "${RED}✗${NC} $2"
    fi
}

# Check Java
echo "Checking Java installation..."
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
    print_status 0 "Java is installed (version: $JAVA_VERSION)"
else
    print_status 1 "Java is not installed"
fi
echo ""

# Check Hadoop
echo "Checking Hadoop installation..."
if [ -d "/usr/local/hadoop" ]; then
    print_status 0 "Hadoop directory exists"
    if command -v hadoop &> /dev/null; then
        HADOOP_VERSION=$(hadoop version 2>&1 | head -n 1)
        print_status 0 "Hadoop command is available ($HADOOP_VERSION)"
    else
        print_status 1 "Hadoop command not found in PATH"
    fi
else
    print_status 1 "Hadoop directory not found"
fi
echo ""

# Check Hadoop services
echo "Checking Hadoop services..."
JPS_OUTPUT=$(jps 2>/dev/null)
if echo "$JPS_OUTPUT" | grep -q "NameNode"; then
    print_status 0 "NameNode is running"
else
    print_status 1 "NameNode is not running"
fi

if echo "$JPS_OUTPUT" | grep -q "DataNode"; then
    print_status 0 "DataNode is running"
else
    print_status 1 "DataNode is not running"
fi

if echo "$JPS_OUTPUT" | grep -q "SecondaryNameNode"; then
    print_status 0 "SecondaryNameNode is running"
else
    print_status 1 "SecondaryNameNode is not running"
fi

if echo "$JPS_OUTPUT" | grep -q "ResourceManager"; then
    print_status 0 "ResourceManager is running"
else
    print_status 1 "ResourceManager is not running"
fi

if echo "$JPS_OUTPUT" | grep -q "NodeManager"; then
    print_status 0 "NodeManager is running"
else
    print_status 1 "NodeManager is not running"
fi
echo ""

# Check HDFS
echo "Checking HDFS..."
if command -v hdfs &> /dev/null; then
    if hdfs dfs -ls / &> /dev/null; then
        print_status 0 "HDFS is accessible"
        
        # Check for Hive directories
        if hdfs dfs -test -d /user/hive/warehouse &> /dev/null; then
            print_status 0 "Hive warehouse directory exists"
        else
            print_status 1 "Hive warehouse directory not found"
        fi
        
        if hdfs dfs -test -d /tmp/hive &> /dev/null; then
            print_status 0 "Hive temp directory exists"
        else
            print_status 1 "Hive temp directory not found"
        fi
    else
        print_status 1 "Cannot access HDFS"
    fi
else
    print_status 1 "HDFS command not found"
fi
echo ""

# Check Hive
echo "Checking Hive installation..."
if [ -d "/usr/local/hive" ]; then
    print_status 0 "Hive directory exists"
    if command -v hive &> /dev/null; then
        HIVE_VERSION=$(hive --version 2>&1 | grep "Hive" | head -n 1)
        print_status 0 "Hive command is available ($HIVE_VERSION)"
    else
        print_status 1 "Hive command not found in PATH"
    fi
else
    print_status 1 "Hive directory not found"
fi

# Check metastore
if [ -d "/usr/local/hive/metastore_db" ]; then
    print_status 0 "Hive metastore database exists"
else
    print_status 1 "Hive metastore database not found (run schematool -initSchema -dbType derby)"
fi
echo ""

# Check TPC-H data generator
echo "Checking TPC-H data generator..."
if [ -d "tpch-dbgen" ] || [ -d "../tpch-dbgen" ]; then
    print_status 0 "TPC-H data generator directory exists"
    
    # Check if dbgen is compiled
    if [ -f "tpch-dbgen/dbgen" ] || [ -f "../tpch-dbgen/dbgen" ]; then
        print_status 0 "dbgen executable is compiled"
    else
        print_status 1 "dbgen executable not found (run setup/04-setup-testbench.sh)"
    fi
else
    print_status 1 "TPC-H data generator not found"
fi
echo ""

# Check required tools
echo "Checking required tools..."
for tool in ssh wget git bc; do
    if command -v $tool &> /dev/null; then
        print_status 0 "$tool is installed"
    else
        print_status 1 "$tool is not installed"
    fi
done
echo ""

# Summary
echo "=========================================="
echo "Verification Summary"
echo "=========================================="
echo ""

# Count issues
ISSUES=0

if ! command -v java &> /dev/null; then ((ISSUES++)); fi
if [ ! -d "/usr/local/hadoop" ]; then ((ISSUES++)); fi
if ! echo "$JPS_OUTPUT" | grep -q "NameNode"; then ((ISSUES++)); fi
if ! echo "$JPS_OUTPUT" | grep -q "DataNode"; then ((ISSUES++)); fi
if ! command -v hive &> /dev/null; then ((ISSUES++)); fi

if [ $ISSUES -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed!${NC}"
    echo ""
    echo "Your system is ready for testing."
    echo ""
    echo "Next steps:"
    echo "1. cd scripts"
    echo "2. bash generate-data.sh 1"
    echo "3. bash create-tables.sh"
    echo "4. bash run-queries.sh"
    echo "5. bash compare-results.sh"
else
    echo -e "${RED}✗ Found $ISSUES issue(s)${NC}"
    echo ""
    echo "Please address the issues above before proceeding."
    echo ""
    echo "Common fixes:"
    echo "- If Hadoop services are not running: start-dfs.sh && start-yarn.sh"
    echo "- If Hive metastore is missing: schematool -initSchema -dbType derby"
    echo "- If tools are missing: sudo apt install <tool-name>"
fi
echo ""

# Display useful URLs
echo "=========================================="
echo "Useful Web Interfaces"
echo "=========================================="
echo ""
echo "HDFS NameNode UI:       http://localhost:9870"
echo "YARN ResourceManager:   http://localhost:8088"
echo "MapReduce JobHistory:   http://localhost:19888"
echo ""
