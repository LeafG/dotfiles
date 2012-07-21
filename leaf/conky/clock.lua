--[[
Air Clock by Alison Pitt (2009)

This clock is designed to look like KDE 4.3's "Air" clock, but from inside Conky.

You can adjust the clock's radius and placement, as well as the size and offset of the drop shadow. You can also choose whether to display the seconds hand. This clock updates every time Conky does, so if you want to show seconds, it is recommended that you set update_interval to no more than 0.5s. If you turn off seconds, you can set the update_interval to as long as 30s.  The settings are in the "Settings" section, starting at Line 21.

Call this script in Conky using the following before TEXT (assuming you save this script to ~/scripts/clock.lua):
	lua_load ~/scripts/clock.lua
	lua_draw_hook_pre draw_clock
]]

require 'cairo'
function conky_draw_clock()
	if conky_window==nil then return end
	local w=conky_window.width
	local h=conky_window.height
	local cs=cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, w, h)
	cr=cairo_create(cs)
			
	-- Settings
	
		-- What radius should the clock face (not including border) be, in pixels?
		
		local clock_r=60
	
		-- x and y coordinates, relative to the top left corner of Conky, in pixels
		
		local xc=w/2
		local yc=h/2
	
		-- Extent of the shadow, in pixels
		
		shadow_width=5
		
		-- x and y offsets of the drop shadow, relative to the centre of the clock face, in pixels. Can be positive (downward) or negative (upward)
		
		shadow_xoffset=1
		shadow_yoffset=1
		
		-- Do you want to show the second hand? Use this if you use a Conky update_interval > 1s. Can be true or false.
		
		show_seconds=true
	
	-- Grab time
	
	local hours=os.date("%I")
	local mins=os.date("%M")
	local secs=os.date("%S")
	
	secs_arc=(2*math.pi/60)*secs
	mins_arc=(2*math.pi/60)*mins
	hours_arc=(2*math.pi/12)*hours+mins_arc/12
	
	-- Drop shadow
--[[	
	local ds_pat=cairo_pattern_create_radial(xc+shadow_xoffset,yc+shadow_yoffset,clock_r*1.25,xc+shadow_xoffset,yc+shadow_yoffset,clock_r*1.25+shadow_width)
	cairo_pattern_add_color_stop_rgba(ds_pat,0,0,0,0,0.2)
	cairo_pattern_add_color_stop_rgba(ds_pat,1,0,0,0,0)
	
	cairo_move_to(cr,0,0)
	cairo_line_to(cr,w,0)
	cairo_line_to(cr,w,h)
	cairo_line_to(cr,0,h)
	cairo_new_sub_path(cr)
	cairo_arc(cr,xc,yc,clock_r*1.25,0,2*math.pi)
	cairo_set_source(cr,ds_pat)
	cairo_set_fill_rule(cr,CAIRO_FILL_RULE_EVEN_ODD)
	cairo_fill(cr)
]]
--[[	
	
	-- Glassy border (should be commented for topaz background image)
	
	cairo_arc(cr,xc,yc,clock_r*1.25,0,2*math.pi)
	cairo_set_source_rgba(cr,0.5,0.5,0.5,0.2)
	cairo_set_line_width(cr,1)
	cairo_stroke(cr)
	
	local border_pat=cairo_pattern_create_linear(xc,yc-clock_r*1.25,xc,yc+clock_r*1.25)
	
	cairo_pattern_add_color_stop_rgba(border_pat,0,1,1,1,0.7)
	cairo_pattern_add_color_stop_rgba(border_pat,0.3,1,1,1,0)
	cairo_pattern_add_color_stop_rgba(border_pat,0.5,1,1,1,0)
	cairo_pattern_add_color_stop_rgba(border_pat,0.7,1,1,1,0)
	cairo_pattern_add_color_stop_rgba(border_pat,1,1,1,1,0.7)
	cairo_set_source(cr,border_pat)
	cairo_arc(cr,xc,yc,clock_r*1.125,0,2*math.pi)
	cairo_close_path(cr)
	cairo_set_line_width(cr,clock_r*0.25)
	cairo_stroke(cr)
]]
	
--[[	
	-- Set clock face
	
	cairo_arc(cr,xc,yc,clock_r,0,2*math.pi)
	cairo_close_path(cr)
	
	local face_pat=cairo_pattern_create_radial(xc,yc-clock_r*0.75,0,xc,yc,clock_r)
	
	cairo_pattern_add_color_stop_rgba(face_pat,0,1,1,1,0.9)
	cairo_pattern_add_color_stop_rgba(face_pat,0.5,1,1,1,0.9)
	cairo_pattern_add_color_stop_rgba(face_pat,1,0.9,0.9,0.9,0.9)
	cairo_set_source(cr,face_pat)
	cairo_fill_preserve(cr)
	cairo_set_source_rgba(cr,0.5,0.5,0.5,0.2)
	cairo_set_line_width(cr, 1)
	cairo_stroke (cr)
]]

	-- Draw hour hand
	
	xh=xc+1.1*clock_r*math.sin(hours_arc)
	yh=yc-1.1*clock_r*math.cos(hours_arc)
	cairo_move_to(cr,xc,yc)
	cairo_line_to(cr,xh,yh)
	
	cairo_set_line_cap(cr,CAIRO_LINE_CAP_ROUND)
	cairo_set_line_width(cr,5)
	cairo_set_source_rgba(cr, 0.8, 255.0, 0.0, 0.8)
	cairo_stroke(cr)
	
	-- Draw minute hand
	
	xm=xc+1.4*clock_r*math.sin(mins_arc)
	ym=yc-1.4*clock_r*math.cos(mins_arc)
	cairo_move_to(cr,xc,yc)
	cairo_line_to(cr,xm,ym)
	
	cairo_set_line_width(cr,3)
	cairo_stroke(cr)
	
	-- Draw seconds hand
	
	if show_seconds then
		xs=xc+1.4*clock_r*math.sin(secs_arc)
		ys=yc-1.4*clock_r*math.cos(secs_arc)
		cairo_move_to(cr,xc,yc)
		cairo_line_to(cr,xs,ys)
	
		cairo_set_line_width(cr,1)
		cairo_set_source_rgba(cr, 1.0, 0.0, 0.0, 1.0)
		cairo_stroke(cr)
	end
end
