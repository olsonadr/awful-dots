#/bin/bash

# Update
sudo dnf update

# Wifi Support
sudo dnf install -y http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y akmods "kernel-devel-uname-r == $(uname -r)" deja-dup broadcom-wl
sudo akmods

# Programs

exit 0
