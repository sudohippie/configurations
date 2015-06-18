#!/bin/sh

curr_time=$(date +%Y%m%d%H%M%S)

RED_COL="\033[0;31m"
GREEN_COL="\033[0;32m"
YELLOL_COL="\033[0;33m"
NO_COL="\033[0m"

# check arguments
if [ "$#" -eq 1 ]
then
    INFILE="$1"
    BN=$(basename $1)
    OUTFILE="$BN.$curr_time.encrypt"
elif [ "$#" -eq 2 ]
then
    INFILE="$1"
    OUTFILE="$2"
else
    >&2 echo "${RED_COL}Invalid number of arguments. Please specify one or two argument(s) only.${NO_COL}"
    exit 1;
fi

# check input and output files
if [ ! -e $INFILE ]
then
    >&2 echo "${RED_COL}Invalid argument. Input file does not exist.${NO_COL}"
    exit 1;
fi

if [ -e $OUTFILE ]
then
    >&2 echo "${RED_COL}Invalid argument. Output file already exists and will not be overwritten.${NO_COL}"
    exit 1;
fi

# execute the command
tar zcvf - $INFILE | openssl enc -e -a -aes-256-cbc -out $OUTFILE

if [ $? -eq 0 ]
then
    echo "${GREEN_COL}Encryption successful: ${YELLOL_COL}$INFILE -> $OUTFILE${NO_COL}"
else
    echo "${RED_COL}Encryption failed.${NO_COL}"
fi

exit 0;