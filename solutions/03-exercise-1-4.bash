#!/bin/bash

get_options=$(getopt -o 'ci' -l 'print-country,invert' -- "$@")
print_country=false
invert=false
while true; do
    case $1 in
        '-c'|'--print-country') print_country=true; shift 1; continue;;
        '-i'|'--invert') invert=true; shift 1; continue;;
        *) input_file=$1; break;;
    esac
done

if [ -z $input_file ]; then
    echo "No file provided."
    exit 1
fi
if ! [ -e $input_file ]; then
    echo "File does not exist."
    exit 2
fi

if ! $invert; then
    selected_line=$(tail -n +2 $input_file | sort -n -t',' -k3 | tail -n1)
else
    selected_line=$(tail -n +2 $input_file | sort -n -t',' -k3 | head -n1)
fi
largest_city=$(echo $selected_line | cut -d',' -f1)
largest_number=$(echo $selected_line | cut -d',' -f3)

if $print_country; then
    largest_country=$(echo $selected_line | cut -d',' -f2)
    echo "The largest city ever is $largest_city in $largest_country with $largest_number inhabitants."
else
    echo "The largest city ever is $largest_city with $largest_number inhabitants."
fi
