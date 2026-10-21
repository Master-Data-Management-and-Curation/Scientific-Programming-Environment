#!/bin/bash

check_input() {
    local file_to_check=$1
    if [ -z $file_to_check ]; then
        echo "No file provided."
        exit 1
    fi
    if ! [ -e $file_to_check ]; then
        echo "File does not exist."
        exit 2
    fi
}

input_file=$1
check_input $input_file
shift 1

if [ -z $1 ]; then
    echo "No pattern provided"
    exit 3
fi
grep $1 $input_file > my_lines.txt
shift 1
for pattern in "$@"; do
    if [ -z $pattern ]; then
        break
    fi
    grep $pattern $input_file >> my_lines.txt
done

