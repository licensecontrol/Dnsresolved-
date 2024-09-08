#!/bin/bash

# Function to print status messages
function status {
    echo "=== $1 ==="
}

# Check DNS configuration
status "Checking DNS configuration..."
cat /etc/resolv.conf

# Test DNS resolution
status "Testing DNS resolution..."
nslookup google.com
if [ $? -ne 0 ]; then
    echo "DNS resolution failed."
else
    echo "DNS resolution is working."
fi

# Attempt to ping an external server
status "Pinging external server..."
ping -c 4 8.8.8.8
if [ $? -ne 0 ]; then
    echo "Network connectivity issue."
else
    echo "Network connectivity is working."
fi

# Offer to update DNS servers
status "Updating DNS servers..."
read -p "Do you want to update DNS servers to Google's DNS (8.8.8.8, 8.8.4.4)? [y/n]: " choice
if [[ "$choice" == "y" ]]; then
    echo "nameserver 8.8.8.8" > /etc/resolv.conf
    echo "nameserver 8.8.4.4" >> /etc/resolv.conf
    echo "DNS servers updated to Google's DNS."
else
    echo "DNS servers not updated."
fi

# Restart network services (adjust as needed for your OS)
status "Restarting network services..."
if command -v systemctl > /dev/null; then
    systemctl restart network || systemctl restart networking
else
    /etc/init.d/networking restart
fi

echo "Script completed."
