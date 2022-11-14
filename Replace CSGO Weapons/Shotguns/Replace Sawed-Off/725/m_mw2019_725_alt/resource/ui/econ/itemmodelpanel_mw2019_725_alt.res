"Resource/UI/Econ/ItemModelPanelCharWeaponInspect.res"
{	
	"default_weapons"
	{
		"rule"
		{
			// Default rule matches all weapons and sets up all default settings
		}
		"config"
		{
			"root_mdl"					    ""		                                // Which pedestal model to load, weapon model is merged to the pedestal, null => weapon model is the scene
			"root_anim"					    ""                          			// Which activity to play on the pedestal
			"root_anim_loop"			    ""				                        // Which activity to play on the pedestal after the initial pedestal animation finishes
			"weapon_anim"				    ""						                // Which activity to play on the weapon
			"weapon_anim_loop"			    ""	                					// Which activity to play on the weapon after the initial weapon animation finishes
			"root_camera"				    "cam_inspect"							// Which attachment specifies camera location
			"light_directional_clearall" "1"
			"light_directional_add"      "rgb{0.89 0.89 0.89} dir[-0.34 -0.90 -0.29] rot[0.0 0.0 0.0] flicker[0.00 0.00 0.00 0.00]"
			"light_directional_add"      "rgb{0.73 0.73 0.73} dir[0.23 0.94 -0.24] rot[0.0 0.0 0.0] flicker[0.00 0.00 0.00 0.00]"
			"light_directional_add"      "rgb{0.88 0.88 0.88} dir[0.97 0.02 -0.23] rot[0.0 0.0 0.0] flicker[0.00 0.00 0.00 0.00]"
			"shadow_light_offset"        "36.42 26.30 15.58"
			"shadow_light_orient"        "33.72 -112.77 0.00"
			"shadow_light_brightness"    "2.7"
			"shadow_light_color"         "[1.00 1.00 1.00]"
			"shadow_light_rotation"      "[0.00 0.00 0.00]"
			"shadow_light_flicker"       "[0.00 0.00 0.00 0.00]"
			"shadow_light_hfov"       "53.9"
			"shadow_light_vfov"       "53.9"
			"shadow_light_znear"       "23.9"
			"shadow_light_zfar"       "59.7"
			"shadow_light_atten_farz"       "119.4"
			"light_ambient"              "[0.06 0.06 0.06]"
			"item_rotate"		"x[-180 180] z[-180 180] y[-180 180]"			// rotate bounds and order of rotation for mouse drag in x then y axis, i.e. y[-10 10] z[20 -20] means dragging mouse horizontally results in a rotation around y between -10 and 10 degrees, and dragging mouse vertically results in a rotation around z between 20 and -20 degrees (sign of bounds indicate which flipped 'sense' the rotation is in)
			"item_orient"	   "0.0 0.0 0.0"									// initial orientation of item (if not attached)
		}
	}
	"Shotguns"
	{
		"rule"
		{
			"type" "Shotgun"
		}
		"config"
		{
			"light_directional_clearall" "1"
			"light_directional_add"      "rgb{0.71 0.71 0.71} dir[-0.06 -0.97 -0.22] rot[0.0 0.0 0.0] flicker[0.00 0.00 0.00 0.00]"
			"light_directional_add"      "rgb{0.42 0.42 0.42} dir[-0.92 0.29 0.27] rot[0.0 0.0 0.0] flicker[0.00 0.00 0.00 0.00]"
			"shadow_light_offset"        "31.03 27.83 19.50"
			"shadow_light_orient"        "35.32 -105.43 0.00"
			"shadow_light_brightness"    "3.00"
			"shadow_light_color"         "[1.00 1.00 1.00]"
			"shadow_light_rotation"      "[0.00 0.00 0.00]"
			"shadow_light_flicker"       "[0.00 0.00 0.00 0.00]"
			"shadow_light_hfov"       "70.0"
			"shadow_light_vfov"       "70.0"
			"shadow_light_znear"       "14.7"
			"shadow_light_zfar"       "67.2"
			"shadow_light_atten_farz"       "134.5"
			"light_ambient"              "[0.06 0.06 0.06]"
			"camera_offset"				    "48 38 13"
			"camera_orient"				    "23.8 -111 0"
			"orbit_pivot"					"26.86 -15.6 -12.27"
			"shadow_light_offset"		    "50.35 -36.38 81.06"
			"shadow_light_orient"		    "62.82 131.73 0"
			"item_rotate"	  "y[-360 360] x[ 0 0 ]"
		}
	}
	"mw2019_725"
	{
		"rule"
		{
			"model" "v_sh_725"
		}
		"config"
		{
			"camera_offset"   "45.75 46.27 -10.29"
			"camera_orient"   "-5.35 -115.35 0.00"
			"orbit_pivot"     "22.82 -3.24 -4.05"
			"root_camera_fov"     "54.0"
			"item_rotate"	  "y[-360 360] z[ -30 30 ]"
			"shadow_light_color"         "[0.90 0.96 1.00]"
			"shadow_light_brightness"    "3.0"
			"light_directional_clearall" "1"
			"light_directional_add"      "rgb{0.62 0.76 0.90} dir[-0.34 -0.90 -0.29] rot[0.0 0.0 0.0] flicker[0.00 0.00 0.00 0.00]"
			"light_directional_add"      "rgb{0.48 0.78 0.84} dir[0.23 0.94 -0.24] rot[0.0 0.0 0.0] flicker[0.00 0.00 0.00 0.00]"
			"light_directional_add"      "rgb{0.68 0.89 1.00} dir[0.97 0.02 -0.23] rot[0.0 0.0 0.0] flicker[0.00 0.00 0.00 0.00]"
			"light_ambient"              "[0.20 0.34 0.46]"
			"weapon_anim"		"inv"
			"weapon_anim_loop"		"inv"
		}
	}
}
