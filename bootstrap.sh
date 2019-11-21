#!/bin/bash


# Git Stuff
git submodule update --init --recursive


# Sources
lists_path="./lists"
misc_path="./misc"
source $lists_path/paths
source $lists_path/functions


# Get username
input "Input your username for home dir... " user


# Generate sudoers
cat > $dots_path/sudoers  << EOF


## Custom script
Cmnd_Alias	CMDS = /home/$user/.config/autostart/startup.sh
$user	ALL=NOPASSWD: CMDS
EOF


# Get Mac Status
get_bool_in "Are you running on a macbook? (y/n) " mac


# Set root passwd
get_bool_in "Set new root password? (y/n) " result
if [ "$result" == "y" ]
then
    sudo -i passwd
fi


# Update
get_bool_in "dnf update? (y/n) " result
if [ "$result" == "y" ]
then
    sudo dnf update -y
fi


# Programs
get_bool_in "Install dnf stuff? (y/n) " result
if [ "$result" == "y" ]
then
    source $lists_path/dnf
fi


# Wifi support
if [ "$mac" == "y" ]
then
    get_bool_in "Wi-fi support for mac? (y/n) " result
    if [ "$result" == "y" ]
    then
	sudo dnf install -y http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && sudo dnf install -y akmods "kernel-devel-uname-r == $(uname -r)" deja-dup broadcom-wl && sudo akmods
	sudo dnf localinstall -y --disableexcludes=all $misc_path/wpa_supplicant-2.6-17.fc29.x86_64.rpm
	if [ $(sudo cat /etc/dnf/dnf.conf | grep -c "exclude=wpa_supplicant") = "0" ]
	then
	    cat "exclude=wpa_supplicant" | sudo tee -a "/etc/dnf/dnf.conf"
	fi
    fi
fi


# Extensions
get_bool_in "Install Gnome extensions? (y/n) " result
if [ "$result" == "y" ]
then
    input="$lists_path/extension-ids"

    while IFS= read -r var
    do
	$misc_path/extension-installer/gnome-shell-extension-installer --yes $var
    done < "$input"
fi


# Terminal Theme
get_bool_in "Install Japanesque (Gogh) terminal profile? (y/n) " result
if [ "$result" == "y" ]
then
    sudo dnf install gconf-editor
    bash -c  "$(wget -qO- https://git.io/vQgMr)" <<< 74
fi


# i3 stuff
get_bool_in "i3 stuff? (y/n) " result
if [ "$result" == "y" ]
then
    sudo $misc_path/build/gnome3-plus-i3/install.sh
    mkdir $misc_path/polybar/build
    cmake -S $misc_path/polybar -B $misc_path/polybar/build
    make -C $misc_path/polybar/build -j$(nproc)
    sudo make -C $misc_path/polybar/build install
fi


# Install libinput-gestures
get_bool_in "Install libinput gestures? (y/n) " result
if [ "$result" == "y" ]
then
    sudo dnf install xdotool wmctrl libinput libinput-devel
    sudo make -C $misc_path/libinput-gestures install
    sudo gpasswd -a $USER input
    libinput-gestures-setup autostart
    libinput-gestures-setup start
fi


# Vim Plugins
get_bool_in "Install Vim plugins? (y/n) " result
if [ "$result" == "y" ]
then
    mkdir -p ~/.vim/pack/tpope/start

    git clone https://github.com/VundleVim/Vundle.vim.git /home/$user/.vim/bundle/Vundle.vim
    git clone https://tpope.io/vim/eunuch.git /home/$user/.vim/pack/tpope/start/eunuch
    git clone https://tpope.io/vim/sensible.git /home/$user/.vim/pack/tpope/start/sensible
    git clone https://tpope.io/vim/surround.git /home/$user/.vim/pack/tpope/start/surround

    vim +PluginInstall +qall
    vim -u NONE -c "helptags eunuch/doc" -c q
    vim -u NONE -c "helptags sensible/doc" -c q
    vim -u NONE -c "helptags surround/doc" -c q
    $HOME/.vim/bundle/YouCompleteMe/install.py --clang-completer
fi


# Dotfiles
get_bool_in "Copy dotfiles? (y/n) " result
if [ "$result" == "y" ]
then
    sudo cp -r -f $dots_path/home/. /home/$user/
    sudo chown -R $user ~/.config/autostart/
    
    if [ "$mac" == "y" ]
    then
	sudo cp -r -f $dots_path/home-mac/. /home/$user/
    fi

    if [ $(sudo cat /etc/sudoers | grep -c "/home/$user/.config/autostart/startup.sh") = "0" ]
    then
        cat "$dots_path/sudoers" | sudo tee -a "/etc/sudoers"
    fi
fi


# Set dconf stuff
get_bool_in "Apply dconf settings? (y/n) " result
if [ "$result" == "y" ]
then
    read_dconfs $lists_path/dconf-stuff

    if [ "$mac" == "y" ]
    then
	read_dconfs $lists_path/dconf-stuff-mac
    fi
fi


# Grub Update
get_bool_in "Update grub.cfg (with caution)? (y/n) " result
if [ "$result" == "y" ]
then
    sudo vim /etc/default/grub -c "%s/GRUB_CMDLINE_LINUX=\"/GRUB_CMDLINE_LINUX=\"nouveau.modeset=0 acpi_backlight=none /g | wq!"
    sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
fi


# Download nVidia driver
if [ "$mac" == "y" ]
then
    get_bool_in "Download nVidia driver? (y/n) " result
    if [ "$result" == "y" ]
    then
	wget -O $misc_path/NVIDIA-Linux-x86_64-418.56.run http://us.download.nvidia.com/XFree86/Linux-x86_64/418.56/NVIDIA-Linux-x86_64-418.56.run
	chmod +x $misc_path/NVIDIA-Linux-*
    fi
fi


# Other instructions
get_bool_in "Other step instructions? (y/n) " result
if [ "$result" == "y" ]
then
    echo "nVidia:"
    echo "Boot into text-only mode. Login and navigate to this dotfiles directory and then the misc/dir. Run the nVidia installer within and hit yes to everything. If you did everything in this bootstrap, everything should work on a \"$ sudo reboot\" call."
fi


# Reboot?
get_bool_in "Reboot system? (y/n) " result
if [ "$result" == "y" ]
then
    sudo reboot
fi


exit 0
