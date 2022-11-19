if (!("migi_ProjWeapons" in this))
	migi_allocateEntityScope("projectiles.nut")

if (!("migi_initDeployWeapons" in this))
	migi_allocateEntityScope("initial_deploy.nut")

self.PrecacheModel("models/weapons/w_la_mgl32_charge.mdl")

function VM_MGL32_GetAnim(vm)
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

MIGI_InitDeployWeapon("models/weapons/v_la_mgl32.mdl", "weapon_ump45", [4], "basic", null)
MIGI_Projectile(10, 0.6, 3000, "weapon_mgl32", 400, 200, 1.0, 24.0, 1.0, 8.0, 3.0, null, null, null, null, null, 600, false, "MGL32", "prop_dynamic", "models/weapons/w_la_mgl32_charge.mdl", "models/weapons/v_la_mgl32.mdl", "Weapon_MGL32.Explode", null, this.VM_MGL32_GetAnim)