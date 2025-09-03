#define BONFIRE_HEALING_POWER_SMALL 0.1
#define BONFIRE_HEALING_POWER_MEDIUM 0.33
#define BONFIRE_HEALING_POWER_HIGH 0.5

/obj/structure/bonfire
	var/sword = FALSE
	var/legendary_sword = FALSE
	var/healing_power = BONFIRE_HEALING_POWER_MEDIUM // ~ 1hp per second, check PROCESSING_SUBSYSTEM_DEF(aura)

/obj/structure/bonfire/examine(mob/user)
	. = ..()
	if(burning)
		if(legendary_sword)
			. += span_engradio("Раскаленный до красна клинок ярко сияет в густых языках пламени!")
		else if(sword)
			switch(healing_power)
				if(BONFIRE_HEALING_POWER_SMALL)
					. += span_engradio("Слабое пламя едва колышется от малейшего дуновения ветра...")
				if(BONFIRE_HEALING_POWER_MEDIUM)
					. += span_engradio("Умеренное пламя ощущается стабильным и спокойным.")
				if(BONFIRE_HEALING_POWER_HIGH)
					. += span_engradio("Пышные языки пламени бурно возносятся вверх!")

/obj/structure/bonfire/Destroy()
	if(sword)
		visible_message("<i>Клинок неожиданно рассыпается в прах...</i>")
	. = ..()

/obj/structure/bonfire/attackby(obj/item/W, mob/user, params) ///obj/item/melee/zweihander из сундуков
	if(istype(W, /obj/item/melee/smith/twohand/zweihander) && !can_buckle && !grill && !sword)
		if(!user.transferItemToLoc(W, src))
			return
		sword = TRUE
		to_chat(user, "<span class='italics'>Ты вонзаешь клинок в костер.")
		if(burning)
			set_restoration(TRUE)
		var/mutable_appearance/rod_underlay = mutable_appearance('icons/obj/hydroponics/equipment.dmi', "bonfire_rod")
		rod_underlay.pixel_y = 16
		underlays += rod_underlay
	else
		. = ..()

/obj/structure/bonfire/proc/set_restoration(state)
	if(state)
		for(var/mob/living/L in view(src, 1))
			to_chat(L, span_engradio("<span class='italics'>Ты ощущаешь необычное спокойствие и умиротворение от теплого костра..."))
		healing_power = initial(healing_power)
		var/obj/item/melee/smith/S = locate(/obj/item/melee/smith/twohand/zweihander) in contents
		if(S) // I don't use switch() because quality ranges in /dofinish() intercept and its really awful.
			if(isnull(S.quality)) // simply spawned
				healing_power = BONFIRE_HEALING_POWER_MEDIUM
			else if(S.quality <= -1) // awful - poor
				healing_power = BONFIRE_HEALING_POWER_SMALL
			else if(-1 < S.quality && S.quality < 5.5) // normal - good
				healing_power = BONFIRE_HEALING_POWER_MEDIUM
			else if(5.5 <= S.quality && S.quality < 10) // excellent - masterwork
				healing_power = BONFIRE_HEALING_POWER_HIGH
			else if(10 <= S.quality) //legendary
				healing_power = BONFIRE_HEALING_POWER_HIGH
				legendary_sword = TRUE
		if(!is_mining_level(get_turf(src)) && !is_away_level(get_turf(src))) // only for those who really need it
			healing_power /= 2
		AddComponent( \
						/datum/component/aura_healing, \
						range = 1, \
						brute_heal = healing_power, \
						burn_heal = healing_power, \
						toxin_heal = healing_power, \
						suffocation_heal = healing_power, \
						stamina_heal = healing_power, \
						blood_heal = healing_power, \
						organ_healing = list(ORGAN_SLOT_BRAIN = healing_power), \
						simple_heal = healing_power, \
						healing_color = COLOR_ORANGE, \
					)
	else
		var/datum/component/aura_healing/A = GetComponent(/datum/component/aura_healing)
		if(A)
			A.RemoveComponent()

// for(var/thing in human.all_wounds)
		// var/datum/wound/W = thing
		// W.remove_wound()

/obj/structure/bonfire/process()
	if(legendary_sword && prob(10))
		for(var/mob/living/carbon/human/H in view(src, 1))
			var/datum/wound/W = pick(H.all_wounds)
			if(W)
				W.remove_wound()
				break
	. = ..()

/obj/structure/bonfire/StartBurning()
	if(!burning && CheckOxygen())
		set_restoration(TRUE)
		if(legendary_sword)
			add_overlay(mutable_appearance('icons/obj/hydroponics/equipment.dmi', "bonfire_on_fire_intense", ABOVE_OBJ_LAYER))
	. = ..()

/obj/structure/bonfire/extinguish()
	if(sword)
		set_restoration(FALSE)
		if(legendary_sword)
			cut_overlay(mutable_appearance('icons/obj/hydroponics/equipment.dmi', "bonfire_on_fire_intense", ABOVE_OBJ_LAYER))
	. = ..()

#undef BONFIRE_HEALING_POWER_SMALL
#undef BONFIRE_HEALING_POWER_MEDIUM
#undef BONFIRE_HEALING_POWER_HIGH
