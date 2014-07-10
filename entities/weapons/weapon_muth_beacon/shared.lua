AddCSLuaFile()

SWEP.PrintName = "Beacon"

SWEP.Slot                  = 2
SWEP.SlotPos               = 0

SWEP.ViewModelFOV = 50
 
SWEP.AutoSwitchTo          = false
SWEP.AutoSwitchFrom        = false
 
SWEP.ViewModel = "models/weapons/c_arms_citizen.mdl"
SWEP.WorldModel            = "models/props_combine/combine_mine01.mdl"

SWEP.DrawAmmo = true

SWEP.Base = "weapon_baseput_muth"

SWEP.HoldType = "slam"

SWEP.Ent = "prop_physics"

SWEP.Primary.Ammo = "NONE"

function SWEP:PreSetUp(ent)
	ent:SetModel("models/props_combine/combine_mine01.mdl")
end

function SWEP:EntitySetUp(ent)
	ent:SetNWBool("isBeacon", true)
end

if CLIENT then SWEP.Cost = 15 end