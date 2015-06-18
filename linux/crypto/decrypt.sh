#!/bin/sh

RED="\033[0;31m"
GREEN="\033[0;32m"
NO_COL="\033[0m"

# check arguments
if [ "$#" -eq 1 ]
then
    INFILE=$1
else
    echo "${RED}Invalid arguments. Missing input argument.${NO_COL}"
    exit 1;
fi

# check input file
if [ ! -e $INFILE ]
then
    echo "${RED}Invid argument. Input file does not exist.${NO_COL}"
    exit 1;
fi

openssl enc -d -a -aes-256-cbc -in $INFILE | tar zxvf -

if [ $? -eq 0 ]
then
    echo "${GREEN}Decryption successful: $INFILE${NO_COL}"
else
    echo "${RED}Decryption failed.${NO_COL}"
fi

exit 0