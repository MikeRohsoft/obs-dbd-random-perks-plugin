bit = require("bit")

script_config = {
    survivor_random_perks_hotkey_id = obslua.OBS_INVALID_HOTKEY_ID,
    killer_random_perks_hotkey_id = obslua.OBS_INVALID_HOTKEY_ID,
    lastSecond = 0,
    loops = 0,
    random_perks = nil,
    trigger_reset = false,
    text_source = nil,
    asset_path = nil,
    language = 1,
    description = "Adds a \"Lua Random Perk\" source which draws an animated random perk choosing.\nCreated by Mike Rohsoft",
    languages = { 
        'English', 
        '日本語', 
        'Deutsch',
    },
}

random_perks_config = {
    name = "DbD Random Perks",
    survivor_perks = require("db/survivor_perks"),
    killer_perks = require("db/killer_perks"),
    asset_path = nil,
}

random_character_config = {
    name = "DbD Random Killer",
    killers = require("db/killers"),
    active = false,
    asset_path = nil,
}

-- Script Implementation

function survivor_random_perks(pressed)
    if pressed then 
        init_perks(true) 
    end
end

function killer_random_perks(pressed)
    if pressed then 
        init_perks(false) 
    end
end

function script_description() 
    return script_config.description 
end

function script_unload() 
    set_text("") 
end

function script_update(settings)
    script_config.text_source = obslua.obs_data_get_string(settings, "source")
    script_config.asset_path = obslua.obs_data_get_string(settings, "asset_path") .. '\\'
    local lang = obslua.obs_data_get_string(settings, "lang")
    for i = 1, 3, 1 do 
        if lang == script_config.languages[i] then 
            script_config.language = i 
        end 
    end
    if script_config.asset_path == '.' then 
        script_config.asset_path = script_path() 
    end
    random_character_config.asset_path = script_config.asset_path
    random_perks_config.asset_path = script_config.asset_path
end

function script_load(settings)
	script_config.survivor_random_perks_hotkey_id = obslua.obs_hotkey_register_frontend("survivor_random_perks.trigger", "Survivor Random Perks", survivor_random_perks)
	local hotkey_save_array = obslua.obs_data_get_array(settings, "survivor_random_perks.trigger")
	obslua.obs_hotkey_load(script_config.survivor_random_perks_hotkey_id, hotkey_save_array)
    obslua.obs_data_array_release(hotkey_save_array)
    script_config.killer_random_perks_hotkey_id = obslua.obs_hotkey_register_frontend("killer_random_perks.trigger", "Killer Random Perks", killer_random_perks)
    hotkey_save_array = obslua.obs_data_get_array(settings, "killer_random_perks.trigger")
	obslua.obs_hotkey_load(script_config.killer_random_perks_hotkey_id, hotkey_save_array)
    obslua.obs_data_array_release(hotkey_save_array)
end

function script_save(settings)
	local hotkey_save_array = obslua.obs_hotkey_save(script_config.survivor_random_perks_hotkey_id)
	obslua.obs_data_set_array(settings, "survivor_random_perks.trigger", hotkey_save_array)
    obslua.obs_data_array_release(hotkey_save_array)
	hotkey_save_array = obslua.obs_hotkey_save(script_config.killer_random_perks_hotkey_id)
	obslua.obs_data_set_array(settings, "killer_random_perks.trigger", hotkey_save_array)
    obslua.obs_data_array_release(hotkey_save_array)
end

function script_properties()
	local props = obslua.obs_properties_create()
	local p = obslua.obs_properties_add_list(props, "source", "Text Source", obslua.OBS_COMBO_TYPE_EDITABLE, obslua.OBS_COMBO_FORMAT_STRING)
	local sources = obslua.obs_enum_sources()
    if sources == nil then 
        goto release 
    end
    for _, source in ipairs(sources) do
        source_id = obslua.obs_source_get_unversioned_id(source)
        if source_id ~= "text_gdiplus" and source_id ~= "text_ft2_source" then 
            goto continue 
        end
        local name = obslua.obs_source_get_name(source)
        obslua.obs_property_list_add_string(p, name, name)
        ::continue::
    end

    ::release::
    obslua.source_list_release(sources)
    p = obslua.obs_properties_add_list(props, "lang", "Language", obslua.OBS_COMBO_TYPE_EDITABLE, obslua.OBS_COMBO_FORMAT_STRING)
    for i = 1, 3, 1 do 
        obslua.obs_property_list_add_string(p, script_config.languages[i], script_config.languages[i]) 
    end
    local default_path = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Dead by Daylight\\DeadByDaylight\\Content\\UI\\Icons"
	obslua.obs_properties_add_path(props, "asset_path", "Asset Path", obslua.OBS_PATH_DIRECTORY, nil, default_path)
    obslua.obs_properties_add_button(props, "survivor_random_perk_button", "Survivor", survivor_button_clicked)
    obslua.obs_properties_add_button(props, "killer_random_perk_button", "Killer", killer_button_clicked)
    obslua.obs_properties_add_button(props, "reset_button", "Reset", reset_button_clicked)
	return props
end

function reset_button_clicked(props, p)
	random_perks_config.trigger_reset = true
	return false
end

function killer_button_clicked(props, p)
    return init_perks(false) 
end

function survivor_button_clicked(props, p) 
    return init_perks(true) 
end

-- Source utillity functions

function perk_path(image_name) 
    if not  random_perks_config.asset_path then
        return ""
    end
    return  random_perks_config.asset_path .. "Perks/" .. image_name .. ".png" 
end

function character_path(image_name) 
    if not random_character_config.asset_path then
        return ""
    end
    return random_character_config.asset_path .. "StoreBackgrounds/" .. image_name .. ".png" 
end

function set_text(text)
    if script_config.text_source == nil then 
        return 
    end
    local source = obslua.obs_get_source_by_name(script_config.text_source)
    if source == nil then 
        return 
    end
    local settings = obslua.obs_data_create()
    obslua.obs_data_set_string(settings, "text", text)
    obslua.obs_source_update(source, settings)
    obslua.obs_data_release(settings)
    obslua.obs_source_release(source)
end

function image_source_load(image, file)
    print("loading file" ..  file)
	obslua.obs_enter_graphics()
	obslua.gs_image_file_free(image)
	obslua.obs_leave_graphics()
	obslua.gs_image_file_init(image, file)
	obslua.obs_enter_graphics()
	obslua.gs_image_file_init_texture(image)
	obslua.obs_leave_graphics()
    if not image.loaded then 
        print("failed to load texture " .. file) 
    end
end

-- Random Perks Source Implementation

function random_perk_reset(data)
    if data == nil or script_config.asset_path == nil then 
        return data 
    end
    for i = 1, 4, 1 do 
        image_source_load(data[i], perk_path("Missing")) 
    end
    return data
end

function get_random_perks_name() 
    return random_perks_config.name 
end

function random_perks_create(source, settings)
    local data = { 
        obslua.gs_image_file(), 
        obslua.gs_image_file(), 
        obslua.gs_image_file(), 
        obslua.gs_image_file(),
    }
	return random_perk_reset(data)
end

function random_perks_show(source, settings)
    set_text("")
    script_config.trigger_reset = true
end

function random_perks_hide(source, settings)
    set_text("")
end

function random_perks_get_width(data) 
    return 1040
end

function random_perks_get_height(data) 
    return 250
end

function random_perks_destroy(data)
    obslua.obs_enter_graphics()
    for i = 1, 4, 1 do 
        obslua.gs_image_file_free(data[i]) 
    end
    set_text("")
	obslua.obs_leave_graphics()
end

function random_perks_video_render(data, effect)
    if data == nil then 
        data = reset(data) 
    end
    if not data[1].texture or script_config.asset_path == nil then 
        return 
    end
    local str = nil
    local random_indexes = { 
        0, 
        0, 
        0, 
        0,
    }
    effect = obslua.obs_get_base_effect(obslua.OBS_EFFECT_DEFAULT)
    if script_config.trigger_reset then
        random_perk_reset(data)
        set_text("")
        script_config.trigger_reset = false
        script_config.loops = 0
        math.randomseed(os.time())
        for i = 1, math.random(2, 100), 1 do 
            math.random(1, i) 
        end
    end

    local perk = { 
        ONE = 1, 
        TWO = 2, 
        THREE = 3, 
        FOUR = 4,
    }
    local str = ""
    if script_config.random_perks == nil then 
        goto render 
    end

    -- perk 1
    while script_config.random_perks[random_indexes[perk.ONE]] == nil do
        random_indexes[perk.ONE] = math.random(1, #script_config.random_perks)
    end
    image_source_load(data[perk.ONE], perk_path(script_config.random_perks[random_indexes[perk.ONE]].image))

    -- perk 2
    while script_config.random_perks[random_indexes[perk.TWO]] == nil do
        random_indexes[perk.TWO] = math.random(1, #script_config.random_perks)
        if random_indexes[perk.TWO] == random_indexes[perk.ONE] then 
            random_indexes[perk.TWO] = 0 
        end
    end
    image_source_load(data[perk.TWO], perk_path(script_config.random_perks[random_indexes[perk.TWO]].image))

    -- perk 3
    while script_config.random_perks[random_indexes[perk.THREE]] == nil do
        random_indexes[perk.THREE] = math.random(1, #script_config.random_perks)
        if random_indexes[perk.THREE] == random_indexes[perk.ONE] or 
           random_indexes[perk.THREE] == random_indexes[perk.TWO] then 
            random_indexes[perk.THREE] = 0 
        end
    end
    image_source_load(data[perk.THREE], perk_path(script_config.random_perks[random_indexes[perk.THREE]].image))

    -- perk 4
    while script_config.random_perks[random_indexes[perk.FOUR]] == nil do
        random_indexes[perk.FOUR] = math.random(1, #script_config.random_perks)
        if random_indexes[perk.FOUR] == random_indexes[perk.ONE] or 
           random_indexes[perk.FOUR] == random_indexes[perk.TWO] or 
           random_indexes[perk.FOUR] == random_indexes[perk.THREE] then 
            random_indexes[perk.FOUR] = 0
        end
    end
    image_source_load(data[perk.FOUR], perk_path(script_config.random_perks[random_indexes[perk.FOUR]].image))

    script_config.loops = script_config.loops + 1
    if script_config.loops ~= 150 then 
        goto render 
    end
    if random_character_config.active and script_config.random_perks == random_perks_config.killer_perks then
        random_character_config.run = get_random_killer()
        str = random_character_config.run.lang[script_config.language] .. "\n"
    end
    

    str = str         .. script_config.random_perks[random_indexes[perk.ONE]].lang[script_config.language]
    str = str .. "\n" .. script_config.random_perks[random_indexes[perk.TWO]].lang[script_config.language]
    str = str .. "\n" .. script_config.random_perks[random_indexes[perk.THREE]].lang[script_config.language]
    str = str .. "\n" .. script_config.random_perks[random_indexes[perk.FOUR]].lang[script_config.language]
    print(str)
    set_text(str)
    -- clean up
    script_config.loops = 0
    script_config.random_perks = nil

    ::render::
    while obslua.gs_effect_loop(effect, "Draw") do
        local yOffset = 0
        for i = 1, 4, 1 do 
            obslua.obs_source_draw(data[i].texture, yOffset, 0, data[i].cx, data[i].cy, false)
            yOffset = yOffset + data[i].cy
        end
    end
    
	obslua.gs_blend_state_push()
	obslua.gs_reset_blend_state()
    obslua.gs_blend_state_pop()
end

function init_perks(b)
    if script_config.random_perks ~= nil then
        script_config.random_perks = nil
        return false
    end
    if b then
        script_config.random_perks = random_perks_config.survivor_perks
    else
        script_config.random_perks = random_perks_config.killer_perks
    end
    return false
end

obslua.obs_register_source({
    id = "lua_random_perk_source",
    output_flags = bit.bor(obslua.OBS_SOURCE_VIDEO, obslua.OBS_SOURCE_CUSTOM_DRAW, obslua.OBS_SOURCE_DO_NOT_DUPLICATE),
    video_render = random_perks_video_render,
    get_name = get_random_perks_name,
    create = random_perks_create,
    destroy = random_perks_destroy,
    show = random_perks_show,
    hide = random_perks_hide,
    get_width = random_perks_get_width,
    get_height = random_perks_get_height,
})

-- Random Killer Source Implementation

function get_random_killer()
    math.randomseed(os.time())
    return random_character_config.killers[math.random(1, #random_character_config.killers)]
end

function random_killer_render(data, effect)
    local character = nil
    local path = nil
    if not data.texture or not script_config.asset_path then 
        return 
    end
    effect = obslua.obs_get_base_effect(obslua.OBS_EFFECT_DEFAULT)
    if random_character_config.run ~= nil then
        character = random_character_config.run
        path = character_path(character.image)
        image_source_load(data, path)
        random_character_config.run = nil
    end
    while obslua.gs_effect_loop(effect, "Draw") do
        obslua.obs_source_draw(data.texture, 0, 0, data.cx, data.cy, false)
    end
    
    obslua.gs_blend_state_push()
    obslua.gs_reset_blend_state()
    obslua.gs_blend_state_pop()
end

function get_random_killer_name()
    return random_character_config.name
end

function random_killer_create(source, settings)
    random_character_config.active = false
    local data = obslua.gs_image_file()
    image_source_load(data, character_path(random_character_config.killers[#random_character_config.killers].image))
    return data
end

function random_killer_destroy(data)
    random_character_config.active = false
    obslua.obs_enter_graphics()
    obslua.gs_image_file_free(data) 
    obslua.obs_leave_graphics()
end

function random_killer_get_width(data)
    return 500
end

function random_killer_get_height(data)
    return 1040
end

function random_killer_activate(data)
    random_character_config.active = true
end

function random_killer_deactivate(data)
    random_character_config.active = false
end

obslua.obs_register_source({
    id = "lua_random_killer_source",
    output_flags = bit.bor(obslua.OBS_SOURCE_VIDEO, obslua.OBS_SOURCE_CUSTOM_DRAW, obslua.OBS_SOURCE_DO_NOT_DUPLICATE),
    video_render = random_killer_render,
    get_name = get_random_killer_name,
    create = random_killer_create,
    destroy = random_killer_destroy,
    get_width = random_killer_get_width,
    get_height = random_killer_get_height,
    activate = random_killer_activate,
    deactivate = random_killer_deactivate,
})
