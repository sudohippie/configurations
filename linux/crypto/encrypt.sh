#!/bin/sh

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
NO_COL="\033[0m"

build_output_file(){
    BN=$(basename $1)
    FILE="${BN}.${curr_time}.encrypt"
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
    curr_time=$(date +%Y%m%d%H%M%S)
    delete_flag=false

    # check arguments
    if [ "$#" -eq 1 ]
    then
        if [ $1 = "-d" ]
        then
            print_error "Invalid flag argument(s). Flag must be followed by one or more arguments"
            exit 1;
        fi

        INFILE="$1"
        OUTFILE=$(build_output_file $1)

    elif [ "$#" -eq 2 ]
    then
        # if first is -d, set flag
        if [ "$1" = "-d" ]
        then
            delete_flag=true

            INFILE="$2"
            OUTFILE=$(build_output_file $2)
        else
            # else, represents input and output files
            INFILE="$1"
            OUTFILE="$2"
        fi
    elif [ "$#" -eq 3 ]
    then
        # first must be -d, else exception
        if [ "$1" != "-d" ]
        then
            print_error "Invalid flag argument(s): $1."
            exit 1;
        fi

        # remaining, represent input output files
        delete_flag=true

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

        if [ ${delete_flag} = true ]
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

    UNSET curr_time
    UNSET delete_flag
}

main "$@"

UNSET RED
UNSET YELLOW
UNSET GREEN
UNSET NO_COL