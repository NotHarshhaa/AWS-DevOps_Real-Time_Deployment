#!/bin/bash

set -e  # Exit immediately if a command fails

# Check if Nginx is installed
if ! command -v nginx &>/dev/null; then
    echo "Error: Nginx is not installed. Please install it first."
    exit 1
fi

# Start Nginx service
echo "Starting Nginx..."
sudo systemctl start nginx

# Enable Nginx to start on boot
sudo systemctl enable nginx

# Check if Nginx is running
if systemctl is-active --quiet nginx; then
    echo "Nginx started successfully!"
else
    echo "Error: Failed to start Nginx. Check logs for details."
    exit 1
fi
