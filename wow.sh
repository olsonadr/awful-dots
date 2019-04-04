#/bin/bash

echo
choice="0"

while [ "$choice" != "y" -a "$choice" != "n" ]
do

    read -p "Clear terminal? (y/n) " choice

    if [ "$choice" != "y" -a "$choice" != "n" ]
    then
        echo "Please input \"y\" or \"n\""
        echo
    fi

done

echo

if [ "$choice" == "y" ]
then
    clear
fi

exit 0
