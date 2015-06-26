#!/bin/sh

RED="\033[0;31m"
YELLOW="\033[0;33m"
GREEN="\033[0;32m"
NO_COL="\033[0m"

print_info(){
    printf "${GREEN}$1${NO_COL}"
    printf "\n"
}

print_warn(){
    printf "${YELLOW}$1${NO_COL}"
    printf "\n"
}

print_error(){
    printf "${RED}$1${NO_COL}"
    printf "\n"
}

main(){
    # check arguments
    if [ "$#" -eq 1 ]
    then
        infile="$1"
    else
        print_error "Invalid arguments. Input file is required"
        exit 1;
    fi

    # check input file
    if [ ! -e "${infile}" ]
    then
        print_error "Invalid argument. Input file does not exist."
        exit 1;
    fi

    openssl enc -d -a -aes-256-cbc -in "${infile}" | tar xvf -

    if [ $? -eq 0 ]
    then
        print_info "Decryption successful: ${infile}"
    else
        print_error "Decryption failed."
    fi

    exit 0
}

main "$@"
