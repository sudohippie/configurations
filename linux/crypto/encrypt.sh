#!/bin/sh
tar zcvf - $1 | openssl enc -e -a -aes-256-cbc -out $2