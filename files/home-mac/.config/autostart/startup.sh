#!/bin/bash

bash -c "echo XHC1 > /proc/acpi/wakeup"
bash -c "echo LID0 > /proc/acpi/wakeup"
bash -c "echo 2 > /sys/module/hid_apple/parameters/fnmode"
setpci -v -H1 -s 00:01.00 BRIDGE_CONTROL=0

exit 0
