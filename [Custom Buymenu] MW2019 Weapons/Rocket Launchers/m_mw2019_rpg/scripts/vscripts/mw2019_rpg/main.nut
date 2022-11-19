if (!("migi_ProjWeapons" in this))
	migi_allocateEntityScope("projectiles.nut")
	
if (!("migi_initDeployWeapons" in this))
	migi_allocateEntityScope("initial_deploy.nut")

self.PrecacheModel("models/weapons/w_la_rpg_rocket.mdl")
self.PrecacheScriptSound("Weapon_RPG.Travel")

function VM_RPG_GetAnim(vm)
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

MIGI_InitDeployWeapon("models/weapons/v_la_rpg.mdl", "weapon_ump45", [3], "basic", null)
MIGI_Projectile(10, 0.9, 2700, "weapon_rpg", 600, 200, 1.0, 30.0, 2.0, 10.0, 5.0, null, null, null, null, null, 450, false, "RPG", "prop_dynamic", "models/weapons/w_la_rpg_rocket.mdl", "models/weapons/v_la_rpg.mdl", "Weapon_RPG.Explode", "Weapon_RPG.Travel", this.VM_RPG_GetAnim)