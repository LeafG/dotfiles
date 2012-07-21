#!/bin/bash

if pgrep -f "conky -c /home/leaf/conky/.conkyrc_analog1"
then
 pkill -f "conky -c /home/leaf/conky/.conkyrc_analog1"
 touch ~/Desktop/u.txt; rm ~/Desktop/u.txt

else
 conky -c /home/leaf/conky/.conkyrc_analog1
fi
