#!/bin/bash

input_file=$1
if [ -z $input_file ]; then
    echo "No file provided."
    exit 1
fi
if ! [ -e $input_file ]; then
    echo "File does not exist."
    exit 2
fi

selected_line=$(tail -n +2 $input_file | sort -n -t',' -k3 | tail -n1)
largest_city=$(echo $selected_line | cut -d',' -f1)
largest_number=$(echo $selected_line | cut -d',' -f3)

echo "The largest city ever is $largest_city with $largest_number inhabitants."
