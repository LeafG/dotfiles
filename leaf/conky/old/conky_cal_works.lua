-- Conky Lua scripting example
--
-- Copyright (c) 2009 Cesare Tirabassi, all rights reserved.
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- Keep track of time to avoid redoing all the computations every cycle
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

   -- Compute what day it was the first of the month (0=Monday)
   first_day = wday - 2 - (day-1) % 7
   if first_day < 0 then first_day = first_day + 7 end

   -- Format and print header
   header = Month[month] .. " " .. year
   result = string.rep(" ", (20-string.len(header))/2) .. header ..
            "\nMo Tu We Th Fr Sa Su\n" .. string.rep("   ", first_day)

   -- Print all days in right order (week starts on Monday)
   count=first_day
   for i=1,day_per_month[month],1 do
       if i<10 then
       	  result = result .. " "
       end
       if i == day then
       	  result = result .. "${color FF0000}"
       end
       result = result .. i
       if i == day then
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