#!/bin/bash
# ═══════════════════════════════════════════════════════════════
#  AARVITEX — Server 2 (Jenkins Server) Setup Script
#  Tools: Java 21, Jenkins LTS, Git
#
#  Usage: Paste into EC2 User Data OR run manually:
#         chmod +x server2-setup.sh && sudo ./server2-setup.sh
#
#  Logs:  /var/log/user-data.log
#  EC2:   t2.large (8 GB) | Amazon Linux 2023
#  Ports: 8080 (Jenkins)
# ═══════════════════════════════════════════════════════════════
set -e
exec > /var/log/user-data.log 2>&1
# ── Step 1: System Update ──────────────────────────────────────
dnf update -y
dnf install -y wget

# ── Step 2: Install Java 21 (Amazon Corretto) ──────────────────

dnf install -y java-21-amazon-corretto-devel

java -version

# ── Step 3: Install Jenkins LTS ────────────────────────────────

# Add Jenkins repo
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

dnf install -y jenkins

systemctl enable jenkins
systemctl start jenkins

echo '>>> Jenkins installed — port 8080'

# ── Step 4: Install Git ────────────────────────────────────────
echo '>>> [Step 4/4] Installing Git...'
dnf install -y git
git --version