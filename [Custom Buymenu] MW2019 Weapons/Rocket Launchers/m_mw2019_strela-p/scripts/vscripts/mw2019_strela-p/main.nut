if (!("migi_ProjWeapons" in this))
	migi_allocateEntityScope("projectiles.nut")
	
if (!("migi_initDeployWeapons" in this))
	migi_allocateEntityScope("initial_deploy.nut")

self.PrecacheModel("models/weapons/w_la_strela-p_rocket.mdl")
self.PrecacheScriptSound("Weapon_STRELA-P.Travel")

function VM_STRELA_GetAnim(vm)
{
	local anim_track = vm.LookupAttachment("a_flag");
	local anim_track_start = vm.LookupAttachment("a_flag_start");
	local tracked_anim = false;
		
    local org = vm.GetAttachmentOrigin(anim_track) - vm.GetOrigin();
    local org_base = vm.GetAttachmentOrigin(anim_track_start) - vm.GetOrigin();
	local org_dist = org - org_base;
	if (org_dist.z > 0.8 && org_dist.z < 1.2) tracked_anim = true;
	
	return tracked_anim;
}

MIGI_InitDeployWeapon("models/weapons/v_la_strela-p.mdl", "weapon_ump45", [3], "basic", null)
MIGI_Projectile(10, 0.9, 2600, "weapon_strela", 500, 200, 1.0, 30.0, 2.0, 10.0, 5.0, null, null, null, null, null, 650, false, "STRELA", "prop_dynamic", "models/weapons/w_la_strela-p_rocket.mdl", "models/weapons/v_la_strela-p.mdl", "Weapon_STRELA-P.Explode", "Weapon_STRELA-P.Travel", this.VM_STRELA_GetAnim)