#!/bin/bash
# version 1.0
# Script to install Docker on Ubuntu
# Date: 2024-06-10

sudo apt update
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

# Verify Docker installation
sudo docker --version
echo "Docker has been installed successfully!"

#Add user to docker group to run docker without sudo
sudo usermod -aG docker $USER
echo "User $USER has been added to the docker group."

# Test Docker installation by running a hello-world container with the added user
newgrp docker <<EOF
docker run hello-world
EOF

