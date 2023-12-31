FROM debian:11

# Required for systemd AS IS #
ENV container docker

# Required for apt-get to not prompt for user input
ENV DEBIAN_FRONTEND noninteractive

# Set stop signal to systemd init AS IS
STOPSIGNAL SIGRTMIN+3

# Enable systemd and install necessary packages
# Install packages
RUN apt-get update -y && apt-get install -y \
    build-essential \
    sudo \
    systemd \
    systemd-sysv \
    git \
    curl \
    wget \
    nano \
    virtualenv \
    python3-dev \
    libffi-dev \
    libncurses-dev \
    libusb-dev \
    avrdude \
    gcc-avr \
    binutils-avr \
    avr-libc \
    stm32flash \
    libnewlib-arm-none-eabi \
    gcc-arm-none-eabi \
    binutils-arm-none-eabi \
    libusb-1.0-0-dev \
    pkg-config \
    dfu-util \
    unzip \
    libjpeg-dev \
    python3-libgpiod \
    liblmdb-dev \
    libopenjp2-7 \
    libsodium-dev \
    packagekit \
    wireless-tools \
    nginx \
    expect \
    # Clean up
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Downloading kiauh
RUN mkdir -p /opt/lrgex \
    && touch /opt/lrgex/flags \
    && cd /opt/lrgex \
    && git clone https://github.com/dw-0/kiauh.git

# Remove unnecessary systemd files
RUN rm -rf /lib/systemd/system/multi-user.target.wants/* \
    && rm -rf /etc/systemd/system/*.wants/* \
    && rm -rf /lib/systemd/system/local-fs.target.wants/* \
    && rm -rf /lib/systemd/system/sockets.target.wants/*udev* \
    && rm -rf /lib/systemd/system/sockets.target.wants/*initctl* \
    && rm -rf /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* \
    && rm -rf /lib/systemd/system/systemd-update-utmp*

# Create a user lrgex with sudo permissions no password
RUN apt-get update -y \
    && useradd -d /home/lrgex -ms /bin/bash lrgex \
    && echo "lrgex ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers 

# Set the working directory
WORKDIR /opt/lrgex/kiauh

# Copy scripts
COPY scripts/ /opt/lrgex/kiauh/

# Make files in /opt/lrgex/kiauh executable
RUN find /opt/lrgex/kiauh -type f -exec chmod +x {} \; \
    && git config --global --add safe.directory /opt/lrgex/kiauh

# Set the default shell to bash instead of sh beacuse kiauh needs this terminal
ENV TERM xterm

# this to install klipper, moonraker and fluidd, you can change fluidd to mainsail
# ENV PACKAGES="klipper moonraker mainsail"

# # this has the script to install klipper, moonraker and fluidd
# RUN ./klipper.sh

# ENV PACKAGES=""

# Enable systemd init system in the container
VOLUME [ "/tmp", "/run", "/run/lock" ]

# Set the entrypoint
ENTRYPOINT ["/opt/lrgex/kiauh/docker-entrypoint.sh"]

# sudo docker run -d --name klipper -p 8562:80 --privileged --cap-add SYS_ADMIN --security-opt seccomp=unconfined --cgroup-parent=docker.slice --cgroupns private --tmpfs /tmp --tmpfs /run --tmpfs /run/lock klipper