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
    language = 'English',
};

random_perks_config.survivor_perks = {
    { image = 'iconPerks_adrenaline',                   name_en = 'Adrenaline',                     name_jp = 'アドレナリン', },
    { image = 'iconPerks_balancedLanding',              name_en = 'Balance Landing',                name_jp = 'スマートな着地'  },
    { image = 'iconPerks_bond',                         name_en = 'Bond',                           name_jp = '絆' },
    { image = 'iconPerks_botanyKnowledge',              name_en = 'Botany Knowledge',               name_jp = '植物学の知識' },
    { image = 'iconPerks_calmSpirit',                   name_en = 'Calm Spirit',                    name_jp = '魂の平穏' },

    { image = 'iconPerks_darkSense',                    name_en = 'Dark Sense',                     name_jp = '闇の感覚' },
    { image = 'iconPerks_dejaVu',                       name_en = 'DeJaVu',                         name_jp = 'デジャヴ' },
    { image = 'iconPerks_empathy',                      name_en = 'Empathy',                        name_jp = '共感' },
    { image = 'iconPerks_hope',                         name_en = 'Hope',                           name_jp = '希望' },
    { image = 'iconPerks_ironWill',                     name_en = 'Iron Will',                      name_jp = '鋼の意思' },
-- 10
    { image = 'iconPerks_kindred',                      name_en = 'Kindred',                        name_jp = '血族' },
    { image = 'iconPerks_leader',                       name_en = 'Leader',                         name_jp = 'リーダー' },
    { image = 'iconPerks_lightweight',                  name_en = 'Lightweight',                    name_jp = '身軽' },
    { image = 'iconPerks_noOneLeftBehind',              name_en = 'No One Left Behind',             name_jp = '誰も見捨てはしない' },
    { image = 'iconPerks_plunderersInstinct',           name_en = 'Plunderers Instinct',            name_jp = 'コソ泥の本能' },

    { image = 'iconPerks_premonition',                  name_en = 'Premonition',                    name_jp = '予感' },
    { image = 'iconPerks_proveThyself',                 name_en = 'Prove Thyself',                  name_jp = '有能の証明' },
    { image = 'iconPerks_quickAndQuiet',                name_en = 'Quick and Quiet',                name_jp = '素早く静かに' },
    { image = 'iconPerks_resilience',                   name_en = 'Resilience',                     name_jp = '逆境魂' },
    { image = 'iconPerks_saboteur',                     name_en = 'Saboteur',                       name_jp = 'サボタージュ' },
-- 20
    { image = 'iconPerks_selfCare',                     name_en = 'Self Care',                      name_jp = 'セルフケア' },
    { image = 'iconPerks_slipperyMeat',                 name_en = 'Slippery Meat',                  name_jp = 'ツルツルとした肉体' },
    { image = 'iconPerks_smallGame',                    name_en = 'Small Game',                     name_jp = '小さな獲物' },
    { image = 'iconPerks_spineChill',                   name_en = 'Spine Chill',                    name_jp = '凍りつく背筋' },
    { image = 'iconPerks_sprintBurst',                  name_en = 'Sprint Burst',                   name_jp = '全力疾走' },

    { image = 'iconPerks_streetwise',                   name_en = 'Streetwise',                     name_jp = '都会の生存術' },
    { image = 'iconPerks_thisIsNotHappening',           name_en = 'This is not happening',          name_jp = '痛みも気から' },
    { image = 'iconPerks_urbanEvasion',                 name_en = 'Urban Evasion',                  name_jp = '都会の逃走術' },
    { image = 'iconPerks_wellMakeIt',                   name_en = 'We\'ll make it',                 name_jp = 'きっとやり遂げる' },
    { image = 'Ash/iconPerks_buckleUp',                 name_en = 'Buckle Up',                      name_jp = 'ベルトを締めろ！' },
-- 30
    { image = 'Ash/iconPerks_flipFlop',                 name_en = 'Flip Flop',                      name_jp = 'フリップ・フロップ' },
    { image = 'Ash/iconPerks_mettleOfMan',              name_en = 'Mettle of Man',                  name_jp = '英雄の奮起' },
    { image = 'DLC2/iconPerks_decisiveStrike',          name_en = 'Decisive Strike',                name_jp = '決死の一撃' },
    { image = 'DLC2/iconPerks_objectOfObsession',       name_en = 'Object of Obsession',            name_jp = '執念の対象' },
    { image = 'DLC2/iconPerks_soleSurvivor',            name_en = 'Sole Survivor',                  name_jp = '唯一の生存者' },

    { image = 'DLC3/iconPerks_aceInTheHole',            name_en = 'Ace in the Hole',                name_jp = '最後の切り札' },
    { image = 'DLC3/iconPerks_openHanded',              name_en = 'Open Handed',                    name_jp = '手札公開' },
    { image = 'DLC3/iconPerks_upTheAnte',               name_en = 'Up the Ante',                    name_jp = '賭け金のレイズ' },
    { image = 'DLC4/iconPerks_alert',                   name_en = 'Alert',                          name_jp = '警戒' },
    { image = 'DLC4/iconPerks_lithe',                   name_en = 'Lithe',                          name_jp = 'しなやか' },
-- 40
    { image = 'DLC4/iconPerks_technician',              name_en = 'Technician',                     name_jp = 'テクニシャン' },
    { image = 'DLC5/iconPerks_DeadHard',                name_en = 'Dead Hard',                      name_jp = 'デッド・ハード' },
    { image = 'DLC5/iconPerks_NoMither',                name_en = 'No Mither',                      name_jp = '弱音はナシだ' },
    { image = 'DLC5/iconPerks_WereGonnaLiveForever',    name_en = 'We\'re gonna Live forever',      name_jp = 'ずっと一緒だ' },
    { image = 'England/iconPerks_pharmacy',             name_en = 'Pharmacy',                       name_jp = '調剤学' },

    { image = 'England/iconPerks_vigil',                name_en = 'Vigil',                          name_jp = '寝ずの番' },
    { image = 'England/iconPerks_wakeUp',               name_en = 'wake up',                        name_jp = '目を覚ませ！' },
    { image = 'Finland/iconPerks_detectivesHunch',      name_en = 'Detectives Hunch',               name_jp = '張り込み' },
    { image = 'Finland/iconPerks_stakeOut',             name_en = 'Stake Out',                      name_jp = '刑事の直感' },
    { image = 'Finland/iconPerks_tenacity',             name_en = 'Tenacity',                       name_jp = '執念' },
-- 50
    { image = 'Haiti/iconPerks_autodidact',             name_en = 'Autodidact',                     name_jp = '独学者' },
    { image = 'Haiti/iconPerks_deliverance',            name_en = 'Deliverence',                    name_jp = '解放' },
    { image = 'Haiti/iconPerks_diversion',              name_en = 'Diversion',                      name_jp = '陽動' },
    { image = 'Kate/iconPerks_boilOver',                name_en = 'Boil Over',                      name_jp = 'ボイルオーバー' },
    { image = 'Kate/iconPerks_danceWithMe',             name_en = 'Dance with me',                  name_jp = 'ダンス・ウィズ・ミー' },

    { image = 'Kate/iconPerks_windowsOfOpportunity',    name_en = 'Windows of Opportunity',         name_jp = 'ウィンドウズ・オブ・オポチュニティ' },
    { image = 'Kenya/iconPerks_aftercare',              name_en = 'Aftercare',                      name_jp = 'アフターケア' },
    { image = 'Kenya/iconPerks_breakdown',              name_en = 'Breakdown',                      name_jp = 'ブレイクダウン' },
    { image = 'Kenya/iconPerks_distortion',             name_en = 'Distortion',                     name_jp = 'ディストーション' },
    { image = 'L4D/iconPerks_borrowedTime',             name_en = 'Borrowed Time',                  name_jp = '与えられた猶予' },
-- 60
    { image = 'L4D/iconPerks_leftBehind',               name_en = 'Left Behind',                    name_jp = '置き去りにされた者'  },
    { image = 'L4D/iconPerks_unbreakable',              name_en = 'Unbreakable',                    name_jp = '不滅'  },
    { image = 'Mali/iconPerks_headOn',                  name_en = 'Head On',                        name_jp = '真っ向勝負'  },
    { image = 'Mali/iconPerks_poised',                  name_en = 'Poised',                         name_jp = '平常心'  },
    { image = 'Mali/iconPerks_solidarity',              name_en = 'Solidarity',                     name_jp = '連帯感'  },

    { image = 'Qatar/iconPerks_babySitter',             name_en = 'Baby Sitter',                    name_jp = 'ベビーシッター'  },
    { image = 'Qatar/iconPerks_betterTogether',         name_en = 'Better Together',                name_jp = '一緒にいよう'  },
    { image = 'Qatar/iconPerks_fixated',                name_en = 'Fixated',                        name_jp = '執着心'  },
    { image = 'Qatar/iconPerks_innerStrength',          name_en = 'Inner Strength',                 name_jp = '内なる力'  },
    { image = 'Qatar/iconPerks_secondWind',             name_en = 'Second Wind',                    name_jp = 'セカンドウインド'  },
-- 70
    { image = 'Qatar/iconPerks_camaraderie',            name_en = 'Camaraderie',                    name_jp = '仲間意識'  },
    { image = 'Sweden/iconPerks_anyMeansNecessary',     name_en = 'Any means Necessary',            name_jp = '強硬手段'  },
    { image = 'Sweden/iconPerks_breakout',              name_en = 'Breakout',                       name_jp = '突破'  },
    { image = 'Sweden/iconPerks_luckyBreak',            name_en = 'Lucky Break',                    name_jp = '怪我の功名'  },
    { image = 'Ukraine/iconPerks_forThePeople',         name_en = 'For the People',                 name_jp = '人々のために'  },

    { image = 'Ukraine/iconPerks_offTheRecord',         name_en = 'Off the Record',                 name_jp = 'オフレコ'  },
    { image = 'Ukraine/iconPerks_redHerring',           name_en = 'Red Herring',                    name_jp = 'おとり'  },
    { image = 'Wales/iconPerks_bloodPact',              name_en = 'Blood Pact',                     name_jp = '血の協定'  },
    { image = 'Wales/iconPerks_repressedAlliance',      name_en = 'Repressed Alliance',             name_jp = '抑圧の同盟'  },
    { image = 'Wales/iconPerks_soulGuard',              name_en = 'Soul Guard',                     name_jp = 'ソウルガード'  },
-- 80
};
random_perks_config.survivor_perk_count = 80;

random_perks_config.killer_perks = {
    { image = 'iconPerks_agitation',                    name_en = 'Agitation',                      name_jp = '興奮' },
    { image = 'iconPerks_aNursesCalling',               name_en = 'A Nurse\'s Calling',             name_jp = '看護婦の使命' },
    { image = 'iconPerks_bitterMurmur',                 name_en = 'Bitter Murmur',                  name_jp = '憎悪の囁き' },
    { image = 'iconPerks_bloodhound',                   name_en = 'Bloodhound',                     name_jp = '血の追跡者' },
    { image = 'iconPerks_brutalStrength',               name_en = 'Brutal Strength',                name_jp = '野蛮な力' },

    { image = 'iconPerks_deerstalker',                  name_en = 'Deerstalker',                    name_jp = '忍び寄る者' },
    { image = 'iconPerks_distressing',                  name_en = 'Distressing',                    name_jp = '苦悶の根源' },
    { image = 'iconPerks_enduring',                     name_en = 'Enduring',                       name_jp = '不屈' },
    { image = 'iconPerks_insidious',                    name_en = 'Insidious',                      name_jp = '狡猾' },
    { image = 'iconPerks_ironGrasp',                    name_en = 'Iron Grasp',                     name_jp = '鋼の握力' },
-- 10
    { image = 'iconPerks_lightborn',                    name_en = 'Lightborn',                      name_jp = '光より出でし者' },
    { image = 'iconPerks_monstrousShrine',              name_en = 'Monstrous Shrine',               name_jp = '異形の祭壇' },
    { image = 'iconPerks_noOneEscapesDeath',            name_en = 'No One Escapes the Death',       name_jp = '呪術・誰も死から逃れられない' },
    { image = 'iconPerks_predator',                     name_en = 'Predator',                       name_jp = '捕食者' },
    { image = 'iconPerks_shadowborn',                   name_en = 'Shadowborn',                     name_jp = '闇より出でし者' },

    { image = 'iconPerks_sloppyButcher',                name_en = 'Sloppy Butcher',                 name_jp = 'ずさんな肉屋' },
    { image = 'iconPerks_spiesFromTheShadows',          name_en = 'Spies from the Shadows',         name_jp = '影の密偵' },
    { image = 'iconPerks_stridor',                      name_en = 'Stridor',                        name_jp = '喘鳴' },
    { image = 'iconPerks_thatanophobia',                name_en = 'Thatanophobia',                  name_jp = '死恐怖症' },
    { image = 'iconPerks_tinkerer',                     name_en = 'Tinkerer',                       name_jp = 'ガラクタいじり' },
-- 20
    { image = 'iconPerks_unnervingPresence',            name_en = 'Unnerving Presence',             name_jp = '不安の元凶' },
    { image = 'iconPerks_unrelenting',                  name_en = 'Unrelenting',                    name_jp = '無慈悲' },
    { image = 'iconPerks_whispers',                     name_en = 'Whispers',                       name_jp = '囁き' },
    { image = 'Cannibal/iconPerks_BBQAndChili',         name_en = 'BBQ and Chili',                  name_jp = 'バーベキュー＆チリ' },
    { image = 'Wales/iconPerks_trailOfTorment',         name_en = 'Trail of Torment',               name_jp = '煩悶のトレイル' },

    { image = 'Cannibal/iconPerks_franklinsLoss',       name_en = 'Franklins Loss',                 name_jp = 'フランクリンの悲劇' },
    { image = 'Cannibal/iconPerks_knockOut',            name_en = 'Knock Out',                      name_jp = 'ノックアウト' },
    { image = 'DLC2/iconPerks_dyingLight',              name_en = 'Dying Light',                    name_jp = '消えゆく灯' },
    { image = 'DLC2/iconPerks_playWithYourFood',        name_en = 'Play with your Food',            name_jp = '弄ばれる獲物' },
    { image = 'DLC2/iconPerks_saveTheBestForLast',      name_en = 'Save the best for Last',         name_jp = '最後のお楽しみ' },
-- 30
    { image = 'DLC3/iconPerks_devourHope',              name_en = 'Hex: Devour Hope',               name_jp = '呪術・貪られる希望' },
    { image = 'DLC3/iconPerks_ruin',                    name_en = 'Hex: Ruin',                      name_jp = '呪術・破滅' },
    { image = 'DLC3/iconPerks_theThirdSeal',            name_en = 'Hex: The third Seal',            name_jp = '呪術・第三の封印' },
    { image = 'DLC3/iconPerks_thrillOfTheHunt',         name_en = 'Hex: Thrill of the Hunt',        name_jp = '呪術・狩りの興奮' },
    { image = 'DLC4/iconPerks_generatorOvercharge',     name_en = 'Generator Overcharge',           name_jp = 'オーバーチャージ' },

    { image = 'DLC4/iconPerks_monitorAndAbuse',         name_en = 'Monitor and Abuse',              name_jp = '観察＆虐待' },
    { image = 'DLC4/iconPerks_overwhelmingPresence',    name_en = 'Overhelming Presence',           name_jp = '圧倒的存在感' },
    { image = 'DLC5/iconPerks_BeastOfPrey',             name_en = 'Beast of Prey',                  name_jp = '猛獣' },
    { image = 'DLC5/iconPerks_HuntressLullaby',         name_en = 'Hex: Huntress Lullaby',          name_jp = '呪術・女狩人の子守歌' },
    { image = 'DLC5/iconPerks_TerritorialImperative',   name_en = 'Territorial Imperative',         name_jp = '縄張り意識' },
-- 40
    { image = 'England/iconPerks_bloodWarden',          name_en = 'Blood Warden',                   name_jp = '血の番人' },
    { image = 'England/iconPerks_fireUp',               name_en = 'Fire Up',                        name_jp = 'ファイヤー・アップ' },
    { image = 'England/iconPerks_rememberMe',           name_en = 'Rember Me',                      name_jp = 'リメンバー・ミー' },
    { image = 'Finland/iconPerks_hangmansTrick',        name_en = 'Hangman\'s Trick',               name_jp = '処刑人の妙技' },
    { image = 'Finland/iconPerks_makeYourChoice',       name_en = 'Make your Choice',               name_jp = '選択は君次第だ' },

    { image = 'Finland/iconPerks_surveillance',         name_en = 'Surveillance',                   name_jp = '監視' },
    { image = 'Guam/iconPerks_bamboozle',               name_en = 'Bamboozle',                      name_jp = 'まやかし' },
    { image = 'Guam/iconPerks_coulrophobia',            name_en = 'Coulrophobia',                   name_jp = 'ピエロ恐怖症' },
    { image = 'Guam/iconPerks_popGoesTheWeasel',        name_en = 'Pop goes the Weasel',            name_jp = 'イタチが飛び出した' },
    { image = 'Haiti/iconPerks_hatred',                 name_en = 'Rancor',                         name_jp = '怨恨' },
-- 50
    { image = 'Haiti/iconPerks_hauntedGround',          name_en = 'Hex: Haunted Ground',            name_jp = '呪術・霊障の地' },
    { image = 'Haiti/iconPerks_spiritFury',             name_en = 'Spirit Fury',                    name_jp = '怨霊の怒り' },
    { image = 'Kenya/iconPerks_discordance',            name_en = 'Discordance',                    name_jp = '不協和音' },
    { image = 'Kenya/iconPerks_ironMaiden',             name_en = 'Iron Maiden',                    name_jp = 'アイアンメイデン' },
    { image = 'Kenya/iconPerks_madGrit',                name_en = 'Mad Grit',                       name_jp = '狂気の根性' },

    { image = 'Mali/iconPerks_corruptIntervention',     name_en = 'Corrupt Intervention',           name_jp = '堕落の介入' },
    { image = 'Mali/iconPerks_darkDevotion',            name_en = 'Dark Devotion',                  name_jp = '闇の信仰心' },
    { image = 'Mali/iconPerks_infectiousFright',        name_en = 'Infectious Fright',              name_jp = '伝播する怖気' },
    { image = 'Oman/iconPerks_furtiveChase',            name_en = 'Furtive Chase',                  name_jp = '隠密の追跡' },
    { image = 'Oman/iconPerks_imAllEars',               name_en = 'I\'m all Ears',                  name_jp = '地獄耳' },
-- 60
    { image = 'Oman/iconPerks_thrillingTremors',        name_en = 'Thrilling Tremors',              name_jp = '戦慄' },
    { image = 'Qatar/iconPerks_cruelConfinement',       name_en = 'Cruel Confinement',              name_jp = '無慈悲の極地' },
    { image = 'Qatar/iconPerks_mindBreaker',            name_en = 'Mind Breaker',                   name_jp = 'マインドブレーカー' },
    { image = 'Qatar/iconPerks_surge',                  name_en = 'Surge',                          name_jp = 'サージ' },
    { image = 'Sweden/iconPerks_bloodEcho',             name_en = 'Blood Echo',                     name_jp = '血の共鳴' },

    { image = 'Sweden/iconPerks_nemesis',               name_en = 'Nemesis',                        name_jp = '天誅' },
    { image = 'Sweden/iconPerks_zanshinTactics',        name_en = 'Zanshin Tactics',                name_jp = '残心の戦術' },
    { image = 'Ukraine/iconPerks_deadManSwitch',        name_en = 'Dead Man Switch',                name_jp = '死人のスイッチ' },
    { image = 'Ukraine/iconPerks_gearHead',             name_en = 'Gear Head',                      name_jp = '変速機' },
    { image = 'Ukraine/iconPerks_hexRetribution',       name_en = 'Hex: Retribution',               name_jp = '呪術：報復' },
-- 70
    { image = 'Wales/iconPerks_deathbound',             name_en = 'Deathound',                      name_jp = 'デスバウンド' },
    { image = 'Wales/iconPerks_forcedPenance',          name_en = 'Forced Penance',                 name_jp = '強制苦行' },
};
random_perks_config.killer_perk_count = 72;

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
            if random_perks_config.language == '日本語' then
                local str = random_perks_config.random_perks[random_indexes[1]].name_jp;
                str = str .. "\n" ..  random_perks_config.random_perks[random_indexes[2]].name_jp;
                str = str .. "\n" .. random_perks_config.random_perks[random_indexes[3]].name_jp;
                str = str .. "\n" .. random_perks_config.random_perks[random_indexes[4]].name_jp;
                set_text(str);
            else
                local str = random_perks_config.random_perks[random_indexes[1]].name_en;
                str = str .. "\n" ..  random_perks_config.random_perks[random_indexes[2]].name_en;
                str = str .. "\n" .. random_perks_config.random_perks[random_indexes[3]].name_en;
                str = str .. "\n" .. random_perks_config.random_perks[random_indexes[4]].name_en;
                set_text(str);             
            end

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
    random_perks_config.language = obs.obs_data_get_string(settings, "lang");
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

    p = obs.obs_properties_add_list(props, "lang", "Language", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING);
    obs.obs_property_list_add_string(p, "English", "en");
    obs.obs_property_list_add_string(p, "日本語", "jp");
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
