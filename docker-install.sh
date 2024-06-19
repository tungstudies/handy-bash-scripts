#!/bin/bash

echo "***********************Updating system***********************************************************************************************"
sudo apt update
echo "***********************Upgrading system**********************************************************************************************"
sudo apt upgrade -y
echo "***********************Removing old docker*******************************************************************************************"
sudo apt-get remove docker docker-engine docker.io containerd runc
echo "***********************removing old docker*******************************************************************************************"
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
echo "***********************Add GPG key***************************************************************************************************"
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
echo "***********************Add docker repo***********************************************************************************************"
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
echo "***********************Specify installation source***********************************************************************************"
apt-cache policy docker-ce
echo "***********************Installing docker*********************************************************************************************"
sudo apt install -y docker-ce docker-ce-cli containerd.io
echo "***********************Add current user to Docker group******************************************************************************"
sudo usermod -aG docker $USER
echo "***********************Check Docker status*******************************************************************************************"
sudo systemctl status docker
echo "***********************Verify Docker installation************************************************************************************"

# Verify Docker installation
echo "Verifying Docker installation..."
sudo docker run hello-world
