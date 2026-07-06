/datum/component/condom_clipping
	var/attached_condoms = 0
	var/max_attached_condoms = 50 // остановимся на юбилейном числе
	var/mutable_appearance/condom_overlay = null

/datum/component/condom_clipping/Initialize()
	if(!isclothing(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/condom_clipping/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, PROC_REF(clip_condom))

/datum/component/condom_clipping/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_PARENT_ATTACKBY)

/datum/component/condom_clipping/proc/clip_condom(datum/source, obj/item/genital_equipment/condom/condom, mob/living/user, mob/living/wearer)
	SIGNAL_HANDLER
	. = TRUE
	var/obj/item/clothing/C = parent
	if(source != C || !istype(condom) || !istype(user) || !user.canUseTopic(C, BE_CLOSE, ismonkey(user), NO_TK, FALSE))
		return FALSE
	if(attached_condoms >= max_attached_condoms)
		to_chat(user, span_warning("Уже некуда цеплять использованные презервативы..."))
		return FALSE
	if(condom.reagents?.total_volume > 0)
		if(user.transferItemToLoc(condom, C))
			attached_condoms++
			if((C.current_equipped_slot & C.slot_flags) && (user == wearer || C.loc == user))
				user.visible_message(span_love("[user] нацепляет использованный презерватив себе на [C.name]."))
			else
				user.visible_message(span_love("[user] нацепляет использованный презерватив на [C.name][istype(wearer) ? " на [wearer]" : ""]."))
		else
			to_chat(user, span_warning("Не удалось прицепить презерватив."))
			return FALSE
	else
		to_chat(user, span_warning("Прежде чем нацеплять презерватив на одежду, его необходимо использовать по назначению."))
		return FALSE
	if(attached_condoms == 1)
		condom_overlay = new /mutable_appearance(condom)
		condom_overlay.layer = -UNIFORM_LAYER
		condom_overlay.transform *= 0.5
		condom_overlay.pixel_x = 8
		condom_overlay.pixel_y = 8
		C.add_overlay(condom_overlay)

/datum/component/condom_clipping/proc/unclip_condom(mob/living/user)
	. = TRUE
	if(attached_condoms <= 0 || !istype(user) || !user.canUseTopic(parent, BE_CLOSE, ismonkey(user), NO_TK, FALSE))
		return FALSE
	var/obj/item/clothing/C = parent
	user.put_in_hands(locate(/obj/item/genital_equipment/condom) in C.contents)
	attached_condoms--
	if((C.current_equipped_slot & C.slot_flags) && ismob(C.loc))
		user.visible_message("[user] снимает использованный презерватив с [C.name] на [user == C.loc ? "себе" : C.loc].")
	else
		user.visible_message("[user] снимает использованный презерватив с [C.name].")
	if(attached_condoms <= 0)
		C.cut_overlay(condom_overlay)
		QDEL_NULL(condom_overlay)

//Я не буду отдельно просматривать тысячу типов одежды на ирл возможность зацепления использованных презервативов, все остается на совести игроков.
//Все остальное отыгрывается через пкм - custom examine text.

/obj/item/clothing/under/Initialize(mapload)
	. = ..()
	if(!GetComponent(/datum/component/storage)) // не собираюсь мудохаться с контейнерами.
		AddComponent(/datum/component/condom_clipping)

/obj/item/clothing/underwear/briefs/Initialize(mapload)
	. = ..()
	if(!GetComponent(/datum/component/storage))
		AddComponent(/datum/component/condom_clipping)

/obj/item/clothing/underwear/shirt/Initialize(mapload)
	. = ..()
	if(!GetComponent(/datum/component/storage))
		AddComponent(/datum/component/condom_clipping)

/obj/item/clothing/underwear/chastity_belt/Initialize(mapload)
	. = ..()
	if(!GetComponent(/datum/component/storage))
		AddComponent(/datum/component/condom_clipping)
