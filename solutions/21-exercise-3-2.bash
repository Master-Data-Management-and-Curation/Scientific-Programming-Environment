#!/bin/bash

echo "You find yourself in a dark forest, up ahead you see a fork in the way. Do you go right or left? [r/l]"
read choice
if [ $choice == 'r' ]; then
    echo "You went right..."
    sleep 2
    echo "A terrible monster attacks you! Do you fight or do you run away? [f/r]"
    read choice
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
    echo "You reach a beautiful meadow with many flowers. You see a treasure chest, do you open it or not? [y/n]"
    read choice
    if [ $choice == 'y' ]; then
        echo "You were caught by someone guarding the chest! Now you'll be a prisoner forever..."
        exit 3
    elif [ $choice == 'n' ]; then
        echo "You choose to just chill on the grass. It is nice here :)"
        exit 0
    fi
fi
