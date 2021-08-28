/*
AI
*/
/datum/job/ai
	title = "AI"
	flag = AI_JF
	department_flag = VAULT
	//
	total_positions = 1
	spawn_positions = 1
	selection_color = "#ccffcc"
	supervisors = "your laws"
	req_admin_notify = TRUE
	minimal_player_age = 30
	exp_requirements = 180
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_SILICON
	display_order = JOB_DISPLAY_ORDER_AI
	var/do_special_check = TRUE
	
	starting_modifiers = list(/datum/skill_modifier/job/level/wiring/basic)

/datum/job/ai/equip(mob/living/carbon/human/H, visualsOnly, announce, latejoin, datum/outfit/outfit_override, client/preference_source = null)
	if(visualsOnly)
		CRASH("dynamic preview is unsupported")
	. = H.AIize(latejoin,preference_source)

/datum/job/ai/after_spawn(mob/H, mob/M, latejoin)
	. = ..()
	if(latejoin)
		var/obj/structure/AIcore/latejoin_inactive/lateJoinCore
		for(var/obj/structure/AIcore/latejoin_inactive/P in GLOB.latejoin_ai_cores)
			if(P.is_available())
				lateJoinCore = P
				GLOB.latejoin_ai_cores -= P
				break
		if(lateJoinCore)
			lateJoinCore.available = FALSE
			H.forceMove(lateJoinCore.loc)
			qdel(lateJoinCore)
	var/mob/living/silicon/ai/AI = H
	AI.apply_pref_name("ai", M.client)			//If this runtimes oh well jobcode is fucked.
	AI.set_core_display_icon(null, M.client)

	ADD_TRAIT(AI, TRAIT_TECHNOPHREAK, TRAIT_GENERIC)

	//we may have been created after our borg
	if(SSticker.current_state == GAME_STATE_SETTING_UP)
		for(var/mob/living/silicon/robot/R in GLOB.silicon_mobs)
			if(!R.connected_ai)
				R.TryConnectToAI()

	if(latejoin)
		announce(AI)

/datum/job/ai/override_latejoin_spawn()
	return TRUE

/datum/job/ai/special_check_latejoin(client/C)
	if(!do_special_check)
		return TRUE
	for(var/i in GLOB.latejoin_ai_cores)
		var/obj/structure/AIcore/latejoin_inactive/LAI = i
		if(istype(LAI))
			if(LAI.is_available())
				return TRUE
	return FALSE

/datum/job/ai/announce(mob/living/silicon/ai/AI)
	. = ..()
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, .proc/minor_announce, "[AI] has been downloaded to an empty bluespace-networked AI core at [AREACOORD(AI)]."))

/datum/job/ai/config_check()
	return CONFIG_GET(flag/allow_ai)

/*
Cyborg
*/
/datum/job/cyborg
	title = "Cyborg"
	flag = F13CYBORG
	department_flag = Oasis
	faction = "oasis"
	total_positions = 2
	spawn_positions = 2
	forbids = "The Oasis forbids: Disobeying the Mayor or the Sheriff. Deserting the city unless it is rendered unhospitable. Killing fellow Residents. Betraying the Oasis and its people."
	enforces = "The Oasis expects: Contributing to Oasis society. Adherence to Oasis laws. Participation in special projects, as ordered by the Mayor or the Sheriff."
	supervisors = "Oasis/Mayor"	//Nodrak
	selection_color = "#ddffdd"
	minimal_player_age = 21
	exp_requirements = 600
	exp_type = EXP_TYPE_FALLOUT

/datum/job/cyborg/equip(mob/living/carbon/human/H, visualsOnly = FALSE, announce = TRUE, latejoin = FALSE, datum/outfit/outfit_override = null, client/preference_source)
	return H.Robotize(FALSE, latejoin)

/datum/job/cyborg/after_spawn(mob/living/silicon/robot/R, mob/M)
	. = ..()
	ADD_TRAIT(R, TRAIT_TECHNOPHREAK, TRAIT_GENERIC)
	R.apply_pref_name("cyborg", M.client)
	R.gender = NEUTER

/*
Mr. Handy
*/
/datum/job/handy
	title = "Mr. Handy"
	flag = CYBORG
	department_flag = ENGSEC
	//
	total_positions = 2
	spawn_positions = 2
	supervisors = "Your Creators"	//Nodrak
	selection_color = "#ddffdd"
	minimal_player_age = 21
	exp_requirements = 12000
	exp_type = EXP_TYPE_CREW

/datum/job/cyborg/equip(mob/living/carbon/human/H, visualsOnly = FALSE, announce = TRUE, latejoin = FALSE, datum/outfit/outfit_override = null, client/preference_source)
	return H.Robotize(FALSE, latejoin)
