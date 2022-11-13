if (!("migi_initDeployWeapons" in this))
	migi_allocateEntityScope("initial_deploy.nut")

// sound precache
self.PrecacheScriptSound("Weapon_Model680.Reload_Empty_Start_Open_01");
self.PrecacheScriptSound("Weapon_Model680.Reload_Empty_Start_Close_01");

::model680_GetCurrentAnim <- function(vm)
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

::model680_GetSoundscript <- function(vm)
{
	local snd_track = vm.LookupAttachment("snd_flag");
	local snd_track_start = vm.LookupAttachment("snd_flag_start");
	local snd_track_script = "none";
		
    local org = vm.GetAttachmentOrigin(snd_track) - vm.GetOrigin();
    local org_base = vm.GetAttachmentOrigin(snd_track_start) - vm.GetOrigin();
	local org_dist = org - org_base;
	if (org_dist.z > 0.8 && org_dist.z < 1.2) snd_track_script = "sound1";
	else if (org_dist.z < -0.8 && org_dist.z > -1.2) snd_track_script = "sound2";
	
	return snd_track_script;
}

function model680_CustomDeployCheck(vm)
{
	local ply = vm.GetMoveParent()
	if (!ply || !ply.IsValid()) return;
	
	local VMDL = vm.GetModelName();
	local model680_index = MIGI_InitDeploy_GetWpnIndex("models/weapons/v_sh_model680.mdl", "weapon_sawedoff");
	if (model680_index < 0 || VMDL != "models/weapons/v_sh_model680.mdl") return;
	
	ply.ValidateScriptScope();
	local draw_scope = ply.GetScriptScope();
	if(!draw_scope.rawin("model680_sndPlayTime"))
	{
		draw_scope.model680_sndCanPlay <- false
		draw_scope.model680_sndPlayTime <- Time()
	}
	if (ply.GetHealth() < 1)
	{
		draw_scope.plyOwnedWpn[model680_index] = false;
		draw_scope.model680_sndCanPlay = false;
	}
	
	if (model680_GetCurrentAnim(vm) == "reload_end")
	{
		if (model680_GetSoundscript(vm) != "none")
			draw_scope.model680_sndCanPlay = true;
		else draw_scope.model680_sndPlayTime <- Time();
		
		if (draw_scope.model680_sndCanPlay == true)
		{
			if (model680_GetSoundscript(vm) == "sound1" && Time() - draw_scope.model680_sndPlayTime > 0.04)
			{
				ply.EmitSound("Weapon_Model680.Reload_Empty_Start_Open_01");
				draw_scope.model680_sndPlayTime <- Time();
				draw_scope.model680_sndCanPlay = false;
			}
			if (model680_GetSoundscript(vm) == "sound2" && Time() - draw_scope.model680_sndPlayTime > 0.04)
			{
				ply.EmitSound("Weapon_Model680.Reload_Empty_Start_Close_01");
				draw_scope.model680_sndPlayTime <- Time();
				draw_scope.model680_sndCanPlay = false;
			}
		}
	}
		
	if (draw_scope.plyWeapon_FD[model680_index] == false)
	{
		draw_scope.plyWeapon_FD[model680_index] = true
		vm.__KeyValueFromInt("sequence", 6)
	}
}

MIGI_InitDeployWeapon("models/weapons/v_sh_model680.mdl", "weapon_sawedoff", [6], this.model680_CustomDeployCheck, null)