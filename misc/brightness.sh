#!/bin/bash

if [ "$1" != "" ] && [ "$2" != "" ]
then
    declare -i curr=$(sudo cat /sys/class/backlight/gmux_backlight/brightness)
    declare -i max=$(sudo cat /sys/class/backlight/gmux_backlight/max_brightness)
    declare -i min=50

    if [ "$1" == "inc" ] ; then
	curr=$(($curr+$2))
    elif [ "$1" == "dec" ] ; then
	curr=$(($curr-$2))
    elif [ "$1" == "set" ] ; then
	curr=$2
    fi

    if [ "$curr" -le "$min" ] ; then
	curr=$min
    elif [ "$curr" -ge "$max" ] ; then
	curr=$max
    fi

    sudo bash -c "echo $curr > /sys/class/backlight/gmux_backlight/brightness"
fi

exit 0
