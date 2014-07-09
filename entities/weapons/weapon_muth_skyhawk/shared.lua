AddCSLuaFile()

SWEP.PrintName = "Sky Hawk"

SWEP.Slot                  = 3
SWEP.SlotPos               = 0

SWEP.ViewModelFOV = 50
 
SWEP.AutoSwitchTo          = false
SWEP.AutoSwitchFrom        = false
 
SWEP.ViewModel             = "models/weapons/c_crossbow.mdl"
SWEP.WorldModel            = "models/weapons/w_crossbow.mdl"

SWEP.DrawAmmo = true

SWEP.Base = "weapon_base_muth"

SWEP.HoldType = "crossbow"

SWEP.UseHands = true

SWEP.Primary.ClipSize      = 10
SWEP.Primary.DefaultClip   = 30
SWEP.Primary.Delay         = 0.6
SWEP.Primary.Ammo          = "ar2"
SWEP.Primary.Automatic     = true
SWEP.Primary.Sound         = Sound("weapon_crossbow.Single")
SWEP.Primary.Damage        = 420

SWEP.Spread = Vector(0, 0, 0)

if CLIENT then SWEP.Cost = 55 end
