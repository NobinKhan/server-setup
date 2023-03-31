#!/bin/bash

# Ask whether to create a new user
read -p "Do you want to create a new user? (y/n) " create_user

if [[ $create_user == "y" ]]; then
  # Ask for the new user's username and password
  read -p "Enter the new username: " username
  read -sp "Enter the new password: " password
  echo

  # Create the new user and set the password
  useradd -m $username
  echo "$username:$password" | chpasswd
  echo "User '$username' created."
  # Add the new user to the sudo group
  usermod -aG sudo $username
  echo "User '$username' added to the 'sudo' group."
fi

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


if [[ $INSTALL_DOCKER =~ ^[Yy]$ ]]; then
  echo "Docker installed successfully"
else
  echo "Docker not installed"
fi
