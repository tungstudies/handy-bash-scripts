#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Step 1: Install Prerequisites
echo "Updating package index and installing prerequisites..."
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

# Step 2: Add Docker’s Official GPG Key
echo "Adding Docker's official GPG key..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg

# Step 3: Add Docker Repo to Debian 11
echo "Adding Docker repository to sources list..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index again
echo "Updating package index again..."
sudo apt update

# Step 4: Install Docker on Debian 11 (Bullseye)
echo "Installing Docker Engine..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Step 5: Verify the Docker Installation
echo "Verifying Docker installation..."
sudo systemctl is-active docker
sudo docker run hello-world

# Enabling Non-root Users to Run Docker Commands
echo "Adding current user to the docker group..."
sudo usermod -aG docker ${USER}

# Step 6: Install Docker Compose
echo "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

# Inform the user to log out and log back in
echo "Docker installation completed. Please log out and log back in to apply the user group changes."
