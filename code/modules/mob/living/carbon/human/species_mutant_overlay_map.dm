/// Builds BODY_* / HORNS mutant overlays without touching the human's overlays_standing (for severed heads, etc.)
/datum/species/proc/build_mutant_bodypart_overlay_map(mob/living/carbon/human/H, list/bodyparts_to_add, forced_colour)
	. = list()
	var/list/relevant_layers = list()
	var/list/dna_feature_as_text_string = list()

	for(var/bodypart in bodyparts_to_add)
		var/reference_list = GLOB.mutant_reference_list[bodypart]
		if(reference_list)
			var/datum/sprite_accessory/S
			var/transformed_part = GLOB.mutant_transform_list[bodypart]
			if(transformed_part)
				S = reference_list[H.dna.features[transformed_part]]
			else
				S = reference_list[H.dna.features[bodypart]]

			if(!S || S.icon_state == "none")
				continue

			if(!S.relevant_layers)
				continue

			for(var/L in S.relevant_layers)
				LAZYADD(relevant_layers["[L]"], S)
			if(!S.mutant_part_string)
				dna_feature_as_text_string[S] = bodypart

	var/static/list/layer_text = list(
		"[BODY_BEHIND_LAYER]" = "BEHIND",
		"[BODY_ADJ_LAYER]" = "ADJ",
		"[BODY_ADJ_UPPER_LAYER]" = "ADJUP",
		"[BODY_FRONT_LAYER]" = "FRONT",
		"[HORNS_LAYER]" = "HORNS",
		)

	var/g = (H.dna.features["body_model"] == FEMALE) ? "f" : "m"
	var/husk = HAS_TRAIT(H, TRAIT_HUSK)

	for(var/layer in relevant_layers)
		var/list/standing = list()
		var/layertext = layer_text[layer]
		if(!layertext)
			stack_trace("invalid layer '[layer]' found in build_mutant_bodypart_overlay_map().")
			continue
		var/layernum = isnum(layer) ? layer : text2num(layer)
		if(!layernum)
			continue
		for(var/bodypart in relevant_layers[layer])
			var/datum/sprite_accessory/S = bodypart
			var/mutable_appearance/accessory_overlay = mutable_appearance(S.icon, layer = -layernum)
			accessory_overlay.category = S.mutable_category
			bodypart = S.mutant_part_string || dna_feature_as_text_string[S]

			if(S.gender_specific)
				accessory_overlay.icon_state = "[g]_[bodypart]_[S.icon_state]_[layertext]"
			else
				accessory_overlay.icon_state = "m_[bodypart]_[S.icon_state]_[layertext]"

			if(S.center)
				accessory_overlay = center_image(accessory_overlay, S.dimension_x, S.dimension_y)

			var/advanced_color_system = (H.dna.features["color_scheme"] == ADVANCED_CHARACTER_COLORING)

			var/mutant_string = S.mutant_part_string
			if(mutant_string == "tailwag")
				mutant_string = "tail"
			var/primary_string = advanced_color_system ? "[mutant_string]_primary" : "mcolor"
			var/secondary_string = advanced_color_system ? "[mutant_string]_secondary" : "mcolor2"
			var/tertiary_string = advanced_color_system ? "[mutant_string]_tertiary" : "mcolor3"
			if(!H.dna.features[primary_string])
				H.dna.features[primary_string] = advanced_color_system ? H.dna.features["mcolor"] : "FFFFFF"
			if(!H.dna.features[secondary_string])
				H.dna.features[secondary_string] = advanced_color_system ? H.dna.features["mcolor2"] : "FFFFFF"
			if(!H.dna.features[tertiary_string])
				H.dna.features[tertiary_string] = advanced_color_system ? H.dna.features["mcolor3"] : "FFFFFF"

			if(!husk)
				if(!forced_colour && S.do_colouration)
					switch(S.color_src)
						if(SKINTONE)
							accessory_overlay.color = SKINTONE2HEX(H.skin_tone)
						if(MUTCOLORS)
							if(fixed_mut_color)
								accessory_overlay.color = "#[fixed_mut_color]"
							else
								accessory_overlay.color = "#[H.dna.features[primary_string]]"
						if(MUTCOLORS2)
							if(fixed_mut_color2)
								accessory_overlay.color = "#[fixed_mut_color2]"
							else
								accessory_overlay.color = "#[H.dna.features[primary_string]]"
						if(MUTCOLORS3)
							if(fixed_mut_color3)
								accessory_overlay.color = "#[fixed_mut_color3]"
							else
								accessory_overlay.color = "#[H.dna.features[primary_string]]"

						if(MATRIXED)
							var/list/accessory_colorlist = list()
							if(S.matrixed_sections == MATRIX_RED || S.matrixed_sections == MATRIX_RED_GREEN || S.matrixed_sections == MATRIX_RED_BLUE || S.matrixed_sections == MATRIX_ALL)
								accessory_colorlist += husk ? ReadRGB("#a3a3a3") : ReadRGB("[H.dna.features[primary_string]]00")
							else
								accessory_colorlist += husk ? ReadRGB("#a3a3a3") : ReadRGB("00000000")
							if(S.matrixed_sections == MATRIX_GREEN || S.matrixed_sections == MATRIX_RED_GREEN || S.matrixed_sections == MATRIX_GREEN_BLUE || S.matrixed_sections == MATRIX_ALL)
								accessory_colorlist += husk ? ReadRGB("#a3a3a3") : ReadRGB("[H.dna.features[secondary_string]]00")
							else
								accessory_colorlist += husk ? ReadRGB("#a3a3a3") : ReadRGB("00000000")
							if(S.matrixed_sections == MATRIX_BLUE || S.matrixed_sections == MATRIX_RED_BLUE || S.matrixed_sections == MATRIX_GREEN_BLUE || S.matrixed_sections == MATRIX_ALL)
								accessory_colorlist += husk ? ReadRGB("#a3a3a3") : ReadRGB("[H.dna.features[tertiary_string]]00")
							else
								accessory_colorlist += husk ? ReadRGB("#a3a3a3") : ReadRGB("00000000")
							accessory_colorlist += husk ? list(0, 0, 0) : list(0, 0, 0, hair_alpha)
							for(var/index in 1 to accessory_colorlist.len)
								accessory_colorlist[index] /= 255
							accessory_overlay.color = list(accessory_colorlist)

						if(HAIR)
							if(hair_color == "mutcolor")
								accessory_overlay.color = "#[H.dna.features["mcolor"]]"
							else
								accessory_overlay.color = "#[H.hair_color]"
						if(FACEHAIR)
							accessory_overlay.color = "#[H.facial_hair_color]"
						if(EYECOLOR)
							accessory_overlay.color = "#[H.left_eye_color]"
						if(HORNCOLOR)
							accessory_overlay.color = "#[H.dna.features["horns_color"]]"
						if(WINGCOLOR)
							accessory_overlay.color = "#[H.dna.features["wings_color"]]"
				else
					accessory_overlay.color = forced_colour
			else
				if(bodypart == "ears")
					accessory_overlay.icon_state = "m_ears_none_[layertext]"
				if(bodypart == "tail")
					accessory_overlay.icon_state = "m_tail_husk_[layertext]"
				if(S.color_src == MATRIXED)
					var/list/accessory_colorlist = list()
					accessory_colorlist += husk ? ReadRGB("#a3a3a3") : ReadRGB("[H.dna.features[primary_string]]00")
					accessory_colorlist += husk ? ReadRGB("#a3a3a3") : ReadRGB("[H.dna.features[secondary_string]]00")
					accessory_colorlist += husk ? ReadRGB("#a3a3a3") : ReadRGB("[H.dna.features[tertiary_string]]00")
					accessory_colorlist += husk ? list(0, 0, 0) : list(0, 0, 0, hair_alpha)
					for(var/index in 1 to accessory_colorlist.len)
						accessory_colorlist[index] /= 255
					accessory_overlay.color = list(accessory_colorlist)

			if(OFFSET_MUTPARTS in H.dna.species.offset_features)
				accessory_overlay.pixel_x += H.dna.species.offset_features[OFFSET_MUTPARTS][1]
				accessory_overlay.pixel_y += H.dna.species.offset_features[OFFSET_MUTPARTS][2]

			standing += accessory_overlay

			if(S.extra)
				var/mutable_appearance/extra_accessory_overlay = mutable_appearance(S.icon, layer = -layernum)
				extra_accessory_overlay.category = S.mutable_category
				if(S.gender_specific)
					extra_accessory_overlay.icon_state = "[g]_[bodypart]_extra_[S.icon_state]_[layertext]"
				else
					extra_accessory_overlay.icon_state = "m_[bodypart]_extra_[S.icon_state]_[layertext]"
				if(S.center)
					extra_accessory_overlay = center_image(extra_accessory_overlay, S.dimension_x, S.dimension_y)

				switch(S.extra_color_src)
					if(MUTCOLORS)
						if(fixed_mut_color)
							extra_accessory_overlay.color = "#[fixed_mut_color]"
						else
							extra_accessory_overlay.color = "#[H.dna.features[secondary_string]]"
					if(MUTCOLORS2)
						if(fixed_mut_color2)
							extra_accessory_overlay.color = "#[fixed_mut_color2]"
						else
							extra_accessory_overlay.color = "#[H.dna.features[secondary_string]]"
					if(MUTCOLORS3)
						if(fixed_mut_color3)
							extra_accessory_overlay.color = "#[fixed_mut_color3]"
						else
							extra_accessory_overlay.color = "#[H.dna.features[secondary_string]]"
					if(HAIR)
						if(hair_color == "mutcolor")
							extra_accessory_overlay.color = "#[H.dna.features["mcolor3"]]"
						else
							extra_accessory_overlay.color = "#[H.hair_color]"
					if(FACEHAIR)
						extra_accessory_overlay.color = "#[H.facial_hair_color]"
					if(EYECOLOR)
						extra_accessory_overlay.color = "#[H.left_eye_color]"

					if(HORNCOLOR)
						extra_accessory_overlay.color = "#[H.dna.features["horns_color"]]"
					if(WINGCOLOR)
						extra_accessory_overlay.color = "#[H.dna.features["wings_color"]]"

				if(OFFSET_MUTPARTS in H.dna.species.offset_features)
					extra_accessory_overlay.pixel_x += H.dna.species.offset_features[OFFSET_MUTPARTS][1]
					extra_accessory_overlay.pixel_y += H.dna.species.offset_features[OFFSET_MUTPARTS][2]

				standing += extra_accessory_overlay

			if(S.extra2)
				var/mutable_appearance/extra2_accessory_overlay = mutable_appearance(S.icon, layer = -layernum)
				extra2_accessory_overlay.category = S.mutable_category
				if(S.gender_specific)
					extra2_accessory_overlay.icon_state = "[g]_[bodypart]_extra2_[S.icon_state]_[layertext]"
				else
					extra2_accessory_overlay.icon_state = "m_[bodypart]_extra2_[S.icon_state]_[layertext]"
				if(S.center)
					extra2_accessory_overlay = center_image(extra2_accessory_overlay, S.dimension_x, S.dimension_y)

				switch(S.extra2_color_src)
					if(MUTCOLORS)
						if(fixed_mut_color)
							extra2_accessory_overlay.color = "#[fixed_mut_color]"
						else
							extra2_accessory_overlay.color = "#[H.dna.features[tertiary_string]]"
					if(MUTCOLORS2)
						if(fixed_mut_color2)
							extra2_accessory_overlay.color = "#[fixed_mut_color2]"
						else
							extra2_accessory_overlay.color = "#[H.dna.features[tertiary_string]]"
					if(MUTCOLORS3)
						if(fixed_mut_color3)
							extra2_accessory_overlay.color = "#[fixed_mut_color3]"
						else
							extra2_accessory_overlay.color = "#[H.dna.features[tertiary_string]]"
					if(HAIR)
						if(hair_color == "mutcolor3")
							extra2_accessory_overlay.color = "#[H.dna.features["mcolor"]]"
						else
							extra2_accessory_overlay.color = "#[H.hair_color]"
					if(HORNCOLOR)
						extra2_accessory_overlay.color = "#[H.dna.features["horns_color"]]"
					if(WINGCOLOR)
						extra2_accessory_overlay.color = "#[H.dna.features["wings_color"]]"

				if(OFFSET_MUTPARTS in H.dna.species.offset_features)
					extra2_accessory_overlay.pixel_x += H.dna.species.offset_features[OFFSET_MUTPARTS][1]
					extra2_accessory_overlay.pixel_y += H.dna.species.offset_features[OFFSET_MUTPARTS][2]

				standing += extra2_accessory_overlay

		.[layernum] = standing

/// Snout, ears, horns, frills, IPC face extras, etc. for /obj/item/bodypart/head get_limb_icon
/datum/species/proc/get_severed_head_mutant_overlays(mob/living/carbon/human/H)
	. = list()
	if(!ishuman(H) || !H.dna || (H.dna.species != src) || !length(mutant_bodyparts))
		return
	var/tauric = mutant_bodyparts["taur"] && H.dna.features["taur"] && H.dna.features["taur"] != "None"
	var/list/bodyparts_to_add = mutant_bodyparts.Copy()
	for(var/mutant_part in mutant_bodyparts)
		if(!(mutant_part in GLOB.head_mutant_parts_for_severed_head))
			bodyparts_to_add -= mutant_part
	for(var/mutant_part in mutant_bodyparts)
		var/reference_list = GLOB.mutant_reference_list[mutant_part]
		if(reference_list)
			var/datum/sprite_accessory/S_acc
			var/transformed_part = GLOB.mutant_transform_list[mutant_part]
			if(transformed_part)
				S_acc = reference_list[H.dna.features[transformed_part]]
			else
				S_acc = reference_list[H.dna.features[mutant_part]]
			if(!S_acc || S_acc.is_not_visible(H, tauric))
				bodyparts_to_add -= mutant_part
	if(!length(bodyparts_to_add))
		return
	var/list/overlay_map = build_mutant_bodypart_overlay_map(H, bodyparts_to_add, null)
	var/static/list/mutant_layer_order = list(BODY_BEHIND_LAYER, BODY_ADJ_LAYER, BODY_ADJ_UPPER_LAYER, BODY_FRONT_LAYER, HORNS_LAYER)
	for(var/ln in mutant_layer_order)
		var/list/layer_standing = overlay_map[ln]
		if(length(layer_standing))
			. += layer_standing
