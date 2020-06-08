local ffi = require "ffi"

ffi.cdef[[	
    struct damage_marker 
    {
	bool headshot;
	int damage;
    float x,y,z;
	float time;
    };
]]

--//because lua doesn't have one credits to thelinx off of some random lua fourm
function math.clamp(...)
    local s = {...}
    table.sort(s)
    return s[2] --fixed //thelinx
end


local damage_vector = { }

local enable = ui.new_checkbox("LUA", "B", "matrix headshot marker")
local custom_file_name = ui.new_textbox("LUA", "B", "| custom image name")
local end_pos = ui.new_slider("LUA", "B", "| end pos", 0, 50)
local custom_file_x = ui.new_slider("LUA", "B", "| custom image x", 0, 250)
local custom_file_y = ui.new_slider("LUA", "B", "| custom image y", 0, 250)


local function player_hurt( e )
    local victim = client.userid_to_entindex(e.userid)
    local attacker = client.userid_to_entindex(e.attacker)

    if attacker ~= entity.get_local_player() then
        return
    end

	local position = { entity.hitbox_position(victim, 0) }
	
	table.insert(damage_vector, ffi.new("struct damage_marker", { e.hitgroup == 1 and true or false, e.dmg_health, position[1], position[2], position[3], globals.realtime() }))
	
end

local custom_image
local placeholder = ui.new_string("cope_custom_image", "")

local function save_custom()
    ui.set(placeholder,ui.get(custom_file_name))
end
local function load_custom()
    if string.len(ui.get(custom_file_name)) == 0 and string.len(ui.get(placeholder)) >= 5 then
        ui.set(custom_file_name,ui.get(placeholder))
    end
    if readfile("matrix_res/" .. ui.get(custom_file_name)) then
        custom_image = renderer.load_png(readfile("matrix_res/" .. ui.get(custom_file_name)) or error("custom file doesn't exist"), ui.get(custom_file_x), ui.get(custom_file_y))
    end
end

local function eventthing()
    save_custom()
    load_custom()
end
client.set_event_callback("shutdown",eventthing)
client.set_event_callback("paint_ui",eventthing)


local function draw_hits()
    for i=1, #damage_vector do
        if globals.realtime( ) - damage_vector[i].time > 1 then
            table.remove( damage_vector, i )
            return
        end
        local anim_time = globals.realtime() - damage_vector[i].time
        local pos_offset = math.clamp(0, ui.get(end_pos) * (anim_time), ui.get(end_pos))
        local alpha = math.abs(math.clamp(0, 255 * (anim_time), 255) - 255)
        local wts = { renderer.world_to_screen(damage_vector[i].x, damage_vector[i].y, damage_vector[i].z) }
        if wts[1] ~= nil and wts[2] ~= nil then
            if damage_vector[i].headshot then
                renderer.texture(custom_image, wts[1] - (ui.get(custom_file_x) / 2 ), wts[2] - (ui.get(custom_file_y) / 2) - pos_offset, ui.get(custom_file_x), ui.get(custom_file_y), 255, 255, 255, alpha, "f")
            end
        end
    end
end

local function paint()

    if not ui.get(enable) then
        return
    end

    draw_hits()
	
end

client.set_event_callback("player_hurt", player_hurt)
client.set_event_callback("paint", paint)