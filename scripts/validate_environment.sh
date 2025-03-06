#!/bin/bash

set -e  # Exit immediately on error
set -o pipefail  # Fail on first command error in a pipeline

echo "Validating environment before installation..."

# Check if the script is running as root
if [[ $EUID -ne 0 ]]; then
    echo "Error: This script must be run as root. Use sudo."
    exit 1
fi

# Check if required packages are installed
REQUIRED_PACKAGES=("curl" "tar" "nginx")

for pkg in "${REQUIRED_PACKAGES[@]}"; do
    if ! dpkg -l | grep -qw "$pkg"; then
        echo "Error: Required package '$pkg' is not installed. Please install it."
        exit 1
    fi
done

# Check if enough disk space is available (at least 500MB)
AVAILABLE_SPACE=$(df / | tail -1 | awk '{print $4}')
if [[ $AVAILABLE_SPACE -lt 500000 ]]; then
    echo "Error: Not enough disk space available (minimum 500MB required)."
    exit 1
fi

echo "Environment validation successful!"
