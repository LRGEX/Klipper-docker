#!/bin/bash
cat << "EOF"
██╗     ██████╗  ██████╗ ███████╗██╗  ██╗
██║     ██╔══██╗██╔════╝ ██╔════╝╚██╗██╔╝
██║     ██████╔╝██║  ███╗█████╗   ╚███╔╝ 
██║     ██╔══██╗██║   ██║██╔══╝   ██╔██╗ 
███████╗██║  ██║╚██████╔╝███████╗██╔╝ ██╗
╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝ 
╦╔═┬  ┬┌─┐┌─┐┌─┐┬─┐
╠╩╗│  │├─┘├─┘├┤ ├┬┘
╩ ╩┴─┘┴┴  ┴  └─┘┴└─   v2.0.0                                  
EOF

##################### Starting code #####################

# This script will run on every container start
if ! systemctl is-enabled nginx > /dev/null 2>&1; then
    echo "Enabling NGINX..."
    systemctl enable nginx
fi
if ! systemctl is-active nginx > /dev/null 2>&1; then
    echo "Starting NGINX..."
    systemctl start nginx
else
    echo "NGINX is already running."
fi

packages_str=$PACKAGES
IFS=' ' read -r -a packages_array <<< "$packages_str"

for package in "${packages_array[@]}"; do
    if [ "${package}" = "klipper" ] && [ ! -d "/home/lrgex/klipper" ]; then
        echo "Installing Klipper with Kiauh..."
        su lrgex -c 'expect ./klipper.exp'
    fi
    if [ "${package}" = "moonraker" ] && [ ! -d "/home/lrgex/moonraker" ]; then
        echo "Installing Moonraker with Kiauh..."
        su lrgex -c 'expect ./moonraker.exp'
    fi
    if [ "${package}" = "fluidd" ] && [ ! -d "/home/lrgex/fluidd" ]; then
        echo "Installing Fluidd with Kiauh..."
        su lrgex -c 'expect ./fluidd.exp'
    fi
done

##################### End code #####################




##################### Only for systemd #####################

# Start systemd /lib/systemd/systemd this for systemd to initialize, "log-level=info" is for debugging , "unit=sysinit.target" is for systemd to initialize AS IS for running the container with systemd
exec /lib/systemd/systemd log-level=info unit=sysinit.target

##################### End Only for systemd #####################



#exec "$@" & wait # This is needed to run other scripts or commands when running the container like docker run -it --rm backarosa:latest /bin/bash, backup,restore,container_start,container_stop ..etc
#so when you run the container it will run only one command from scripts folder and exit, however commands in line 3 and 4 will run on every docker run - mandatory hard coded - 