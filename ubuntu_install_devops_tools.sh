#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Step 1: Install Prerequisites
echo "Updating package index and installing prerequisites..."
sudo apt update
sudo apt install -y unzip wget software-properties-common apt-transport-https ca-certificates curl gnupg lsb-release

# Step 2: Install Terraform
echo "Installing Terraform..."
TERRAFORM_VERSION="1.8.5"
wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform --version

# Step 3: Install Ansible
echo "Installing Ansible..."
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt update
sudo apt install -y ansible
ansible --version

# Step 4: Install kubectl
echo "Installing kubectl..."

# Download the latest stable version of kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Validate the kubectl binary against the checksum file
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

# Install kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Test to ensure the version you installed is up-to-date
kubectl version --client

# Step 5: Install Azure CLI
echo "Installing Azure CLI..."

# Download and install the Microsoft signing key
sudo mkdir -p /etc/apt/keyrings
curl -sLS https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg
sudo chmod go+r /etc/apt/keyrings/microsoft.gpg

# Add the Azure CLI software repository
AZ_DIST=$(lsb_release -cs)
echo "Types: deb
URIs: https://packages.microsoft.com/repos/azure-cli/
Suites: ${AZ_DIST}
Components: main
Architectures: $(dpkg --print-architecture)
Signed-by: /etc/apt/keyrings/microsoft.gpg" | sudo tee /etc/apt/sources.list.d/azure-cli.sources

# Update repository information and install the azure-cli package
sudo apt-get update
sudo apt-get install -y azure-cli
az --version

# Inform the user of completion
echo "Terraform, Ansible, kubectl, and Azure CLI installation completed."
