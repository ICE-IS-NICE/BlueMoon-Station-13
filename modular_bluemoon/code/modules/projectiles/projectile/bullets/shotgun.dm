/obj/item/projectile/bullet/pellet/shotgun_flechette
	name = "flechette pellet"
	damage = 3
	wound_bonus = 5
	bare_wound_bonus = 5
	armour_penetration = 30
	wound_falloff_tile = -2.5
	tile_dropoff = 0.4

/obj/item/projectile/bullet/frangible_slug
	name = "frangible slug"
	damage = 20
	sharpness = SHARP_POINTY
	wound_bonus = 10
	bare_wound_bonus = 10

/obj/item/projectile/bullet/frangible_slug/on_hit(atom/target, blocked, pierce_hit)
	if(isobj(target))
		damage = 400 // airlock integrity is about 300, but on airlock destruction its assembly is spawned
		armour_penetration = 100
		if(ismecha(target))
			damage /= 4
	. = ..()
