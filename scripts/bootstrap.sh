#!/bin/bash

# Sources
scripts_path="."
source $scripts_path/paths
source $scripts_path/functions


# Set root passwd
get_bool_in "Set new root password? (y/n) " result
if [ "$result" == "y" ]
then
    sudo -i passwd
fi


# Update
sudo dnf update


# Wifi Support
get_bool_in "Wi-fi support for mac? (y/n) " result
if [ "$result" == "y" ]
then
    sudo dnf install -y http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && sudo dnf install -y akmods "kernel-devel-uname-r == $(uname -r)" deja-dup broadcom-wl && sudo akmods
fi


# Programs
source $lists_path/dnf


# Extensions
get_bool_in "Install Gnome extensions? (y/n) " result
if [ "$result" == "y" ]
then
    input="$lists_path/extension-ids"

    while IFS= read -r var
    do
	$installer_path/gnome-shell-extension-installer --yes $var
    done < "$input"
fi


# Terminal Theme
bash -c  "$(wget -qO- https://git.io/vQgMr)" <<< 73


# Vim Plugins
git clone https://github.com/VundleVim/Vundle.vim.git /home/olsonadr/.vim/bundle/Vundle.vim
git clone https://github.com/Valloric/YouCompleteMe.git /home/olsonadr/.vim/bundle/YouCompleteMe
git clone https://github.com/drewtempelmeyer/palenight.vim.git /home/olsonadr/.vim/bundle/palenight.vim
git clone https://github.com/itchyny/lightline.vim /home/olsonadr/.vim/bundle/lightline.vim

vim +PluginInstall +qall
$HOME/.vim/bundle/YouCompleteMe/install.py --clang-completer

# Reboot?
get_bool_in "Reboot system? (y/n) " result
if [ "$result" == "y" ]
then
    sudo reboot
fi


exit 0
