MW2019serverName <- self.GetName();
MW2019_Stimshot_MDL <- "models/weapons/v_healthshot.mdl"
MW2019_Heal_HP <- 50;
MW2019_MaxHealth <- 100;
MW2019_MaxHealth_String <- "#SFUI_Healthshot_AlreadyAtMax"

SendToConsole("healthshot_health 0");
SendToConsoleServer("sv_health_approach_enabled 0");
SendToConsoleServer("healthshot_healthboost_time 0");
SendToConsoleServer("healthshot_healthboost_speed_multiplier 1.0");
SendToConsoleServer("healthshot_healthboost_damage_multiplier 1.0");
SendToConsoleServer("sv_health_approach_speed 0");

function MW2019_Stimshot_animTrack(vm)
{
	local anim_track = vm.LookupAttachment("a_flag");
	local anim_track_start = vm.LookupAttachment("a_flag_start");
	local anim_track_state = "none";
		
    local org = vm.GetAttachmentOrigin(anim_track) - vm.GetOrigin();
    local org_base = vm.GetAttachmentOrigin(anim_track_start) - vm.GetOrigin();
	local org_dist = org - org_base;
	if (org_dist.z > 0.8 && org_dist.z < 1.2) anim_track_state = "inject";
	else if (org_dist.z < -0.8 && org_dist.z > -1.2) anim_track_state = "cancel";
	
	return anim_track_state;
}

function MW2019_Stim_Check()
{
	local vm = null
	while(vm = Entities.FindByClassname(vm, "predicted_viewmodel"))
	{
		local ply = vm.GetMoveParent()
		if (!ply || !ply.IsValid()) continue;
		
		ply.ValidateScriptScope();
		local stimScope = ply.GetScriptScope();
		if (!stimScope.rawin("IsStimshotUsed"))
		{
			stimScope.StimshotTime <- Time();
			stimScope.canStimshotHeal <- false;
			stimScope.canUseStimshot <- false;
			stimScope.StimshotLeave <- false;
			stimScope.IsStimshotUsed <- false;
		}
		
		if (stimScope.canStimshotHeal == true)
		{
			if (ply.GetHealth() < 1 || Time() - stimScope.StimshotTime > 4.99)
			{
				stimScope.canStimshotHeal = false;
				EntFireByHandle(MW2019_speedmod, "ModifySpeed", "1.0", 0, ply, ply);
				ply.__KeyValueFromFloat("gravity", 1.0);
				continue;
			}
			EntFireByHandle(MW2019_speedmod, "ModifySpeed", "1.2", 0, ply, ply);
			ply.__KeyValueFromFloat("gravity", 0.9);
		}
		
		if(vm.GetModelName() != MW2019_Stimshot_MDL)
		{
			stimScope.IsStimshotUsed = false;
			stimScope.canUseStimshot = true;
			continue;
		}
		
		local stimAnimState = MW2019_Stimshot_animTrack(vm);
		if (stimAnimState == "inject" && stimScope.IsStimshotUsed == false)
		{
			stimScope.IsStimshotUsed = true;
			stimScope.canStimshotHeal = true;
			stimScope.canUseStimshot = false;
			stimScope.StimshotLeave = false;
			stimScope.StimshotTime = Time();
			local curPlayerHP = ply.GetHealth();
			if (curPlayerHP >= MW2019_MaxHealth) continue;
			if (curPlayerHP + MW2019_Heal_HP > MW2019_MaxHealth) ply.SetHealth(MW2019_MaxHealth)
			else ply.SetHealth(curPlayerHP + MW2019_Heal_HP);
			continue;
		}
		
		if (stimAnimState == "cancel" && stimScope.StimshotLeave == false)
		{
			stimScope.StimshotLeave = true;
			EntFireByHandle(MW2019cmd_client, "Command", "slot3;slot2;slot1;slot0", 0.1, ply, ply);
			continue;
		}
		if (ply.GetHealth() >= MW2019_MaxHealth && stimScope.canUseStimshot == true)
		{
			ply.StopSound("Equipment_Stimshot.Use");
			vm.StopSound("Equipment_Stimshot.Use");
			EntFireByHandle(MW2019cmd_client, "Command", "slot3;slot2;slot1;slot0", 0, ply, ply);
			EntFireByHandle(MW2019_maxHealthMSG, "HideHudHint", "", 0, ply, ply);
			EntFireByHandle(MW2019_maxHealthMSG, "ShowHudHint", "", 0.01, ply, ply);
			EntFireByHandle(MW2019_maxHealthMSG, "HideHudHint", "", 3.0, ply, ply);
		}
	}
}

function OnNewRound()
{
	SendToConsole("healthshot_health 0");
	SendToConsoleServer("sv_health_approach_enabled 0");
	SendToConsoleServer("healthshot_healthboost_time 0");
	SendToConsoleServer("healthshot_healthboost_speed_multiplier 1.0");
	SendToConsoleServer("healthshot_healthboost_damage_multiplier 1.0");
	SendToConsoleServer("sv_health_approach_speed 0");
}

MW2019_Stim_Timer <- Entities.CreateByClassname("logic_timer")
MW2019_Stim_Timer.__KeyValueFromFloat("RefireTime", 0.01)
MW2019_Stim_Timer.__KeyValueFromString("classname", "move_rope")
EntFireByHandle(MW2019_Stim_Timer, "AddOutput", "OnTimer "+MW2019serverName+":RunScriptCode:MW2019_Stim_Check():0:-1", 0, null, null)
EntFireByHandle(MW2019_Stim_Timer, "Enable", "", 0.1, null, null)

MW2019cmd_client <- Entities.CreateByClassname("point_clientcommand");
MW2019cmd_client.__KeyValueFromString("classname", "info_target");

MW2019_speedmod <- Entities.CreateByClassname("player_speedmod");
MW2019_speedmod.__KeyValueFromString("classname", "info_target");

MW2019_maxHealthMSG <- Entities.CreateByClassname("env_hudhint");
MW2019_maxHealthMSG.__KeyValueFromString("classname", "info_target");
EntFireByHandle(MW2019_maxHealthMSG, "AddOutput", "message "+MW2019_MaxHealth_String, 0, null, null);