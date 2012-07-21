#!/bin/bash

if pgrep -f "conky -c /home/leaf/conky/.conkyrc_lang"
then
 pkill -f "conky -c /home/leaf/conky/.conkyrc_lang"
 conky -c /home/leaf/conky/.conkyrc_lang
else
 conky -c /home/leaf/conky/.conkyrc_lang
fi
