/obj/item/smithing/coiled_sword
	name = "raw coiled sword"
	icon = 'modular_splurt/icons/obj/smith.dmi'
	icon_state = "coiled_raw"
	finishingitem = /obj/item/stack/ore/glass/basalt
	finalitem = /obj/item/melee/smith/coiled_sword
	var/heated_in_lava = FALSE

/obj/item/smithing/coiled_sword/examine(mob/user)
	. = ..()
	if(!heated_in_lava)
		. += "Этот клинок выглядит практически завершенным, однако лишь кипящая лава позволит раскрыть его истинный потенциал."

/obj/item/smithing/coiled_sword/attackby(obj/item/I, mob/user)
	if(istype(I, finishingitem) && !heated_in_lava)
		to_chat(user, "Прежде чем покрывать витой меч пеплом, его требуется окунуть в кипящую лаву. Только она поможет ракрыть его потенциал.")
		return
	else
		. = ..()

/obj/item/smithing/coiled_sword/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(islava(target) && proximity_flag)
		visible_message("[user] погружает конец витого меча в кипящую лаву...")
		if(do_after(user, 10 SECONDS, target))
			visible_message("... и вынимает - конец клинка излучает томную пылающую ауру.")
			heated_in_lava = TRUE
		else
			visible_message("... но вынимает его слишком рано и клинок заметно тускнеет.")
			quality -= 2

/obj/item/smithing/coiled_sword/startfinish()
	var/obj/item/melee/smith/coiled_sword/finalforreal = new /obj/item/melee/smith/coiled_sword(src)
	finalforreal.quality = quality
	finalforreal.force += quality
	finalforreal.flame_power = max(1, (finalforreal.flame_power + quality)) // 1 to 10+
	finalitem = finalforreal
	..()

/obj/item/melee/smith/coiled_sword
	name = "coiled sword"
	icon = ''
	icon_state = "coiled"
	overlay_state = "flame_end"
	force = 4
	item_flags = NEEDS_PERMIT
	sharpness = SHARP_EDGED
	light_power = 0.5
	light_color = LIGHT_COLOR_FIRE
	var/flame_power = 1 // 1 to 10+

/obj/item/melee/smith/coiled_sword/Initialize(mapload)
	. = ..()
	set_light(2)

/obj/item/melee/smith/coiled_sword/examine(mob/user)
	. = ..()
	. += "Вонзи этот томно тлеющий витой меч в горстку вулканического пепла, чтобы пробудить его [span_engradio("<i>предназначение</i>")]."

/obj/item/melee/smith/coiled_sword/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(istype(target, /obj/item/stack/ore/glass/basalt) && proximity_flag)
		var/obj/item/stack/ore/glass/basalt/B = target
		if(B.use(10))
			if(user.temporarilyRemoveItemFromInventory(src))
				visible_message("<i>[user] вонзает витой меч в вулканический пепел.</i>")
				var/obj/structure/bonfire/prelit/ash/A = new /obj/structure/bonfire/prelit/ash(get_turf(target))
				forceMove(A)
				A.sword = src
				A.set_restoration(TRUE) // we do it here beacuse no sword = no healing
			else
				to_chat(user, span_danger("По какой-то причине ты не смог воткнуть меч."))
		else
			to_chat(user, span_danger("Слишком мало пепла."))
	else if(isliving(target))
		var/mob/living/L = target
		L.adjust_fire_stacks(flame_power)
		L.IgniteMob()
