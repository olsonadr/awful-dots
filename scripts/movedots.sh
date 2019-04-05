#!/bin/bash

# Sources
scripts_path="."
source $scripts_path/paths

# Move home stuff (dotfiles)
sudo cp -r -v -f $dots_path/home/.* /home/olsonadr/

exit 0
