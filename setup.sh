#!/bin/bash

# Prompt for username and password
echo "Create new user"
read -p "Enter a username for the new user: " USERNAME
read -s -p "Enter a password for the new user: " PASSWORD

# Create the new user with the given username and password
sudo useradd -m -p $(openssl passwd -1 $PASSWORD) $USERNAME

# Add the new user to the sudo group
sudo usermod -aG sudo $USERNAME

# Prompt the user to install Docker
read -p "Do you want to install Docker? (y/n) " INSTALL_DOCKER

# Install Docker if the user chooses to do so
if [[ $INSTALL_DOCKER =~ ^[Yy]$ ]]; then
  # Install Docker dependencies
  sudo apt-get update
  sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

  # Add the Docker GPG key and repository
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  # Install Docker
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io

  # Display the Docker version
  docker --version
fi

# Display the new user's details
echo ""
echo "User $USERNAME created with password $PASSWORD"
echo "User $USERNAME added to the sudo group"

if [[ $INSTALL_DOCKER =~ ^[Yy]$ ]]; then
  echo "Docker installed successfully"
else
  echo "Docker not installed"
fi
