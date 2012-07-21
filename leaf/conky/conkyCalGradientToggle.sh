# Filename:      conkytoggle.sh
# Purpose:       toggle conky on/off from menu
# Authors:       Kerry and anticapitalista for antiX
# Latest change: Sun April 13, 2008.
#######################################################

#!/bin/sh

if pgrep -f "conky -c /home/leaf/conky/.conkyrc_cal_gradient"
then
 pkill -f "conky -c /home/leaf/conky/.conkyrc_cal_gradient"
 touch ~/Desktop/u.txt; rm ~/Desktop/u.txt

else
 conky -c /home/leaf/conky/.conkyrc_cal_gradient
fi
