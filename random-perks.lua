bit = require("bit");
obs = obslua;
survivor_random_perks_hotkey_id   = obs.OBS_INVALID_HOTKEY_ID;
killer_random_perks_hotkey_id   = obs.OBS_INVALID_HOTKEY_ID;

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
    language = 1,
    description = "Adds a \"Lua Random Perk\" source which draws an animated random perk choosing.\nCreated by Mike Rohsoft",
    name = "Lua DbD Random Perks",
    languages = { 'English', '日本語', 'Deutsch' },
};

function perk_path(image_name) return random_perks_config.asset_path .. "Perks/" .. image_name .. ".png" end

function set_text(text)
    if random_perks_config.text_source == nil then return end
    local source = obs.obs_get_source_by_name(random_perks_config.text_source);
    if source == nil then return end
    local settings = obs.obs_data_create();
    obs.obs_data_set_string(settings, "text", text);
    obs.obs_source_update(source, settings);
    obs.obs_data_release(settings);
    obs.obs_source_release(source);
end

function image_source_load(image, file)
	obs.obs_enter_graphics();
	obs.gs_image_file_free(image);
	obs.obs_leave_graphics();
	obs.gs_image_file_init(image, file);
	obs.obs_enter_graphics();
	obs.gs_image_file_init_texture(image);
	obs.obs_leave_graphics();
	if not image.loaded then print("failed to load texture " .. file) end
end

function reset(data)
    if data == nil or random_perks_config.asset_path == nil then return end
    for i = 1, 4, 1 do image_source_load(data[i], perk_path("Missing")) end
    return data;
end

source_def.get_name = function() return random_perks_config.name end

source_def.create = function(source, settings)
	return reset({ obs.gs_image_file(), obs.gs_image_file(), obs.gs_image_file(), obs.gs_image_file() });
end

source_def.show = function(source, settings) random_perks_config.trigger_reset = true end

source_def.hide = function(source, settings) set_text("") end

source_def.get_width = function(data) return 1040 end

source_def.get_height = function(data) return 250 end

source_def.destroy = function(data)
    obs.obs_enter_graphics();
    for i = 1, 4, 1 do obs.gs_image_file_free(data[i]) end
    random_perks_config.data = nil;
    set_text("");
	obs.obs_leave_graphics();
end

source_def.video_render = function(data, effect)
    if not data[1].texture or random_perks_config.asset_path == nil then return end
    local str = nil;
    local random_indexes = { 0, 0, 0, 0 };
    effect = obs.obs_get_base_effect(obs.OBS_EFFECT_DEFAULT);
    if random_perks_config.trigger_reset then
        reset(data);
        set_text("");
        random_perks_config.trigger_reset = false;
        random_perks_config.loops = 0;
        math.randomseed(os.time());
        for i = 1, math.random(80, 100), 1 do math.random(1, i) end
    end

    local perk = { ONE = 1, TWO = 2, THREE = 3, FOUR = 4 };
    if random_perks_config.random_perks == nil then goto render end
    -- perk 1
    while random_perks_config.random_perks[random_indexes[perk.ONE]] == nil
    do
        random_indexes[perk.ONE] = math.random(1, random_perks_config.perk_count);
    end
    image_source_load(data[perk.ONE], perk_path(random_perks_config.random_perks[random_indexes[perk.ONE]].image));

    -- perk 2
    while random_perks_config.random_perks[random_indexes[perk.TWO]] == nil
    do
        random_indexes[perk.TWO] = math.random(1, random_perks_config.perk_count)
        if random_indexes[perk.TWO] == random_indexes[perk.ONE] then random_indexes[perk.TWO] = 0 end
    end
    image_source_load(data[perk.TWO], perk_path(random_perks_config.random_perks[random_indexes[perk.TWO]].image));

    -- perk 3
    while random_perks_config.random_perks[random_indexes[perk.THREE]] == nil
    do
        random_indexes[perk.THREE] = math.random(1, random_perks_config.perk_count);
        if random_indexes[perk.THREE] == random_indexes[perk.ONE] or 
           random_indexes[perk.THREE] == random_indexes[perk.TWO] then random_indexes[perk.THREE] = 0 end
    end
    image_source_load(data[perk.THREE], perk_path(random_perks_config.random_perks[random_indexes[perk.THREE]].image));

    -- perk 4
    while random_perks_config.random_perks[random_indexes[perk.FOUR]] == nil
    do
        random_indexes[perk.FOUR] = math.random(1, random_perks_config.perk_count);
        if random_indexes[perk.FOUR] == random_indexes[perk.ONE] or 
           random_indexes[perk.FOUR] == random_indexes[perk.TWO] or 
           random_indexes[perk.FOUR] == random_indexes[perk.THREE] then random_indexes[perk.FOUR] = 0 end
    end
    image_source_load(data[perk.FOUR], perk_path(random_perks_config.random_perks[random_indexes[perk.FOUR]].image));

    random_perks_config.loops = random_perks_config.loops + 1;
    if random_perks_config.loops == 1 then set_text("") end
    if random_perks_config.loops ~= 50 then goto render end

    str =                random_perks_config.random_perks[random_indexes[perk.ONE]].lang[random_perks_config.language];
    str = str .. "\n" .. random_perks_config.random_perks[random_indexes[perk.TWO]].lang[random_perks_config.language];
    str = str .. "\n" .. random_perks_config.random_perks[random_indexes[perk.THREE]].lang[random_perks_config.language];
    str = str .. "\n" .. random_perks_config.random_perks[random_indexes[perk.FOUR]].lang[random_perks_config.language];
    print(str);
    set_text(str);

    -- clean up
    random_perks_config.loops = 0;
    random_perks_config.random_perks = nil;

    ::render::
    while obs.gs_effect_loop(effect, "Draw") do
        local yOffset = 0;
        for i = 1, 4, 1 do 
            obs.obs_source_draw(data[i].texture, yOffset, 0, data[i].cx, data[i].cy, false);
            yOffset = yOffset + data[i].cy;
        end
    end
    
	obs.gs_blend_state_push();
	obs.gs_reset_blend_state();
    obs.gs_blend_state_pop();
end

function survivor_random_perks(pressed)
    if not pressed then return end
    if random_perks_config.random_perks == nil then
        random_perks_config.random_perks = random_perks_config.survivor_perks;
        random_perks_config.perk_count = random_perks_config.survivor_perk_count;
    else
        random_perks_config.random_perks = nil;
        random_perks_config.perk_count = 0;
    end
end

function killer_random_perks(pressed)
    if not pressed then return end
    if random_perks_config.random_perks == nil then
        random_perks_config.random_perks = random_perks_config.killer_perks;
        random_perks_config.perk_count = random_perks_config.killer_perk_count;
    else
        random_perks_config.random_perks = nil;
        random_perks_config.perk_count = 0;
    end
end

function script_description() return random_perks_config.description end

function script_unload() set_text("") end

function script_update(settings)
    random_perks_config.text_source = obs.obs_data_get_string(settings, "source");
    random_perks_config.asset_path = obs.obs_data_get_string(settings, "asset_path") .. '\\';
    local lang = obs.obs_data_get_string(settings, "lang");
    for i = 1, 3, 1 do if lang == random_perks_config.languages[i] then random_perks_config.language = i end end
    if random_perks_config.asset_path == '.' then random_perks_config.asset_path = script_path() end
    random_perks_config.trigger_reset = true;
end

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

function script_save(settings)
	local hotkey_save_array = obs.obs_hotkey_save(survivor_random_perks_hotkey_id);
	obs.obs_data_set_array(settings, "survivor_random_perks.trigger", hotkey_save_array);
    obs.obs_data_array_release(hotkey_save_array);
	hotkey_save_array = obs.obs_hotkey_save(killer_random_perks_hotkey_id);
	obs.obs_data_set_array(settings, "killer_random_perks.trigger", hotkey_save_array);
    obs.obs_data_array_release(hotkey_save_array);
end

function script_properties()
	local props = obs.obs_properties_create();
	local p = obs.obs_properties_add_list(props, "source", "Text Source", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING);
	local sources = obs.obs_enum_sources();
    if sources == nil then goto release end
    for _, source in ipairs(sources) do
        source_id = obs.obs_source_get_unversioned_id(source);
        if source_id ~= "text_gdiplus" and source_id ~= "text_ft2_source" then goto continue end
        local name = obs.obs_source_get_name(source);
        obs.obs_property_list_add_string(p, name, name);
        ::continue::
    end
    ::release::
    obs.source_list_release(sources);
    p = obs.obs_properties_add_list(props, "lang", "Language", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING);
    for i = 1, 3, 1 do obs.obs_property_list_add_string(p, random_perks_config.languages[i], random_perks_config.languages[i]) end
    local default_path = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Dead by Daylight\\DeadByDaylight\\Content\\UI\\Icons";
	obs.obs_properties_add_path(props, "asset_path", "Asset Path", obs.OBS_PATH_DIRECTORY, nil, default_path);
    obs.obs_properties_add_button(props, "survivor_random_perk_button", "Survivor", survivor_button_clicked);
    obs.obs_properties_add_button(props, "killer_random_perk_button", "Killer", killer_button_clicked);
    obs.obs_properties_add_button(props, "reset_button", "Reset", reset_button_clicked);
	return props;
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

random_perks_config.survivor_perks = {
    { image = 'iconPerks_adrenaline',                   lang = { 'Adrenaline', 'アドレナリン', 'Adrenalin' } },
    { image = 'iconPerks_balancedLanding',              lang = { 'Balance Landing', 'スマートな着地', 'Ausgewogene Landung' } },
    { image = 'iconPerks_bond',                         lang = { 'Bond', '絆', 'Bindung' } },
    { image = 'iconPerks_botanyKnowledge',              lang = { 'Botany Knowledge', '植物学の知識', 'Botanisches Wissen' } },
    { image = 'iconPerks_calmSpirit',                   lang = { 'Calm Spirit', '魂の平穏', 'Seelenruhe' } },

    { image = 'iconPerks_darkSense',                    lang = { 'Dark Sense', '闇の感覚', 'Dunkle Wahrnehmung' } },
    { image = 'iconPerks_dejaVu',                       lang = { 'Déjà-Vu', 'デジャヴ', 'Déjà-Vu-Erlebnis' } },
    { image = 'iconPerks_empathy',                      lang = { 'Empathy', '共感', 'Einfühlungsvermögen' } },
    { image = 'iconPerks_hope',                         lang = { 'Hope', '希望', 'Hoffnung' } },
    { image = 'iconPerks_ironWill',                     lang = { 'Iron Will', '鋼の意思', 'Eiserner Wille' } },
-- 10
    { image = 'iconPerks_kindred',                      lang = { 'Kindred', '血族', 'Verwandt' } },
    { image = 'iconPerks_leader',                       lang = { 'Leader', 'リーダー', 'Anführer' } },
    { image = 'iconPerks_lightweight',                  lang = { 'Lightweight', '身軽', 'Leichtgewicht' } },
    { image = 'iconPerks_noOneLeftBehind',              lang = { 'No One Left Behind', '誰も見捨てはしない', 'Niemand wird Zurückgelassen' } },
    { image = 'iconPerks_plunderersInstinct',           lang = { 'Plunderers Instinct', 'コソ泥の本能', 'Plündererspürsinn' } },

    { image = 'iconPerks_premonition',                  lang = { 'Premonition', '予感', 'Vorwarnung' } },
    { image = 'iconPerks_proveThyself',                 lang = { 'Prove Thyself', '有能の証明', 'Beweise dich' } },
    { image = 'iconPerks_quickAndQuiet',                lang = { 'Quick & Quiet', '素早く静かに', 'Schnell & Leise' } },
    { image = 'iconPerks_resilience',                   lang = { 'Resilience', '逆境魂', 'Widerstandsfähigkeit' } },
    { image = 'iconPerks_saboteur',                     lang = { 'Saboteur', 'サボタージュ', 'Saboteur' } },
-- 20
    { image = 'iconPerks_selfCare',                     lang = { 'Self Care', 'セルフケア', 'Selbstfürsorge' } },
    { image = 'iconPerks_slipperyMeat',                 lang = { 'Slippery Meat', 'ツルツルとした肉体', 'Gerissenes Fleisch' } },
    { image = 'iconPerks_smallGame',                    lang = { 'Small Game', '小さな獲物', 'Niederwild' } },
    { image = 'iconPerks_spineChill',                   lang = { 'Spine Chill', '凍りつく背筋', 'Kalter Rückenschauer' } },
    { image = 'iconPerks_sprintBurst',                  lang = { 'Sprint Burst', '全力疾走', 'Sprintboost' } },

    { image = 'iconPerks_streetwise',                   lang = { 'Streetwise', '都会の生存術', 'Pfiffig' } },
    { image = 'iconPerks_thisIsNotHappening',           lang = { 'This is not happening', '痛みも気から', 'Das geschieht nicht' } },
    { image = 'iconPerks_urbanEvasion',                 lang = { 'Urban Evasion', '都会の逃走術', 'Städtische Invasion' } },
    { image = 'iconPerks_wellMakeIt',                   lang = { 'We\'ll make it', 'きっとやり遂げる', 'Wir schaffen das!' } },
    { image = 'Ash/iconPerks_buckleUp',                 lang = { 'Buckle Up', 'ベルトを締めろ！', 'Anschnallen' } },
-- 30
    { image = 'Ash/iconPerks_flipFlop',                 lang = { 'Flip Flop', 'フリップ・フロップ', 'Flip-Flop' } },
    { image = 'Ash/iconPerks_mettleOfMan',              lang = { 'Mettle of Man', '英雄の奮起', 'Der Eifer der Menschen' } },
    { image = 'DLC2/iconPerks_decisiveStrike',          lang = { 'Decisive Strike', '決死の一撃', 'Entscheidungsschlag' } },
    { image = 'DLC2/iconPerks_objectOfObsession',       lang = { 'Object of Obsession', '執念の対象', 'Objekt der Besessenheit' } },
    { image = 'DLC2/iconPerks_soleSurvivor',            lang = { 'Sole Survivor', '唯一の生存者', 'Einziger Überlebender' } },

    { image = 'DLC3/iconPerks_aceInTheHole',            lang = { 'Ace in the Hole', '最後の切り札', 'Ass im Ärmel' } },
    { image = 'DLC3/iconPerks_openHanded',              lang = { 'Open Handed', '手札公開', 'Mit offener Hand' } },
    { image = 'DLC3/iconPerks_upTheAnte',               lang = { 'Up the Ante', '賭け金のレイズ', 'Erhöhe den Einsatz' } },
    { image = 'DLC4/iconPerks_alert',                   lang = { 'Alert', '警戒', 'Wachsam' } },
    { image = 'DLC4/iconPerks_lithe',                   lang = { 'Lithe', 'しなやか', 'Flink' } },
-- 40
    { image = 'DLC4/iconPerks_technician',              lang = { 'Technician', 'テクニシャン', 'Technikerin' } },
    { image = 'DLC5/iconPerks_DeadHard',                lang = { 'Dead Hard', 'デッド・ハード', 'Hart im Nehmen' } },
    { image = 'DLC5/iconPerks_NoMither',                lang = { 'No Mither', '弱音はナシだ', 'Kein Gejammer' } },
    { image = 'DLC5/iconPerks_WereGonnaLiveForever',    lang = { 'We\'re gonna Live forever', 'ずっと一緒だ', 'Wir werden ewig Leben' } },
    { image = 'England/iconPerks_pharmacy',             lang = { 'Pharmacy', '調剤学', 'Apotheke' } },

    { image = 'England/iconPerks_vigil',                lang = { 'Vigil', '寝ずの番', 'Nachtwache' } },
    { image = 'England/iconPerks_wakeUp',               lang = { 'Wake up!', '目を覚ませ！', 'Aufwachen!' } },
    { image = 'Finland/iconPerks_detectivesHunch',      lang = { 'Detectives Hunch', '張り込み', 'Tapps Verdacht' } },
    { image = 'Finland/iconPerks_stakeOut',             lang = { 'Stake Out', '刑事の直感', 'Observierung' } },
    { image = 'Finland/iconPerks_tenacity',             lang = { 'Tenacity', '執念', 'Beharrlichkeit' } },
-- 50
    { image = 'Haiti/iconPerks_autodidact',             lang = { 'Autodidact', '独学者', 'Autodidakt' } },
    { image = 'Haiti/iconPerks_deliverance',            lang = { 'Deliverence', '解放', 'Befreiung' } },
    { image = 'Haiti/iconPerks_diversion',              lang = { 'Diversion', '陽動', 'Ablenkung' } },
    { image = 'Kate/iconPerks_boilOver',                lang = { 'Boil Over', 'ボイルオーバー', 'Wildpferd' } },
    { image = 'Kate/iconPerks_danceWithMe',             lang = { 'Dance with me', 'ダンス・ウィズ・ミー', 'Tanz mit mir' } },

    { image = 'Kate/iconPerks_windowsOfOpportunity',    lang = { 'Windows of Opportunity', 'ウィンドウズ・オブ・オポチュニティ', 'Gelegenheit nutzen' } },
    { image = 'Kenya/iconPerks_aftercare',              lang = { 'Aftercare', 'アフターケア', 'Nachsorge' } },
    { image = 'Kenya/iconPerks_breakdown',              lang = { 'Breakdown', 'ブレイクダウン', 'Zerlegen' } },
    { image = 'Kenya/iconPerks_distortion',             lang = { 'Distortion', 'ディストーション', 'Verzerrung' } },
    { image = 'L4D/iconPerks_borrowedTime',             lang = { 'Borrowed Time', '与えられた猶予', 'Geliehene Zeit' } },
-- 60
    { image = 'L4D/iconPerks_leftBehind',               lang = { 'Left Behind', '置き去りにされた者', 'Zurückgelassen' } },
    { image = 'L4D/iconPerks_unbreakable',              lang = { 'Unbreakable', '不滅', 'Unbeugsam' } },
    { image = 'Mali/iconPerks_headOn',                  lang = { 'Head On', '真っ向勝負', 'Frontal' } },
    { image = 'Mali/iconPerks_poised',                  lang = { 'Poised', '平常心', 'Selbstsicher' } },
    { image = 'Mali/iconPerks_solidarity',              lang = { 'Solidarity', '連帯感', 'Solidarität' } },

    { image = 'Qatar/iconPerks_babySitter',             lang = { 'Baby Sitter', 'ベビーシッター', 'Babysitter' } },
    { image = 'Qatar/iconPerks_betterTogether',         lang = { 'Better Together', '一緒にいよう', 'Besser Gemeinsam' } },
    { image = 'Qatar/iconPerks_fixated',                lang = { 'Fixated', '執着心', 'Fixiert' } },
    { image = 'Qatar/iconPerks_innerStrength',          lang = { 'Inner Strength', '内なる力', 'Innere Kraft' } },
    { image = 'Qatar/iconPerks_secondWind',             lang = { 'Second Wind', 'セカンドウインド', 'Aufschwung' } },
-- 70
    { image = 'Qatar/iconPerks_camaraderie',            lang = { 'Camaraderie', '仲間意識', 'Kameradschaft' } },
    { image = 'Sweden/iconPerks_anyMeansNecessary',     lang = { 'Any means Necessary', '強硬手段', 'Mit allen Mitteln' } },
    { image = 'Sweden/iconPerks_breakout',              lang = { 'Breakout', '突破', 'Ausbruch' } },
    { image = 'Sweden/iconPerks_luckyBreak',            lang = { 'Lucky Break', '怪我の功名', 'Glück gehabt' } },
    { image = 'Ukraine/iconPerks_forThePeople',         lang = { 'For the People', '人々のために', 'Für das Volk' } },

    { image = 'Ukraine/iconPerks_offTheRecord',         lang = { 'Off the Record', 'オフレコ', 'Vertraulich' } },
    { image = 'Ukraine/iconPerks_redHerring',           lang = { 'Red Herring', 'おとり', 'Ablenkungsmanöver' } },
    { image = 'Wales/iconPerks_bloodPact',              lang = { 'Blood Pact', '血の協定', 'Blutpakt' } },
    { image = 'Wales/iconPerks_repressedAlliance',      lang = { 'Repressed Alliance', '抑圧の同盟', 'Verdrängtes Bündnis' } },
    { image = 'Wales/iconPerks_soulGuard',              lang = { 'Soul Guard', 'ソウルガード', 'Seelenwächter' } },
-- 80
};
random_perks_config.survivor_perk_count = 80;

random_perks_config.killer_perks = {
    { image = 'iconPerks_agitation',                    lang = { 'Agitation', '興奮', 'Erregung' } },
    { image = 'iconPerks_aNursesCalling',               lang = { 'A Nurse\'s Calling', '看護婦の使命', 'Der Ruf einer Krankenschwester' } },
    { image = 'iconPerks_bitterMurmur',                 lang = { 'Bitter Murmur', '憎悪の囁き', 'Verbittertes Gemurmel' } },
    { image = 'iconPerks_bloodhound',                   lang = { 'Bloodhound', '血の追跡者', 'Bluthund' } },
    { image = 'iconPerks_brutalStrength',               lang = { 'Brutal Strength', '野蛮な力', 'Brutale Stärke' } },

    { image = 'iconPerks_deerstalker',                  lang = { 'Deerstalker', '忍び寄る者', 'Pirscher' } },
    { image = 'iconPerks_distressing',                  lang = { 'Distressing', '苦悶の根源', 'Verstört' } },
    { image = 'iconPerks_enduring',                     lang = { 'Enduring', '不屈', 'Beständig' } },
    { image = 'iconPerks_insidious',                    lang = { 'Insidious', '狡猾', 'Heimtückisch' } },
    { image = 'iconPerks_ironGrasp',                    lang = { 'Iron Grasp', '鋼の握力', 'Eiserner Griff' } },
-- 10
    { image = 'iconPerks_lightborn',                    lang = { 'Lightborn', '光より出でし者', 'Lichtgeborener' } },
    { image = 'iconPerks_monstrousShrine',              lang = { 'Monstrous Shrine', '異形の祭壇', 'Monströser Schrein' } },
    { image = 'iconPerks_noOneEscapesDeath',            lang = { 'Hex: No One Escapes the Death', '呪術・誰も死から逃れられない', 'Fluch: Niemand entrinnt dem Tod' } },
    { image = 'iconPerks_predator',                     lang = { 'Predator', '捕食者', 'Räuber' } },
    { image = 'iconPerks_shadowborn',                   lang = { 'Shadowborn', '闇より出でし者', 'Schattengeborener' } },

    { image = 'iconPerks_sloppyButcher',                lang = { 'Sloppy Butcher', 'ずさんな肉屋', 'Schlampiger Schlachter' } },
    { image = 'iconPerks_spiesFromTheShadows',          lang = { 'Spies from the Shadows', '影の密偵', 'Spione des Schattens' } },
    { image = 'iconPerks_stridor',                      lang = { 'Stridor', '喘鳴', 'Stridor' } },
    { image = 'iconPerks_thatanophobia',                lang = { 'Thatanophobia', '死恐怖症', 'Thanatophobia' } },
    { image = 'iconPerks_tinkerer',                     lang = { 'Tinkerer', 'ガラクタいじり', 'Tüftler' } },
-- 20
    { image = 'iconPerks_unnervingPresence',            lang = { 'Unnerving Presence', '不安の元凶', 'Zermürbende Präsenz' } },
    { image = 'iconPerks_unrelenting',                  lang = { 'Unrelenting', '無慈悲', 'Unerbittlich' } },
    { image = 'iconPerks_whispers',                     lang = { 'Whispers', '囁き', 'GeflüsterGrausame Grenzen' } },
    { image = 'Cannibal/iconPerks_BBQAndChili',         lang = { 'Barbecue & Chili', 'バーベキュー＆チリ', 'Barbecue und Chili' } },
    { image = 'Wales/iconPerks_trailOfTorment',         lang = { 'Trail of Torment', '煩悶のトレイル', 'Pfad der Folter' } },

    { image = 'Cannibal/iconPerks_franklinsLoss',       lang = { 'Franklin\'s Demise', 'フランクリンの悲劇', 'Franklins Niedergang' } },
    { image = 'Cannibal/iconPerks_knockOut',            lang = { 'Knock Out', 'ノックアウト', 'K.O.' } },
    { image = 'DLC2/iconPerks_dyingLight',              lang = { 'Dying Light', '消えゆく灯', 'Erlischendes Licht' } },
    { image = 'DLC2/iconPerks_playWithYourFood',        lang = { 'Play with your Food', '弄ばれる獲物', 'Spiele mit deinem Essen' } },
    { image = 'DLC2/iconPerks_saveTheBestForLast',      lang = { 'Save the best for Last', '最後のお楽しみ', 'Das Beste kommt zum Schluss' } },
-- 30
    { image = 'DLC3/iconPerks_devourHope',              lang = { 'Hex: Devour Hope', '呪術・貪られる希望', 'Fluch: Aufgezehrte Hoffnung' } },
    { image = 'DLC3/iconPerks_ruin',                    lang = { 'Hex: Ruin', '呪術・破滅', 'Fluch: Ruin' } },
    { image = 'DLC3/iconPerks_theThirdSeal',            lang = { 'Hex: The third Seal', '呪術・第三の封印', 'Fluch: Das dritte Siegel' } },
    { image = 'DLC3/iconPerks_thrillOfTheHunt',         lang = { 'Hex: Thrill of the Hunt', '呪術・狩りの興奮', 'Fluch: Nervenkitzel der Jagd' } },
    { image = 'DLC4/iconPerks_generatorOvercharge',     lang = { 'Generator Overcharge', 'オーバーチャージ', 'Überladen' } },

    { image = 'DLC4/iconPerks_monitorAndAbuse',         lang = { 'Monitor and Abuse', '観察＆虐待', 'Beobachten und Zuschlagen' } },
    { image = 'DLC4/iconPerks_overwhelmingPresence',    lang = { 'Overhelming Presence', '圧倒的存在感', 'Erdrückende Präsenz' } },
    { image = 'DLC5/iconPerks_BeastOfPrey',             lang = { 'Beast of Prey', '猛獣', 'Raubtier' } },
    { image = 'DLC5/iconPerks_HuntressLullaby',         lang = { 'Hex: Huntress Lullaby', '呪術・女狩人の子守歌', 'Fluch: Wiegenlied der Jägerin' } },
    { image = 'DLC5/iconPerks_TerritorialImperative',   lang = { 'Territorial Imperative', '縄張り意識', 'Gebietszwang' } },
-- 40
    { image = 'England/iconPerks_bloodWarden',          lang = { 'Blood Warden', '血の番人', 'Blutwächter' } },
    { image = 'England/iconPerks_fireUp',               lang = { 'Fire Up', 'ファイヤー・アップ', 'Einheizen' } },
    { image = 'England/iconPerks_rememberMe',           lang = { 'Rember Me', 'リメンバー・ミー', 'Vergissmeinnicht' } },
    { image = 'Finland/iconPerks_hangmansTrick',        lang = { 'Hangman\'s Trick', '処刑人の妙技', 'Henkerstreich' } },
    { image = 'Finland/iconPerks_makeYourChoice',       lang = { 'Make your Choice', '選択は君次第だ', 'Triff deine Wahl' } },

    { image = 'Finland/iconPerks_surveillance',         lang = { 'Surveillance', '監視', 'Überwachung' } },
    { image = 'Guam/iconPerks_bamboozle',               lang = { 'Bamboozle', 'まやかし', 'Verblüffen' } },
    { image = 'Guam/iconPerks_coulrophobia',            lang = { 'Coulrophobia', 'ピエロ恐怖症', 'Coulrophobie' } },
    { image = 'Guam/iconPerks_popGoesTheWeasel',        lang = { 'Pop goes the Weasel', 'イタチが飛び出した', 'Pop Goes the Weasel' } },
    { image = 'Haiti/iconPerks_hatred',                 lang = { 'Rancor', '怨恨', 'Hass' } },
-- 50
    { image = 'Haiti/iconPerks_hauntedGround',          lang = { 'Hex: Haunted Ground', '呪術・霊障の地', 'Fluch: Heimgesuchter Boden' } },
    { image = 'Haiti/iconPerks_spiritFury',             lang = { 'Spirit Fury', '怨霊の怒り', 'Zorn des Gespensts' } },
    { image = 'Kenya/iconPerks_discordance',            lang = { 'Discordance', '不協和音', 'Uneinigkeit' } },
    { image = 'Kenya/iconPerks_ironMaiden',             lang = { 'Iron Maiden', 'アイアンメイデン', 'Eiserne Jungfrau' } },
    { image = 'Kenya/iconPerks_madGrit',                lang = { 'Mad Grit', '狂気の根性', 'Irrer Mut' } },

    { image = 'Mali/iconPerks_corruptIntervention',     lang = { 'Corrupt Intervention', '堕落の介入', 'Korrupte Intervention' } },
    { image = 'Mali/iconPerks_darkDevotion',            lang = { 'Dark Devotion', '闇の信仰心', 'Dunkle Hingabe' } },
    { image = 'Mali/iconPerks_infectiousFright',        lang = { 'Infectious Fright', '伝播する怖気', 'Infektiöse Angst' } },
    { image = 'Oman/iconPerks_furtiveChase',            lang = { 'Furtive Chase', '隠密の追跡', 'Heimliche Verfolgungsjagd' } },
    { image = 'Oman/iconPerks_imAllEars',               lang = { 'I\'m all Ears', '地獄耳', 'Ich bin ganz Ohr' } },
-- 60
    { image = 'Oman/iconPerks_thrillingTremors',        lang = { 'Thrilling Tremors', '戦慄', 'Durchdringendes Zittern' } },
    { image = 'Qatar/iconPerks_cruelConfinement',       lang = { 'Cruel Confinement', '無慈悲の極地', 'Grausame Grenzen' } },
    { image = 'Qatar/iconPerks_mindBreaker',            lang = { 'Mind Breaker', 'マインドブレーカー', 'Seelenbrecher' } },
    { image = 'Qatar/iconPerks_surge',                  lang = { 'Surge', 'サージ', 'Spannungsstoß' } },
    { image = 'Sweden/iconPerks_bloodEcho',             lang = { 'Blood Echo', '血の共鳴', 'Blutecho' } },

    { image = 'Sweden/iconPerks_nemesis',               lang = { 'Nemesis', '天誅', 'Nemesis' } },
    { image = 'Sweden/iconPerks_zanshinTactics',        lang = { 'Zanshin Tactics', '残心の戦術', 'Zanshin-Taktik' } },
    { image = 'Ukraine/iconPerks_deadManSwitch',        lang = { 'Dead Man Switch', '死人のスイッチ', 'Totenschalter' } },
    { image = 'Ukraine/iconPerks_gearHead',             lang = { 'Gear Head', '変速機', 'Ausrüstungsspezi' } },
    { image = 'Ukraine/iconPerks_hexRetribution',       lang = { 'Hex: Retribution', '呪術：報復', 'Fluch: Vergeltung' } },
-- 70
    { image = 'Wales/iconPerks_deathbound',             lang = { 'Deathound', 'デスバウンド', 'Todgeweiht' } },
    { image = 'Wales/iconPerks_forcedPenance',          lang = { 'Forced Penance', '強制苦行', 'Erzwungene Buße' } },
};
random_perks_config.killer_perk_count = 72;
