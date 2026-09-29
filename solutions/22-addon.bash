#!/bin/bash

exit_code=$1
if [ -z $exit_code ]; then
    echo "No exit code provided."
    exit 1
fi

case $exit_code in
    0) echo "You decided to chill.";;
    1) echo "You woke up from a terrible dream.";;
    2) echo "You are haunted forever.";;
    3) echo "You became a prisoner.";;
    *) echo "Invalid exit code provided.";;
esac
