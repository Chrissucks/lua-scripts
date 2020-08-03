local voice_lines = {
    ["alexa"] = "voice_lines/alexa.wav",
    ["five kills"] = "voice_lines/all5.wav",
    ["ayyware"] = "voice_lines/ayyware.wav",
    ["bixby"] = "voice_lines/bixby.wav",
    ["cant hit me?"] = "voice_lines/canthit.wav",
    ["cortana"] = "voice_lines/cortana.wav",
    ["dead people can't talk"] = "voice_lines/deadpeople.wav",
    ["doubletap death"] = "voice_lines/doubletapnewfag.wav",
    ["nice dump"] = "voice_lines/dump.wav",
    ["fakeduck death"] = "voice_lines/fakeduck.wav",
    ["damn you got fucked"] = "voice_lines/fucked.wav",
    ["get fucked"] = "voice_lines/getfucked.wav",
    ["what hack?"] = "voice_lines/goldenhack.wav",
    ["ok google"] = "voice_lines/google.wav",
    ["highlight reel"] = "voice_lines/highlightreel.wav",
    ["bodyaim death"] = "voice_lines/hitmyhead.wav",
    ["kd"] = "voice_lines/kd.wav",
    ["lifehack bitch"] = "voice_lines/lifehackbitch.wav",
    ["matrix resolver"] = "voice_lines/matrixresolver.wav",
    ["one"] = "voice_lines/one.wav",
    ["onetap bitch"] = "voice_lines/onetapbitch.wav",
    ["oneway death"] = "voice_lines/oneway.wav",
    ["see you on fourms"] = "voice_lines/onfourms.wav",
    ["onshot death"] = "voice_lines/onshot.wav",
    ["owned by chris"] = "voice_lines/ownedbychris.wav",
    ["do you pay to go negative?"] = "voice_lines/paytogonegative.wav",
    ["poo poo head"] = "voice_lines/poopoohead.wav",
    ["refund"] = "voice_lines/refund.wav",
    ["resolve this dick"] = "voice_lines/resolvethisdick.wav",
    ["see you in court"] = "voice_lines/seeyouincourt.wav",
    ["serverside death"] = "voice_lines/serverside.wav",
    ["siri"] = "voice_lines/siri.wav",
    ["sit dog"] = "voice_lines/sitdog.wav",
    ["uid?"] = "voice_lines/uid.wav",
    ["xane"] = "voice_lines/xane.wav",
    ["xbox record that"] = "voice_lines/xboxrecordthat.wav",
    ["custom"] = "custom",
    ["random"] = "random",
    ["none"] = "none"
}

local kill_lines = 
{
    [1] = "voice_lines/alexa.wav",
    [2] = "voice_lines/all5.wav",
    [3] = "voice_lines/ayyware.wav",
    [4] = "voice_lines/bixby.wav",
    [5] = "voice_lines/canthit.wav",
    [6] = "voice_lines/cortana.wav",
    [7] = "voice_lines/deadpeople.wav",
    [8] = "voice_lines/dump.wav",
    [9] = "voice_lines/fucked.wav",
    [10] = "voice_lines/getfucked.wav",
    [11] = "voice_lines/goldenhack.wav",
    [12] = "voice_lines/google.wav",
    [13] = "voice_lines/highlightreel.wav",
    [14] = "voice_lines/kd.wav",
    [15] = "voice_lines/lifehackbitch.wav",
    [16] = "voice_lines/matrixresolver.wav",
    [17] = "voice_lines/one.wav",
    [18] = "voice_lines/onetapbitch.wav",
    [19] = "voice_lines/onfourms.wav",
    [20] = "voice_lines/ownedbychris.wav",
    [21] = "voice_lines/paytogonegative.wav",
    [22] = "voice_lines/poopoohead.wav",
    [23] = "voice_lines/refund.wav",
    [24] = "voice_lines/resolvethisdick.wav",
    [25] = "voice_lines/seeyouincourt.wav",
    [26] = "voice_lines/siri.wav",
    [27] = "voice_lines/sitdog.wav",
    [28] = "voice_lines/uid.wav",
    [29] = "voice_lines/xane.wav",
    [30] = "voice_lines/xboxrecordthat.wav"
}
local death_lines = 
{
    [1] = "voice_lines/doubletapnewfag.wav",
    [2] = "voice_lines/fakeduck.wav",
    [3] = "voice_lines/hitmyhead.wav",
    [4] = "voice_lines/oneway.wav",
    [5] = "voice_lines/onshot.wav",
    [6] = "voice_lines/serverside.wav"
}
function math.clamp(...)
    local s = {...}
    table.sort(s)
    return s[2]
end
local voice_line_names = {}
for i,z in pairs(voice_lines) do
    if i ~= "none" and i ~="custom" then
    table.insert(voice_line_names, i)
    end
end
table.sort(voice_line_names)
table.insert( voice_line_names, 1, "none" )
table.insert( voice_line_names, 2, "custom" )
table.insert( voice_line_names, 3, "random" )
local voice_enable = ui.new_checkbox("LUA","A","Adaptive killsay")
local voice_combobox = ui.new_combobox("LUA","A","Kill number", "1k", "2k", "3k", "4k", "5k", "6k", "7k", "8k", "death")
local voice_line_reference_1k = ui.new_listbox("LUA", "A", "1k", voice_line_names)
local voice_line_reference_2k = ui.new_listbox("LUA", "A", "2k", voice_line_names)
local voice_line_reference_3k = ui.new_listbox("LUA", "A", "3k", voice_line_names)
local voice_line_reference_4k = ui.new_listbox("LUA", "A", "4k", voice_line_names)
local voice_line_reference_5k = ui.new_listbox("LUA", "A", "5k", voice_line_names)
local voice_line_reference_6k = ui.new_listbox("LUA", "A", "6k", voice_line_names)
local voice_line_reference_7k = ui.new_listbox("LUA", "A", "7k", voice_line_names)
local voice_line_reference_8k = ui.new_listbox("LUA", "A", "8k", voice_line_names)
local voice_line_reference_death = ui.new_listbox("LUA", "A", "death", voice_line_names)
local function set_all_that_shit_to_false()
    ui.set_visible(voice_line_reference_1k, false)
    ui.set_visible(voice_line_reference_2k, false)
    ui.set_visible(voice_line_reference_3k, false)
    ui.set_visible(voice_line_reference_4k, false)
    ui.set_visible(voice_line_reference_5k, false)
    ui.set_visible(voice_line_reference_6k, false)
    ui.set_visible(voice_line_reference_7k, false)
    ui.set_visible(voice_line_reference_8k, false)
    ui.set_visible(voice_line_reference_death, false)
end
ui.set_visible(voice_combobox, false)
set_all_that_shit_to_false()
local ui_references =
{
    ["1k"] = voice_line_reference_1k,
    ["2k"] = voice_line_reference_2k,
    ["3k"] = voice_line_reference_3k,
    ["4k"] = voice_line_reference_4k,
    ["5k"] = voice_line_reference_5k,
    ["6k"] = voice_line_reference_6k,
    ["7k"] = voice_line_reference_7k,
    ["8k"] = voice_line_reference_8k,
    ["death"] = voice_line_reference_death,
}
local function set_visibility()
    ui.set_visible(voice_combobox, ui.get(voice_enable))
    ui.set_visible(ui_references[ui.get(voice_combobox)], ui.get(voice_enable))
end
ui.set_callback(voice_enable, set_visibility)
local function listbox_retardation()
    set_all_that_shit_to_false()
    ui.set_visible(ui_references[ui.get(voice_combobox)], ui.get(voice_enable))
end
ui.set_callback(voice_combobox, listbox_retardation)
local function overwrite_killsay(filename)
    writefile("voice_input.wav", readfile(filename))
end
local function get_duration()
    return (readfile("voice_input.wav"):len() / 22050) / 2
end
local function set_cvars(on)
    cvar.voice_loopback:set_int(on and 1 or 0)
    cvar.voice_inputfromfile:set_int(on and 1 or 0)
    client.exec(on and '+'..'voicerecord' or '-'..'voicerecord')
end
local kills_this_round = 0
local in_killsay = false
local end_time = 0
local function do_killsay(kills)
    local killsay = voice_lines[voice_line_names[ui.get(ui_references[tostring(kills).."k"])+1]]
    if killsay == "custom" then
        killsay = "voice_lines/"..tostring(kills).."k.wav"
    end
    if killsay == "random" then
        killsay = kill_lines[math.random(1,30)];
    end
    if killsay == "none" then
        return
    end
    overwrite_killsay(killsay)
    set_cvars(true)
    end_time = globals.realtime() + get_duration()
    in_killsay = true
end
local function do_deathsay()
    local killsay = voice_lines[voice_line_names[ui.get(ui_references["death"])+1]]
    if killsay == "custom" then
        killsay = "voice_lines/death.wav"
    end
    if killsay == "random" then
        killsay = death_lines[math.random(1,6)];
    end
    if killsay == "none" then
        return
    end
    overwrite_killsay(killsay)
    set_cvars(true)
    end_time = globals.realtime() + get_duration()
    in_killsay = true
end
client.set_event_callback('round_start', function()
    kills_this_round = 0
end)
client.set_event_callback('player_death', function(e)
    if e == nil or not ui.get(voice_enable) then
        return
    end

    local attacker = client.userid_to_entindex(e.attacker)
    local target = client.userid_to_entindex(e.userid)

    if attacker == nil or attacker ~= entity.get_local_player() or target == entity.get_local_player() then
        if target == entity.get_local_player() then
            kills_this_round = 0
            do_deathsay()
        end
        return
    end
    kills_this_round = math.clamp(0, kills_this_round + 1, 8)
    do_killsay(kills_this_round)
end)
client.set_event_callback('paint_ui', function()
    if in_killsay then
        if globals.realtime() >= end_time then
            set_cvars(false)
            in_killsay = false
        end
    end
end)
client.set_event_callback("shutdown", function()
    set_cvars(false)
end)