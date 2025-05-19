#!/bin/bash

# update
sudo pacman -Syu # system update and upgrade
yay -Syu # do same for AUR

# troubleshooting if error "is marginal trust" run below command
# sudo pacman -Sy archlinux-keyring

# clean pacman cache
sudo paccache -r

# remove orphans
sudo pacman -Qdtq # list orphans

sudo pacman -Qtdq | sudo pacman -Rns -

# print explivcit installed packages
pacman -Qei | awk '/^Name/{name=$3} /^Installed Size/{print $4$5, name}' | sort -h

# use below to remove unwanted packages
# sudo pacman -Rns <package-name>

# remove home caches

rm -rf /home/maddy/.cache

#run reflector

sudo reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
