#!/bin/sh
openssl enc -d -a -aes-256-cbc -in $1 | tar zxvf -