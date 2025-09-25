#!/bin/bash

# Nginx Installation Script
# This script installs and configures Nginx for the DevOps blog application

set -e  # Exit on error
set -o pipefail  # Fail pipeline if any command fails

# Configuration variables
NGINX_VERSION="nginx"
LOG_FILE="/var/log/nginx-install.log"

# Function to log messages with timestamp
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Function to check if Nginx is installed
is_nginx_installed() {
    dpkg -l | grep -qw nginx
}

# Function to check system requirements
check_system_requirements() {
    log_message "Checking system requirements..."
    
    # Check available disk space (minimum 100MB)
    AVAILABLE_SPACE=$(df / | tail -1 | awk '{print $4}')
    if [[ $AVAILABLE_SPACE -lt 100000 ]]; then
        log_message "❌ Error: Insufficient disk space (minimum 100MB required)"
        exit 1
    fi
    
    # Check if running on supported OS
    if ! command -v apt-get &> /dev/null; then
        log_message "❌ Error: This script requires a Debian/Ubuntu-based system"
        exit 1
    fi
    
    log_message "✅ System requirements check passed"
}

# Function to install Nginx
install_nginx() {
    log_message "=== NGINX INSTALLATION STARTED ==="
    
    # Update package lists
    log_message "Updating package lists..."
    sudo apt-get update -y
    
    # Install Nginx if not already installed
    if is_nginx_installed; then
        log_message "✅ Nginx is already installed"
        nginx -v
    else
        log_message "Installing Nginx..."
        sudo apt-get install -y nginx
        
        # Verify installation
        if is_nginx_installed; then
            log_message "✅ Nginx installed successfully"
            nginx -v
        else
            log_message "❌ Error: Nginx installation failed"
            exit 1
        fi
    fi
}

# Function to configure and start Nginx
configure_nginx() {
    log_message "Configuring Nginx..."
    
    # Enable Nginx service
    sudo systemctl enable nginx
    
    # Start Nginx service
    log_message "Starting Nginx service..."
    sudo systemctl start nginx
    
    # Wait for service to start
    sleep 2
    
    # Check Nginx status
    if systemctl is-active --quiet nginx; then
        log_message "✅ Nginx is running successfully"
    else
        log_message "❌ Error: Nginx failed to start"
        log_message "Checking Nginx status:"
        sudo systemctl status nginx --no-pager
        exit 1
    fi
}

# Function to validate Nginx configuration
validate_nginx_config() {
    log_message "Validating Nginx configuration..."
    
    if sudo nginx -t; then
        log_message "✅ Nginx configuration is valid"
    else
        log_message "❌ Error: Nginx configuration is invalid"
        exit 1
    fi
}

# Main execution
main() {
    log_message "=== NGINX INSTALLATION SCRIPT STARTED ==="
    
    check_system_requirements
    install_nginx
    validate_nginx_config
    configure_nginx
    
    log_message "✅ Nginx installation and configuration completed successfully!"
    log_message "=== NGINX INSTALLATION SCRIPT COMPLETED ==="
}

# Run main function
main "$@"
