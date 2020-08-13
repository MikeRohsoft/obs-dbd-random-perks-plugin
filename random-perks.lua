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
    { image = 'iconPerks_adrenaline',                   name_en = 'Adrenaline',                     name_jp = 'アドレナリン',                           name_de='Adrenalin' },
    { image = 'iconPerks_balancedLanding',              name_en = 'Balance Landing',                name_jp = 'スマートな着地',                         name_de='Ausgewogene Landung'  },
    { image = 'iconPerks_bond',                         name_en = 'Bond',                           name_jp = '絆',                                     name_de='Bindung' },
    { image = 'iconPerks_botanyKnowledge',              name_en = 'Botany Knowledge',               name_jp = '植物学の知識',                           name_de='Botanisches Wissen' },
    { image = 'iconPerks_calmSpirit',                   name_en = 'Calm Spirit',                    name_jp = '魂の平穏',                               name_de='Seelenruhe' },

    { image = 'iconPerks_darkSense',                    name_en = 'Dark Sense',                     name_jp = '闇の感覚',                               name_de='Dunkle Wahrnehmung' },
    { image = 'iconPerks_dejaVu',                       name_en = 'Déjà-Vu',                        name_jp = 'デジャヴ',                               name_de='Déjà-Vu-Erlebnis' },
    { image = 'iconPerks_empathy',                      name_en = 'Empathy',                        name_jp = '共感',                                   name_de='Einfühlungsvermögen' },
    { image = 'iconPerks_hope',                         name_en = 'Hope',                           name_jp = '希望',                                   name_de='Hoffnung' },
    { image = 'iconPerks_ironWill',                     name_en = 'Iron Will',                      name_jp = '鋼の意思',                               name_de='Eiserner Wille' },
-- 10
    { image = 'iconPerks_kindred',                      name_en = 'Kindred',                        name_jp = '血族',                                   name_de='Verwandt' },
    { image = 'iconPerks_leader',                       name_en = 'Leader',                         name_jp = 'リーダー',                               name_de='Anführer' },
    { image = 'iconPerks_lightweight',                  name_en = 'Lightweight',                    name_jp = '身軽',                                   name_de='Leichtgewicht' },
    { image = 'iconPerks_noOneLeftBehind',              name_en = 'No One Left Behind',             name_jp = '誰も見捨てはしない',                     name_de='Niemand wird Zurückgelassen' },
    { image = 'iconPerks_plunderersInstinct',           name_en = 'Plunderers Instinct',            name_jp = 'コソ泥の本能',                           name_de='Plündererspürsinn' },

    { image = 'iconPerks_premonition',                  name_en = 'Premonition',                    name_jp = '予感',                                   name_de='Vorwarnung' },
    { image = 'iconPerks_proveThyself',                 name_en = 'Prove Thyself',                  name_jp = '有能の証明',                             name_de='Beweise dich' },
    { image = 'iconPerks_quickAndQuiet',                name_en = 'Quick & Quiet',                  name_jp = '素早く静かに',                           name_de='Schnell & Leise' },
    { image = 'iconPerks_resilience',                   name_en = 'Resilience',                     name_jp = '逆境魂',                                 name_de='Widerstandsfähigkeit' },
    { image = 'iconPerks_saboteur',                     name_en = 'Saboteur',                       name_jp = 'サボタージュ',                           name_de='Saboteur' },
-- 20
    { image = 'iconPerks_selfCare',                     name_en = 'Self Care',                      name_jp = 'セルフケア',                             name_de='Selbstfürsorge' },
    { image = 'iconPerks_slipperyMeat',                 name_en = 'Slippery Meat',                  name_jp = 'ツルツルとした肉体',                     name_de='Gerissenes Fleisch' },
    { image = 'iconPerks_smallGame',                    name_en = 'Small Game',                     name_jp = '小さな獲物',                             name_de='Niederwild' },
    { image = 'iconPerks_spineChill',                   name_en = 'Spine Chill',                    name_jp = '凍りつく背筋',                           name_de='Kalter Rückenschauer' },
    { image = 'iconPerks_sprintBurst',                  name_en = 'Sprint Burst',                   name_jp = '全力疾走',                               name_de='Sprintboost' },

    { image = 'iconPerks_streetwise',                   name_en = 'Streetwise',                     name_jp = '都会の生存術',                           name_de='Pfiffig' },
    { image = 'iconPerks_thisIsNotHappening',           name_en = 'This is not happening',          name_jp = '痛みも気から',                           name_de='Das geschieht nicht' },
    { image = 'iconPerks_urbanEvasion',                 name_en = 'Urban Evasion',                  name_jp = '都会の逃走術',                           name_de='Städtische Invasion' },
    { image = 'iconPerks_wellMakeIt',                   name_en = 'We\'ll make it',                 name_jp = 'きっとやり遂げる',                       name_de='Wir schaffen das!' },
    { image = 'Ash/iconPerks_buckleUp',                 name_en = 'Buckle Up',                      name_jp = 'ベルトを締めろ！',                       name_de='Anschnallen' },
-- 30
    { image = 'Ash/iconPerks_flipFlop',                 name_en = 'Flip Flop',                      name_jp = 'フリップ・フロップ',                     name_de='Flip-Flop' },
    { image = 'Ash/iconPerks_mettleOfMan',              name_en = 'Mettle of Man',                  name_jp = '英雄の奮起',                             name_de='Der Eifer der Menschen' },
    { image = 'DLC2/iconPerks_decisiveStrike',          name_en = 'Decisive Strike',                name_jp = '決死の一撃',                             name_de='Entscheidungsschlag' },
    { image = 'DLC2/iconPerks_objectOfObsession',       name_en = 'Object of Obsession',            name_jp = '執念の対象',                             name_de='Objekt der Besessenheit' },
    { image = 'DLC2/iconPerks_soleSurvivor',            name_en = 'Sole Survivor',                  name_jp = '唯一の生存者',                           name_de='Einziger Überlebender' },

    { image = 'DLC3/iconPerks_aceInTheHole',            name_en = 'Ace in the Hole',                name_jp = '最後の切り札',                           name_de='Ass im Ärmel' },
    { image = 'DLC3/iconPerks_openHanded',              name_en = 'Open Handed',                    name_jp = '手札公開',                               name_de='Mit offener Hand' },
    { image = 'DLC3/iconPerks_upTheAnte',               name_en = 'Up the Ante',                    name_jp = '賭け金のレイズ',                         name_de='Erhöhe den Einsatz' },
    { image = 'DLC4/iconPerks_alert',                   name_en = 'Alert',                          name_jp = '警戒',                                   name_de='Wachsam' },
    { image = 'DLC4/iconPerks_lithe',                   name_en = 'Lithe',                          name_jp = 'しなやか',                               name_de='Flink' },
-- 40
    { image = 'DLC4/iconPerks_technician',              name_en = 'Technician',                     name_jp = 'テクニシャン',                           name_de='Technikerin' },
    { image = 'DLC5/iconPerks_DeadHard',                name_en = 'Dead Hard',                      name_jp = 'デッド・ハード',                         name_de='Hart im Nehmen' },
    { image = 'DLC5/iconPerks_NoMither',                name_en = 'No Mither',                      name_jp = '弱音はナシだ',                           name_de='Kein Gejammer' },
    { image = 'DLC5/iconPerks_WereGonnaLiveForever',    name_en = 'We\'re gonna Live forever',      name_jp = 'ずっと一緒だ',                           name_de='Wir werden ewig Leben' },
    { image = 'England/iconPerks_pharmacy',             name_en = 'Pharmacy',                       name_jp = '調剤学',                                 name_de='Apotheke' },

    { image = 'England/iconPerks_vigil',                name_en = 'Vigil',                          name_jp = '寝ずの番',                               name_de='Nachtwache' },
    { image = 'England/iconPerks_wakeUp',               name_en = 'Wake up!',                       name_jp = '目を覚ませ！',                           name_de='Aufwachen!' },
    { image = 'Finland/iconPerks_detectivesHunch',      name_en = 'Detectives Hunch',               name_jp = '張り込み',                               name_de='Tapps Verdacht' },
    { image = 'Finland/iconPerks_stakeOut',             name_en = 'Stake Out',                      name_jp = '刑事の直感',                             name_de='Observierung' },
    { image = 'Finland/iconPerks_tenacity',             name_en = 'Tenacity',                       name_jp = '執念',                                   name_de='Beharrlichkeit' },
-- 50
    { image = 'Haiti/iconPerks_autodidact',             name_en = 'Autodidact',                     name_jp = '独学者',                                 name_de='Autodidakt' },
    { image = 'Haiti/iconPerks_deliverance',            name_en = 'Deliverence',                    name_jp = '解放',                                   name_de='Befreiung' },
    { image = 'Haiti/iconPerks_diversion',              name_en = 'Diversion',                      name_jp = '陽動',                                   name_de='Ablenkung' },
    { image = 'Kate/iconPerks_boilOver',                name_en = 'Boil Over',                      name_jp = 'ボイルオーバー',                         name_de='Wildpferd' },
    { image = 'Kate/iconPerks_danceWithMe',             name_en = 'Dance with me',                  name_jp = 'ダンス・ウィズ・ミー',                   name_de='Tanz mit mir' },

    { image = 'Kate/iconPerks_windowsOfOpportunity',    name_en = 'Windows of Opportunity',         name_jp = 'ウィンドウズ・オブ・オポチュニティ',     name_de='Gelegenheit nutzen' },
    { image = 'Kenya/iconPerks_aftercare',              name_en = 'Aftercare',                      name_jp = 'アフターケア',                           name_de='Nachsorge' },
    { image = 'Kenya/iconPerks_breakdown',              name_en = 'Breakdown',                      name_jp = 'ブレイクダウン',                         name_de='Zerlegen' },
    { image = 'Kenya/iconPerks_distortion',             name_en = 'Distortion',                     name_jp = 'ディストーション',                       name_de='Verzerrung' },
    { image = 'L4D/iconPerks_borrowedTime',             name_en = 'Borrowed Time',                  name_jp = '与えられた猶予',                         name_de='Geliehene Zeit' },
-- 60
    { image = 'L4D/iconPerks_leftBehind',               name_en = 'Left Behind',                    name_jp = '置き去りにされた者',                     name_de='Zurückgelassen'  },
    { image = 'L4D/iconPerks_unbreakable',              name_en = 'Unbreakable',                    name_jp = '不滅',                                   name_de='Unbeugsam'  },
    { image = 'Mali/iconPerks_headOn',                  name_en = 'Head On',                        name_jp = '真っ向勝負',                             name_de='Frontal'  },
    { image = 'Mali/iconPerks_poised',                  name_en = 'Poised',                         name_jp = '平常心',                                 name_de='Selbstsicher'  },
    { image = 'Mali/iconPerks_solidarity',              name_en = 'Solidarity',                     name_jp = '連帯感',                                 name_de='Solidarität'  },

    { image = 'Qatar/iconPerks_babySitter',             name_en = 'Baby Sitter',                    name_jp = 'ベビーシッター',                         name_de='Babysitter'  },
    { image = 'Qatar/iconPerks_betterTogether',         name_en = 'Better Together',                name_jp = '一緒にいよう',                           name_de='Besser Gemeinsam'  },
    { image = 'Qatar/iconPerks_fixated',                name_en = 'Fixated',                        name_jp = '執着心',                                 name_de='Fixiert'  },
    { image = 'Qatar/iconPerks_innerStrength',          name_en = 'Inner Strength',                 name_jp = '内なる力',                               name_de='Innere Kraft'  },
    { image = 'Qatar/iconPerks_secondWind',             name_en = 'Second Wind',                    name_jp = 'セカンドウインド',                       name_de='Aufschwung'  },
-- 70
    { image = 'Qatar/iconPerks_camaraderie',            name_en = 'Camaraderie',                    name_jp = '仲間意識',                               name_de='Kameradschaft'  },
    { image = 'Sweden/iconPerks_anyMeansNecessary',     name_en = 'Any means Necessary',            name_jp = '強硬手段',                               name_de='Mit allen Mitteln'  },
    { image = 'Sweden/iconPerks_breakout',              name_en = 'Breakout',                       name_jp = '突破',                                   name_de='Ausbruch'  },
    { image = 'Sweden/iconPerks_luckyBreak',            name_en = 'Lucky Break',                    name_jp = '怪我の功名',                             name_de='Glück gehabt'  },
    { image = 'Ukraine/iconPerks_forThePeople',         name_en = 'For the People',                 name_jp = '人々のために',                           name_de='Für das Volk'  },

    { image = 'Ukraine/iconPerks_offTheRecord',         name_en = 'Off the Record',                 name_jp = 'オフレコ',                               name_de='Vertraulich'  },
    { image = 'Ukraine/iconPerks_redHerring',           name_en = 'Red Herring',                    name_jp = 'おとり',                                 name_de='Ablenkungsmanöver'  },
    { image = 'Wales/iconPerks_bloodPact',              name_en = 'Blood Pact',                     name_jp = '血の協定',                               name_de='Blutpakt'  },
    { image = 'Wales/iconPerks_repressedAlliance',      name_en = 'Repressed Alliance',             name_jp = '抑圧の同盟',                             name_de='Verdrängtes Bündnis'  },
    { image = 'Wales/iconPerks_soulGuard',              name_en = 'Soul Guard',                     name_jp = 'ソウルガード',                           name_de='Seelenwächter'  },
-- 80
};
random_perks_config.survivor_perk_count = 80;

random_perks_config.killer_perks = {
    { image = 'iconPerks_agitation',                    name_en = 'Agitation',                      name_jp = '興奮',                                   name_de='Erregung' },
    { image = 'iconPerks_aNursesCalling',               name_en = 'A Nurse\'s Calling',             name_jp = '看護婦の使命',                           name_de='Der Ruf einer Krankenschwester' },
    { image = 'iconPerks_bitterMurmur',                 name_en = 'Bitter Murmur',                  name_jp = '憎悪の囁き',                             name_de='Verbittertes Gemurmel' },
    { image = 'iconPerks_bloodhound',                   name_en = 'Bloodhound',                     name_jp = '血の追跡者',                             name_de='Bluthund' },
    { image = 'iconPerks_brutalStrength',               name_en = 'Brutal Strength',                name_jp = '野蛮な力',                               name_de='Brutale Stärke' },

    { image = 'iconPerks_deerstalker',                  name_en = 'Deerstalker',                    name_jp = '忍び寄る者',                             name_de='Pirscher' },
    { image = 'iconPerks_distressing',                  name_en = 'Distressing',                    name_jp = '苦悶の根源',                             name_de='Verstört' },
    { image = 'iconPerks_enduring',                     name_en = 'Enduring',                       name_jp = '不屈',                                   name_de='Beständig' },
    { image = 'iconPerks_insidious',                    name_en = 'Insidious',                      name_jp = '狡猾',                                   name_de='Heimtückisch' },
    { image = 'iconPerks_ironGrasp',                    name_en = 'Iron Grasp',                     name_jp = '鋼の握力',                               name_de='Eiserner Griff' },
-- 10
    { image = 'iconPerks_lightborn',                    name_en = 'Lightborn',                      name_jp = '光より出でし者',                         name_de='Lichtgeborener' },
    { image = 'iconPerks_monstrousShrine',              name_en = 'Monstrous Shrine',               name_jp = '異形の祭壇',                             name_de='Monströser Schrein' },
    { image = 'iconPerks_noOneEscapesDeath',            name_en = 'Hex: No One Escapes the Death',  name_jp = '呪術・誰も死から逃れられない',           name_de='Fluch: Niemand entrinnt dem Tod' },
    { image = 'iconPerks_predator',                     name_en = 'Predator',                       name_jp = '捕食者',                                 name_de='Räuber' },
    { image = 'iconPerks_shadowborn',                   name_en = 'Shadowborn',                     name_jp = '闇より出でし者',                         name_de='Schattengeborener' },

    { image = 'iconPerks_sloppyButcher',                name_en = 'Sloppy Butcher',                 name_jp = 'ずさんな肉屋',                           name_de='Schlampiger Schlachter' },
    { image = 'iconPerks_spiesFromTheShadows',          name_en = 'Spies from the Shadows',         name_jp = '影の密偵',                               name_de='Spione des Schattens' },
    { image = 'iconPerks_stridor',                      name_en = 'Stridor',                        name_jp = '喘鳴',                                   name_de='Stridor' },
    { image = 'iconPerks_thatanophobia',                name_en = 'Thatanophobia',                  name_jp = '死恐怖症',                               name_de='Thanatophobia' },
    { image = 'iconPerks_tinkerer',                     name_en = 'Tinkerer',                       name_jp = 'ガラクタいじり',                         name_de='Tüftler' },
-- 20
    { image = 'iconPerks_unnervingPresence',            name_en = 'Unnerving Presence',             name_jp = '不安の元凶',                             name_de='Zermürbende Präsenz' },
    { image = 'iconPerks_unrelenting',                  name_en = 'Unrelenting',                    name_jp = '無慈悲',                                 name_de='Unerbittlich' },
    { image = 'iconPerks_whispers',                     name_en = 'Whispers',                       name_jp = '囁き',                                   name_de='GeflüsterGrausame Grenzen' },
    { image = 'Cannibal/iconPerks_BBQAndChili',         name_en = 'Barbecue & Chili',               name_jp = 'バーベキュー＆チリ',                     name_de='Barbecue und Chili' },
    { image = 'Wales/iconPerks_trailOfTorment',         name_en = 'Trail of Torment',               name_jp = '煩悶のトレイル',                         name_de='Pfad der Folter' },

    { image = 'Cannibal/iconPerks_franklinsLoss',       name_en = 'Franklin\'s Demise',             name_jp = 'フランクリンの悲劇',                     name_de='Franklins Niedergang' },
    { image = 'Cannibal/iconPerks_knockOut',            name_en = 'Knock Out',                      name_jp = 'ノックアウト',                           name_de='K.O.' },
    { image = 'DLC2/iconPerks_dyingLight',              name_en = 'Dying Light',                    name_jp = '消えゆく灯',                             name_de='Erlischendes Licht' },
    { image = 'DLC2/iconPerks_playWithYourFood',        name_en = 'Play with your Food',            name_jp = '弄ばれる獲物',                           name_de='Spiele mit deinem Essen' },
    { image = 'DLC2/iconPerks_saveTheBestForLast',      name_en = 'Save the best for Last',         name_jp = '最後のお楽しみ',                         name_de='Das Beste kommt zum Schluss' },
-- 30
    { image = 'DLC3/iconPerks_devourHope',              name_en = 'Hex: Devour Hope',               name_jp = '呪術・貪られる希望',                     name_de='Fluch: Aufgezehrte Hoffnung' },
    { image = 'DLC3/iconPerks_ruin',                    name_en = 'Hex: Ruin',                      name_jp = '呪術・破滅',                             name_de='Fluch: Ruin' },
    { image = 'DLC3/iconPerks_theThirdSeal',            name_en = 'Hex: The third Seal',            name_jp = '呪術・第三の封印',                       name_de='Fluch: Das dritte Siegel' },
    { image = 'DLC3/iconPerks_thrillOfTheHunt',         name_en = 'Hex: Thrill of the Hunt',        name_jp = '呪術・狩りの興奮',                       name_de='Fluch: Nervenkitzel der Jagd' },
    { image = 'DLC4/iconPerks_generatorOvercharge',     name_en = 'Generator Overcharge',           name_jp = 'オーバーチャージ',                       name_de='Überladen' },

    { image = 'DLC4/iconPerks_monitorAndAbuse',         name_en = 'Monitor and Abuse',              name_jp = '観察＆虐待',                             name_de='Beobachten und Zuschlagen' },
    { image = 'DLC4/iconPerks_overwhelmingPresence',    name_en = 'Overhelming Presence',           name_jp = '圧倒的存在感',                           name_de='Erdrückende Präsenz' },
    { image = 'DLC5/iconPerks_BeastOfPrey',             name_en = 'Beast of Prey',                  name_jp = '猛獣',                                   name_de='Raubtier' },
    { image = 'DLC5/iconPerks_HuntressLullaby',         name_en = 'Hex: Huntress Lullaby',          name_jp = '呪術・女狩人の子守歌',                   name_de='Fluch: Wiegenlied der Jägerin' },
    { image = 'DLC5/iconPerks_TerritorialImperative',   name_en = 'Territorial Imperative',         name_jp = '縄張り意識',                             name_de='Gebietszwang' },
-- 40
    { image = 'England/iconPerks_bloodWarden',          name_en = 'Blood Warden',                   name_jp = '血の番人',                               name_de='Blutwächter' },
    { image = 'England/iconPerks_fireUp',               name_en = 'Fire Up',                        name_jp = 'ファイヤー・アップ',                     name_de='Einheizen' },
    { image = 'England/iconPerks_rememberMe',           name_en = 'Rember Me',                      name_jp = 'リメンバー・ミー',                       name_de='Vergissmeinnicht' },
    { image = 'Finland/iconPerks_hangmansTrick',        name_en = 'Hangman\'s Trick',               name_jp = '処刑人の妙技',                           name_de='Henkerstreich' },
    { image = 'Finland/iconPerks_makeYourChoice',       name_en = 'Make your Choice',               name_jp = '選択は君次第だ',                         name_de='Triff deine Wahl' },

    { image = 'Finland/iconPerks_surveillance',         name_en = 'Surveillance',                   name_jp = '監視',                                   name_de='Überwachung' },
    { image = 'Guam/iconPerks_bamboozle',               name_en = 'Bamboozle',                      name_jp = 'まやかし',                               name_de='Verblüffen' },
    { image = 'Guam/iconPerks_coulrophobia',            name_en = 'Coulrophobia',                   name_jp = 'ピエロ恐怖症',                           name_de='Coulrophobie' },
    { image = 'Guam/iconPerks_popGoesTheWeasel',        name_en = 'Pop goes the Weasel',            name_jp = 'イタチが飛び出した',                     name_de='Pop Goes the Weasel' },
    { image = 'Haiti/iconPerks_hatred',                 name_en = 'Rancor',                         name_jp = '怨恨',                                   name_de='Hass' },
-- 50
    { image = 'Haiti/iconPerks_hauntedGround',          name_en = 'Hex: Haunted Ground',            name_jp = '呪術・霊障の地',                         name_de='Fluch: Heimgesuchter Boden' },
    { image = 'Haiti/iconPerks_spiritFury',             name_en = 'Spirit Fury',                    name_jp = '怨霊の怒り',                             name_de='Zorn des Gespensts' },
    { image = 'Kenya/iconPerks_discordance',            name_en = 'Discordance',                    name_jp = '不協和音',                               name_de='Uneinigkeit' },
    { image = 'Kenya/iconPerks_ironMaiden',             name_en = 'Iron Maiden',                    name_jp = 'アイアンメイデン',                       name_de='Eiserne Jungfrau' },
    { image = 'Kenya/iconPerks_madGrit',                name_en = 'Mad Grit',                       name_jp = '狂気の根性',                             name_de='Irrer Mut' },

    { image = 'Mali/iconPerks_corruptIntervention',     name_en = 'Corrupt Intervention',           name_jp = '堕落の介入',                             name_de='Korrupte Intervention' },
    { image = 'Mali/iconPerks_darkDevotion',            name_en = 'Dark Devotion',                  name_jp = '闇の信仰心',                             name_de='Dunkle Hingabe' },
    { image = 'Mali/iconPerks_infectiousFright',        name_en = 'Infectious Fright',              name_jp = '伝播する怖気',                           name_de='Infektiöse Angst' },
    { image = 'Oman/iconPerks_furtiveChase',            name_en = 'Furtive Chase',                  name_jp = '隠密の追跡',                             name_de='Heimliche Verfolgungsjagd' },
    { image = 'Oman/iconPerks_imAllEars',               name_en = 'I\'m all Ears',                  name_jp = '地獄耳',                                 name_de='Ich bin ganz Ohr' },
-- 60
    { image = 'Oman/iconPerks_thrillingTremors',        name_en = 'Thrilling Tremors',              name_jp = '戦慄',                                   name_de='Durchdringendes Zittern' },
    { image = 'Qatar/iconPerks_cruelConfinement',       name_en = 'Cruel Confinement',              name_jp = '無慈悲の極地',                           name_de='Grausame Grenzen' },
    { image = 'Qatar/iconPerks_mindBreaker',            name_en = 'Mind Breaker',                   name_jp = 'マインドブレーカー',                     name_de='Seelenbrecher' },
    { image = 'Qatar/iconPerks_surge',                  name_en = 'Surge',                          name_jp = 'サージ',                                 name_de='Spannungsstoß' },
    { image = 'Sweden/iconPerks_bloodEcho',             name_en = 'Blood Echo',                     name_jp = '血の共鳴',                               name_de='Blutecho' },

    { image = 'Sweden/iconPerks_nemesis',               name_en = 'Nemesis',                        name_jp = '天誅',                                   name_de='Nemesis' },
    { image = 'Sweden/iconPerks_zanshinTactics',        name_en = 'Zanshin Tactics',                name_jp = '残心の戦術',                             name_de='Zanshin-Taktik' },
    { image = 'Ukraine/iconPerks_deadManSwitch',        name_en = 'Dead Man Switch',                name_jp = '死人のスイッチ',                         name_de='Totenschalter' },
    { image = 'Ukraine/iconPerks_gearHead',             name_en = 'Gear Head',                      name_jp = '変速機',                                 name_de='Ausrüstungsspezi' },
    { image = 'Ukraine/iconPerks_hexRetribution',       name_en = 'Hex: Retribution',               name_jp = '呪術：報復',                             name_de='Fluch: Vergeltung' },
-- 70
    { image = 'Wales/iconPerks_deathbound',             name_en = 'Deathound',                      name_jp = 'デスバウンド',                           name_de='Todgeweiht' },
    { image = 'Wales/iconPerks_forcedPenance',          name_en = 'Forced Penance',                 name_jp = '強制苦行',                               name_de='Erzwungene Buße' },
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
        random_perks_config.loops = 0;
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
        if random_perks_config.loops == 1 then
            set_text("");
        end
        if random_perks_config.loops == 50 then
            if random_perks_config.language == '日本語' then
                local str = random_perks_config.random_perks[random_indexes[1]].name_jp;
                str = str .. "\n" ..  random_perks_config.random_perks[random_indexes[2]].name_jp;
                str = str .. "\n" .. random_perks_config.random_perks[random_indexes[3]].name_jp;
                str = str .. "\n" .. random_perks_config.random_perks[random_indexes[4]].name_jp;
                set_text(str);
            end
            if random_perks_config.language == 'Deutsch' then
                local str = random_perks_config.random_perks[random_indexes[1]].name_de;
                str = str .. "\n" ..  random_perks_config.random_perks[random_indexes[2]].name_de;
                str = str .. "\n" .. random_perks_config.random_perks[random_indexes[3]].name_de;
                str = str .. "\n" .. random_perks_config.random_perks[random_indexes[4]].name_de;
                set_text(str);
            end
            if random_perks_config.language ~= 'Deutsch' and random_perks_config.language ~= '日本語'  then
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
    obs.obs_property_list_add_string(p, "Deutsch", "de");
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
