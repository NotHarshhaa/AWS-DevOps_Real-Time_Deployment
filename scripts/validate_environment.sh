#!/bin/bash

# Environment Validation Script
# This script validates the system environment before deployment

set -e  # Exit immediately on error
set -o pipefail  # Fail on first command error in a pipeline

# Configuration variables
LOG_FILE="/var/log/environment-validation.log"
MIN_DISK_SPACE=500000  # 500MB in KB
MIN_MEMORY=512         # 512MB in MB
REQUIRED_PACKAGES=("curl" "tar" "wget" "unzip")

# Function to log messages with timestamp
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Function to check if running as root
check_root_privileges() {
    log_message "Checking root privileges..."
    
    if [[ $EUID -ne 0 ]]; then
        log_message "❌ Error: This script must be run as root. Use sudo."
        exit 1
    fi
    
    log_message "✅ Running with root privileges"
}

# Function to check system information
check_system_info() {
    log_message "=== SYSTEM INFORMATION ==="
    log_message "OS: $(lsb_release -d 2>/dev/null | cut -f2 || echo 'Unknown')"
    log_message "Kernel: $(uname -r)"
    log_message "Architecture: $(uname -m)"
    log_message "Hostname: $(hostname)"
    log_message "Uptime: $(uptime -p 2>/dev/null || uptime)"
}

# Function to check disk space
check_disk_space() {
    log_message "Checking disk space..."
    
    # Get available disk space in KB
    AVAILABLE_SPACE=$(df / | tail -1 | awk '{print $4}')
    AVAILABLE_SPACE_MB=$((AVAILABLE_SPACE / 1024))
    
    log_message "Available disk space: ${AVAILABLE_SPACE_MB}MB"
    
    if [[ $AVAILABLE_SPACE -lt $MIN_DISK_SPACE ]]; then
        log_message "❌ Error: Insufficient disk space (${AVAILABLE_SPACE_MB}MB available, ${MIN_DISK_SPACE}MB required)"
        exit 1
    fi
    
    log_message "✅ Sufficient disk space available"
}

# Function to check memory
check_memory() {
    log_message "Checking system memory..."
    
    # Get available memory in MB
    AVAILABLE_MEMORY=$(free -m | awk 'NR==2{printf "%.0f", $7}')
    
    log_message "Available memory: ${AVAILABLE_MEMORY}MB"
    
    if [[ $AVAILABLE_MEMORY -lt $MIN_MEMORY ]]; then
        log_message "⚠️ Warning: Low memory (${AVAILABLE_MEMORY}MB available, ${MIN_MEMORY}MB recommended)"
    else
        log_message "✅ Sufficient memory available"
    fi
}

# Function to check required packages
check_required_packages() {
    log_message "Checking required packages..."
    
    MISSING_PACKAGES=()
    
    for pkg in "${REQUIRED_PACKAGES[@]}"; do
        if ! dpkg -l | grep -qw "$pkg"; then
            MISSING_PACKAGES+=("$pkg")
        else
            log_message "✅ Package '$pkg' is installed"
        fi
    done
    
    if [ ${#MISSING_PACKAGES[@]} -gt 0 ]; then
        log_message "❌ Error: Missing required packages: ${MISSING_PACKAGES[*]}"
        log_message "Please install missing packages with: sudo apt-get install ${MISSING_PACKAGES[*]}"
        exit 1
    fi
    
    log_message "✅ All required packages are installed"
}

# Function to check network connectivity
check_network_connectivity() {
    log_message "Checking network connectivity..."
    
    # Test internet connectivity
    if ping -c 1 8.8.8.8 > /dev/null 2>&1; then
        log_message "✅ Internet connectivity is available"
    else
        log_message "⚠️ Warning: Internet connectivity may be limited"
    fi
    
    # Test DNS resolution
    if nslookup google.com > /dev/null 2>&1; then
        log_message "✅ DNS resolution is working"
    else
        log_message "⚠️ Warning: DNS resolution may have issues"
    fi
}

# Function to check system services
check_system_services() {
    log_message "Checking system services..."
    
    # Check if systemd is running
    if systemctl --version > /dev/null 2>&1; then
        log_message "✅ systemd is available"
    else
        log_message "❌ Error: systemd is not available"
        exit 1
    fi
    
    # Check if apt is available
    if command -v apt-get > /dev/null 2>&1; then
        log_message "✅ Package manager (apt) is available"
    else
        log_message "❌ Error: Package manager (apt) is not available"
        exit 1
    fi
}

# Function to check file system permissions
check_file_permissions() {
    log_message "Checking file system permissions..."
    
    # Check if we can write to /var/www/html
    if [ -d "/var/www/html" ]; then
        if [ -w "/var/www/html" ]; then
            log_message "✅ /var/www/html is writable"
        else
            log_message "⚠️ Warning: /var/www/html is not writable"
        fi
    else
        log_message "ℹ️ /var/www/html directory does not exist (will be created during deployment)"
    fi
}

# Function to display validation summary
display_validation_summary() {
    log_message "=== VALIDATION SUMMARY ==="
    log_message "✅ Root privileges: OK"
    log_message "✅ Disk space: OK"
    log_message "✅ Required packages: OK"
    log_message "✅ System services: OK"
    log_message "✅ Environment validation completed successfully!"
}

# Main execution
main() {
    log_message "=== ENVIRONMENT VALIDATION STARTED ==="
    
    check_root_privileges
    check_system_info
    check_disk_space
    check_memory
    check_required_packages
    check_network_connectivity
    check_system_services
    check_file_permissions
    display_validation_summary
    
    log_message "=== ENVIRONMENT VALIDATION COMPLETED ==="
}

# Run main function
main "$@"
