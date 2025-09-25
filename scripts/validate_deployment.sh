#!/bin/bash

# Deployment validation script
# This script validates that the deployment was successful

set -e  # Exit immediately on error
set -o pipefail  # Fail on first command error in a pipeline

echo "=== DEPLOYMENT VALIDATION STARTED ==="

# Check if Nginx is running
echo "Checking Nginx service status..."
if systemctl is-active --quiet nginx; then
    echo "✅ Nginx is running"
else
    echo "❌ Nginx is not running!"
    exit 1
fi

# Check if index.html exists and is accessible
echo "Validating web content..."
if [ -f /var/www/html/index.html ]; then
    echo "✅ index.html exists"
else
    echo "❌ index.html not found!"
    exit 1
fi

# Test HTTP response
echo "Testing HTTP response..."
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost)
if [ "$HTTP_STATUS" = "200" ]; then
    echo "✅ HTTP 200 response received"
else
    echo "❌ HTTP $HTTP_STATUS response received"
    exit 1
fi

# Test content delivery
echo "Testing content delivery..."
if curl -s http://localhost | grep -q "<html>"; then
    echo "✅ HTML content is being served correctly"
else
    echo "❌ HTML content is not being served correctly"
    exit 1
fi

# Check file permissions
echo "Checking file permissions..."
if [ -r /var/www/html/index.html ]; then
    echo "✅ index.html is readable"
else
    echo "❌ index.html is not readable"
    exit 1
fi

echo "✅ Deployment validation completed successfully!"
echo "=== DEPLOYMENT VALIDATION COMPLETED ==="
