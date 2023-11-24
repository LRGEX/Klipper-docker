<p align="center"><img src="http://cloud.lrgex.com/s/mCxTfnA2bikjYyZ/download/Dark%20Full%20Logo.png" alt= “” width="400" height="100"></p>


<p align="center"><img src="https://download.lrgex.com/klipper-logo.png" alt= “” width="100" height="100"></p>

<h2 align="center">Backarosa</h2>






# <div align="center">Klipper-Docker</div>

<p align="center">We are proudly produce to you LRGEX Klipper-docker which is a docker container that contains Fluidd,klipper and moonraker all together in one solution, and to add more spice we also added LRGEX-Backarosa which will backup and restore all of your settings at once and it works on both x86/Arm archetectures</p> 



## Developers:

- Hesham M ALAHDAL a.k.a L.R.G
- Nidhal A Brniyyah a.k.a Ezmex



## What are we using to accomplish this?

- we used [Kiauh](https://github.com/dw-0/kiauh) as main source of the installation of Fluidd/mainsail,klipper and moonraker

 

## How to install LRGEX Klipper-Docker ? 



### To install Fluidd, Klipper, moonraker and Backarosa :

Create a docker-compose.yml file ,copy the example below and edit your settings to what suits you. the **most important thing is to edit the devices "/dev/ttyUSB0:/dev/ttyUSB0**" and change it for your USB tty. you can find more information on how to do it [here]().

example: 

```dockerfile
version: '3.8'

services:
  klipper:
    image: lrgex/klipper-docker:kmf-v2.5
    container_name: LRGEX-klipper
    restart: always
    privileged: true
    cap_add:
      - SYS_ADMIN
    security_opt:
      - seccomp=unconfined
    cgroup_parent: docker.slice
    cgroup: private
    tmpfs:
      - /tmp
      - /run
      - /run/lock
    volumes:
      - klipper-config:/home/lrgex/printer_data
    ports:
      - "5001:80"
      - "7125:7125"
    devices:
      - "/dev/ttyUSB0:/dev/ttyUSB0"

  klipper-backarosa:
    image: lrgex/backarosa
    container_name: klipper-backarosa
    restart: no
    command: backup
    volumes:
      - /mnt/backups/klipper:/backup
      - klipper-config:/source:ro
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - KEEP_VERSIONS=2
      - LOCAL_BACKUP=true
      - TZ=Asia/Riyadh

volumes:
  klipper-config:
   # external: true
    name: klipper-config 

```

--------



### To install Mainsail, Klipper, moonraker and Backarosa:

Create a docker-compose.yml file ,copy the example below and edit your settings to what suits you. **the most important thing is to edit the devices "/dev/ttyUSB0:/dev/ttyUSB0"** and change it for your USB  tty. you can find more information on how to do it [here]().

example: 

```
version: '3.8'

services:
  klipper:
    image: lrgex/klipper-docker:kmm-v2.5
    container_name: LRGEX-klipper
    restart: always
    privileged: true
    cap_add:
      - SYS_ADMIN
    security_opt:
      - seccomp=unconfined
    cgroup_parent: docker.slice
    cgroup: private
    tmpfs:
      - /tmp
      - /run
      - /run/lock
    volumes:
      - klipper-config:/home/lrgex/printer_data
    ports:
      - "5001:80"
      - "7125:7125"
    devices:
      - "/dev/ttyUSB0:/dev/ttyUSB0"

  klipper-backarosa:
    image: lrgex/backarosa
    container_name: klipper-backarosa
    restart: no
    command: backup
    volumes:
      - /mnt/backups/klipper:/backup
      - klipper-config:/source:ro
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - KEEP_VERSIONS=2
      - LOCAL_BACKUP=true
      - TZ=Asia/Riyadh

volumes:
  klipper-config:
   # external: true
    name: klipper-config 
```

-----------





#### To manually install  what you need from Kiauh: 

Create a docker-compose.yml file ,copy the example below and edit your settings to what suits you. **the most important thing is to edit the devices "/dev/ttyUSB0:/dev/ttyUSB0"** and change it for your USB  tty. you can find more information on how to do it [here]().

example: 

```
version: '3.8'

services:
  klipper:
    image: lrgex/klipper-docker:manual-v2.5
    container_name: LRGEX-klipper
    restart: always
    privileged: true
    cap_add:
      - SYS_ADMIN
    security_opt:
      - seccomp=unconfined
    cgroup_parent: docker.slice
    cgroup: private
    tmpfs:
      - /tmp
      - /run
      - /run/lock
    volumes:
      - klipper-config:/home/lrgex/printer_data
    ports:
      - "5001:80"
      - "7125:7125"
    devices:
      - "/dev/ttyUSB0:/dev/ttyUSB0"

  klipper-backarosa:
    image: lrgex/backarosa
    container_name: klipper-backarosa
    restart: no
    command: backup
    volumes:
      - /mnt/backups/klipper:/backup
      - klipper-config:/source:ro
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - KEEP_VERSIONS=2
      - LOCAL_BACKUP=true
      - TZ=Asia/Riyadh

volumes:
  klipper-config:
   # external: true
    name: klipper-config 
```

After docker pull do this :

```
sudo docker exec -it LRGEX-klipper bash 
```

then

```
su lrgex
```

then

```
./kiauh.sh
```

----

## Stay Up-to-Date

⭐ ${\normalsize{\textcolor{goldenrod}{\texttt{Star this project}}}}$

Watch for releases and updates.

<img src="https://download.lrgex.com/assets/images/givestar.gif" width="500" alt='github star'/>


## Support Me

Please ⭐ star this repository!

If you found my work useful, consider buying me a [<img src="https://download.lrgex.com/assets/images/coffee.png" height="20" alt='Ko-fi'/>](https://ko-fi.com/lrgex).





## How to use Backarosa backup and restore? 



[Backarosa](https://github.com/LRGEX/backarosa) is a docker container developed by LRGEX, forked from [Duplicati](https://www.duplicati.com/) that has the ability to wok perfectly for both x86 and Arm architectures, you can see more information about it on https://github.com/LRGEX/backarosa



##### To backup your container:

-  All you have to do is to start lrgex/backarosa container, and backup process will begins, keep in mind Backarosa will close LRGEX-klipper container for 30 sec in order to take full backup of it, so **dont** use it while you are printing something.
- The default backup files  location will be on /mnt/backups/klipper, depending on your settings of docker-compose, so if you change that in docker compose use it accordingly. 



#### To restore your backup:

- The way Backarosa works is to first restore the backed up volume then you run the docker compose. 

- run this command to restore your backups, change -v /mnt/backups/klipper:/backup  if you used another volume directory...
  ```dockerfile
  sudo docker run --rm \
  -v /mnt/backups/klipper:/backup \
  -v klipper-config:/source \
  -e LOCAL_BACKUP="true" \
  -e TZ="Asia/Riyadh" \
  -e RESTORE_VERSION="0" \
  lrgex/backarosa restore
  ```


  
