#!/bin/bash

# Get the IP address of the router
router_ip=$(ip route | grep default | awk '{print $3}')

# List all connected devices to the router
connected_devices=$(arp -a | grep -v "$router_ip" | awk '{print $2}')

# Function to enable/disable internet connection
toggle_internet() {
    device_ip=$1
    action=$2

    # Enable or disable internet connection using iptables
    if [ "$action" = "enable" ]; then
        iptables -D FORWARD -s "$device_ip" -j DROP
    elif [ "$action" = "disable" ]; then
        iptables -I FORWARD -s "$device_ip" -j DROP
    fi
}

# List all connected devices
echo "Connected devices:"
for device in $connected_devices; do
    echo "$device"
done

# Enable or disable internet connection for a specific device
read -p "Enter the IP address of the device you want to modify: " device_ip
read -p "Enter 'enable' to enable internet connection or 'disable' to disable internet connection: " action

# Call the function to toggle internet connection
toggle_internet "$device_ip" "$action"
