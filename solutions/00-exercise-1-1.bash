#!/bin/bash

input_file=$1

tail -n +2 $input_file | cut -d',' -f3 | sort -n | tail -n1

# Also:
# tail -n +2 $input_file | sort -n -t',' -k3 | tail -n1 | cut -d',' -f3

# Also:
# grep -v '^#' $input_file | cut -d',' -f3 | sort -n | tail -n1

# No good:
# tail -n 5 $input_file | cut -d',' -f3 | sort -n | tail -n1
