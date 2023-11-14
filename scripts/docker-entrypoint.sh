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
╩ ╩┴─┘┴┴  ┴  └─┘┴└─   v2.3                                  
EOF

##################### Starting code #####################

##################### Backarosa #####################
backarosa=$(grep -c "restore done" /opt/lrgex/flags)
if [ ! $backarosa ]; then
    echo "Backuping klipper files..."
    cp -r /home/lrgex/klipper/printer_data /tmp/klipper_printer_data
fi

##################### End Backarosa #####################

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
    if [ "${package}" = "fluidd" ] && [ ! -d "/home/lrgex/fluidd" ] && [ ! -d "/home/lrgex/mainsail" ]; then
        echo "Installing Fluidd with Kiauh..."
        su lrgex -c 'expect ./fluidd.exp'
    elif [ -d "/home/lrgex/mainsail" ]; then
        echo -e "\e[31mMainsail detected, skipping Fluidd installation.\e[0m"
        echo -e "\e[31mIf you want to install Fluidd, please re run the container without the Mainsail package. .e.g [-e PACKAGES=\"klipper moonraker fluidd\"]\e[0m"
        sleep 5
        break
    fi
    if [ "${package}" = "mainsail" ] && [ ! -d "/home/lrgex/mainsail" ] && [ ! -d "/home/lrgex/fluidd" ]; then
        echo "Installing Mainsail with Kiauh..."
        su lrgex -c 'expect ./mainsail.exp'
    elif [ -d "/home/lrgex/fluidd" ]; then
        echo -e "\e[31mFluidd detected, skipping Mainsail installation.\e[0m"
        echo -e "\e[31mIf you want to install Mainsail, please re run the container without the Fluidd package. .e.g [-e PACKAGES=\"klipper moonraker mainsail\"]\e[0m"
        sleep 5
        break
    fi
done

if [ ${RESTORE} = "true" ]; then
    echo "Restoring klipper files..."
    cp -r /tmp/klipper_printer_data /home/lrgex/klipper/printer_data
    echo "restore done" >> /opt/lrgex/flags
fi

##################### End code #####################




##################### Only for systemd #####################

# Start systemd /lib/systemd/systemd this for systemd to initialize, "log-level=info" is for debugging , "unit=sysinit.target" is for systemd to initialize AS IS for running the container with systemd
exec /lib/systemd/systemd log-level=info unit=sysinit.target

##################### End Only for systemd #####################



#exec "$@" & wait # This is needed to run other scripts or commands when running the container like docker run -it --rm backarosa:latest /bin/bash, backup,restore,container_start,container_stop ..etc
#so when you run the container it will run only one command from scripts folder and exit, however commands in line 3 and 4 will run on every docker run - mandatory hard coded - 