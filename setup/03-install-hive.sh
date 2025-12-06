#!/bin/bash

# Script to install and configure Apache Hive 3.1.3 on Ubuntu 24.04
# Run as regular user: bash 03-install-hive.sh

set -e

HIVE_VERSION="3.1.3"
HIVE_HOME="/usr/local/hive"

echo "=========================================="
echo "Installing Apache Hive ${HIVE_VERSION}"
echo "=========================================="

# Check if Hadoop is installed
if [ ! -d "/usr/local/hadoop" ]; then
    echo "ERROR: Hadoop not found. Please run 02-install-hadoop.sh first."
    exit 1
fi

# Download Hive if not already present
if [ ! -f "apache-hive-${HIVE_VERSION}-bin.tar.gz" ]; then
    echo "Downloading Hive ${HIVE_VERSION}..."
    wget https://archive.apache.org/dist/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz
else
    echo "Hive tarball already downloaded"
fi

# Extract and move to /usr/local
echo "Extracting Hive..."
tar -xzf apache-hive-${HIVE_VERSION}-bin.tar.gz

echo "Moving Hive to ${HIVE_HOME}..."
sudo rm -rf ${HIVE_HOME}
sudo mv apache-hive-${HIVE_VERSION}-bin ${HIVE_HOME}
sudo chown -R $USER:$USER ${HIVE_HOME}

# Add environment variables to .bashrc if not already present
echo "Configuring environment variables..."
if ! grep -q "HIVE_HOME" ~/.bashrc; then
    cat >> ~/.bashrc << 'EOF'

# Hive Environment Variables
export HIVE_HOME=/usr/local/hive
export PATH=$PATH:$HIVE_HOME/bin
export CLASSPATH=$CLASSPATH:/usr/local/hadoop/lib/*:.
export CLASSPATH=$CLASSPATH:/usr/local/hive/lib/*:.
EOF
    echo "Environment variables added to ~/.bashrc"
else
    echo "Environment variables already configured"
fi

# Source the updated .bashrc
source ~/.bashrc

# Create hive-site.xml
echo "Configuring hive-site.xml..."
mkdir -p ${HIVE_HOME}/conf
cat > ${HIVE_HOME}/conf/hive-site.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>javax.jdo.option.ConnectionURL</name>
        <value>jdbc:derby:;databaseName=/usr/local/hive/metastore_db;create=true</value>
        <description>JDBC connection string for Derby database</description>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionDriverName</name>
        <value>org.apache.derby.jdbc.EmbeddedDriver</value>
        <description>Derby JDBC driver</description>
    </property>
    <property>
        <name>hive.metastore.warehouse.dir</name>
        <value>/user/hive/warehouse</value>
        <description>Location of default database for the warehouse</description>
    </property>
    <property>
        <name>hive.exec.scratchdir</name>
        <value>/tmp/hive</value>
        <description>Scratch space for Hive jobs</description>
    </property>
    <property>
        <name>hive.server2.enable.doAs</name>
        <value>false</value>
    </property>
    <property>
        <name>hive.exec.dynamic.partition</name>
        <value>true</value>
    </property>
    <property>
        <name>hive.exec.dynamic.partition.mode</name>
        <value>nonstrict</value>
    </property>
    <property>
        <name>hive.exec.max.dynamic.partitions</name>
        <value>10000</value>
    </property>
</configuration>
EOF

echo "=========================================="
echo "Hive installation completed!"
echo "=========================================="
echo ""
echo "Before starting Hive, ensure Hadoop is running:"
echo "1. source ~/.bashrc"
echo "2. Make sure HDFS is running (start-dfs.sh if needed)"
echo "3. Create HDFS directories:"
echo "   hdfs dfs -mkdir -p /user/hive/warehouse"
echo "   hdfs dfs -mkdir -p /tmp/hive"
echo "   hdfs dfs -chmod g+w /user/hive/warehouse"
echo "   hdfs dfs -chmod 777 /tmp/hive"
echo "4. Initialize metastore: schematool -initSchema -dbType derby"
echo "5. Start Hive: hive"
echo ""
echo "Next step: Run bash 04-setup-testbench.sh"
