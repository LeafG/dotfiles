  #! /bin/sh
   # written by: jjgomera
    
   #str='echo '\033[01;32m29''
    
   # replace the 4 "cal |" with "cal -m |" to have the week start on Monday
    
   DATE='date | awk -F" " '{print $3}''
    
   case "$1" in
   mes)
   cal | head -n1
   ;;
   semana)
   cal | head -n2 | tail -n1
   ;;
   pasado)
   cal | grep -v '[a-zA-Z]' | grep '[0-9]' | awk -F$DATE ' BEGIN {i=0}
   ($1 == $0 && i==0) {print $1}($1 != $0 && i==0){i=i+1;print $1}';
   ;;
   hoy)
   echo $DATE;
   ;;
   futuro)
   cal | grep -v '[a-zA-Z]' | grep '[0-9]' | awk -F$DATE ' BEGIN {i=1}
   (i==0) {print $0}($1 != $0 && i==1){i=i-1;print $2}';
   ;;
   esac
