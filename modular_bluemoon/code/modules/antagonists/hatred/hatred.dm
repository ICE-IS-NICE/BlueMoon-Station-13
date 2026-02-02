/**
 * Данный антаг был вдоховлен игрою "Hatred" (2015).
 *
 * Краткое пояснение концепта антага и игромеханических решений:
 * 		Концепт: мажорный мидраунд антаг для хард динамика с целью моментального массового ПВП пиздореза. Почти как Lone Operative, но этот не должен
 * просто закончить раунд, убив капитана. Минимум манча и времени на разогрев. Только при существенном онлайне и с достаточным количеством живых офицеров СБ.
 * 		Хил от убийства других игроков: как и в оригинальной игре персонаж восстанавливает здоровье от кинематографичных убийств (glory kills) и это является
 * единственным способом востановить здоровье. Я полагаю и в сске оно будет выглядеть уместно и вполне сбалансированно. Игроку для восстановления
 * здоровья необходимо заставить живую цель не двигаться вплоть до ~10 секунд и убить её выстрелом вплотную для восстановления здоровья. Тем самым мы снижаем
 * градус ахуевания антага и заставляем его делать передышики и играть аккуратнее, ведь он один, всегда уязвим и не может прятаться в космосе или вне станции,
 * как делает абсолютное большинство антагов.
 * 		Оружие с бесконечными патронами: в оригинальной игре по локации разбросана куча других оружий, а также оружие щедро падает с бесконечных волн
 * полицейских. Но в сске у нас ограниченное количество СБ, поэтому рано или поздно антаг пойдет манчить себе оружие. Этот антаг создан для пиздореза,
 * а не получасового манча оружейки, поэтому я хочу свести к минимуму любой существенный манч.
 * 		"Прикрученное намертво" снаряжение: всё минимально необходимое снаряжение намертво прикручено к персонажу. Оно хорошо сбалансированно
 * для ведения продолжительных пвп битв, но не является читами и накладывает массу ограничений, поэтому при возможности игрок скинул бы свое снаряжение и
 * взял бы что-то более мощное, убийственное или полезное, например МОДсьюты или хардсьюты ЕРТшников, но я ему не позволю, ибо как сказано в предыдущем
 * пункте: это антаг не для манча, а для моментального пиздореза.
 *
 * Если будет востребованно, то я возможно сделаю:
 * 		- Антаг худ (квадратик над персонажем с иконкой роли)
 * 		- Счетчик убийств и вывод его в итоги раунда (здесь мне нужна помощь, я не знаю, как считать сочные фраги).
 * 			- минимум убийств для получения гринтекста.
 * 			- события после определенного кол-ва убийств
 * 		- Больше QOL фич, если у меня или других игроков будут хорошие и выполнимые идеи.
 */

//////////////////////////////////////////////
//                                          //
//            	 ANTAG BASE		            //
//                                          //
//////////////////////////////////////////////


/**
 * 		TODO
 * ak карман
 * дробовик
 * патроны для дробовика
 * запреты на стрельбу с других оружий?
 * новое оружие - super shotgun двустволка
 * ROLE_MASS_SHOOTER
 * проверка на спавнды в динамики
 * калибровка скорости, спросить у смайли конфиги?
 * русификация
 * есть ли у антагов свои тгуи окошки? Chetr nyy hagehguf naq ubabe Ratvar / open antag information: mafioso Цель Твоей Семьи | You have been provided with a standard uplink to accomplish your task.
 * Do not forget to prepare your spells
 * дубинка
 *
 *
 * 		DONE
 * +mood
 * +heal
 * +knife добвивания
 *
 *
 */




/datum/antagonist/hatred
	name = "Mass Shooter"
	antagpanel_category = "Mass Shooter"
	roundend_category = "Mass shooter"
	job_rank = ROLE_OPERATIVE
	// antag_moodlet = /datum/mood_event/focused
	suicide_cry = "I REGRET NOTHING."
	show_to_ghosts = TRUE
	show_in_antagpanel = TRUE
	// antag_hud_type = ANTAG_HUD_WIZ // TO BE ADDED
	// antag_hud_name = "wizard"
	// ui_name = "AntagInfoWizard"
	threat = 10
	can_coexist_with_others = FALSE
	// reminded_times_left = 1
	var/list/allowed_z_levels = list()
	/**
	 * Level of available gear is determined by a number of alive security officers and other conditions.
	 * 0 = low guns NOT IMPLEMENTED YET!
	 * 1 = default classic and serious guns
	 * 2 = high gear
	 */
	var/gear_level = 1
	var/list/classic_guns = list("AK47", "Riot Shotgun", "Pistols")
	// there won't be special level 2 guns, because I don't want antag to have cheat guns. Level 2 gear is always better stats/traits for level 1 gear.
	var/list/high_gear = list(/*"Belt of Hatred", */"More armor", "Faster executions")
	var/chosen_gun = null
	var/chosen_high_gear = null
	COOLDOWN_DECLARE(killing_speech_cd)
	var/list/killing_speech = list(	'modular_bluemoon/code/modules/antagonists/hatred/killing_speech/hatred_speech_1.ogg',
									'modular_bluemoon/code/modules/antagonists/hatred/killing_speech/hatred_speech_2.ogg',
									'modular_bluemoon/code/modules/antagonists/hatred/killing_speech/hatred_speech_3.ogg',
									'modular_bluemoon/code/modules/antagonists/hatred/killing_speech/hatred_speech_4.ogg',
									'modular_bluemoon/code/modules/antagonists/hatred/killing_speech/hatred_speech_5.ogg',
									'modular_bluemoon/code/modules/antagonists/hatred/killing_speech/hatred_speech_6.ogg',
									'modular_bluemoon/code/modules/antagonists/hatred/killing_speech/hatred_speech_7.ogg',
									'modular_bluemoon/code/modules/antagonists/hatred/killing_speech/hatred_speech_8.ogg',
									'modular_bluemoon/code/modules/antagonists/hatred/killing_speech/hatred_speech_9.ogg',
									'modular_bluemoon/code/modules/antagonists/hatred/killing_speech/hatred_speech_10.ogg',
									'modular_bluemoon/code/modules/antagonists/hatred/killing_speech/hatred_speech_11.ogg',
									'modular_bluemoon/code/modules/antagonists/hatred/killing_speech/hatred_speech_12.ogg',
									'modular_bluemoon/code/modules/antagonists/hatred/killing_speech/hatred_speech_13.ogg',
									'modular_bluemoon/code/modules/antagonists/hatred/killing_speech/hatred_speech_14.ogg'
									)
	// var/global/list/allowed_guns = list(/obj/item/gun/ballistic/automatic/ak47/hatred,
	// 									/obj/item/gun/ballistic/shotgun/riot/hatred,
	// 									/obj/item/gun/ballistic/automatic/pistol/m1911/hatred,
	// 									/obj/item/gun/ballistic/shotgun/doublebarrel/hatred_sawn_off
	// 									)
	var/global/list/nodrop_guns = list(/obj/item/gun/ballistic/automatic/ak47/hatred,
										/obj/item/gun/ballistic/shotgun/riot/hatred
										)
	var/list/items_with_hatred_traits = list() // for droppable items after killing mass shooter

/datum/antagonist/hatred/greet()
	var/greet_text
	greet_text += "Ты - [span_red(span_bold("Безымянный Массшутер"))]. Твое имя совершенно неважно. Твое прошлое даже если и было, оно было незавидным.<br>"
	greet_text += "Ты испытываешь непреодолимую ненависть, отвращение и презрение ко всем окружающим.<br>"
	greet_text += "У тебя лишь две цели: <u>убивать</u> и <u>умереть славной смертью</u>.<br>"
	greet_text += "Твое проклятое снаряжение неразлучно с тобою и подстегивает тебя продолжать соврешать геноцид беззащитных гражданских.<br>"
	greet_text += "Твоё [span_red("Оружие Ненависти")] и неутолимая жажда убивать вознаграждают тебя, ибо завершающий выстрел в упор в голову (рот) исцеляет твои раны, нож добивает быстрее и надежнее. [span_red("Обычная медицина бессильна")].<br>"
	if(chosen_gun == "Pistols")
		greet_text += "[span_red("Кобура Ненависти")] всегда готова предоставить тебе особое парное оружие (стрелять с двух рук - в харме). После использования можешь просто выбросить их, ибо их цель была выполнена.<br>"
	else
		greet_text += "[span_red("Cумка для патронов")] сама пополняет пустые магазины/картриджи/клипсы. Никогда не выбрасывай их!<br>"
	if(chosen_gun == "Riot Shotgun")
		greet_text += "В твоей кобуре спрятан [span_red("запасной дробовик")], чтобы у тебя всегда под рукой был План Б.<br>"
	if(!isnull(chosen_high_gear))
		greet_text += "[span_red("Пояс с гранатами")] пожирает сердца твоих жертв после их добивания и вознаграждает тебя новой взрывоопасной аммуницией.<br>"
	greet_text += "[span_red(span_bold("Убивай и будь убит!"))] Ибо никто сегодня не защищен от твоей Ненависти.<br>"
	to_chat(owner.current, greet_text)
	antag_memory = greet_text
	owner.announce_objectives()

/datum/antagonist/hatred/on_gain()
	var/mob/living/carbon/human/H = owner.current
	if(!istype(H))
		return
	make_authentic_body()
	evaluate_security()
	forge_objectives()
	H.Immobilize(INFINITY, ignore_canstun = TRUE)
	// H.Paralyze(INFINITY, TRUE)
	// H.SetParalyzed(0, TRUE)
	RegisterSignal(H, COMSIG_MOB_EQUIPPED_ITEM, PROC_REF(check_equipped_item)) // any knife we pick might be our deadliest weapon. also sets nodrop trait onto some weapons
	H.equipOutfit(/datum/outfit/hatred)
	. = ..()
	// var/datum/atom_hud/U = GLOB.huds[DATA_HUD_MEDICAL_BASIC]
	// U.add_hud_to(src)
	// H.add_movespeed_mod_immunities("hatred", /datum/movespeed_modifier/damage_slowdown)
	// H.add_movespeed_mod_immunities("hatred", /datum/movespeed_modifier/damage_slowdown_flying)
	H.add_movespeed_modifier(/datum/movespeed_modifier/hatred)
	// H.add_movespeed_mod_immunities("hatred", /datum/movespeed_modifier/sanity) // this doesn't work due to subtypes
	// Unpredictable mood changes makes it diffcult to balance antag's speed.
	var/datum/component/mood/mood = H.GetComponent(/datum/component/mood)
	mood?.mood_modifier = 0 //Basically nothing can change your mood
	// SPECIAL TRAITS
	ADD_TRAIT(H, TRAIT_SLEEPIMMUNE, "hatred") // I challenge you to a glorious fight!
	ADD_TRAIT(H, TRAIT_VIRUSIMMUNE, "hatred")
	ADD_TRAIT(H, TRAIT_NONATURALHEAL, "hatred")
	ADD_TRAIT(H, TRAIT_IGNOREDAMAGESLOWDOWN, "hatred")
	ADD_TRAIT(H, TRAIT_FEARLESS, "hatred")
	ADD_TRAIT(H, TRAIT_STRONG_GRABBER, "hatred") // This way player will have less problems with his targets run/crawl away during glory kills
	ADD_TRAIT(H, TRAIT_QUICKER_CARRY, "hatred")
	ADD_TRAIT(H, TRAIT_NODISMEMBER, "hatred") // if a player loses his arm, he won't be able to shoot nor drop his gun. it would be unplayable.
	ADD_TRAIT(H, TRAIT_FAST_PUMP, "hatred")
	H.mind.unconvertable = TRUE
	H.status_flags &= ~CANKNOCKDOWN // пкм батоном = автовин сб
	//EMP_PROTECT_CONTENTS
	// ADD_TRAIT(H, TRAIT_DRINKS_BLOOD, "hatred") // why not
	// ADD_TRAIT(H, TRAIT_NOSOFTCRIT, "hatred")
	// ADD_TRAIT(H, TRAIT_STUNIMMUNE, "hatred") // Doesn't work against stunbatons anyway :(
	//  GENERAL QUIRKS
	H.add_quirk(/datum/quirk/night_vision, FALSE)
	H.add_quirk(/datum/quirk/tough, FALSE)
	H.add_quirk(/datum/quirk/freerunning, FALSE)
	H.add_quirk(/datum/quirk/monochromatic, FALSE)
	H.add_quirk(/datum/quirk/high_pain_threshold, FALSE)
	// H.add_quirk(/datum/quirk/jumper, announce = FALSE) // ADD_TRAIT(H, TRAIT_JUMPER, "hatred")
	// ADD_TRAIT(H, TRAIT_EVIL, "hatred") // H.add_quirk(/datum/quirk/evil, announce = FALSE) // no unwanted post_add() text
	tgui_alert(H, "У тебя есть последняя минута, чтобы собраться с мыслями. Ознакомься с инструкциями в чате. Закрой это окошко когда будешь готов...", "Ты готов убивать?", list("Я готов убивать."), timeout = 1 MINUTES, autofocus = FALSE)
	RegisterSignal(H, COMSIG_MOB_DEATH, PROC_REF(on_hatred_death))
	// WE ARE READY.
	H.SetImmobilized(0, TRUE, TRUE)
	H.fully_heal() // in case of some accidents in spawn room during preparation
	mood?.setSanity(SANITY_NEUTRAL)
	appear_on_station()
	allowed_z_levels += SSmapping.levels_by_trait(ZTRAIT_CENTCOM)
	allowed_z_levels += SSmapping.levels_by_trait(ZTRAIT_RESERVED)
	allowed_z_levels += SSmapping.levels_by_trait(ZTRAIT_STATION)
	RegisterSignal(H, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(check_hatred_off_station)) // almost like anchor implant, but doesn't hurt
	// RegisterSignal(H, COMSIG_MOB_TRYING_TO_FIRE_GUN, PROC_REF(check_used_gun))
	playsound(H, pick('modular_bluemoon/code/modules/antagonists/hatred/hatred_begin_1.ogg', \
					'modular_bluemoon/code/modules/antagonists/hatred/hatred_begin_2.ogg', \
					'modular_bluemoon/code/modules/antagonists/hatred/hatred_begin_3.ogg'), vol = 100, vary = FALSE, ignore_walls = FALSE)
	addtimer(CALLBACK(src, PROC_REF(alarm_station)), 10 SECONDS, TIMER_DELETE_ME) // Give a player a moment to understand what's going on.

/datum/antagonist/hatred/on_removal()
	var/mob/living/L = owner.current
	UnregisterSignal(L, COMSIG_MOVABLE_Z_CHANGED)
	UnregisterSignal(L, COMSIG_MOB_EQUIPPED_ITEM)
	UnregisterSignal(L, COMSIG_MOB_DEATH)
	// UnregisterSignal(L, COMSIG_MOB_TRYING_TO_FIRE_GUN) can_trigger_gun
	. = ..()
	if(!QDELETED(L) && istype(L))
		to_chat(L, span_userdanger("As Hatred leaves your mind, it consumes you completely..."))
		L.dust(FALSE, FALSE, TRUE) // from ghosts we come, to ghosts we leave.
		// deathgasp doesn't appear during dust() so implant doesn't go boom.

/datum/antagonist/hatred/proc/on_hatred_death()
	SIGNAL_HANDLER
	switch(chosen_gun)
		if("AK47", "Riot Shotgun")
			for(var/obj/item/I in items_with_hatred_traits)
				REMOVE_TRAIT(I, TRAIT_NODROP, "hatred")
		if("Pistols")
			var/obj/item/clothing/suit/jacket/leather/overcoat/hatred/I = new(get_turf(owner.current))
			I.desc = "The blood stained shabby leather overcoat with decent armor paddings and special lightweight kevlar."
			addtimer(CALLBACK(I, TYPE_PROC_REF(/obj/item/clothing, repair)), 3 SECONDS, TIMER_DELETE_ME)

/datum/movespeed_modifier/hatred
	multiplicative_slowdown = 0.4

/datum/antagonist/hatred/proc/evaluate_security()
	var/gear_points = length(SSjob.get_living_sec())
	for(var/mob/living/carbon/human/player in GLOB.carbon_list)
		if(player.client && player.stat != DEAD && player.mind && (player.mind.assigned_role in list("Blueshield")))
			gear_points++
	if(GLOB.security_level == SEC_LEVEL_GREEN) // (GC) - у станции нет проблем и все внимание СБ будет приковано к антагу
		gear_points++
	if(length(active_ais(check_mind = TRUE))) // вертолеты
		gear_points++
	switch(gear_points)
		if(-INFINITY to 5) 	// 5
			gear_level = 1
		if(7 to INFINITY) 	// 7+
			gear_level = 2

/datum/antagonist/hatred/proc/make_authentic_body()
	var/mob/living/carbon/human/H = owner.current
	H.real_name = "The Man without a name"
	H.name = H.real_name
	H.dna.real_name = H.real_name
	H.mind?.name = H.real_name
	H.set_species(/datum/species/human)
	H.set_gender(MALE, TRUE, forced = TRUE)
	H.dna.remove_all_mutations()
	H.skin_tone = "albino"
	//H.hair_style = Curtains diagonal_bangs sunny vivi #000000 "Bonnie"
	H.hair_style = "Curtains"
	H.hair_color = sanitize_hexcolor("#000000")
	H.facial_hair_style = "Beard (3 o\'Clock)" //"Shaved"
	H.facial_hair_color = sanitize_hexcolor("#000000")
	H.set_bark("growl2")
	H.vocal_speed = 8
	H.vocal_pitch = 0.6
	H.vocal_pitch_range = 0.3
	H.dna.update_ui_block(DNA_GENDER_BLOCK)
	H.dna.update_ui_block(DNA_SKIN_TONE_BLOCK)
	H.dna.update_ui_block(DNA_HAIR_STYLE_BLOCK)
	H.dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
	H.dna.update_ui_block(DNA_FACIAL_HAIR_STYLE_BLOCK)
	H.dna.update_ui_block(DNA_FACIAL_HAIR_COLOR_BLOCK)
	H.dna.features["legs"] = "Plantigrade"
	H.dna.species.mutant_bodyparts["legs"] = "Plantigrade"
	H.Digitigrade_Leg_Swap(TRUE)
	H.update_body()
	H.update_hair()

/datum/antagonist/hatred/proc/forge_objectives()
	var/datum/objective/O = new /datum/objective/genocide()
	O.owner = owner
	objectives += O
	O = new /datum/objective/martyr()
	O.owner = owner
	objectives += O

/datum/objective/genocide
	name = "Genocide of civilians"
	explanation_text = "Убей столько народу, сколько успеешь за свою короткую оставшуюся жизнь. Не щади никого. Кровь слабых питает тебя."
	martyr_compatible = TRUE
	completed = TRUE // i have no idea how to count your personal kills.

/datum/antagonist/hatred/proc/appear_on_station()
	var/list/possible_spawns = list()
	// Method 1: find the most optimal maint turf
	for(var/i = 1; i <= 20; i++)
		var/turf/T = get_safe_random_station_turf(typesof(/area/maintenance) & GLOB.the_station_areas) // !!!
		if(istype(T))
			possible_spawns += T
		if(length(possible_spawns) >= 6) // enough
			break
	listclearnulls(possible_spawns)
	// Method 2 (if 1 failed): find the most optimal xeno maint spawn. Atmos problems are possible.
	for(var/turf/X in GLOB.xeno_spawn) //Some xeno spawns are in some spots that will instantly kill human, like atmos
		if(length(possible_spawns) < 6)
			if(istype(X.loc, /area/maintenance))
				possible_spawns += X
		else
			break
	listclearnulls(possible_spawns)
	// Method 3 (if 1 and 2 failed): find ANY safe station turf
	if(isemptylist(possible_spawns))
		possible_spawns += find_safe_turf(extended_safety_checks = TRUE, dense_atoms = FALSE) // in case of some huge map problems
	possible_spawns += get_safe_random_station_turf(typesof(/area/command/gateway)) // 1/7 is ~15%
	listclearnulls(possible_spawns)
	owner.current.forceMove(pick(possible_spawns))
	do_sparks(4, TRUE, owner.current)

/datum/antagonist/hatred/proc/check_hatred_off_station()
	SIGNAL_HANDLER
	var/turf/my_location = get_turf(owner.current)
	if(!(my_location.z in allowed_z_levels))
		to_chat(owner.current, span_userdanger("Так просто они от меня не избавятся..."))
		appear_on_station()

/datum/antagonist/hatred/proc/alarm_station() // major antag is currently commencing genocide, so we must let everyone know.
	if(istype(src) && owner?.current && owner?.current.stat != DEAD)
		var/chosen_sound = pick('modular_bluemoon/code/modules/antagonists/hatred/hatred_spawned_1.ogg','modular_bluemoon/code/modules/antagonists/hatred/hatred_spawned_2.ogg')
		priority_announce("На ваш объект ворвался особо опасный вооруженный преступник с целью массового убийства гражданских лиц. \
							Нейтрализуйте угрозу любыми доступными средствами. \
							ЦК санкционирует всему персоналу станции против данной цели: использование летального вооружения, открытие огня без предупреждения и казнь на месте. \
							\n\nОсобые приметы: мужчина спортивного телосложения в длинном черном кожаном пальто с длинными черными волосами и [chosen_gun].", \
							"ALERT: MASS SHOOTER!", chosen_sound, has_important_message = TRUE)

/// we check if we picked up a knife in our hand. if so, we listen to it when it strikes its target.
/datum/antagonist/hatred/proc/check_equipped_item(mob/source, obj/item/I, slot)
	SIGNAL_HANDLER
	if(ishuman(source) &&  slot == ITEM_SLOT_HANDS)
		if(istype(I, /obj/item/kitchen/knife))
			RegisterSignal(I, COMSIG_ITEM_DROPPED, PROC_REF(remove_knife_check_glory))
			RegisterSignal(I, COMSIG_ITEM_ATTACK, PROC_REF(knife_check_glory))
		else if(istype(I, /obj/item/gun) && ispath_in_list(I.type, nodrop_guns) && !HAS_TRAIT(I, TRAIT_NODROP))
			ADD_TRAIT(I, TRAIT_NODROP, "hatred")
			items_with_hatred_traits += I

/// once we don't hold a knife, we don't listen to it when it strikes.
/datum/antagonist/hatred/proc/remove_knife_check_glory(obj/item/kitchen/knife/K, mob/user)
	SIGNAL_HANDLER
	UnregisterSignal(K, COMSIG_ITEM_ATTACK)
	UnregisterSignal(K, COMSIG_ITEM_DROPPED)

/// if we strike a target and it meets certain criteria - we handle it in a special way.
/datum/antagonist/hatred/proc/knife_check_glory(obj/item/kitchen/knife/knife, mob/living/target_mob, mob/user, damage_multiplier)
	SIGNAL_HANDLER
	if(ishuman(target_mob) && ishuman(user) && target_mob != user)
		if(damage_multiplier == 100) // no need to check. the lethal strike is about to be blown.
			return
		var/mob/living/carbon/human/target = target_mob
		var/mob/living/carbon/human/killer = user
		// the target is dead and we want its heart for the Belt of Hatred.
		if(target.stat == DEAD && killer.zone_selected == BODY_ZONE_CHEST && target.get_bodypart(BODY_ZONE_CHEST))
			var/datum/wound/loss/dismembering = new
			dismembering.apply_dismember(target.get_bodypart(BODY_ZONE_CHEST))
		// the target is almost dead and we want to glory kill it with a knife.
		else if(!(target.stat in list(CONSCIOUS)) && killer.zone_selected == BODY_ZONE_PRECISE_MOUTH && !HAS_TRAIT(target, TRAIT_DULLAHAN) && target.get_bodypart(BODY_ZONE_HEAD))
			target.visible_message(span_warning("[killer] brings [knife] to [target]'s throat, ready to slit it open..."), \
									span_userdanger("[killer] brings [knife] to your throat, ready to slit it open..."))
			// it's a signal handler so we don't sleep
			INVOKE_ASYNC(src, PROC_REF(knife_glory_kill), knife, target, killer)
			return COMPONENT_CANCEL_ATTACK_CHAIN

/// target is in crit and about to be executed.
/datum/antagonist/hatred/proc/knife_glory_kill(obj/item/kitchen/knife/knife, mob/living/carbon/human/target, mob/living/carbon/human/killer)
	var/is_glory = TRUE
	// already dead bodies or npcs don't count
	// if((!target.client && ((world.time - target.lastclienttime) > 10 SECONDS)) || (target.stat == DEAD && ((world.time - target.timeofdeath) > 3 SECONDS)))
	if(/*!target.client || */target.stat == DEAD)
		is_glory = FALSE
	else if(COOLDOWN_FINISHED(src, killing_speech_cd))
		playsound(owner.current, pick(killing_speech), vol = 100, vary = FALSE, ignore_walls = FALSE)
		COOLDOWN_START(src, killing_speech_cd, 10 SECONDS)
	var/time_to_kill = chosen_high_gear == "Faster executions" ? 4 SECONDS : 6 SECONDS
	if(do_after(killer, time_to_kill, target))
		target.visible_message(span_warning("[killer] slits [target]'s throat!"), span_userdanger("[killer] slits your throat!"))
		knife.melee_attack_chain(killer, target, damage_multiplier = 100)
		while(!QDELETED(target) && target.stat != DEAD && killer.CanReach(target, knife))
			if(!do_after(killer, 0.5 SECONDS, target))
				break
			if(knife.melee_attack_chain(killer, target, damage_multiplier = 100) & STOP_ATTACK_PROC_CHAIN)
				break
		if(is_glory)
			addtimer(CALLBACK(knife, TYPE_PROC_REF(/obj/item/kitchen/knife, check_glory_kill), killer, target), 1 SECONDS, TIMER_DELETE_ME)
	else
		target.visible_message(span_notice("[killer] stopped his knife."), span_notice("[killer] stopped his knife!"))

// /datum/antagonist/hatred/proc/check_used_gun(mob/living/carbon/human/H, obj/item/gun/G, target, flag, params)
// 	SIGNAL_HANDLER
// 	if(is_type_in_list(G, allowed_guns))
// 		return
// 	else
// 		to_chat(H, span_userdanger("You have no need for this. You have your own killing machines."))
// 		return COMPONENT_CANCEL_GUN_FIRE

/obj/item/gun/handle_suicide(mob/living/carbon/human/user, mob/living/carbon/human/target, params, bypass_timer, time_to_kill = 12 SECONDS)
	var/datum/antagonist/hatred/Ha = user.mind?.has_antag_datum(/datum/antagonist/hatred)
	if(!Ha || !ishuman(target))
		return ..()
	if(!target.get_bodypart(BODY_ZONE_HEAD))
		return
	var/is_glory = TRUE
	// already dead bodies or npcs don't count
	// if((!target.client && ((world.time - target.lastclienttime) > 10 SECONDS)) || (target.stat == DEAD && ((world.time - target.timeofdeath) > 3 SECONDS)))
	if(/*!target.client || */target?.stat == DEAD)
		is_glory = FALSE
	else if(COOLDOWN_FINISHED(Ha, killing_speech_cd))
		playsound(user, pick(Ha.killing_speech), vol = 100, vary = FALSE, ignore_walls = FALSE)
		COOLDOWN_START(Ha, killing_speech_cd, 10 SECONDS)
	var/new_ttk = Ha.chosen_high_gear == "Faster executions" ? 6 SECONDS : 8 SECONDS
	. = ..(user, target, params, bypass_timer, time_to_kill = new_ttk)
	if(!. || user == target || !is_glory)
		return
	addtimer(CALLBACK(src, PROC_REF(check_glory_kill), user, target), 1 SECONDS, TIMER_DELETE_ME) // wait for boolet to do its job

/obj/item/proc/check_glory_kill(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if((QDELETED(target) || target?.stat == DEAD) && !QDELETED(user) && user?.stat != DEAD)
		user.fully_heal(TRUE) // the only way of healing
		// user.do_adrenaline(150, TRUE, 0, 0, TRUE, list(/datum/reagent/medicine/inaprovaline = 10, /datum/reagent/medicine/synaptizine = 15, /datum/reagent/medicine/regen_jelly = 20, /datum/reagent/medicine/stimulants = 20), "<span class='boldnotice'>You feel a sudden surge of energy!</span>")
		user.visible_message("The blood of the weak gives [user] an inhuman relief and strength to continue the massacre.")
		var/obj/item/storage/belt/military/assault/hatred/B = user.get_item_by_slot(ITEM_SLOT_BELT)
		if(istype(B))
			to_chat(user, span_notice("[B.name] hungrily growls in anticipation of the coming sacrifice."))
			B.glory_points++

//////////////////////////////////////////////
//                                          //
//                	 GEAR		            //
//                                          //
//////////////////////////////////////////////

/// AK-47 GEAR ///

/obj/item/gun/ballistic/automatic/ak47/hatred
	name = "\improper AK-47 rifle of Hatred"
	desc = "The scratches on this rifle say: \"The Genocide Machine\"."
	resistance_flags = FIRE_PROOF | ACID_PROOF
	max_integrity = 400 // will be damaged during antag's death implant detonation
	weapon_weight = WEAPON_HEAVY
	// 100% = 28

/obj/item/gun/ballistic/automatic/ak47/hatred/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(src, TRAIT_NODROP))
		. += span_danger("You cannot make your fingers drop this weapon of Doom.")

/// SHOTGUN GEAR ///

/obj/item/gun/ballistic/shotgun/riot/hatred
	name = "\improper Riot Shotgun of Hatred"
	desc = "The scratches on this shotgun say: \"The Bringer of Doom\"."
	icon_state = "wood_riotshotgun"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/hatred_riot
	resistance_flags = FIRE_PROOF | ACID_PROOF
	max_integrity = 400 // will be damaged during antag's death implant detonation
	fire_delay = 4
	unique_reskin = null
	var/quick_empty_flag = FALSE // is user quick emptying it right now

/obj/item/ammo_box/magazine/internal/shot/hatred_riot
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot
	max_ammo = 7 // 7+1 = 2 clips

/obj/item/gun/ballistic/shotgun/riot/hatred/examine(mob/user)
	. = ..()
	. += span_notice("[span_bold("Ctrl-Shift-Click")] to quickly empty [src].")
	if(HAS_TRAIT(src, TRAIT_NODROP))
		. += span_danger("You cannot make your fingers drop this weapon of Doom.")

/obj/item/gun/ballistic/shotgun/riot/hatred/CtrlShiftClick(mob/living/carbon/human/user)
	if(!quick_empty_flag)
		quick_empty_flag = TRUE
		pump(user, TRUE)
		while(chambered)
			stoplag(3) // a bit slower than TRAIT_FAST_PUMP
			pump(user, TRUE)
		quick_empty_flag = FALSE

/obj/item/gun/ballistic/revolver/doublebarrel/sawn/hatred
	name = "\proper The \"Plan B\""
	desc = "The scratches on this sawn-off double-barreled shotgun say: \"Plan B\"."
	resistance_flags = FIRE_PROOF | ACID_PROOF
	mag_type = /obj/item/ammo_box/magazine/internal/shot/hatred_dual
	// copy-paste from proc/sawoff() since we don't have existing solutions.
	// sawn_off = TRUE
	// spread = -100 // will become ~0 during math things. we do it to reduce sawn_off spread.
	// w_class = WEIGHT_CLASS_NORMAL
	// weapon_weight = WEAPON_MEDIUM
	// lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	// righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	// inhand_x_dimension = 32
	// inhand_y_dimension = 32
	// inhand_icon_state = "gun"
	// worn_icon_state = "gun"
	// slot_flags = ITEM_SLOT_BELT
	// recoil = SAWN_OFF_RECOIL

/obj/item/ammo_box/magazine/internal/shot/hatred_dual
	ammo_type = /obj/item/ammo_casing/shotgun/frangible
	max_ammo = 2

/obj/item/storage/belt/holster/hatred_sawn_off
	name = "\proper The \"Plan B\" Holster"
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/storage/belt/holster/hatred_sawn_off/Initialize(mapload)
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = INFINITY // only for weight calculations. it still has type and slots limits
	STR.display_numerical_stacking = FALSE
	STR.max_items = 1
	STR.quickdraw = FALSE // иначе невозможно зарядить с nodrop
	STR.can_hold = typecacheof(list(/obj/item/gun/ballistic/revolver/doublebarrel/sawn/hatred))
	new /obj/item/gun/ballistic/revolver/doublebarrel/sawn/hatred(src)

/// PISTOLS GEAR ///

/obj/item/gun/ballistic/automatic/pistol/m1911/hatred // enforcer?
	name = "\proper M1911 of Hatred"
	desc = "The scratches on this pistol say: \"The Executioner\"."
	resistance_flags = FIRE_PROOF | ACID_PROOF
	// 100% = 30
	// 90% = 27
	// 80% = 24
	projectile_damage_multiplier = 0.85
	dual_wield_spread = 5
	var/mob/living/carbon/human/original_owner = null

/obj/item/gun/ballistic/automatic/pistol/m1911/hatred/equipped(mob/user, slot, initial)
	. = ..()
	if(isnull(original_owner) && ishuman(loc) && slot == ITEM_SLOT_HANDS)
		original_owner = loc

/obj/item/gun/ballistic/automatic/pistol/m1911/hatred/dropped(mob/user, silent)
	. = ..()
	if(!QDELETED(src))
		addtimer(CALLBACK(src, PROC_REF(check_destroy_pistol), user), 3 SECONDS, TIMER_DELETE_ME)

/obj/item/gun/ballistic/automatic/pistol/m1911/hatred/proc/check_destroy_pistol(mob/user)
	if(!QDELETED(src) && original_owner != loc)
		visible_message("[src] рассыпается в прах на ваших глазах...")
		var/obj/effect/decal/cleanable/ash/ash = new /obj/effect/decal/cleanable/ash(get_turf(loc))
		ash.pixel_z = -5
		ash.pixel_w = rand(-1, 1)
		qdel(src)

/obj/item/gun/ballistic/automatic/pistol/m1911/hatred/shoot_with_empty_chamber(mob/living/user)
	. = ..()
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.dropItemToGround(src, force = TRUE, silent = FALSE)
		H.visible_message("[H] nonchalantly drops his empty pistol on the ground as soon as he makes a last shot.")
	var/obj/item/gun/ballistic/automatic/pistol/m1911/hatred/second = user.get_inactive_held_item()
	if(istype(second, type))
		if(!second.can_shoot() || !second.chambered || !second.chambered.BB)
			addtimer(CALLBACK(second, TYPE_PROC_REF(/obj/item/gun, shoot_with_empty_chamber), user), 2)

/obj/item/storage/belt/holster/hatred
	name = "\proper Holster of Hatred"
	desc = "The cursed holster is always ready to supply you with new tools of Genocide."
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/storage/belt/holster/hatred/Initialize(mapload)
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = INFINITY // only for weight calculations. it still has type and slots limits
	STR.display_numerical_stacking = FALSE
	STR.max_items = 2
	STR.quickdraw = TRUE
	STR.can_hold = typecacheof(list(/obj/item/gun/ballistic/automatic/pistol/m1911/hatred))
	new /obj/item/gun/ballistic/automatic/pistol/m1911/hatred(src)
	new /obj/item/gun/ballistic/automatic/pistol/m1911/hatred(src)

/obj/item/storage/belt/holster/hatred/examine(mob/user)
	. = ..()
	. += span_notice("[span_bold("Alt-Click")] to quick-equip pistols into empty hands.")

/obj/item/storage/belt/holster/hatred/equipped(mob/user, slot)
	. = ..()
	if(slot in list(ITEM_SLOT_BELT, ITEM_SLOT_SUITSTORE))
		ADD_TRAIT(src, TRAIT_NODROP, "hatred")

/obj/item/storage/belt/holster/hatred/dropped(mob/user, silent)
	. = ..()
	if(!QDELETED(src))
		visible_message("[src] рассыпается в прах на ваших глазах...")
		qdel(src)

/obj/item/storage/belt/holster/hatred/Exited(atom/movable/gone, direction)
	. = ..()
	if(!QDELETED(src))
		new /obj/item/gun/ballistic/automatic/pistol/m1911/hatred(src)
		// atom_storage.refresh_views()
		// update_appearance()

/// THE POUCH OF HATRED ///

/obj/item/storage/bag/ammo/hatred
	name = "\improper Ammo pouch of Hatred"
	desc = "The cursed pouch with infinite bullets encourage you to relentlessly continue your atrocities against humanity. What a miracle and delight for your Genocide Machines."
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/storage/bag/ammo/hatred/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = INFINITY // only for weight calculations. it still has type and slots limits
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.display_numerical_stacking = FALSE
	STR.attack_hand_interact = FALSE // TRAIT_NODROP
	STR.quickdraw = FALSE

/obj/item/storage/bag/ammo/hatred/examine(mob/user)
	. = ..()
	. += "If you place an empty magazine/clip into this phenomenal pouch next time you check it will be filled with bullets."
	. += span_notice("[span_bold("Alt-Click")] to open.")
	. += span_notice("Once you lose this item it will turn into dust.")

/obj/item/storage/bag/ammo/hatred/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	var/M = AM.type
	qdel(AM)
	new M(src)

// TRAIT_NODROP doesn't work on items in pockets T_T
/obj/item/storage/bag/ammo/hatred/MouseDrop(atom/over, src_location, over_location, src_control, over_control, params)

/obj/item/storage/bag/ammo/hatred/equipped(mob/user, slot, initial)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, "hatred")

/obj/item/storage/bag/ammo/hatred/dropped(mob/user, silent)
	. = ..()
	if(!QDELETED(src))
		visible_message("[src] рассыпается в прах на ваших глазах...")
		qdel(src)

/// THE BELT OF HATRED ///

/obj/item/storage/belt/military/assault/hatred
	name = "\improper Belt of Hatred"
	desc = "The cursed belt eagerly devours hearts of your victims and supplies you with new deadly explosives."
	resistance_flags = FIRE_PROOF | ACID_PROOF
	var/glory_points = 0

/obj/item/storage/belt/military/assault/hatred/examine(mob/user)
	. = ..()
	. += "If you place a heart into this phenomenal belt next time you check there will be no heart but a deadly explosive."
	. += span_notice("[src] is ready to accept [span_bold("[glory_points]")] hearts. Get more Glory Kills to make it accept more.")
	. += span_notice("Once you lose this item it will turn into dust.")

/obj/item/storage/belt/military/assault/hatred/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	if(istype(AM, /obj/item/organ/heart) && glory_points)
		glory_points--
		qdel(AM)
		switch(rand(1,3))
			if(1)
				new /obj/item/grenade/syndieminibomb/concussion(src)
			if(2)
				new /obj/item/grenade/frag(src)
			if(3)
				var/obj/item/reagent_containers/food/drinks/bottle/molotov/mol = new /obj/item/reagent_containers/food/drinks/bottle/molotov(src)
				mol.reagents.add_reagent(/datum/reagent/consumable/ethanol/vodka, 100)

/obj/item/storage/belt/military/assault/hatred/equipped(mob/user, slot, initial)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, "hatred")

/obj/item/storage/belt/military/assault/hatred/dropped(mob/user, silent)
	. = ..()
	if(!QDELETED(src))
		visible_message("[src] рассыпается в прах на ваших глазах...")
		qdel(src)

/// THE OVERCOAT OF HATRED ///

/obj/item/clothing/suit/jacket/leather/overcoat/hatred
	name = "leather overcoat of Hatred"
	desc = "The shabby leather overcoat with decent armor paddings. Once it has been splashed with blood you can't take it off anymore."
	resistance_flags = FIRE_PROOF
	// clueless armor stats.
	armor = list(MELEE 	= 40, \
				BULLET 	= 40, \
				LASER 	= 40, \
				ENERGY 	= 40, \
				BOMB 	= 40, \
				BIO 	= 40, \
				RAD 	= 20, \
				FIRE 	= 70, \
				ACID 	= 70, \
				WOUND 	= 40)

/obj/item/clothing/suit/jacket/leather/overcoat/hatred/Initialize(mapload)
	. = ..()
	allowed += list(/obj/item/storage/belt/holster, /obj/item/gun)

/obj/item/clothing/head/invisihat/hatred
	name = "Veil of Hatred"
	desc = "Once you felt <b><i>that</i></b> urge to commit relentless genocide of civilians, you clearly understood you were cursed... blessed... and... protected by invisible Veil of Hatred."
	resistance_flags = FIRE_PROOF | ACID_PROOF
	// clueless armor stats.
	armor = list(MELEE 	= 40, \
				BULLET 	= 40, \
				LASER 	= 40, \
				ENERGY 	= 40, \
				BOMB 	= 40, \
				BIO 	= 40, \
				RAD 	= 20, \
				FIRE 	= 70, \
				ACID 	= 70, \
				WOUND 	= 40)

/obj/item/clothing/head/invisihat/hatred/equipped(mob/user, slot)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, "hatred")

/obj/item/clothing/head/invisihat/hatred/dropped(mob/user)
	. = ..()
	if(!QDELETED(src))
		visible_message("[src] рассыпается в прах на ваших глазах...")
		qdel(src)

/// OUTFIT ///
/// defult gear. will be changed during pre_equip().
/datum/outfit/hatred
	name = "Hatred"
	head = /obj/item/clothing/head/invisihat/hatred
	glasses = /obj/item/clothing/glasses/hud/health/sunglasses/aviators // to help player identify when a target is in crit so player can safely execute him
	uniform = /obj/item/clothing/under/rank/civilian/util/greyshirt
	suit = /obj/item/clothing/suit/jacket/leather/overcoat/hatred
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	shoes = /obj/item/clothing/shoes/jackboots/tall_default
	id = /obj/item/card/id/stowaway_stolen
	belt = /obj/item/storage/belt/military/assault
	back = /obj/item/storage/backpack/rucksack
	backpack_contents = list(/obj/item/storage/box/survival/engineer = 1,
		/obj/item/kitchen/knife/combat = 1,
		/obj/item/flashlight/seclite = 1,
		/obj/item/crowbar = 1
		)
	implants = list(/obj/item/implant/explosive) // post_equip() doesn't work for implants since implanting occurs afrer post_equip()

/datum/outfit/hatred/pre_equip(mob/living/carbon/human/H, visualsOnly, client/preference_source)
	var/datum/antagonist/hatred/Ha = H.mind?.has_antag_datum(/datum/antagonist/hatred)
	if(!Ha)
		return
	// Ha.gear_level = tgui_input_list(H, "ЭТО ОКОШКО ДЛЯ ОБМАНА ПОДСЧЕТА ОФИЦЕРОВ В РАУНДЕ И НУЖНО ТОЛЬКО ДЛЯ ДЕБАГА, В ИГРЕ ЕГО НЕ БУДЕТ", "gear level?", list(1, 2), 1)
	var/available_sets = Ha.classic_guns
	SEND_SOUND(H, 'sound/misc/notice2.ogg')
	Ha.chosen_gun = tgui_input_list(H, "Выбери стартовое оружие и сделай это БЫСТРО!", "Выбери оружие геноцида", available_sets, available_sets[1], 10 SECONDS)
	if(!Ha.chosen_gun)
		Ha.chosen_gun = available_sets[1]
	switch(Ha.chosen_gun)
		if("AK47")
			r_hand = /obj/item/gun/ballistic/automatic/ak47/hatred
			l_pocket = /obj/item/storage/bag/ammo/hatred
		if("Riot Shotgun")
			r_hand = /obj/item/gun/ballistic/shotgun/riot/hatred
			suit_store = /obj/item/storage/belt/holster/hatred_sawn_off
			l_pocket = /obj/item/storage/bag/ammo/hatred
		if("Pistols")
			suit_store = /obj/item/storage/belt/holster/hatred
			ADD_TRAIT(H, TRAIT_DOUBLE_TAP, "hatred")
	if(Ha.gear_level == 2)
		belt = /obj/item/storage/belt/military/assault/hatred
		Ha.chosen_high_gear = tgui_input_list(H, "Выбери дополнительную экипировку и сделай это БЫСТРО!", "Выбери оружие геноцида", Ha.high_gear, Ha.high_gear[1], 10 SECONDS)
		if(!Ha.chosen_high_gear)
			Ha.chosen_high_gear = Ha.high_gear[1]

/datum/outfit/hatred/post_equip(mob/living/carbon/human/H, visualsOnly, client/preference_source)
	// var/obj/item/implant/explosive/E = new
	// E.implant(H)
	var/obj/item/clothing/under/U = H.get_item_by_slot(ITEM_SLOT_ICLOTHING)
	U.has_sensor = NO_SENSORS
	U.resistance_flags = FIRE_PROOF | ACID_PROOF
	U.unique_reskin = null
	ADD_TRAIT(U, TRAIT_NODROP, "hatred")

	var/obj/item/I = H.get_item_by_slot(ITEM_SLOT_FEET)
	I.resistance_flags = FIRE_PROOF

	I = H.get_item_by_slot(ITEM_SLOT_EYES)
	I.resistance_flags = FIRE_PROOF

	I = H.get_item_by_slot(ITEM_SLOT_GLOVES)
	I.resistance_flags = FIRE_PROOF

	I = H.get_item_by_slot(ITEM_SLOT_BACK)
	I.resistance_flags = FIRE_PROOF

	var/obj/item/storage/belt/B = H.get_item_by_slot(ITEM_SLOT_BELT)
	new /obj/item/grenade/syndieminibomb/concussion(B)
	new /obj/item/grenade/frag(B)
	var/obj/item/reagent_containers/food/drinks/bottle/molotov/mol = new /obj/item/reagent_containers/food/drinks/bottle/molotov(B)
	mol.reagents.add_reagent(/datum/reagent/consumable/ethanol/vodka, 100)
	new /obj/item/lighter/contractor(B)

	var/datum/antagonist/hatred/Ha = H.mind?.has_antag_datum(/datum/antagonist/hatred)
	if(!Ha)
		return
	switch(Ha.chosen_gun)
		if("AK47")
			var/obj/item/storage/bag/ammo/hatred/P = H.get_item_by_slot(ITEM_SLOT_LPOCKET)
			var/datum/component/storage/STR = P.GetComponent(/datum/component/storage)
			STR.can_hold = typecacheof(list(/obj/item/ammo_box/magazine/ak47))
			STR.max_items = 3
			new /obj/item/ammo_box/magazine/ak47(P)
			new /obj/item/ammo_box/magazine/ak47(P)
		if("Riot Shotgun")
			var/obj/item/storage/bag/ammo/hatred/P = H.get_item_by_slot(ITEM_SLOT_LPOCKET)
			var/datum/component/storage/STR = P.GetComponent(/datum/component/storage)
			STR.can_hold = typecacheof(list(/obj/item/ammo_box/shotgun/loaded))
			STR.max_items = 5
			new /obj/item/ammo_box/shotgun/loaded/buckshot(P)
			new /obj/item/ammo_box/shotgun/loaded(P)
			new /obj/item/ammo_box/shotgun/loaded/incendiary(P)
			// new /obj/item/ammo_casing/shotgun/dragonsbreath(P)
			new /obj/item/ammo_box/shotgun/loaded/frangible(P)
			new /obj/item/ammo_box/shotgun/loaded/flechette(P)
		if("Pistols")
			I = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
			I.resistance_flags = FIRE_PROOF | ACID_PROOF // to prevent the holster of Hatred to be dropped and lost forever.

	switch(Ha.chosen_high_gear)
		if("More armor")
			var/obj/item/clothing/C = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
			C.armor.modifyAllRatings(10)
			C = H.get_item_by_slot(ITEM_SLOT_HEAD)
			C.armor.modifyAllRatings(10)

/// DYNAMIC THINGS ///

/datum/dynamic_ruleset/midround/from_ghosts/hatred
	name = "Mass Shooter"
	antag_datum = /datum/antagonist/hatred
	antag_flag = "Mass Shooter"
	antag_flag_override = ROLE_OPERATIVE
	// enemy_roles = list("Blueshield", "Peacekeeper", "Brig Physician", "Security Officer", "Warden", "Detective", "Head of Security","Bridge Officer", "Captain")
	// required_enemies = list(0,0,0,0,5,5,4,4,3,0)
	required_round_type = list(ROUNDTYPE_DYNAMIC_HARD)
	required_candidates = 1
	weight = 9
	cost = 10
	// minimum_players = 50 // security alive check is more than enough, but there must be a bare minimum of players
	// requirements = list(101,101,101,101,101,101,60,40,30,10) // I'm not sure how this works and I don't trust it.
	repeatable = FALSE // one man is enough to shake this station.
	// makeBody = FALSE
	// var/list/spawn_locs = list()

/datum/dynamic_ruleset/midround/from_ghosts/hatred/ready(forced = FALSE)
	. = ..()
	if(. && !forced)
		if(length(SSjob.get_living_sec()) < 5) // я желаю достойного сопротивления.
			return FALSE

/datum/dynamic_ruleset/midround/from_ghosts/hatred/generate_ruleset_body(mob/applicant)
	// var/turf/entry_spawn_loc
	// if(length(GLOB.newplayer_start))
	// 	entry_spawn_loc = pick(GLOB.newplayer_start)
	// else
	// 	entry_spawn_loc = get_safe_random_station_turf(typesof(/area/centcom/evac))
	var/mob/living/carbon/human/body = new(GET_ERROR_ROOM)
	body.dna.remove_all_mutations()
	var/datum/mind/player_mind = new /datum/mind(applicant.key)
	player_mind.active = TRUE
	player_mind.transfer_to(body)
	message_admins("[ADMIN_LOOKUPFLW(body)] has been made into a Mass Shooter by the midround ruleset.")
	log_game("DYNAMIC: [key_name(body)] was spawned as a Mass Shooter by the midround ruleset.")
	return body

/datum/admins/proc/makeMassShooter()
	var/list/mob/candidates = pollGhostCandidates("Do you wish to be considered for the position of a Mass Shooter?", ROLE_OPERATIVE)
	var/mob/applicant = pick_n_take(candidates)
	// var/turf/entry_spawn_loc
	// if(length(GLOB.newplayer_start))
	// 	entry_spawn_loc = pick(GLOB.newplayer_start)
	// else
	// 	entry_spawn_loc = get_safe_random_station_turf(typesof(/area/centcom/evac))
	var/mob/living/carbon/human/body = new(GET_ERROR_ROOM)
	body.dna.remove_all_mutations()
	var/datum/mind/player_mind = new /datum/mind(applicant.key)
	player_mind.active = TRUE
	player_mind.transfer_to(body)
	body.mind.make_MassShooter()
	return TRUE

/datum/mind/proc/make_MassShooter()
	if(!has_antag_datum(/datum/antagonist/hatred))
		special_role = "Mass Shooter"
		assigned_role = "Mass Shooter"
		add_antag_datum(/datum/antagonist/hatred)
