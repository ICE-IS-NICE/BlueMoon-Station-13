// Custom flags were added for logic actions - lying should not prevent ~98% of all actions

/datum/action/item_action/toggle_helmet_light
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUN|AB_CHECK_CONSCIOUS
	required_mobility_flags = NONE

/datum/action/item_action/toggle_helmet_mode
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUN|AB_CHECK_CONSCIOUS
	required_mobility_flags = NONE

/datum/action/item_action/toggle_helmet
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUN|AB_CHECK_CONSCIOUS
	required_mobility_flags = NONE

/datum/action/item_action/set_internals
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUN|AB_CHECK_CONSCIOUS
	required_mobility_flags = NONE

/datum/action/item_action/toggle_gunlight
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUN|AB_CHECK_CONSCIOUS
	required_mobility_flags = NONE

/datum/action/item_action/toggle_welding_screen
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUN|AB_CHECK_CONSCIOUS
	required_mobility_flags = NONE
	icon_icon = 'icons/obj/clothing/hats.dmi'
	button_icon_state = "weldvisor" 			// for easier indication

/datum/action/item_action/toggle_hood
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUN|AB_CHECK_CONSCIOUS
	required_mobility_flags = NONE

/datum/action/item_action/toggle_gloves
	name = "Activate"
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUN|AB_CHECK_CONSCIOUS
	required_mobility_flags = NONE

/datum/action/item_action/toggle_nodrop
	name = "No Drop"
	check_flags = AB_CHECK_RESTRAINED|AB_CHECK_STUN|AB_CHECK_CONSCIOUS
	required_mobility_flags = MOBILITY_HOLD
	var/inhand_only = FALSE
	var/text_on = "Предмет неоделим от тебя!"
	var/text_off = "Предмет отцепляется от тебя."

/datum/action/item_action/toggle_nodrop/inhand
	inhand_only = TRUE
	text_on = "Ты цепляешься к предмету смертной хваткой!"
	text_off = "Ты расжимаешь хватку."

/datum/action/item_action/toggle_nodrop/Trigger()
	. = ..()
	if(!. || !isitem(target))
		return FALSE
	var/obj/item/I = target
	if(inhand_only && I.current_equipped_slot != ITEM_SLOT_HANDS)
		return
	if(HAS_TRAIT_FROM(I, TRAIT_NODROP, src))
		REMOVE_TRAIT(I, TRAIT_NODROP, src)
		to_chat(usr, text_off)
	else
		ADD_TRAIT(I, TRAIT_NODROP, src)
		to_chat(usr, text_on)
	UpdateButtons()

/datum/action/item_action/toggle_nodrop/UpdateButton(atom/movable/screen/movable/action_button/button, status_only, force)
	if(HAS_TRAIT_FROM(target, TRAIT_NODROP, src))
		background_icon_state = "bg_default_on"
	else
		background_icon_state = "bg_default"
	. = ..()
