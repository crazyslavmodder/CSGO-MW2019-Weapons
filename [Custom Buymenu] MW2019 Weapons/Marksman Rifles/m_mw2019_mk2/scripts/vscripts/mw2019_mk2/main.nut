if (!("migi_initDeployWeapons" in this))
	migi_allocateEntityScope("initial_deploy.nut")

// sound precache
self.PrecacheScriptSound("Weapon_MK2.Rechamber");
self.PrecacheScriptSound("Weapon_MK2.Reload_End_Cock");

::mk2_GetCurrentAnim <- function(vm)
{
	local anim_track = vm.LookupAttachment("a_flag");
	local anim_track_start = vm.LookupAttachment("a_flag_start");
	local anim_track_state = "none";
		
    local org = vm.GetAttachmentOrigin(anim_track) - vm.GetOrigin();
    local org_base = vm.GetAttachmentOrigin(anim_track_start) - vm.GetOrigin();
	local org_dist = org - org_base;
	if (org_dist.z > 0.8 && org_dist.z < 1.2) anim_track_state = "reload_end";
	
	return anim_track_state;
}

::mk2_GetSoundscript <- function(vm)
{
	local snd_track = vm.LookupAttachment("snd_flag");
	local snd_track_start = vm.LookupAttachment("snd_flag_start");
	local snd_track_script = "none";
		
    local org = vm.GetAttachmentOrigin(snd_track) - vm.GetOrigin();
    local org_base = vm.GetAttachmentOrigin(snd_track_start) - vm.GetOrigin();
	local org_dist = org - org_base;
	if (org_dist.z > 0.8 && org_dist.z < 1.2) snd_track_script = "sound_emit";
	
	return snd_track_script;
}

function mk2_CustomDeployCheck(vm)
{
	local ply = vm.GetMoveParent()
	if (!ply || !ply.IsValid()) return;
	
	local VMDL = vm.GetModelName();
	local mk2_index = MIGI_InitDeploy_GetWpnIndex("models/weapons/v_sn_mk2.mdl", "weapon_sawedoff");
	if (mk2_index < 0 || VMDL != "models/weapons/v_sn_mk2.mdl") return;
	
	ply.ValidateScriptScope();
	local draw_scope = ply.GetScriptScope();
	if(!draw_scope.rawin("mk2_sndPlayTime"))
	{
		draw_scope.mk2_sndCanPlay <- false
		draw_scope.mk2_playLastSnd <- function()
		{
			self.EmitSound("Weapon_MK2.Reload_End_Cock");
		}
		draw_scope.mk2_sndPlayTime <- Time()
	}
	if (ply.GetHealth() < 1)
	{
		draw_scope.plyOwnedWpn[mk2_index] = false;
		draw_scope.mk2_sndCanPlay = false;
	}
	
	if (mk2_GetCurrentAnim(vm) == "reload_end")
	{
		if (mk2_GetSoundscript(vm) != "none")
			draw_scope.mk2_sndCanPlay = true;
		else draw_scope.mk2_sndPlayTime <- Time();
		
		if (draw_scope.mk2_sndCanPlay == true)
		{
			if (mk2_GetSoundscript(vm) == "sound_emit" && Time() - draw_scope.mk2_sndPlayTime > 0.05)
			{
				ply.EmitSound("Weapon_MK2.Rechamber");
				EntFireByHandle(ply, "RunScriptCode", "mk2_playLastSnd()", 0.03, null, null);
				draw_scope.mk2_sndPlayTime <- Time();
				draw_scope.mk2_sndCanPlay = false;
			}
		}
	}
		
	if (draw_scope.plyWeapon_FD[mk2_index] == false)
	{
		draw_scope.plyWeapon_FD[mk2_index] = true
		vm.__KeyValueFromInt("sequence", 6)
	}
}

MIGI_InitDeployWeapon("models/weapons/v_sn_mk2.mdl", "weapon_sawedoff", [6], this.mk2_CustomDeployCheck, null)