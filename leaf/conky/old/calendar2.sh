#!/bin/bash
# calendar.sh
# copyright 2011 by Mobilediesel
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.

# m="m" # uncomment this line for starting the week on Monday instead of Sunday.
dates=$(remind -s | awk -F"[ /]+" '{if ( $3!=strftime( "%d" ) ) {DAYS=DAYS $3+0"|"}} END{sub("\\|$","",DAYS);printf DAYS}')
cal -3$m | awk -v DAYS=${dates} '{
{if ( substr($0,1,20)!~/^ *$/ )
{PREV=substr($0,1,20)}}
{if ( NR==3 )
{NEXT=substr($0,45,20)} {sub(/^ */," ",NEXT)}}
{if ( NR==1 )
MONTH=substr($0,23,20)}
{if ( NR==2 )
DOW=substr($0,23,20)}
{if ( substr($0,23,20)!~/^ *$/ && NR!=1 && NR!=2 )
{tmp=substr($0,23,20);sub("^ +1\\>"," 1",tmp);sub(/[ ]+$/,"",tmp)
{if ( length(tmp)==20 || NR==3 )
CAL=CAL tmp"\n"
else
CAL=CAL tmp" "}}}}
END{
{gsub("\\<("DAYS")\\>","${color green}&${color 99ccff}",CAL)}
{sub("\\<"strftime( "%-d" )"\\>","${color white}&${color 99ccff}",CAL)}
sub(/[ ]+$/," ",PREV)
{if ( length(PREV)==20 )
PREV=PREV"\n"}
print "${color grey}"MONTH"\n${color 808080}"DOW"\n${color grey}"PREV"${color 99ccff}"CAL"${color grey}"NEXT
}'
