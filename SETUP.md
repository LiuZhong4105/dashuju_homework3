# Detailed Setup Guide for Ubuntu 24.04

This guide walks through setting up Hadoop and Hive on a fresh Ubuntu 24.04 system.

## Prerequisites

Before starting, ensure you have:
- Ubuntu 24.04 (fresh installation)
- At least 10GB free disk space
- sudo/root access
- Internet connection

## Step 1: Install Prerequisites

### Update System
```bash
sudo apt update
sudo apt upgrade -y
```

### Install Java
Hadoop and Hive require Java. Install OpenJDK 11:

```bash
sudo apt install -y openjdk-11-jdk
java -version
```

### Install Required Tools
```bash
sudo apt install -y ssh pdsh wget git vim
```

### Configure SSH for Hadoop
```bash
# Generate SSH key (press Enter for all prompts)
ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa

# Add to authorized keys
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# Test SSH
ssh localhost
# Type 'yes' if prompted, then exit
```

## Step 2: Install Hadoop

### Download Hadoop
```bash
cd ~
wget https://archive.apache.org/dist/hadoop/common/hadoop-3.3.4/hadoop-3.3.4.tar.gz
tar -xzf hadoop-3.3.4.tar.gz
sudo mv hadoop-3.3.4 /usr/local/hadoop
```

### Configure Environment Variables
Add to `~/.bashrc`:

```bash
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
```

Apply changes:
```bash
source ~/.bashrc
```

### Configure Hadoop

#### 1. hadoop-env.sh
Edit `/usr/local/hadoop/etc/hadoop/hadoop-env.sh`:
```bash
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
```

#### 2. core-site.xml
Edit `/usr/local/hadoop/etc/hadoop/core-site.xml`:
```xml
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
```

#### 3. hdfs-site.xml
Edit `/usr/local/hadoop/etc/hadoop/hdfs-site.xml`:
```xml
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
```

#### 4. mapred-site.xml
Edit `/usr/local/hadoop/etc/hadoop/mapred-site.xml`:
```xml
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
```

#### 5. yarn-site.xml
Edit `/usr/local/hadoop/etc/hadoop/yarn-site.xml`:
```xml
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
```

### Format HDFS and Start Hadoop
```bash
# Format namenode
hdfs namenode -format

# Start HDFS
start-dfs.sh

# Start YARN
start-yarn.sh

# Verify services are running
jps
# Should show: NameNode, DataNode, SecondaryNameNode, ResourceManager, NodeManager
```

### Create HDFS directories
```bash
hdfs dfs -mkdir -p /user/$USER
hdfs dfs -mkdir /tmp
hdfs dfs -chmod 777 /tmp
```

## Step 3: Install Hive

### Download Hive
```bash
cd ~
wget https://archive.apache.org/dist/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz
tar -xzf apache-hive-3.1.3-bin.tar.gz
sudo mv apache-hive-3.1.3-bin /usr/local/hive
```

### Configure Hive Environment
Add to `~/.bashrc`:

```bash
# Hive Environment Variables
export HIVE_HOME=/usr/local/hive
export PATH=$PATH:$HIVE_HOME/bin
export CLASSPATH=$CLASSPATH:/usr/local/hadoop/lib/*:.
export CLASSPATH=$CLASSPATH:/usr/local/hive/lib/*:.
```

Apply changes:
```bash
source ~/.bashrc
```

### Configure Hive

#### Create hive-site.xml
Create `/usr/local/hive/conf/hive-site.xml`:
```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>javax.jdo.option.ConnectionURL</name>
        <value>jdbc:derby:;databaseName=/usr/local/hive/metastore_db;create=true</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionDriverName</name>
        <value>org.apache.derby.jdbc.EmbeddedDriver</value>
    </property>
    <property>
        <name>hive.metastore.warehouse.dir</name>
        <value>/user/hive/warehouse</value>
    </property>
    <property>
        <name>hive.exec.scratchdir</name>
        <value>/tmp/hive</value>
    </property>
    <property>
        <name>hive.server2.enable.doAs</name>
        <value>false</value>
    </property>
</configuration>
```

### Initialize Hive Metastore
```bash
# Create HDFS directories
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -mkdir -p /tmp/hive
hdfs dfs -chmod g+w /user/hive/warehouse
hdfs dfs -chmod 777 /tmp/hive

# Initialize schema
schematool -initSchema -dbType derby
```

### Test Hive
```bash
# Start Hive CLI
hive

# In Hive prompt:
show databases;
quit;
```

## Step 4: Setup Hive-Testbench

### Clone Repository
```bash
cd ~
git clone https://github.com/hortonworks/hive-testbench.git
cd hive-testbench
```

### Install TPC-H Data Generator
```bash
cd ~
git clone https://github.com/electrum/tpch-dbgen.git
cd tpch-dbgen
make
```

## Troubleshooting

### Common Issues

#### Port Already in Use
If Hadoop ports are in use:
```bash
stop-all.sh
# Wait a few seconds
start-all.sh
```

#### Permission Denied
If you encounter permission issues:
```bash
sudo chown -R $USER:$USER /usr/local/hadoop
sudo chown -R $USER:$USER /usr/local/hive
```

#### Java Not Found
Verify JAVA_HOME:
```bash
echo $JAVA_HOME
ls $JAVA_HOME
```

#### Cannot Connect to NameNode
Check if services are running:
```bash
jps
# Restart if needed
stop-all.sh
start-all.sh
```

## Verification

After completing all steps, verify:

```bash
# Check Hadoop
hdfs dfs -ls /
hadoop version

# Check Hive
hive --version

# Check services
jps
# Should show: NameNode, DataNode, SecondaryNameNode, ResourceManager, NodeManager
```

## Next Steps

After completing setup:
1. Generate test data using scripts in `scripts/` directory
2. Create tables in different formats
3. Run benchmark queries
4. Analyze results

See [README.md](README.md) for testing instructions.
