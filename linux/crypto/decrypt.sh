#!/bin/sh

RED="\033[0;31m"
GREEN="\033[0;32m"
NO_COL="\033[0m"

# check arguments
if [ "$#" -eq 1 ]
then
    INFILE=$1
else
    printf "${RED}Invalid arguments. Input file is required${NO_COL}"
    printf "\n"
    exit 1;
fi

# check input file
if [ ! -e ${INFILE} ]
then
    printf "${RED}Invid argument. Input file does not exist.${NO_COL}"
    printf "\n"
    exit 1;
fi

openssl enc -d -a -aes-256-cbc -in ${INFILE} | tar zxvf -

if [ $? -eq 0 ]
then
    printf "${GREEN}Decryption successful: ${INFILE}${NO_COL}"
    printf "\n"
else
    printf "${RED}Decryption failed.${NO_COL}"
    printf "\n"
fi

exit 0