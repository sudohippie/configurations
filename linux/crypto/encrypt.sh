#!/bin/bash

curr_time=$(date +%Y%m%d%H%M%S)

# check arguments
if [ "$#" -eq 1 ]
then
    INFILE="$1"
    OUTFILE="$1.$curr_time.encrypt"
elif [ "$#" -eq 2 ]
then
    INFILE="$1"
    OUTFILE="$2"
else
    >&2 echo "Invalid number of arguments. Please specify one or two argument(s) only."
    exit 1;
fi

# check input and output files
if [ ! -e $INFILE ]
then
    >&2 echo "Invalid argument. Input file does not exist."
    exit 1;
fi

if [ -e $OUTFILE ]
then
    >&2 echo "Invalid argument. Output file already exists and will not be overwritten."
    exit 1;
fi

# execute the command
tar zcvf - $INFILE | openssl enc -e -a -aes-256-cbc -out $OUTFILE

echo "Encrypted: $INFILE > $OUTFILE"
exit 0;