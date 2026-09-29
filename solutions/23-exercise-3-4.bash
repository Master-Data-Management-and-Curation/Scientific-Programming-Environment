#!/bin/bash

accept_only() {
    local not_accepted=true
    local choices="$@"
    while $not_accepted; do
        read -p "Input choice [$choices] (repeats until valid): " choice
        for accepted_choice in "$@"; do
            if [ $choice == $accepted_choice ]; then
                not_accepted=false
                break
            fi
        done
    done
    echo $choice
}

echo "You find yourself in a dark forest, up ahead you see a fork in the way. Do you go right or left?"
choice=$(accept_only r l)
if [ $choice == 'r' ]; then
    echo "You went right..."
    sleep 2
    echo "A terrible monster attacks you! Do you fight or do you run away?"
    choice=$(accept_only f r)
    if [ $choice == 'f' ]; then
        echo "You bravely face the moster but it is too strong for you. A second before it kills you... You wake up!"
        exit 1
    elif [ $choice == 'r' ]; then
        echo "You run away but the monster is behind you, hauting you forever..."
        exit 2
    fi
elif [ $choice == 'l' ]; then
    echo "You went left..."
    sleep 2
    echo "You reach a beautiful meadow with many flowers. You see a treasure chest, do you open it or not?"
    choice=$(accept_only y n)
    if [ $choice == 'y' ]; then
        echo "You were caught by someone guarding the chest! Now you'll be a prisoner forever..."
        exit 3
    elif [ $choice == 'n' ]; then
        echo "You choose to just chill on the grass. It is nice here :)"
        exit 0
    fi
fi
