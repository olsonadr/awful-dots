#!/usr/bin/env python
import sys
import subprocess
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('scaling_factor', type=int)
args = parser.parse_args()
scaling_factor = args.scaling_factor

def call(command):
      return subprocess.call(command, shell=True)

if not scaling_factor > 0:
    sys.stderr.write('scaling_factor must be postive\n')
    sys.exit(1)

# set scale-factor
call('gsettings set org.gnome.desktop.interface scaling-factor {}'.format(scaling_factor))

# set text-scale-factor
text_scaling_factor = 1 - (scaling_factor - 1) * 0.06
call('gsettings set org.gnome.desktop.interface text-scaling-factor {}'.format(text_scaling_factor))

# set dpi with xrandr (for qt apps on X11)
dpi = 100 * scaling_factor
call('xrandr --dpi {}'.format(dpi))
