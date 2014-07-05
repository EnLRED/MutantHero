AddCSLuaFile()

SWEP.PrintName			= "Hook"			
SWEP.Author				= "HK47"
SWEP.Slot				= 1
SWEP.SlotPos			= 1

SWEP.HoldType			= "grenade"
SWEP.Base				= "wep_muth_melee_base"

SWEP.ShowWorldModel = false

SWEP.DrawAmmo = false

if CLIENT then
	SWEP.VElements = {
		["m"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10, 0, -1.2), angle = Angle(0, 90, 0), size = Vector(1.5, 1.5, 1.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["m"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 4, -2), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.HoldType = "grenade"

SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
}

SWEP.Weight				= 15
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= 0.3
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.Dmg = 110
SWEP.MissSound = "weapons/iceaxe/iceaxe_swing1.wav"
SWEP.HitSound = "weapons/crowbar/crowbar_impact" .. math.random(1, 2) ..".wav"
SWEP.SlashSound = "npc/zombie/claw_strike1.wav"



