#!/bin/bash
cat << "EOF"
██╗     ██████╗  ██████╗ ███████╗██╗  ██╗
██║     ██╔══██╗██╔════╝ ██╔════╝╚██╗██╔╝
██║     ██████╔╝██║  ███╗█████╗   ╚███╔╝ 
██║     ██╔══██╗██║   ██║██╔══╝   ██╔██╗ 
███████╗██║  ██║╚██████╔╝███████╗██╔╝ ██╗
╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝ 
╔╗ ┌─┐┌─┐┬┌─┌─┐┬─┐┌─┐┌─┐┌─┐
╠╩╗├─┤│  ├┴┐├─┤├┬┘│ │└─┐├─┤
╚═╝┴ ┴└─┘┴ ┴┴ ┴┴└─└─┘└─┘┴ ┴    v0.1.0                                  
EOF

#set -e
#set -x

if [ "$1" = 'kiauh' ]; then
    ./opt/lrgex/kiauh/kiauh.sh
fi

/lib/systemd/systemd

exec "$@" & wait # This is needed to run other scripts or commands when running the container like docker run -it --rm backarosa:latest /bin/bash, backup,restore,container_start,container_stop ..etc
#so when you run the container it will run only one command from scripts folder and exit, however commands in line 3 and 4 will run on every docker run - mandatory hard coded - 