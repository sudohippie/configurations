#!/bin/sh

CURR_TIME=$(date +%Y%m%d%H%M%S)

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
NO_COL="\033[0m"

DELETE_FLAG="-d"

build_output_file(){
    BN=$(basename $1)
    FILE="${BN}.${CURR_TIME}.encrypt"
    echo "${FILE}"
}

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
    should_delete_file=false

    # check arguments
    if [ "$#" -eq 1 ]
    then
        if [ $1 = ${DELETE_FLAG} ]
        then
            print_error "Invalid flag argument(s). Flag must be followed by one or more arguments"
            exit 1;
        fi

        INFILE="$1"
        OUTFILE=$(build_output_file $1)

    elif [ "$#" -eq 2 ]
    then
        # if first is delete flag, should delete file
        if [ "$1" = ${DELETE_FLAG} ]
        then
            should_delete_file=true

            INFILE="$2"
            OUTFILE=$(build_output_file $2)
        else
            # else, represents input and output files
            INFILE="$1"
            OUTFILE="$2"
        fi
    elif [ "$#" -eq 3 ]
    then
        # first must be delete flag, else exception
        if [ "$1" != ${DELETE_FLAG} ]
        then
            print_error "Invalid flag argument(s): $1."
            exit 1;
        fi

        # remaining, represent input output files
        should_delete_file=true

        INFILE="$2"
        OUTFILE="$3"
    else
        print_error "Invalid argument(s). Input file is required, output file is optional."
        exit 1;
    fi

    # check input and output files
    if [ ! -e ${INFILE} ]
    then
        print_error "Invalid argument. Input file does not exist."
        exit 1;
    fi

    if [ -e ${OUTFILE} ]
    then
        print_error "Invalid argument. Output file exists: ${OUTFILE}. For safety, it will not be overwritten."
        exit 1;
    fi

    # execute the command
    replace="s/^.*${BN}/${BN}/" # tar preserves complete path, this changes it.
    tar -zcvf - --transform=${replace} --show-transformed ${INFILE} | openssl enc -e -a -aes-256-cbc -out ${OUTFILE}

    if [ $? -eq 0 ]
    then
        print_info "Encryption successful: ${INFILE} -> ${OUTFILE}"

        if [ ${should_delete_file} = true ]
        then
            rm -rfi ${INFILE}

            if [ $? -eq 0 ] && [ ! -e ${INFILE} ]
            then
                print_warn "File DELETED: ${INFILE}"
            else
                print_error "File NOT-DELETED: ${INFILE}"
            fi
        fi
    else
        print_error "Encryption failed."
    fi

    exit 0;

    UNSET delete_flag
}

main "$@"

UNSET CURR_TIME

UNSET RED
UNSET YELLOW
UNSET GREEN
UNSET NO_COL

UNSET DELETE_FLAG
