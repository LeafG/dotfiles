# Filename:      conkytoggle.sh
# Purpose:       toggle conky on/off from menu
# Authors:       Kerry and anticapitalista for antiX
# Latest change: Sun April 13, 2008.
#######################################################

#!/bin/sh

if pidof conky | grep [0-9] > /dev/null
then
 killall conky

 touch ~/Desktop/u.txt; rm ~/Desktop/u.txt

else
 conky
fi
