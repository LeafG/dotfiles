#!/bin/bash

if pgrep -f "conky -c /home/leaf/conky/.conkyrc_lang"
then
 pkill -f "conky -c /home/leaf/conky/.conkyrc_lang"
 touch ~/Desktop/u.txt; rm ~/Desktop/u.txt

else
 conky -c /home/leaf/conky/.conkyrc_lang
fi
