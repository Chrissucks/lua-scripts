--//cope logs by Chris and xboxlivegold

--//requirements
local ffi = require "ffi"
local gif_decoder = require 'gamesense/gif_decoder'

--//struct definition
ffi.cdef[[	
    struct cope_log 
    {
    float time;
    char log_text[100];
    char info_text[100];
    bool green;
    int image;
    };
]]

--//references
local cope_ref = ui.new_checkbox("MISC", "Miscellaneous", "cope logs")
local purchase_log_ref = ui.reference("MISC", "Miscellaneous", "Log weapon purchases")
local damage_log_ref = ui.reference("MISC", "Miscellaneous", "Log damage dealt")
local spread_log_ref = ui.reference("RAGE", "Aimbot", "Log misses due to spread")

--//because lua doesn't have one credits to thelinx off of some random lua fourm
function math.clamp(...)
    local s = {...}
    table.sort(s)
    return s[2] --fixed //thelinx
end

--//misc variables and tables
local images = {
    [1] = { 
        data = gif_decoder.load_gif(readfile("cope_res/cope.gif") or error("file cope_res/cope.gif doesn't exist")),
        gif = true },
    [2] = {
        data = gif_decoder.load_gif(readfile("cope_res/really.gif") or error("file cope_res/really.gif doesn't exist")),
        gif = true },
    [3] = {
        data = renderer.load_png(readfile("cope_res/thumbsup.png") or error("file cope_res/thumbsup.png doesn't exist"), 50, 50),
        gif = false},
    [4] = {
        data = renderer.load_png(readfile("cope_res/mulattobadass.png") or error("file cope_res/mulattobadass.png doesn't exist"), 50, 50),
        gif = false},
    [5] = {
        data = renderer.load_png(readfile("cope_res/facepalm.png") or error("file cope_res/facepalm.png doesn't exist"), 50, 50),
        gif = false},
    [6] = {
        data = renderer.load_png(readfile("cope_res/muscle.png") or error("file cope_res/muscle.png doesn't exist"), 50, 50),
        gif = false},
}
local colors = {
    red = {
        r = 247, g = 89, b = 89
    },
    green = {
        r = 89, g = 247, b = 105
    }
}
local start_time = globals.realtime()
local hitgroup_names = { "generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear" }
local weapon_to_verb = { --//credits Salvatore
    knife = 'Knifed',
    hegrenade = 'Naded',
    inferno = 'Burned'
}
local logs = {}


--//main functions
local function draw_coperectangle(x,y,w,h,r,g,b,a)
    if w >= 4 then
    renderer.rectangle(x + w - 2 ,y + 2 ,2 ,h - 4 ,r ,g ,b ,a)
    renderer.rectangle(x,y + h - 2,w,2,r,g,b,a)
    end
end

local function draw_log( pos, green, image, string, string2, time )
    local color = green and colors.green or colors.red
    local anim_time = globals.realtime() - time
    local alpha = math.clamp(0, 255 * (anim_time), 255)
    local max_width,max_height = renderer.measure_text("",string) + 10
    local max_width2,max_height2 = renderer.measure_text("",string2) + 10
    local width = 0
    local width2 = 0
    if anim_time >= 0.5 then
        width = math.clamp(0, max_width * (anim_time - 0.5), max_width)
    end
    if anim_time >= 1 then
        width2 = math.clamp(0, max_width2 * ((anim_time - 1) * 1.3 ), max_width2)
    end
    if anim_time >= 7 then
        alpha = math.abs(math.clamp(0, 255 * (anim_time -7), 255) - 255)
    end
    renderer.rectangle( 10, pos, 40, 40, color.r, color.g, color.b, alpha * 0.5 )
    renderer.rectangle( 50, pos, width, 20, color.r, color.g, color.b, alpha * 0.5 )
    renderer.rectangle( 50, pos + 2, math.clamp(0, width - 2), 16, 0, 0, 0, alpha * 0.4 )

    draw_coperectangle( 50, pos + 18, width2, 22, color.r, color.g, color.b, alpha * 0.5 )
    renderer.rectangle( 50, pos + 20, math.clamp(0, width2 - 2), 18, color.r, color.g, color.b, alpha * 0.5 )
    renderer.rectangle( 50, pos + 20, math.clamp(0, width2 - 2), 18, 0, 0, 0, alpha * 0.4 )

    renderer.text(52,pos + 3,255,255,255,alpha,"", math.clamp(1, width), string)

    renderer.text(52,pos + 23,255,255,255,alpha,"", math.clamp(1, width2), string2)
    if (image.gif) then
        image.data:draw(globals.realtime()-start_time, 12, pos + 2, 36, 36, 255, 255, 255, alpha)
    else
        renderer.texture(image.data, 12, pos + 2, 36, 36, 255, 255, 255, alpha, "f" )
    end
    
end


local function handle_logs( )
    local pos = 10
    for i=1, #logs do
        if globals.realtime( ) - logs[i].time > 8 then
            table.remove( logs, i )
            return
        end
        draw_log( pos, logs[i].green, images[logs[i].image], ffi.string(logs[i].log_text, ffi.sizeof(logs[i].log_text)), ffi.string(logs[i].info_text, ffi.sizeof(logs[i].info_text)), logs[i].time )
        pos = pos + 50
    end
end

--//callbacks
local function disable_default_logs( )
    if ui.get(cope_ref) then
        ui.set(purchase_log_ref, false)
        ui.set(damage_log_ref, false)
        ui.set(spread_log_ref, false)
    else
        ui.set(damage_log_ref, true)
        ui.set(spread_log_ref, true)
    end
end
ui.set_callback( cope_ref, disable_default_logs)

client.set_event_callback("aim_miss",function(e)

    if e == nil then
        return
    end

    if ui.get(cope_ref) then

        local ent = e.target
        local name = entity.get_player_name(ent)
        local hitnames = hitgroup_names[e.hitgroup + 1] or '?'
        local hc = math.floor(e.hit_chance)
        local reason
        local image = 1
        if e.reason == "?" then
            reason = "resolver"
            image = 2
        else
            reason = e.reason
            image = e.reason == "prediction error" and 5 or e.reason == "death" and 5 or 1
        end
        local main_log = "Missed shot due to " .. reason
        local info_log = hitnames .. " - " .. hc .. "% chance"
        print(main_log .. " (".. info_log .. ")")
        table.insert( logs, ffi.new("struct cope_log", { globals.realtime( ), main_log, info_log, false, image  }) )
    end
end)

client.set_event_callback('player_hurt', function(e)

    if e == nil then
        return
    end

    local attacker = client.userid_to_entindex(e.attacker)

    if attacker == nil or attacker ~= entity.get_local_player() then
        return
    end

    if ui.get(cope_ref) then
        local target = client.userid_to_entindex(e.userid)
        local name = entity.get_player_name(target)
        local hitnames = hitgroup_names[e.hitgroup + 1] or '?'
        local image = hitnames == "head" and 6 or e.health <= 0 and 4 or 3
        local main_log, info_log = ""
        if hitnames == "generic" then
            main_log = (weapon_to_verb[e.weapon] == nil and "Hit" or weapon_to_verb[e.weapon] ).. " " .. name .. " for " .. e.dmg_health 
            info_log = e.health .. " hp remaining"
        else
            main_log = "Hit " .. name .. " in the " .. hitnames .. " for " .. e.dmg_health 
            info_log = e.health .. " hp remaining"
        end
        print(main_log .. " (".. info_log .. ")")
        if e.weapon == "inferno" then
            return
        end
        table.insert( logs, ffi.new("struct cope_log", { globals.realtime( ), main_log, info_log, true, image  }) )
    end
end)
    
client.set_event_callback("paint_ui", function()
        handle_logs()
end)