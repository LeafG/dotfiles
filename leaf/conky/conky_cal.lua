-- Conky Lua scripting example
--
-- Copyright (c) 2009 Cesare Tirabassi, all rights reserved.
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- Keep track of time to avoid redoing all the computations every cycle
-- --------------------------------------------------------------------
-- From Lua Reference 2012 March
-- os.date ([format [, time]])
-- 
-- Returns a string or a table containing date and time, formatted according to the given string format.
-- 
-- If the time argument is present, this is the time to be formatted (see the os.time function for a description of this value). Otherwise, date formats the current time.
-- 
-- If format starts with '!', then the date is formatted in Coordinated Universal Time. After this optional character, if format is the string "*t", then date returns a table with the following fields: year (four digits), month (1--12), day (1--31), hour (0--23), min (0--59), sec (0--61), wday (weekday, Sunday is 1), yday (day of the year), and isdst (daylight saving flag, a boolean).
-- 
-- If format is not "*t", then date returns the date as a string, formatted according to the same rules as the C function strftime.
-- 
-- When called without arguments, date returns a reasonable date and time representation that depends on the host system and on the current locale (that is, os.date() is equivalent to os.date("%c")). 
-- --------------------------------------------------------------------
c_timer = 0

-- Print a calendar
function conky_cal()

 if c_timer == 0 then

   -- Some useful arrays
   day_per_month = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
   Month = { "January", "February", "March", "April", "May", "June",
   	     "July", "August", "September", "October", "November", "December" }

   -- Retrieve current date
   dtable = os.date("*t")
   year = dtable.year
   month = dtable.month
   day = dtable.day
   wday = dtable.wday

   -- Adjust number of days for February if it is a leap year
   if month == 2 then
      if (year % 4 == 0) and (year % 100 ~= 0) or (year % 400 == 0) then
      	 day_per_month[2] = day_per_month[2]+1
      end
   end

   -- Compute what day it was the first of the month (0=Sunday)
   first_day = wday - 1 - (day-1) % 7
   if first_day < 0 then first_day = first_day + 7 end

   -- Compute what day it was the first weekend date of the month
   first_weekend = (7 - first_day) % 7

   -- Format and print header
   header = Month[month] .. " " .. year
--   header2 = ${color #FFDC00}.."\nSu Mo Tu We Th Fr Sa\n"${color}
   result = string.rep(" ", (20-string.len(header))/2).."${font DejaVu:bold:size=12}${color yellow}" .. header.."${font}${color}".."\n".."${hr 1}" ..
           "${color #FFDC00}".."\nSu Mo Tu We Th Fr Sa\n".."${color}" .. string.rep("   ", first_day)

   -- Print all days in right order (week starts on Sunday)
   count=first_day
   for i=1,day_per_month[month],1 do
       if i<10 then
       	  result = result .. " "
       end
       if i == day then
       	  result = result .. "${color yellow}"
       elseif (i + first_weekend) % 7 == 0 then
       	  result = result .. "${color #A2FF01}"
       end
       result = result .. i
       if i == day then
       	  result = result .. "$color"
       elseif (i + first_weekend) % 7 == 0 then
       	  result = result .. "$color"
       end
       count=count+1
       if count==7 then
       	  result = result .. "\n"
	  count = 0
       else
       	  result = result .. " "
       end
   end
 end

 -- Update timer, reset it after an hour
 c_timer = c_timer + conky_info.update_interval
 if c_timer >= 3600 then c_timer = 0 end

 -- And finally, return the result
 return result

end