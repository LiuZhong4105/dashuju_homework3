#!/bin/bash

# Script to install prerequisites for Hadoop and Hive on Ubuntu 24.04
# Run with sudo: sudo bash 01-install-prerequisites.sh

set -e

echo "=========================================="
echo "Installing Prerequisites for Hadoop/Hive"
echo "=========================================="

# Update package list
echo "Updating package list..."
apt update

# Install OpenJDK 11
echo "Installing OpenJDK 11..."
apt install -y openjdk-11-jdk

# Verify Java installation
echo "Java version:"
java -version

# Install required tools
echo "Installing required tools..."
apt install -y ssh pdsh wget git vim curl build-essential bc

# Configure SSH for passwordless login
echo "Configuring SSH..."
if [ ! -f "$HOME/.ssh/id_rsa" ]; then
    sudo -u $SUDO_USER ssh-keygen -t rsa -P "" -f /home/$SUDO_USER/.ssh/id_rsa
    sudo -u $SUDO_USER cat /home/$SUDO_USER/.ssh/id_rsa.pub >> /home/$SUDO_USER/.ssh/authorized_keys
    sudo -u $SUDO_USER chmod 600 /home/$SUDO_USER/.ssh/authorized_keys
    echo "SSH key generated and configured"
else
    echo "SSH key already exists"
fi

# Start SSH service
systemctl start ssh
systemctl enable ssh

echo "=========================================="
echo "Prerequisites installation completed!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Run: bash 02-install-hadoop.sh"
echo "2. Then: bash 03-install-hive.sh"
echo "3. Finally: bash 04-setup-testbench.sh"
