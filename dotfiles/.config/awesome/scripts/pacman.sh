#!/bin/bash

if [ "$1" == "check" ]; then
    # Update the package list and check for updates
    sudo pacman -Sy > /dev/null 2>&1
    updates=$(pacman -Qu | wc -l)
    echo $updates
else
    # Update the package list, upgrade packages, and clean the package cache
    sudo pacman -Syu --noconfirm
    sudo pacman -Scc --noconfirm
fi