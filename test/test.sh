#!/bin/bash

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
    elif [ -d "/home/lrgex/mainsail" ] && [ "${package}" = "fluidd" ]; then
        echo -e "\e[31mMainsail detected, skipping Fluidd installation.\e[0m"
        echo -e "\e[31mIf you want to install Fluidd, please re run the container without the Mainsail package. .e.g [-e PACKAGES=\"klipper moonraker fluidd\"]\e[0m"
        sleep 5
        break
    fi
    if [ "${package}" = "mainsail" ] && [ ! -d "/home/lrgex/mainsail" ] && [ ! -d "/home/lrgex/fluidd" ]; then
        echo "Installing Mainsail with Kiauh..."
        su lrgex -c 'expect ./mainsail.exp'
    elif [ -d "/home/lrgex/fluidd" ] && [ "${package}" = "mainsail" ]; then
        echo -e "\e[31mFluidd detected, skipping Mainsail installation.\e[0m"
        echo -e "\e[31mIf you want to install Mainsail, please re run the container without the Fluidd package. .e.g [-e PACKAGES=\"klipper moonraker mainsail\"]\e[0m"
        sleep 5
        break
    fi
done