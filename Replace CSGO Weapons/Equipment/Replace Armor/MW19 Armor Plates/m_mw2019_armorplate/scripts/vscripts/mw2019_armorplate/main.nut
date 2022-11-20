self.PrecacheModel("models/props_survival/upgrades/upgrade_dz_armor.mdl");
MW2019serverName <- self.GetName();
MW2019_Armor_MDL01 <- "models/weapons/v_eq_armor_plate.mdl"
MW2019_Armor_MDL02 <- "models/weapons/v_eq_armor_plate_green.mdl"

function MW2019_Armor_animTrack(vm)
{
	local anim_track = vm.LookupAttachment("a_flag");
	local anim_track_start = vm.LookupAttachment("a_flag_start");
	local anim_track_state = "none";
		
    local org = vm.GetAttachmentOrigin(anim_track) - vm.GetOrigin();
    local org_base = vm.GetAttachmentOrigin(anim_track_start) - vm.GetOrigin();
	local org_dist = org - org_base;
	if (org_dist.z > 0.8 && org_dist.z < 1.2) anim_track_state = "insert";
	else if (org_dist.z < -0.8 && org_dist.z > -1.2) anim_track_state = "cancel";
	
	return anim_track_state;
}

function MW2019_Armor_Check()
{
	local vm = null
	while(vm = Entities.FindByClassname(vm, "predicted_viewmodel"))
	{
		local ply = vm.GetMoveParent()
		if (!ply || !ply.IsValid()) continue;
		
		ply.ValidateScriptScope();
		local armorScope = ply.GetScriptScope();
		if (!armorScope.rawin("IsArmorUsed"))
		{
			armorScope.armorLeave <- false;
			armorScope.armorCount <- 4;
			armorScope.armorCountAlt <- 4;
			armorScope.IsArmorUsed <- false;
		}
		
		local armorToKill = null;
		local armorToKill2 = null;
		local armorWeapon = null;
		while (armorWeapon = Entities.FindByModel(armorWeapon, MW2019_Armor_MDL01))
		{
			if (armorWeapon.GetClassname() == "weapon_taser" && armorWeapon.GetOwner() == ply)
			{
				armorToKill = armorWeapon;
				break;
			}
		}
		if (armorToKill == null) armorScope.armorCount = 4;
		
		if (armorToKill2 == null)
		while (armorWeapon = Entities.FindByModel(armorWeapon, MW2019_Armor_MDL02))
		{
			if (armorWeapon.GetClassname() == "weapon_taser" && armorWeapon.GetOwner() == ply)
			{
				armorToKill2 = armorWeapon;
				break;
			}
		}
		if (armorToKill2 == null) armorScope.armorCountAlt = 4;
		
		if(vm.GetModelName() != MW2019_Armor_MDL01 && vm.GetModelName() != MW2019_Armor_MDL02)
		{
			if (armorScope.IsArmorUsed == true && ply.GetHealth() > 0)
			{
				if (armorToKill != null && armorScope.armorCount < 1) EntFireByHandle(armorToKill, "Kill", "", 0, ply, ply);
				if (armorToKill2 != null && armorScope.armorCountAlt < 1) EntFireByHandle(armorToKill2, "Kill", "", 0, ply, ply);
			}
			
			armorScope.IsArmorUsed = false;
			continue;
		}
		
		local armorAnimState = MW2019_Armor_animTrack(vm);
		if (armorAnimState == "insert" && armorScope.IsArmorUsed == false)
		{
			armorScope.IsArmorUsed = true;
			armorScope.armorLeave = false;
			if (armorScope.armorCount > 0 && vm.GetModelName() == MW2019_Armor_MDL01) armorScope.armorCount--;
			else if (armorScope.armorCountAlt > 0 && vm.GetModelName() == MW2019_Armor_MDL02) armorScope.armorCountAlt--;
			
			local armorItem = Entities.CreateByClassname("prop_weapon_upgrade_armor");
			armorItem.SetHealth(25);
			EntFireByHandle(armorItem, "Use", "", 0, ply, ply);
		}
		
		if (armorAnimState == "cancel" && armorScope.armorLeave == false)
		{
			armorScope.armorLeave = true;
			EntFireByHandle(MW2019cmd_client, "Command", "slot3;slot2;slot1;slot0", 0.1, ply, ply);
		}
	}
}

function OnNewRound()
{
	EntFireByHandle(MW2019cmd_server, "Command", "mp_free_armor 0", 0, null, null);
}

MW2019_Armor_Timer <- Entities.CreateByClassname("logic_timer")
MW2019_Armor_Timer.__KeyValueFromFloat("RefireTime", 0.01)
MW2019_Armor_Timer.__KeyValueFromString("classname", "move_rope")
EntFireByHandle(MW2019_Armor_Timer, "AddOutput", "OnTimer "+MW2019serverName+":RunScriptCode:MW2019_Armor_Check():0:-1", 0, null, null)
EntFireByHandle(MW2019_Armor_Timer, "Enable", "", 0.1, null, null)

MW2019cmd_client <- Entities.CreateByClassname("point_clientcommand");
MW2019cmd_client.__KeyValueFromString("classname", "info_target");
MW2019cmd_server <- Entities.CreateByClassname("point_servercommand");
MW2019cmd_server.__KeyValueFromString("classname", "info_target");