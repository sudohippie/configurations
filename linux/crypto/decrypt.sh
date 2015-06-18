#!/bin/sh

# check arguments
if [ "$#" -eq 1 ]
then
    INFILE=$1
else
    echo "Invalid arguments. Missing input argument."
    exit 1;
fi

# check input file
if [ ! -e $INFILE ]
then
    echo "Invid argument. Input file does not exist."
    exit 1;
fi

openssl enc -d -a -aes-256-cbc -in $INFILE | tar zxvf -

echo "Decrypted: $INFILE"
exit 0