/proc/random_blood_type()
	return pick(4;"O-", 36;"O+", 3;"A-", 28;"A+", 1;"B-", 20;"B+", 1;"AB-", 5;"AB+")

/proc/random_eye_color()
	switch(pick(20;"brown",20;"hazel",20;"grey",15;"blue",15;"green",1;"amber",1;"albino"))
		if("brown")
			return "630"
		if("hazel")
			return "542"
		if("grey")
			return pick("666","777","888","999","aaa","bbb","ccc")
		if("blue")
			return "36c"
		if("green")
			return "060"
		if("amber")
			return "fc0"
		if("albino")
			return pick("c","d","e","f") + pick("0","1","2","3","4","5","6","7","8","9") + pick("0","1","2","3","4","5","6","7","8","9")
		else
			return "000"

/proc/random_underwear(gender)
	if(!underwear_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/underwear, underwear_list, underwear_m, underwear_f)
	switch(gender)
		if(MALE)
			return pick(underwear_m)
		if(FEMALE)
			return pick(underwear_f)
		else
			return pick(underwear_list)

/proc/random_undershirt(gender)
	if(!undershirt_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/undershirt, undershirt_list, undershirt_m, undershirt_f)
	switch(gender)
		if(MALE)
			return pick(undershirt_m)
		if(FEMALE)
			return pick(undershirt_f)
		else
			return pick(undershirt_list)

/proc/random_socks()
	if(!socks_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/socks, socks_list)
	return pick(socks_list)

/proc/random_features()
	if(!tails_list_human.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/tails/human, tails_list_human)
	if(!tails_list_lizard.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/tails/lizard, tails_list_lizard)
	if(!snouts_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/snouts, snouts_list)
	if(!horns_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/horns, horns_list)
	if(!ears_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/ears, horns_list)
	if(!frills_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/frills, frills_list)
	if(!spines_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/spines, spines_list)
	if(!body_markings_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/body_markings, body_markings_list)
	if(!wings_list.len)
		init_sprite_accessory_subtypes(/datum/sprite_accessory/wings, wings_list)

	//For now we will always return none for tail_human and ears.
	return(list("mcolor" = pick("FFFFFF","7F7F7F", "7FFF7F", "7F7FFF", "FF7F7F", "7FFFFF", "FF7FFF", "FFFF7F"), "tail_lizard" = pick(tails_list_lizard), "tail_human" = "None", "wings" = "None", "snout" = pick(snouts_list), "horns" = pick(horns_list), "ears" = "None", "frills" = pick(frills_list), "spines" = pick(spines_list), "body_markings" = pick(body_markings_list)))

/proc/random_hair_style(gender)
	switch(gender)
		if(MALE)
			return pick(hair_styles_male_list)
		if(FEMALE)
			return pick(hair_styles_female_list)
		else
			return pick(hair_styles_list)

/proc/random_facial_hair_style(gender)
	switch(gender)
		if(MALE)
			return pick(facial_hair_styles_male_list)
		if(FEMALE)
			return pick(facial_hair_styles_female_list)
		else
			return pick(facial_hair_styles_list)

/proc/random_unique_name(gender, attempts_to_find_unique_name=10)
	for(var/i=1, i<=attempts_to_find_unique_name, i++)
		if(gender==FEMALE)
			. = capitalize(pick(first_names_female)) + " " + capitalize(pick(last_names))
		else
			. = capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))

		if(i != attempts_to_find_unique_name && !findname(.))
			break

/proc/random_unique_lizard_name(gender, attempts_to_find_unique_name=10)
	for(var/i=1, i<=attempts_to_find_unique_name, i++)
		. = capitalize(lizard_name(gender))

		if(i != attempts_to_find_unique_name && !findname(.))
			break

/proc/random_skin_tone()
	return pick(skin_tones)

var/list/skin_tones = list(
	"albino",
	"caucasian1",
	"caucasian2",
	"caucasian3",
	"latino",
	"mediterranean",
	"asian1",
	"asian2",
	"arab",
	"indian",
	"african1",
	"african2"
	)

var/global/list/species_list[0]
var/global/list/roundstart_species[0]

/proc/age2agedescription(age)
	switch(age)
		if(0 to 1)
			return "infant"
		if(1 to 3)
			return "toddler"
		if(3 to 13)
			return "child"
		if(13 to 19)
			return "teenager"
		if(19 to 30)
			return "young adult"
		if(30 to 45)
			return "adult"
		if(45 to 60)
			return "middle-aged"
		if(60 to 70)
			return "aging"
		if(70 to INFINITY)
			return "elderly"
		else
			return "unknown"

/*
Proc for attack log creation, because really why not
1 argument is the actor
2 argument is the target of action
3 is the description of action(like punched, throwed, or any other verb)
4 should it make adminlog note or not
5 is the tool with which the action was made(usually item)					5 and 6 are very similar(5 have "by " before it, that it) and are separated just to keep things in a bit more in order
6 is additional information, anything that needs to be added
*/

/proc/add_logs(mob/user, mob/target, what_done, object=null, addition=null)
	var/newhealthtxt = ""
	var/coordinates = ""
	var/turf/attack_location = get_turf(target)
	if(attack_location)
		coordinates = "([attack_location.x],[attack_location.y],[attack_location.z])"
	if(target && isliving(target))
		var/mob/living/L = target
		newhealthtxt = " (NEWHP: [L.health])"
	if(user && ismob(user))
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Has [what_done] [target ? "[target.name][(ismob(target) && target.ckey) ? "([target.ckey])" : ""]" : "NON-EXISTANT SUBJECT"][object ? " with [object]" : " "][addition][newhealthtxt][coordinates]</font>")
		if(user.mind)
			user.mind.attack_log += text("\[[time_stamp()]\] <font color='red'>[user ? "[user.name][(ismob(user) && user.ckey) ? "([user.ckey])" : ""]" : "NON-EXISTANT SUBJECT"] has [what_done] [target ? "[target.name][(ismob(target) && target.ckey) ? "([target.ckey])" : ""]" : "NON-EXISTANT SUBJECT"][object ? " with [object]" : " "][addition][newhealthtxt][coordinates]</font>")
	if(target && ismob(target))
		target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been [what_done] by [user ? "[user.name][(ismob(user) && user.ckey) ? "([user.ckey])" : ""]" : "NON-EXISTANT SUBJECT"][object ? " with [object]" : " "][addition][newhealthtxt][coordinates]</font>")
		if(target.mind)
			target.mind.attack_log += text("\[[time_stamp()]\] <font color='orange'>[target ? "[target.name][(ismob(target) && target.ckey) ? "([target.ckey])" : ""]" : "NON-EXISTANT SUBJECT"] has been [what_done] by [user ? "[user.name][(ismob(user) && user.ckey) ? "([user.ckey])" : ""]" : "NON-EXISTANT SUBJECT"][object ? " with [object]" : " "][addition][newhealthtxt][coordinates]</font>")
	log_attack("[user ? "[user.name][(ismob(user) && user.ckey) ? "([user.ckey])" : ""]" : "NON-EXISTANT SUBJECT"] [what_done] [target ? "[target.name][(ismob(target) && target.ckey)? "([target.ckey])" : ""]" : "NON-EXISTANT SUBJECT"][object ? " with [object]" : " "][addition][newhealthtxt][coordinates]")



/proc/do_mob(mob/user , mob/target, time = 30, uninterruptible = 0, progress = 1)
	if(!user || !target)
		return 0
	var/user_loc = user.loc

	var/drifting = 0
	if(!user.Process_Spacemove(0) && user.inertia_dir)
		drifting = 1

	var/target_loc = target.loc

	var/holding = user.get_active_hand()
	var/datum/progressbar/progbar
	if (progress)
		progbar = new(user, time, target)

	var/endtime = world.time+time
	var/starttime = world.time
	. = 1
	while (world.time < endtime)
		stoplag()
		if (progress)
			progbar.update(world.time - starttime)
		if(!user || !target)
			. = 0
			break
		if(uninterruptible)
			continue

		if(drifting && !user.inertia_dir)
			drifting = 0
			user_loc = user.loc

		if((!drifting && user.loc != user_loc) || target.loc != target_loc || user.get_active_hand() != holding || user.incapacitated() || user.lying )
			. = 0
			break
	if (progress)
		qdel(progbar)


/proc/do_after(mob/user, delay, needhand = 1, atom/target = null, progress = 1)
	if(!user)
		return 0
	var/atom/Tloc = null
	if(target)
		Tloc = target.loc

	var/atom/Uloc = user.loc

	var/drifting = 0
	if(!user.Process_Spacemove(0) && user.inertia_dir)
		drifting = 1

	var/holding = user.get_active_hand()

	var/holdingnull = 1 //User's hand started out empty, check for an empty hand
	if(holding)
		holdingnull = 0 //Users hand started holding something, check to see if it's still holding that

	var/datum/progressbar/progbar
	if (progress)
		progbar = new(user, delay, target)

	var/endtime = world.time + delay
	var/starttime = world.time
	. = 1
	while (world.time < endtime)
		stoplag()
		if (progress)
			progbar.update(world.time - starttime)

		if(drifting && !user.inertia_dir)
			drifting = 0
			Uloc = user.loc

		if(!user || user.stat || user.weakened || user.stunned  || (!drifting && user.loc != Uloc))
			. = 0
			break

		if(Tloc && (!target || Tloc != target.loc))
			. = 0
			break

		if(needhand)
			//This might seem like an odd check, but you can still need a hand even when it's empty
			//i.e the hand is used to pull some item/tool out of the construction
			if(!holdingnull)
				if(!holding)
					. = 0
					break
			if(user.get_active_hand() != holding)
				. = 0
				break
	if (progress)
		qdel(progbar)

/proc/do_after_mob(mob/user, var/list/targets, time = 30, uninterruptible = 0, progress = 1)
	if(!user || !targets)
		return 0
	if(!islist(targets))
		targets = list(targets)
	var/user_loc = user.loc

	var/drifting = 0
	if(!user.Process_Spacemove(0) && user.inertia_dir)
		drifting = 1

	var/list/originalloc = list()
	for(var/atom/target in targets)
		originalloc[target] = target.loc

	var/holding = user.get_active_hand()
	var/datum/progressbar/progbar
	if(progress)
		progbar = new(user, time, targets[1])

	var/endtime = world.time + time
	var/starttime = world.time
	. = 1
	mainloop:
		while(world.time < endtime)
			sleep(1)
			if(progress)
				progbar.update(world.time - starttime)
			if(!user || !targets)
				. = 0
				break
			if(uninterruptible)
				continue

			if(drifting && !user.inertia_dir)
				drifting = 0
				user_loc = user.loc

			for(var/atom/target in targets)
				if((!drifting && user_loc != user.loc) || originalloc[target] != target.loc || user.get_active_hand() != holding || user.incapacitated() || user.lying )
					. = 0
					break mainloop
	if(progbar)
		qdel(progbar)

/proc/is_species(A, species_datum)
	. = FALSE
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		if(H.dna && istype(H.dna.species, species_datum))
			. = TRUE

/proc/get_ckey(user)
	if(ismob(user))
		var/mob/temp = user
		return temp.ckey
	else if(istype(user, /client))
		var/client/temp = user
		return temp.ckey
	else if(istype(user, /datum/mind))
		var/datum/mind/temp = user
		return temp.ckey

	return "* Unknown *"

/proc/get_client(var/user)
	if(istype(user, /client))
		return user
	if(ismob(user))
		var/mob/temp = user
		return temp.client
	return user

/proc/get_fancy_key(mob/user)
	if(ismob(user))
		var/mob/temp = user
		return temp.key
	else if(istype(user, /client))
		var/client/temp = user
		return temp.key
	else if(istype(user, /datum/mind))
		var/datum/mind/temp = user
		return temp.key

	return "* Unknown *"

/proc/has_pref(var/user, var/pref)
	if(ismob(user))
		var/mob/temp = user

		if(temp && temp.client && temp.client.prefs && temp.client.prefs.toggles & pref)
			return 1
	else if(istype(user, /client))
		var/client/temp = user

		if(temp && temp.prefs && temp.prefs.toggles & pref)
			return 1

	return 0

/proc/is_admin(var/user)
	if(ismob(user))
		var/mob/temp = user

		if(temp && temp.client && temp.client.holder)
			return 1
	else if(istype(user, /client))
		var/client/temp = user

		if(temp && temp.holder)
			return 1

	return 0

/proc/compare_ckey(var/user, var/target)
	if(!user || !target)
		return 0

	var/key1 = user
	var/key2 = target

	if(ismob(user))
		var/mob/M = user
		if(M.ckey)
			key1 = M.ckey
		else if(M.client && M.client.ckey)
			key1 = M.client.ckey
	else if(istype(user, /client))
		var/client/C = user
		key1 = C.ckey
	else
		key1 = lowertext(key1)

	if(ismob(target))
		var/mob/M = target
		if(M.ckey)
			key2 = M.ckey
		else if(M.client && M.client.ckey)
			key2 = M.client.ckey
	else if(istype(target, /client))
		var/client/C = target
		key2 = C.ckey
	else
		key2 = lowertext(key2)


	if(key1 == key2)
		return 1
	else
		return 0

/proc/is_donator(mob/user)
	// Enable only for testing!
	if(is_admin(user))
		return 1

	if(ismob(user))
		if(user.client && user.client.prefs)
			return (user.client.prefs.unlock_content & 2)
	else if(istype(user, /client))
		var/client/C = user
		if(C.prefs)
			return (C.prefs.unlock_content & 2)
	else
		return 0

/proc/is_whitelisted(mob/user)
	if(ismob(user))
		if(user.client)
			return user.client.is_whitelisted
	else if(istype(user, /client))
		var/client/C = user
		return C.is_whitelisted
	return 0

/proc/is_veteran(mob/user)
	if(ismob(user))
		if(user.client && user.client.prefs)
			return (user.client.prefs.unlock_content & 4)
	else if(istype(user, /client))
		var/client/C = user
		if(C.prefs)
			return (C.prefs.unlock_content & 4)
	else
		return 0

/proc/get_ip(user)
	if(ismob(user))
		var/mob/temp = user
		if(temp.client)
			return temp.client.address
	else if(istype(user, /client))
		var/client/temp = user
		return temp.address

	return "0.0.0.0"

/proc/get_computer_id(user)
	if(ismob(user))
		var/mob/temp = user
		if(temp.client)
			return temp.client.computer_id
	else if(istype(user, /client))
		var/client/temp = user
		return temp.computer_id

	return "Unknown"

/proc/deadchat_broadcast(message, mob/follow_target=null, speaker_key=null, message_type=DEADCHAT_REGULAR)
	for(var/mob/M in player_list)
		var/datum/preferences/prefs
		if(M.client && M.client.prefs)
			prefs = M.client.prefs
		else
			prefs = new

		var/adminoverride = 0
		if(M.client && M.client.holder && (prefs.chat_toggles & CHAT_DEAD))
			adminoverride = 1
		if(istype(M, /mob/new_player) && !adminoverride)
			continue
		if(M.stat != DEAD && !adminoverride)
			continue
		if(speaker_key && speaker_key in prefs.ignoring)
			continue
		if(message_type == DEADCHAT_DEATHRATTLE)
			if(prefs.toggles & DISABLE_DEATHRATTLE)
				continue

		if(istype(M, /mob/dead/observer) && follow_target)
			var/link = FOLLOW_LINK(M, follow_target)
			to_chat(M, "[link] [message]")
		else
			to_chat(M, "[message]")
