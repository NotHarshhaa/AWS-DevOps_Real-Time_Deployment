#!/bin/bash

# Nginx Start Script
# This script starts and configures Nginx for the DevOps blog application

set -e  # Exit immediately if a command fails
set -o pipefail  # Fail on first command error in a pipeline

# Configuration variables
LOG_FILE="/var/log/nginx-start.log"
MAX_RETRIES=3
RETRY_DELAY=2

# Function to log messages with timestamp
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Function to check if Nginx is installed
check_nginx_installation() {
    log_message "Checking Nginx installation..."
    
    if ! command -v nginx &>/dev/null; then
        log_message "❌ Error: Nginx is not installed. Please install it first."
        exit 1
    fi
    
    log_message "✅ Nginx is installed: $(nginx -v 2>&1)"
}

# Function to validate Nginx configuration
validate_nginx_config() {
    log_message "Validating Nginx configuration..."
    
    if sudo nginx -t; then
        log_message "✅ Nginx configuration is valid"
    else
        log_message "❌ Error: Nginx configuration is invalid"
        log_message "Configuration test output:"
        sudo nginx -t 2>&1 | tee -a "$LOG_FILE"
        exit 1
    fi
}

# Function to start Nginx with retry logic
start_nginx_service() {
    log_message "Starting Nginx service..."
    
    # Enable Nginx to start on boot
    sudo systemctl enable nginx
    
    # Start Nginx service with retry logic
    for attempt in $(seq 1 $MAX_RETRIES); do
        log_message "Attempt $attempt/$MAX_RETRIES: Starting Nginx..."
        
        if sudo systemctl start nginx; then
            log_message "✅ Nginx start command executed successfully"
            break
        else
            log_message "⚠️ Nginx start attempt $attempt failed"
            if [ $attempt -eq $MAX_RETRIES ]; then
                log_message "❌ Error: Failed to start Nginx after $MAX_RETRIES attempts"
                exit 1
            fi
            sleep $RETRY_DELAY
        fi
    done
}

# Function to verify Nginx is running
verify_nginx_running() {
    log_message "Verifying Nginx is running..."
    
    # Wait for service to fully start
    sleep 2
    
    # Check if Nginx is active
    if systemctl is-active --quiet nginx; then
        log_message "✅ Nginx is running successfully"
    else
        log_message "❌ Error: Nginx is not running"
        log_message "Nginx status:"
        sudo systemctl status nginx --no-pager | tee -a "$LOG_FILE"
        exit 1
    fi
    
    # Check if Nginx is listening on port 80
    if netstat -tlnp | grep -q ":80 "; then
        log_message "✅ Nginx is listening on port 80"
    else
        log_message "⚠️ Warning: Nginx may not be listening on port 80"
    fi
}

# Function to test HTTP response
test_http_response() {
    log_message "Testing HTTP response..."
    
    # Wait a bit more for Nginx to be fully ready
    sleep 3
    
    # Test HTTP response
    if curl -s -f http://localhost > /dev/null; then
        log_message "✅ HTTP response test passed"
    else
        log_message "⚠️ Warning: HTTP response test failed (this may be normal if no content is deployed yet)"
    fi
}

# Function to display Nginx status
display_nginx_status() {
    log_message "=== NGINX STATUS SUMMARY ==="
    log_message "Service Status: $(systemctl is-active nginx)"
    log_message "Service State: $(systemctl is-enabled nginx)"
    log_message "Process Info:"
    ps aux | grep nginx | grep -v grep | tee -a "$LOG_FILE"
    log_message "Port Status:"
    netstat -tlnp | grep nginx | tee -a "$LOG_FILE"
}

# Main execution
main() {
    log_message "=== NGINX START SCRIPT STARTED ==="
    
    check_nginx_installation
    validate_nginx_config
    start_nginx_service
    verify_nginx_running
    test_http_response
    display_nginx_status
    
    log_message "✅ Nginx started successfully!"
    log_message "=== NGINX START SCRIPT COMPLETED ==="
}

# Run main function
main "$@"
