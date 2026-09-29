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

input_file=$6
check_input $input_file

grep $1 $input_file > my_lines.txt
for pattern in $2 $3 $4 $5; do
    grep $pattern $input_file >> my_lines.txt
done

# Also:
# echo "" > my_lines.txt
# for pattern in $1 ...
