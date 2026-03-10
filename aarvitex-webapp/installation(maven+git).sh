#!/bin/bash
# user_data.sh
# Runs as root on first boot. Logs to /var/log/user-data.log
set -e
exec > /var/log/user-data.log 2>&1

echo '============================================'
echo 'Aarvitex Maven Server Bootstrap'
echo "Started: $(date)"
echo '============================================'

# ── Step 1: System update ──────────────────────────────────────────
echo '>>> Updating system packages...'
dnf update -y

# ── Step 2: Install Java 11 (Amazon Corretto) ──────────────────────
echo '>>> Installing Java 11 Amazon Corretto...'
dnf install java-11-amazon-corretto -y

# Verify Java
java -version
echo "JAVA_HOME set to: $(dirname $(dirname $(readlink -f $(which java))))"

# Set JAVA_HOME globally
echo 'export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))' >> /etc/profile
echo 'export PATH=$PATH:$JAVA_HOME/bin' >> /etc/profile

# ── Step 3: Install Maven 3.9.13 ───────────────────────────────────
echo '>>> Installing Apache Maven 3.9.13...'
cd /opt
wget https://archive.apache.org/dist/maven/maven-3/3.9.13/binaries/apache-maven-3.9.13-bin.tar.gz

# Extract
sudo tar -xvzf apache-maven-3.9.13-bin.tar.gz

# Set environment variables
echo 'export M2_HOME=/opt/apache-maven-3.9.13' | sudo tee -a /etc/profile
echo 'export PATH=$PATH:$M2_HOME/bin'         | sudo tee -a /etc/profile
source /etc/profile

# Verify
mvn -version

# ── Step 4: Install Git ─────────────────────────────────────────────
sudo yum install git -y
cd /opt
git clone https://github.com/Aarvitexsathya/aarvitex-webapp.git
