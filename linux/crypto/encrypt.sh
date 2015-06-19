#!/bin/sh

curr_time=$(date +%Y%m%d%H%M%S)

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
NO_COL="\033[0m"

# check arguments
if [ "$#" -eq 1 ]
then
    INFILE="$1"
    BN=$(basename $1)
    OUTFILE="${BN}.${curr_time}.encrypt"
elif [ "$#" -eq 2 ]
then
    INFILE="$1"
    OUTFILE="$2"
else
    printf "${RED}Invalid argument(s). Input file is required, output file is optional.${NO_COL}"
    printf "\n"
    exit 1;
fi

# check input and output files
if [ ! -e ${INFILE} ]
then
    printf "${RED}Invalid argument. Input file does not exist.${NO_COL}"
    printf "\n"
    exit 1;
fi

if [ -e ${OUTFILE} ]
then
    printf "${RED}Invalid argument. Output file exists. For safety, it will not be overwritten.${NO_COL}"
    printf "\n"
    exit 1;
fi

# execute the command
replace="s/^.*${BN}/${BN}/" # tar preserves complete path, this changes it.
tar -zcvf - --transform=${replace} --show-transformed ${INFILE} | openssl enc -e -a -aes-256-cbc -out ${OUTFILE}

if [ $? -eq 0 ]
then
    printf "${GREEN}Encryption successful: ${YELLOW}$INFILE -> $OUTFILE${NO_COL}"
    printf "\n"
else
    printf "${RED}Encryption failed.${NO_COL}"
    printf "\n"
fi

exit 0;