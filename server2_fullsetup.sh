#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════
#  AARVITEX — Server 2 (Jenkins + Docker Server) Complete Setup Script
#
#  Tools Installed:
#    Step 1  — System Update
#    Step 2  — Java 21 (Amazon Corretto)  — Jenkins requirement
#    Step 3  — Jenkins LTS                — port 8080
#    Step 4  — Git + Clone Webapp Repo
#    Step 5  — Docker Engine              — for container builds
#    Step 6  — AWS CLI v2                 — for ECR push + EKS access
#    Step 7  — kubectl                    — for Kubernetes deployments
#    Step 8  — eksctl                     — for EKS cluster creation
#    Step 9  — Final validation           — verify everything is installed
#
#  Usage:
#    Paste into EC2 User Data  OR
#    chmod +x server2-setup.sh && sudo ./server2-setup.sh
#
#  Logs:   /var/log/aarvitex-setup.log  (also visible in terminal)
#  EC2:    t2.large (8 GB RAM) | Amazon Linux 2023 | 30 GB gp3
#  Ports:  8080 (Jenkins)
#
#  IMPORTANT — After running this script, do these MANUALLY:
#    1. Open http://<Server2-IP>:8080 and complete Jenkins setup
#    2. Run: aws configure  (enter your AWS Access Key + Secret Key)
#    3. Run: eksctl create cluster ... (see Section 16 of setup guide)
#    4. Copy kubeconfig for jenkins:
#       sudo cp ~/.kube/config /var/lib/jenkins/.kube/config
#       sudo chown -R jenkins:jenkins /var/lib/jenkins/.kube/
# ═══════════════════════════════════════════════════════════════════════════

set -e

# Log to file AND show in terminal simultaneously
exec > >(tee -a /var/log/aarvitex-setup.log) 2>&1

echo ""
echo "═══════════════════════════════════════════════════════"
echo "  AARVITEX — Server 2 Setup Starting"
echo "  $(date)"
echo "═══════════════════════════════════════════════════════"
echo ""

# ── Step 1: System Update ────────────────────────────────────────────────────
echo ">>> [Step 1/8] System update..."
dnf update -y
dnf install -y wget unzip tar git
# Install curl separately and handle package conflicts by retrying with --allowerasing if needed
if ! dnf install -y curl; then
  echo ">>> curl install failed due to package conflicts; retrying with --allowerasing"
  dnf install -y curl --allowerasing
fi
echo ">>> [Step 1/8] DONE"
echo ""

# ── Step 2: Install Java 21 (Amazon Corretto) ────────────────────────────────
echo ">>> [Step 2/8] Installing Java 21 (Amazon Corretto)..."
dnf install -y java-21-amazon-corretto-devel

# Verify
JAVA_VER=$(java -version 2>&1 | head -1)
echo ">>> Java installed: $JAVA_VER"
echo ">>> [Step 2/8] DONE"
echo ""

# ── Step 3: Install Jenkins LTS ──────────────────────────────────────────────
echo ">>> [Step 3/8] Installing Jenkins LTS..."

# Add Jenkins stable repository
wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo

# Import Jenkins GPG key
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install Jenkins
dnf install -y jenkins

# Enable and start Jenkins
systemctl enable jenkins
systemctl start jenkins

# Wait for Jenkins to start fully
echo ">>> Waiting 30 seconds for Jenkins to start..."
sleep 30

# Show Jenkins status
systemctl status jenkins --no-pager | head -5

# ── Step 4: Install Git + Clone Webapp ───────────────────────────────────────
echo ">>> [Step 4/8] Installing Git and cloning webapp..."

git --version

# Clone the Aarvitex webapp repo into /opt
cd /opt
git clone https://github.com/Aarvitexsathya/aarvitex-webapp.git aarvitex-webapp
echo ">>> Webapp cloned to /opt/aarvitex-webapp"
echo ">>> [Step 4/8] DONE"
echo ""

# ── Step 5: Install Docker Engine ────────────────────────────────────────────
echo ">>> [Step 5/8] Installing Docker Engine..."

dnf install -y docker

# Start and enable Docker
systemctl start docker
systemctl enable docker

# Add ec2-user to docker group (for manual docker commands)
usermod -aG docker ec2-user

# CRITICAL: Add jenkins to docker group
# Without this, every docker build in the pipeline fails with:
# "permission denied while trying to connect to the Docker daemon socket"
usermod -aG docker jenkins

# Restart Jenkins so it picks up the new docker group membership
systemctl restart jenkins
echo ">>> Waiting 20 seconds for Jenkins to restart..."
sleep 20

# Verify Docker
DOCKER_VER=$(docker --version)
echo ">>> Docker installed: $DOCKER_VER"

# Quick smoke test
docker run --rm hello-world 2>&1 | grep "Hello from Docker" && \
    echo ">>> Docker smoke test: PASSED" || \
    echo ">>> Docker smoke test: check logs"

echo ">>> [Step 5/8] DONE"
echo ""

# ── Step 6: Install AWS CLI v2 ───────────────────────────────────────────────
echo ">>> [Step 6/8] Installing AWS CLI v2..."

cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
./aws/install
rm -f awscliv2.zip
rm -rf aws/

# Verify
AWS_VER=$(aws --version)
echo ">>> AWS CLI installed: $AWS_VER"

echo ""
echo ">>> NOTE: You must configure AWS credentials MANUALLY after this script:"
echo ">>>   aws configure"
echo ">>>   sudo su jenkins -c 'aws configure'"
echo ">>> (Enter your Access Key, Secret Key, region: us-east-1)"
echo ""
echo ">>> [Step 6/8] DONE"
echo ""

# ── Step 7: Install kubectl ──────────────────────────────────────────────────
echo ">>> [Step 7/8] Installing kubectl..."

cd /tmp

# Get latest stable version
KUBECTL_VERSION=$(curl -Ls https://dl.k8s.io/release/stable.txt)
echo ">>> Downloading kubectl $KUBECTL_VERSION"

curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/kubectl

# Verify
KUBECTL_VER=$(kubectl version --client --short 2>/dev/null || kubectl version --client 2>&1 | head -1)
echo ">>> kubectl installed: $KUBECTL_VER"

# Create .kube directory for jenkins user (will need kubeconfig copied later)
mkdir -p /var/lib/jenkins/.kube
chown -R jenkins:jenkins /var/lib/jenkins/.kube

echo ""
echo ">>> NOTE: After creating EKS cluster, copy kubeconfig for Jenkins:"
echo ">>>   sudo cp ~/.kube/config /var/lib/jenkins/.kube/config"
echo ">>>   sudo chown -R jenkins:jenkins /var/lib/jenkins/.kube/"
echo ""
echo ">>> [Step 7/8] DONE"
echo ""

# ── Step 8: Install eksctl ───────────────────────────────────────────────────
echo ">>> [Step 8/8] Installing eksctl..."

cd /tmp

# Download latest eksctl
curl --silent --location \
    "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" \
    | tar xz -C /tmp

mv /tmp/eksctl /usr/local/bin/eksctl
chmod +x /usr/local/bin/eksctl

# Verify
EKSCTL_VER=$(eksctl version)
echo ">>> eksctl installed: $EKSCTL_VER"

echo ""
echo ">>> NOTE: Create EKS cluster MANUALLY (takes 15-20 min) with:"
echo ">>>   eksctl create cluster \\"
echo ">>>       --name aarvitex-cluster \\"
echo ">>>       --region us-east-1 \\"
echo ">>>       --nodegroup-name aarvitex-nodes \\"
echo ">>>       --node-type t3.medium \\"
echo ">>>       --nodes 2 \\"
echo ">>>       --nodes-min 1 \\"
echo ">>>       --nodes-max 4 \\"
echo ">>>       --managed"
echo ""
echo ">>> [Step 8/8] DONE"
echo ""

# ── Step 9: Final Validation ─────────────────────────────────────────────────
echo "═══════════════════════════════════════════════════════"
echo "  AARVITEX — Server 2 Setup Complete"
echo "  $(date)"
echo "═══════════════════════════════════════════════════════"
echo ""
echo "  INSTALLATION SUMMARY:"
echo "  ─────────────────────────────────────────────────────"

# Java
java -version 2>&1 | head -1 | xargs -I{} echo "  [OK] Java    : {}"

# Jenkins
systemctl is-active jenkins | xargs -I{} echo "  [OK] Jenkins : {} — port 8080"

# Git
git --version | xargs -I{} echo "  [OK] Git     : {}"

# Docker
docker --version | xargs -I{} echo "  [OK] Docker  : {}"

# AWS CLI
aws --version | xargs -I{} echo "  [OK] AWS CLI : {}"

# kubectl
kubectl version --client --short 2>/dev/null | head -1 | xargs -I{} echo "  [OK] kubectl : {}" || \
kubectl version --client 2>&1 | head -1 | xargs -I{} echo "  [OK] kubectl : {}"

# eksctl
eksctl version | xargs -I{} echo "  [OK] eksctl  : {}"

echo ""
echo "  NEXT MANUAL STEPS (in order):"
echo "  ─────────────────────────────────────────────────────"
echo "  1. Open Jenkins UI:"
echo "     http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null || echo '<Server2-Public-IP>'):8080"
echo ""
echo "  2. Jenkins admin password:"
cat /var/lib/jenkins/secrets/initialAdminPassword 2>/dev/null && echo "" || \
    echo "     sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
echo ""
echo "  3. Install Jenkins plugins (see Section 14.1 of setup guide)"
echo ""
echo "  4. Configure AWS credentials:"
echo "     aws configure"
echo "     sudo su jenkins -c 'aws configure'"
echo ""
echo "  5. Create ECR repository:"
echo "     aws ecr create-repository --repository-name aarvitex-webapp --region us-east-1"
echo ""
echo "  6. Create EKS cluster (takes 15-20 min):"
echo "     eksctl create cluster --name aarvitex-cluster --region us-east-1 \\"
echo "         --nodegroup-name aarvitex-nodes --node-type t3.medium --nodes 2 --managed"
echo ""
echo "  7. Copy kubeconfig for Jenkins:"
echo "     sudo cp ~/.kube/config /var/lib/jenkins/.kube/config"
echo "     sudo chown -R jenkins:jenkins /var/lib/jenkins/.kube/"
echo ""
echo "  8. Add Jenkins .m2/settings.xml (see Section 14.5 of setup guide)"
echo ""
echo "═══════════════════════════════════════════════════════"
echo "  Full setup log saved at: /var/log/aarvitex-setup.log"
echo "═══════════════════════════════════════════════════════"