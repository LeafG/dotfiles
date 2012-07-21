--
-- Conky Lua scripting example
--
-- Copyright (c) 2009 Brenden Matthews, all rights reserved.
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--

function components_to_colour(r, g, b)
	-- Take the RGB components r, g, b, and return an RGB integer
	return ((math.floor(r + 0.5) * 0x10000) + (math.floor(g + 0.5) * 0x100) + math.floor(b + 0.5)) % 0xffffff -- no bit shifting operator in Lua afaik
end

function colour_to_components(colour)
	-- Take the RGB components r, g, b, and return an RGB integer
	return (colour / 0x10000) % 0x100, (colour / 0x100) % 0x100, colour % 0x100
end

function conky_top_colour(value, default_colour, lower_thresh, upper_thresh)
	--[[
	This function returns a colour based on a threshold, by adding more of
	the red component and reducing the other components.  ``value'' is the
	value we're checking the thresholds against, ``default_colour'' is the
	original colour (before adjusting), and the ``lower_thresh'' and
	``upper_thresh'' parameters are the low and high values for which we
	start applying redness.
	]]
	local r, g, b = colour_to_components(default_colour)
	local colour = 0
	if value ~= nil and (value - lower_thresh) > 0 then
		if value > upper_thresh then value = upper_thresh end
		local perc = (value - lower_thresh) / (upper_thresh - lower_thresh)
		if perc > 1 then perc = 1 end
		-- add some redness, depending on where ``value'' lies within the
		-- threshhold range
		r = r + perc * (0xff - r)
		b = b - perc * b
		g = g - perc * g
	end
	colour = components_to_colour(r, g, b)

	return string.format("${color #%06x}", colour)
end

-- parses the output from top and calls the colour function
function conky_top_cpu_colour(arg)
	-- input is the top var number we want to use

	local str = conky_parse(string.format('${top name %i}$alignr${top pid %i} ${top cpu %i} ${top mem %i}', tonumber(arg), tonumber(arg), tonumber(arg), tonumber(arg)))

	local cpu = tonumber(string.match(str, '(%d+%.%d+)'))
	-- tweak the last 3 parameters to your liking
	-- my machine has 4 CPUs, so an upper thresh of 25% is appropriate
	return conky_top_colour(cpu, 0x008000, 15, 25) .. str
end

function conky_top_mem_colour(arg)
	-- input is the top var number we want to use
	local str = conky_parse(string.format('${top_mem name %i} $alignr${top_mem pid %i} ${top_mem cpu %i} ${top_mem mem %i}', tonumber(arg), tonumber(arg), tonumber(arg), tonumber(arg)))
	local mem = tonumber(string.match(str, '%d+%.%d+%s+(%d+%.%d+)'))
	-- tweak the last 3 parameters to your liking
	-- my machine has ~8GiB of ram, so an upper thresh of 15% seemed appropriate
	return conky_top_colour(mem, 0x008000, 5, 15) .. str
end

function colour_transition(start, stop, position)
	--[[
	Transition from one colour to another based on the value of
	``position'', which should be a number between 0 and 1.
	]]
	local rs, gs, bs = colour_to_components(start) -- start components
	local re, ge, be = colour_to_components(stop) -- end components
	local function tr(s, e, p)
		return e + (e - s) * p
	end
	local rr, gr, br = tr(rs, re, position), tr(gs, ge, position), tr(bs, be, position) -- result components
	return components_to_colour(rr, gr, br)
end

function get_timezone_offset()
	-- returns the number of seconds of timezone offset
	local tz = tonumber(os.date('%z'))
	local tzh = math.floor(tz / 100 + 0.5)
	local tzm = math.abs(tz) % 100 / 60.
	if tzh < 0 then tzm = -tzm end
	return (tzh + tzm) * 3600
end

function julian_to_unix(J)
	-- converts a julian date into unit time
	return (J - 2440588) * 86400
end

function get_julian_now()
	-- returns the current time in julian date format
	local now = os.time()
	return now / 86400. + 2440588
end

function calculate_sunrise_sunset(latitude, longitude)
	--[[
	This function returns the unix timestamps in the local time for sunrise and
	sunset times, according to ``latitude'' and ``longitude''.  For the
	latitude, north is positive and south is negative.  For the longitude, west
	is negative, and east is positive.  You can usually determine the lat/long
	for your location from Wikipedia or using some mapping tool.

	In my case (Calgary, AB) the lat/long are 51.045 and -114.057222

	Reference: http://en.wikipedia.org/wiki/Sunrise_equation
	]]

	-- Negate longitude, west is positive and east is negative
	longitude = -longitude

	--  Calculate current Julian Cycle
	local n = math.floor(get_julian_now() - 2451545 - 0.0009 - longitude / 360 + 0.5)

	-- Approximate Solar Noon
	local Js = 2451545 + 0.0009 + longitude / 360 + n

	-- Solar Mean Anomaly
	local M = (357.5291 + 0.98560028 * (Js - 2451545)) % 360

	-- Equation of Center
	local C = (1.9148 * math.deg(math.sin(math.rad(M)))) + (0.0200 * math.deg(math.sin(math.rad(2 * M)))) + (0.0003 * math.deg(math.sin(math.rad(3 * M))))

	-- Ecliptic Longitude
	local lam = (M + 102.9372 + C + 180) % 360

	-- Solar Transit
	local Jt = Js + (0.0053 * math.deg(math.sin(math.rad(M)))) - (0.0069 * math.deg(math.sin(math.rad(2 * lam))))

	-- Declination of the Sun
	local delta = math.deg(math.asin(math.sin(math.rad(lam)) * math.sin(math.rad(23.45))))

	-- Hour Angle
	local w = math.deg(math.acos((math.sin(math.rad(-0.83)) - math.sin(math.rad(delta)) * math.sin(math.rad(latitude))) / (math.cos(math.rad(latitude)) * math.cos(math.rad(delta)))))

	local J_set = 2451545 + 0.0009 + ((w + longitude)/360 + n + (0.0053 * math.deg(math.sin(math.rad(M)))) - (0.0069 * math.deg(math.sin(math.rad(2 * lam)))))
	local J_rise = Jt - (J_set - Jt)


	local rising_t, setting_t = julian_to_unix(J_rise), julian_to_unix(J_set)

	-- apply timezone offset
	local tz_offset = get_timezone_offset()
	rising_t = rising_t + tz_offset
	setting_t = setting_t + tz_offset

	return rising_t, setting_t
end

local last_sunrise_set_check = 0
local sunrise, sunset = 0

function conky_datey(latitude, longitude, change)
	--[[
	Returns a colour at or between day_sky and night_sky (see below) depending on the
	time of day.  You must provide the ``latitude'' and ``longitude''
	parameters for your location (see the comments for
	calculate_sunrise_sunset() above for more info).  The ``change'' parameter
	is the number of hours we want to start and have a transition, so a value
	of 1 will mean the transition starts 30 minutes before, and ends 30 minutes
	after.
	]]
	local function to_hours(t)
		return tonumber(os.date('%k', t)) + (tonumber(os.date('%M', t)) / 60) + (tonumber(os.date('%S', t)) / 3600)
	end
	if last_sunrise_set_check < os.time() - 86400 then
		sunrise, sunset = calculate_sunrise_sunset(tonumber(latitude), tonumber(longitude))
		-- convert unix times into hours
		sunrise, sunset = to_hours(sunrise), to_hours(sunset)
	end
	local day_sky = 0x6698FF -- colour to use during daytime
	local night_sky = 0x342D7E -- colour to use during nighttime
	local hour = to_hours(os.time())
	if hour > sunrise + change / 2 and hour < sunset - change / 2 then
		-- midday
		sky = day_sky
	elseif hour > sunset + change / 2 or hour < sunrise - change / 2 then
		-- midnight
		sky = night_sky
	elseif hour > sunset - change / 2 then
		-- sunset time
		sky = colour_transition(day_sky, night_sky, (hour - sunset - change / 2) / change)
	elseif hour < sunrise + change / 2 then
		-- sunrise time
		sky = colour_transition(night_sky, day_sky, (hour - sunrise - change / 2) / change)
	end
	return string.format('${color #%6x}', sky)
end
