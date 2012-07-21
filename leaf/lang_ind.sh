#!/bin/sh

#xkblayout-state set +1
#ind=$(xkblayout-state print %s)

#if [ "$ind" == "il" ]; then
#	echo -n "HE"
#else
#	echo -n "$ind"
#fi

if [ `setxkbmap -print | grep xkb_symbols | awk '{print $4}' | awk -F"+" '{print $2}'` = us ] ;then 
   setxkbmap il ; 
   echo "HE"; 
else 
   setxkbmap us ; 
   echo -n "EN"; 
fi

