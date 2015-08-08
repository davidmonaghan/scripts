#! /bin/bash
# Script to clean /boot of unused Linux Kernels
sudo dpkg -l linux-{image,headers}-"[0-9]*" | awk '/^ii/{ print $2}' | grep -v -e `uname -r | cut -f1,2 -d"-"` | grep -e '[0-9]' | xargs sudo apt-get -y purge
sudo apt-get update && sudo apt-get upgrade -y
