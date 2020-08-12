obs = obslua;
survivor_random_perks_hotkey_id   = obs.OBS_INVALID_HOTKEY_ID;
killer_random_perks_hotkey_id   = obs.OBS_INVALID_HOTKEY_ID;
bit = require("bit");
source_def = {
    id = "lua_random_perk_source",
    output_flags = bit.bor(obs.OBS_SOURCE_VIDEO, obs.OBS_SOURCE_CUSTOM_DRAW),
};

random_perks_config = {
    lastSecond = 0,
    loops = 0,
    random_perks = nil,
    perk_count = 0,
    trigger_reset = false,
    text_source = nil,
    asset_path = nil,
};

random_perks_config.survivor_perks = {
    { image = 'iconPerks_adrenaline',                   name_en = 'Adrenaline' },
    { image = 'iconPerks_balancedLanding',              name_en = 'Balance Landing' },
    { image = 'iconPerks_bond',                         name_en = 'Bond' },
    { image = 'iconPerks_botanyKnowledge',              name_en = 'Botany Knowledge' },
    { image = 'iconPerks_calmSpirit',                   name_en = 'Calm Spirit' },

    { image = 'iconPerks_darkSense',                    name_en = 'Dark Sense' },
    { image = 'iconPerks_dejaVu',                       name_en = 'DeJaVu' },
    { image = 'iconPerks_empathy',                      name_en = 'Empathy' },
    { image = 'iconPerks_hope',                         name_en = 'Hope' },
    { image = 'iconPerks_ironWill',                     name_en = 'Iron Will' },
-- 10
    { image = 'iconPerks_kindred',                      name_en = 'Kindred' },
    { image = 'iconPerks_leader',                       name_en = 'Leader' },
    { image = 'iconPerks_lightweight',                  name_en = 'Lightweight' },
    { image = 'iconPerks_noOneLeftBehind',              name_en = 'No One Left Behind' },
    { image = 'iconPerks_plunderersInstinct',           name_en = 'Plunderers Instinct' },

    { image = 'iconPerks_premonition',                  name_en = 'Premonition' },
    { image = 'iconPerks_proveThyself',                 name_en = 'Prove Thyself' },
    { image = 'iconPerks_quickAndQuiet',                name_en = 'Quick and Quiet' },
    { image = 'iconPerks_resilience',                   name_en = 'Resilience' },
    { image = 'iconPerks_saboteur',                     name_en = 'Saboteur' },
-- 20
    { image = 'iconPerks_selfCare',                     name_en = 'Self Care' },
    { image = 'iconPerks_slipperyMeat',                 name_en = 'Slippery Meat' },
    { image = 'iconPerks_smallGame',                    name_en = 'Small Game' },
    { image = 'iconPerks_spineChill',                   name_en = 'Spine Chill' },
    { image = 'iconPerks_sprintBurst',                  name_en = 'Sprint Burst' },

    { image = 'iconPerks_streetwise',                   name_en = 'Streetwise' },
    { image = 'iconPerks_thisIsNotHappening',           name_en = 'This is not happening' },
    { image = 'iconPerks_urbanEvasion',                 name_en = 'Urban Evasion' },
    { image = 'iconPerks_wellMakeIt',                   name_en = 'We\'ll make it' },
    { image = 'Ash/iconPerks_buckleUp',                 name_en = 'Buckle Up' },
-- 30
    { image = 'Ash/iconPerks_flipFlop',                 name_en = 'Flip Flop' },
    { image = 'Ash/iconPerks_mettleOfMan',              name_en = 'Mettle of Man' },
    { image = 'DLC2/iconPerks_decisiveStrike',          name_en = 'Decisive Strike' },
    { image = 'DLC2/iconPerks_objectOfObsession',       name_en = 'Object of Obsession' },
    { image = 'DLC2/iconPerks_soleSurvivor',            name_en = 'Sole Survivor' },

    { image = 'DLC3/iconPerks_aceInTheHole',            name_en = 'Ace in the Hole' },
    { image = 'DLC3/iconPerks_openHanded',              name_en = 'Open Handed' },
    { image = 'DLC3/iconPerks_upTheAnte',               name_en = 'Up the Ante' },
    { image = 'DLC4/iconPerks_alert',                   name_en = 'Alert' },
    { image = 'DLC4/iconPerks_lithe',                   name_en = 'Lithe' },
-- 40
    { image = 'DLC4/iconPerks_technician',              name_en = 'Technician' },
    { image = 'DLC5/iconPerks_DeadHard',                name_en = 'Dead Hard' },
    { image = 'DLC5/iconPerks_NoMither',                name_en = 'No Mither' },
    { image = 'DLC5/iconPerks_WereGonnaLiveForever',    name_en = 'We\'re gonna Live forever' },
    { image = 'England/iconPerks_pharmacy',             name_en = 'Pharmacy' },

    { image = 'England/iconPerks_vigil',                name_en = 'Vigil' },
    { image = 'England/iconPerks_wakeUp',               name_en = 'wake up' },
    { image = 'Finland/iconPerks_detectivesHunch',      name_en = 'Detectives Hunch' },
    { image = 'Finland/iconPerks_stakeOut',             name_en = 'Stake Out' },
    { image = 'Finland/iconPerks_tenacity',             name_en = 'Tenacity' },
-- 50
    { image = 'Haiti/iconPerks_autodidact',             name_en = 'Autodidact' },
    { image = 'Haiti/iconPerks_deliverance',            name_en = 'Deliverence' },
    { image = 'Haiti/iconPerks_diversion',              name_en = 'Diversion' },
    { image = 'Kate/iconPerks_boilOver',                name_en = 'Boil Over' },
    { image = 'Kate/iconPerks_danceWithMe',             name_en = 'Dance with me' },

    { image = 'Kate/iconPerks_windowsOfOpportunity',    name_en = 'Windows of Opportunity' },
    { image = 'Kenya/iconPerks_aftercare',              name_en = 'Aftercare' },
    { image = 'Kenya/iconPerks_breakdown',              name_en = 'Breakdown' },
    { image = 'Kenya/iconPerks_distortion',             name_en = 'Distortion' },
    { image = 'L4D/iconPerks_borrowedTime',             name_en = 'Borrowed Time' },
-- 60
    { image = 'L4D/iconPerks_leftBehind',               name_en = 'Left Behind' },
    { image = 'L4D/iconPerks_unbreakable',              name_en = 'Unbreakable' },
    { image = 'Mali/iconPerks_headOn',                  name_en = 'Head On' },
    { image = 'Mali/iconPerks_poised',                  name_en = 'Poised' },
    { image = 'Mali/iconPerks_solidarity',              name_en = 'Solidarity' },

    { image = 'Qatar/iconPerks_babySitter',             name_en = 'Baby Sitter' },
    { image = 'Qatar/iconPerks_betterTogether',         name_en = 'Better Together' },
    { image = 'Qatar/iconPerks_fixated',                name_en = 'Fixated' },
    { image = 'Qatar/iconPerks_innerStrength',          name_en = 'Inner Strength' },
    { image = 'Qatar/iconPerks_secondWind',             name_en = 'Second Wind' },
-- 70
    { image = 'Qatar/iconPerks_camaraderie',            name_en = 'Camaraderie' },
    { image = 'Sweden/iconPerks_anyMeansNecessary',     name_en = 'Any means Necessary' },
    { image = 'Sweden/iconPerks_breakout',              name_en = 'Breakout' },
    { image = 'Sweden/iconPerks_luckyBreak',            name_en = 'Lucky Break' },
    { image = 'Ukraine/iconPerks_forThePeople',         name_en = 'For the People' },

    { image = 'Ukraine/iconPerks_offTheRecord',         name_en = 'Off the Record' },
    { image = 'Ukraine/iconPerks_redHerring',           name_en = 'Red Herring' },
    { image = 'Wales/iconPerks_bloodPact',              name_en = 'Blood Pact' },
    { image = 'Wales/iconPerks_repressedAlliance',      name_en = 'Repressed Alliance' },
    { image = 'Wales/iconPerks_soulGuard',              name_en = 'Soul Guard' },
-- 80
};
random_perks_config.survivor_perk_count = 80;

random_perks_config.killer_perks = {
    { image = 'iconPerks_agitation',                    name_en = 'Agitation' },
    { image = 'iconPerks_aNursesCalling',               name_en = 'A Nurse\'s Calling' },
    { image = 'iconPerks_bitterMurmur',                 name_en = 'Bitt4er Murmur' },
    { image = 'iconPerks_bloodhound',                   name_en = 'Bloodhound' },
    { image = 'iconPerks_brutalStrength',               name_en = 'Brutal Strength' },

    { image = 'iconPerks_deerstalker',                  name_en = 'Deerstalker' },
    { image = 'iconPerks_distressing',                  name_en = 'Distressing' },
    { image = 'iconPerks_enduring',                     name_en = 'Enduring' },
    { image = 'iconPerks_insidious',                    name_en = 'Insidious' },
    { image = 'iconPerks_ironGrasp',                    name_en = 'Iron Grasp' },
-- 10
    { image = 'iconPerks_lightborn',                    name_en = 'Lightborn' },
    { image = 'iconPerks_monstrousShrine',              name_en = 'Monstrous Shrine' },
    { image = 'iconPerks_noOneEscapesDeath',            name_en = 'No One Escapes the Death' },
    { image = 'iconPerks_predator',                     name_en = 'Predator' },
    { image = 'iconPerks_shadowborn',                   name_en = 'Shadowborn' },

    { image = 'iconPerks_sloppyButcher',                name_en = 'Sloppy Butcher' },
    { image = 'iconPerks_spiesFromTheShadows',          name_en = 'Spies from the Shadows' },
    { image = 'iconPerks_stridor',                      name_en = 'Stridor' },
    { image = 'iconPerks_thatanophobia',                name_en = 'Thatanophobia' },
    { image = 'iconPerks_tinkerer',                     name_en = 'Tinkerer' },
-- 20
    { image = 'iconPerks_underperform',                 name_en = 'Underperform' },
    { image = 'iconPerks_unnervingPresence',            name_en = 'Unnerving Presence' },
    { image = 'iconPerks_unrelenting',                  name_en = 'Unrelenting' },
    { image = 'iconPerks_whispers',                     name_en = 'Whispers' },
    { image = 'Cannibal/iconPerks_BBQAndChili',         name_en = 'BBQ and Chili' },

    { image = 'Cannibal/iconPerks_franklinsLoss',       name_en = 'Franklins Loss' },
    { image = 'Cannibal/iconPerks_knockOut',            name_en = 'Knock Out' },
    { image = 'DLC2/iconPerks_dyingLight',              name_en = 'Dying Light' },
    { image = 'DLC2/iconPerks_playWithYourFood',        name_en = 'Play with your Food' },
    { image = 'DLC2/iconPerks_saveTheBestForLast',      name_en = 'Save the best for Last' },
-- 30
    { image = 'DLC3/iconPerks_devourHope',              name_en = 'Devour Hope' },
    { image = 'DLC3/iconPerks_ruin',                    name_en = 'Ruin' },
    { image = 'DLC3/iconPerks_theThirdSeal',            name_en = 'The third Seal' },
    { image = 'DLC3/iconPerks_thrillOfTheHunt',         name_en = 'Thrill of the Hunt' },
    { image = 'DLC4/iconPerks_generatorOvercharge',     name_en = 'Generator Overcharge' },

    { image = 'DLC4/iconPerks_monitorAndAbuse',         name_en = 'Monitor and Abuse' },
    { image = 'DLC4/iconPerks_overwhelmingPresence',    name_en = 'Overhelming Presence' },
    { image = 'DLC5/iconPerks_BeastOfPrey',             name_en = 'Beast of Prey' },
    { image = 'DLC5/iconPerks_HuntressLullaby',         name_en = 'Huntress Lullaby' },
    { image = 'DLC5/iconPerks_TerritorialImperative',   name_en = 'Territorial Imperative' },
-- 40
    { image = 'England/iconPerks_bloodWarden',          name_en = 'Blood Warden' },
    { image = 'England/iconPerks_fireUp',               name_en = 'Fire Up' },
    { image = 'England/iconPerks_rememberMe',           name_en = 'Rember Me' },
    { image = 'Finland/iconPerks_hangmansTrick',        name_en = 'Hangmans Trick' },
    { image = 'Finland/iconPerks_makeYourChoice',       name_en = 'Make your Choice' },

    { image = 'Finland/iconPerks_surveillance',         name_en = 'Surveillance' },
    { image = 'Guam/iconPerks_bamboozle',               name_en = 'Bamboozle' },
    { image = 'Guam/iconPerks_coulrophobia',            name_en = 'Coulrophobia' },
    { image = 'Guam/iconPerks_popGoesTheWeasel',        name_en = 'Pop goes the Weasel' },
    { image = 'Haiti/iconPerks_hatred',                 name_en = 'Rancor' },
-- 50
    { image = 'Haiti/iconPerks_hauntedGround',          name_en = 'Haunted Ground' },
    { image = 'Haiti/iconPerks_spiritFury',             name_en = 'Spirit Fury' },
    { image = 'Kenya/iconPerks_discordance',            name_en = 'Discordance' },
    { image = 'Kenya/iconPerks_ironMaiden',             name_en = 'Iron Maiden' },
    { image = 'Kenya/iconPerks_madGrit',                name_en = 'Mad Grit' },

    { image = 'Mali/iconPerks_corruptIntervention',     name_en = 'Corrupt Intervention' },
    { image = 'Mali/iconPerks_darkDevotion',            name_en = 'Dark Devotion' },
    { image = 'Mali/iconPerks_infectiousFright',        name_en = 'Infectious Fright' },
    { image = 'Oman/iconPerks_furtiveChase',            name_en = 'Furtive Chase' },
    { image = 'Oman/iconPerks_imAllEars',               name_en = 'Im all Ears' },
-- 60
    { image = 'Oman/iconPerks_thrillingTremors',        name_en = 'Thrilling Tremors' },
    { image = 'Qatar/iconPerks_cruelConfinement',       name_en = 'Cruel Confinement' },
    { image = 'Qatar/iconPerks_mindBreaker',            name_en = 'Mind Breaker' },
    { image = 'Qatar/iconPerks_surge',                  name_en = 'Surge' },
    { image = 'Sweden/iconPerks_bloodEcho',             name_en = 'Blood Echo' },

    { image = 'Sweden/iconPerks_nemesis',               name_en = 'Nemesis' },
    { image = 'Sweden/iconPerks_zanshinTactics',        name_en = 'Zanshin Tactics' },
    { image = 'Ukraine/iconPerks_deadManSwitch',        name_en = 'Dead Man Switch' },
    { image = 'Ukraine/iconPerks_gearHead',             name_en = 'Gear Head' },
    { image = 'Ukraine/iconPerks_hexRetribution',       name_en = 'Hex: Retribution' },
-- 70
    { image = 'Wales/iconPerks_deathbound',             name_en = 'Deathound' },
    { image = 'Wales/iconPerks_forcedPenance',          name_en = 'Forced Penance' },
    { image = 'Wales/iconPerks_trailOfTorment',         name_en = 'Trail of Torment' },
};
random_perks_config.killer_perk_count = 73;

function set_text(text)
    if random_perks_config.text_source == nil then
        return;
    end
    local source = obs.obs_get_source_by_name(random_perks_config.text_source);
    if source == nil then
        return;
    end
    local settings = obs.obs_data_create();
    obs.obs_data_set_string(settings, "text", text);
    obs.obs_source_update(source, settings);
    obs.obs_data_release(settings);
    obs.obs_source_release(source);
end

function perk_path(image_name)
    return random_perks_config.asset_path .. "Perks/" .. image_name .. ".png";
end

function image_source_load(image, file)
	obs.obs_enter_graphics();
	obs.gs_image_file_free(image);
	obs.obs_leave_graphics();

	obs.gs_image_file_init(image, file);

	obs.obs_enter_graphics();
	obs.gs_image_file_init_texture(image);
	obs.obs_leave_graphics();

	if not image.loaded then
		print("failed to load texture " .. file);
	end
end

source_def.get_name = function()
	return "Lua DbD Random Perks";
end

function reset(data)
    if data ~= nil and random_perks_config.asset_path ~= nil then
	    image_source_load(data.image[1], perk_path("Missing"));
	    image_source_load(data.image[2], perk_path("Missing"));
	    image_source_load(data.image[3], perk_path("Missing"));
        image_source_load(data.image[4], perk_path("Missing"));
    end
end

source_def.create = function(source, settings)
	local data = {
        image = {
            obs.gs_image_file(),
            obs.gs_image_file(),
            obs.gs_image_file(),
            obs.gs_image_file(),
        },
    };
    reset(data);
	return data;
end

source_def.show = function(source, settings)
    random_perks_config.trigger_reset = true;
end

source_def.hide = function(source, settings)
    set_text("");
end

source_def.destroy = function(data)
	obs.obs_enter_graphics();
    obs.gs_image_file_free(data.image[1]);
	obs.gs_image_file_free(data.image[2]);
	obs.gs_image_file_free(data.image[3]);
    obs.gs_image_file_free(data.image[4]);
    random_perks_config.data = nil;
    set_text("");
	obs.obs_leave_graphics();
end

source_def.video_render = function(data, effect)
    if not data.image[1].texture or random_perks_config.asset_path == nil then
		return;
	end

    effect = obs.obs_get_base_effect(obs.OBS_EFFECT_DEFAULT);
    if random_perks_config.trigger_reset then
        reset(data);
        set_text("");
        random_perks_config.trigger_reset = false;
    end
    local random_indexes = { 0, 0, 0, 0 };

    if random_perks_config.random_perks ~= nil then
    -- perk 1
        while random_perks_config.random_perks[random_indexes[1]] == nil
        do
            random_indexes[1] = math.random(1, random_perks_config.perk_count);
        end
        image_source_load(data.image[1], perk_path(random_perks_config.random_perks[random_indexes[1]].image));
    -- perk 2
        while random_perks_config.random_perks[random_indexes[2]] == nil
        do
            random_indexes[2] = math.random(1, random_perks_config.perk_count)
            if random_indexes[2] == random_indexes[1] then 
                random_indexes[2] = 0;
            end
        end
        image_source_load(data.image[2], perk_path(random_perks_config.random_perks[random_indexes[2]].image));
    -- perk 3
        while random_perks_config.random_perks[random_indexes[3]] == nil
        do
            random_indexes[3] = math.random(1, random_perks_config.perk_count);
            if random_indexes[3] == random_indexes[1] or random_indexes[3] == random_indexes[2] then
                random_indexes[3] = 0;
            end
        end
        image_source_load(data.image[3], perk_path(random_perks_config.random_perks[random_indexes[3]].image));
    -- perk 4
        while random_perks_config.random_perks[random_indexes[4]] == nil
        do
            random_indexes[4] = math.random(1, random_perks_config.perk_count);
            if random_indexes[4] == random_indexes[1] or random_indexes[4] == random_indexes[2] or random_indexes[4] == random_indexes[3] then
                random_indexes[4] = 0;
            end
        end
        image_source_load(data.image[4], perk_path(random_perks_config.random_perks[random_indexes[4]].image));

        random_perks_config.loops = random_perks_config.loops + 1;
        if random_perks_config.loops == 50 then
            local str = random_perks_config.random_perks[random_indexes[1]].name_en;
            str = str .. "\n" ..  random_perks_config.random_perks[random_indexes[2]].name_en;
            str = str .. "\n" .. random_perks_config.random_perks[random_indexes[3]].name_en;
            str = str .. "\n" .. random_perks_config.random_perks[random_indexes[4]].name_en;
            set_text(str);
            -- clean up
            random_perks_config.loops = 0;
            random_perks_config.random_perks = nil;
        end
    end

    while obs.gs_effect_loop(effect, "Draw") do
        local yOffset = 0;
        obs.obs_source_draw(data.image[1].texture, yOffset, 0, data.image[1].cx, data.image[1].cy, false);
        yOffset = yOffset + data.image[1].cy;
        obs.obs_source_draw(data.image[2].texture, yOffset, 0, data.image[2].cx, data.image[2].cy, false);
        yOffset = yOffset + data.image[2].cy;
        obs.obs_source_draw(data.image[3].texture, yOffset, 0, data.image[3].cx, data.image[3].cy, false);
        yOffset = yOffset + data.image[3].cy;
        obs.obs_source_draw(data.image[4].texture, yOffset, 0, data.image[4].cx, data.image[4].cy, false);
    end
    
	obs.gs_blend_state_push();
	obs.gs_reset_blend_state();
    obs.gs_blend_state_pop();

end

source_def.get_width = function(data)
	return 1040;
end

source_def.get_height = function(data)
	return 250;
end

function script_description()
	return "Adds a \"Lua Random Perk\" source which draws an animated random perk choosing.\nCreated by Mike Rohsoft";
end

-- The "Survivor Random Perks" hotkey callback
function survivor_random_perks(pressed)
	if not pressed then
		return
    end
    if random_perks_config.random_perks == nil then
        random_perks_config.random_perks = random_perks_config.survivor_perks;
        random_perks_config.perk_count = random_perks_config.survivor_perk_count;
    else
        random_perks_config.random_perks = nil;
        random_perks_config.perk_count = 0;
    end
end


-- The "Killer Random Perks" hotkey callback
function killer_random_perks(pressed)
    if not pressed then
        return
    end
    if random_perks_config.random_perks == nil then
        random_perks_config.random_perks = random_perks_config.killer_perks;
        random_perks_config.perk_count = random_perks_config.killer_perk_count;
    else
        random_perks_config.random_perks = nil;
        random_perks_config.perk_count = 0;
    end
end

-- A function named script_update will be called when settings are changed
function script_update(settings)
    random_perks_config.text_source = obs.obs_data_get_string(settings, "source");
    random_perks_config.asset_path = obs.obs_data_get_string(settings, "asset_path") .. '\\';
    if random_perks_config.asset_path == '.' then
        random_perks_config.asset_path = script_path();
    end
    random_perks_config.trigger_reset = true;
end

-- A function named script_load will be called on startup
function script_load(settings)
	survivor_random_perks_hotkey_id = obs.obs_hotkey_register_frontend("survivor_random_perks.trigger", "Survivor Random Perks", survivor_random_perks);
	local hotkey_save_array = obs.obs_data_get_array(settings, "survivor_random_perks.trigger");
	obs.obs_hotkey_load(survivor_random_perks_hotkey_id, hotkey_save_array);
    obs.obs_data_array_release(hotkey_save_array);

    killer_random_perks_hotkey_id = obs.obs_hotkey_register_frontend("killer_random_perks.trigger", "Killer Random Perks", killer_random_perks);
    hotkey_save_array = obs.obs_data_get_array(settings, "killer_random_perks.trigger");
	obs.obs_hotkey_load(killer_random_perks_hotkey_id, hotkey_save_array);
    obs.obs_data_array_release(hotkey_save_array);
end

function script_unload()
    set_text("")
end

-- A function named script_save will be called when the script is saved
function script_save(settings)
	local hotkey_save_array = obs.obs_hotkey_save(survivor_random_perks_hotkey_id);
	obs.obs_data_set_array(settings, "survivor_random_perks.trigger", hotkey_save_array);
    obs.obs_data_array_release(hotkey_save_array);

	hotkey_save_array = obs.obs_hotkey_save(killer_random_perks_hotkey_id);
	obs.obs_data_set_array(settings, "killer_random_perks.trigger", hotkey_save_array);
    obs.obs_data_array_release(hotkey_save_array);
end

-- A function named script_properties defines the properties that the user
-- can change for the entire script module itself
function script_properties()
	local props = obs.obs_properties_create()
	local p = obs.obs_properties_add_list(props, "source", "Text Source", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
	local sources = obs.obs_enum_sources()
	if sources ~= nil then
		for _, source in ipairs(sources) do
			source_id = obs.obs_source_get_unversioned_id(source)
			if source_id == "text_gdiplus" or source_id == "text_ft2_source" then
				local name = obs.obs_source_get_name(source)
				obs.obs_property_list_add_string(p, name, name)
			end
		end
	end
	obs.source_list_release(sources)

	obs.obs_properties_add_text(props, "asset_path", "Asset Path", obs.OBS_TEXT_DEFAULT)
    obs.obs_properties_add_button(props, "survivor_random_perk_button", "Survivor", survivor_button_clicked)
    obs.obs_properties_add_button(props, "killer_random_perk_button", "Killer", killer_button_clicked)
    obs.obs_properties_add_button(props, "reset_button", "Reset", reset_button_clicked)

	return props
end

function reset_button_clicked(props, p)
	random_perks_config.trigger_reset = true;
	return false;
end

function killer_button_clicked(props, p)
    killer_random_perks(true);
    return false;
end

function survivor_button_clicked(props, p)
    survivor_random_perks(true);
    return false;
end

obs.obs_register_source(source_def);
