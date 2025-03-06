#!/bin/bash

set -e  # Exit on error
set -o pipefail  # Fail pipeline if any command fails

# Function to check if Nginx is installed
is_nginx_installed() {
    dpkg -l | grep -qw nginx
}

# Update package lists
echo "Updating package lists..."
sudo apt-get update -y

# Install Nginx if not already installed
if is_nginx_installed; then
    echo "Nginx is already installed."
else
    echo "Installing Nginx..."
    sudo apt-get install -y nginx
fi

# Enable and start Nginx service
echo "Enabling and starting Nginx..."
sudo systemctl enable nginx
sudo systemctl start nginx

# Check Nginx status
if systemctl is-active --quiet nginx; then
    echo "Nginx installation successful and running!"
else
    echo "Error: Nginx is not running. Check logs for details."
    exit 1
fi
