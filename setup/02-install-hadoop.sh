#!/bin/bash

# Script to install and configure Hadoop 3.3.4 on Ubuntu 24.04
# Run as regular user: bash 02-install-hadoop.sh

set -e

HADOOP_VERSION="3.3.4"
HADOOP_HOME="/usr/local/hadoop"

echo "=========================================="
echo "Installing Hadoop ${HADOOP_VERSION}"
echo "=========================================="

# Download Hadoop if not already present
if [ ! -f "hadoop-${HADOOP_VERSION}.tar.gz" ]; then
    echo "Downloading Hadoop ${HADOOP_VERSION}..."
    wget https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
else
    echo "Hadoop tarball already downloaded"
fi

# Extract and move to /usr/local
echo "Extracting Hadoop..."
tar -xzf hadoop-${HADOOP_VERSION}.tar.gz

echo "Moving Hadoop to ${HADOOP_HOME}..."
sudo rm -rf ${HADOOP_HOME}
sudo mv hadoop-${HADOOP_VERSION} ${HADOOP_HOME}
sudo chown -R $USER:$USER ${HADOOP_HOME}

# Add environment variables to .bashrc if not already present
echo "Configuring environment variables..."
if ! grep -q "HADOOP_HOME" ~/.bashrc; then
    cat >> ~/.bashrc << 'EOF'

# Hadoop Environment Variables
export HADOOP_HOME=/usr/local/hadoop
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"

# Java Environment
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin
EOF
    echo "Environment variables added to ~/.bashrc"
else
    echo "Environment variables already configured"
fi

# Source the updated .bashrc
source ~/.bashrc

# Configure Java home in hadoop-env.sh
echo "Configuring hadoop-env.sh..."
if ! grep -q "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh; then
    echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh
fi

# Create Hadoop directories
echo "Creating Hadoop directories..."
mkdir -p ~/hadoop/tmp
mkdir -p ~/hadoop/hdfs/namenode
mkdir -p ~/hadoop/hdfs/datanode

# Configure core-site.xml
echo "Configuring core-site.xml..."
cat > ${HADOOP_HOME}/etc/hadoop/core-site.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost:9000</value>
    </property>
    <property>
        <name>hadoop.tmp.dir</name>
        <value>/home/${user.name}/hadoop/tmp</value>
    </property>
</configuration>
EOF

# Configure hdfs-site.xml
echo "Configuring hdfs-site.xml..."
cat > ${HADOOP_HOME}/etc/hadoop/hdfs-site.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>file:///home/${user.name}/hadoop/hdfs/namenode</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>file:///home/${user.name}/hadoop/hdfs/datanode</value>
    </property>
</configuration>
EOF

# Configure mapred-site.xml
echo "Configuring mapred-site.xml..."
cat > ${HADOOP_HOME}/etc/hadoop/mapred-site.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
    <property>
        <name>mapreduce.application.classpath</name>
        <value>$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/*:$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/lib/*</value>
    </property>
</configuration>
EOF

# Configure yarn-site.xml
echo "Configuring yarn-site.xml..."
cat > ${HADOOP_HOME}/etc/hadoop/yarn-site.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.nodemanager.env-whitelist</name>
        <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_HOME,PATH,LANG,TZ,HADOOP_MAPRED_HOME</value>
    </property>
</configuration>
EOF

echo "=========================================="
echo "Hadoop installation completed!"
echo "=========================================="
echo ""
echo "To start Hadoop, run the following commands:"
echo "1. source ~/.bashrc"
echo "2. hdfs namenode -format"
echo "3. start-dfs.sh"
echo "4. start-yarn.sh"
echo "5. jps (to verify services are running)"
echo ""
echo "Next step: Run bash 03-install-hive.sh"
