AddCSLuaFile()

SWEP.PrintName = "Quick Gun"

SWEP.Slot                  = 1
SWEP.SlotPos               = 0
 
SWEP.ViewModel             = "models/weapons/c_smg1.mdl"
SWEP.WorldModel            = "models/weapons/w_smg1.mdl"

SWEP.DrawAmmo = true

SWEP.Base = "weapon_base_muth"

SWEP.Primary.ClipSize      = 60
SWEP.Primary.DefaultClip   = 400
SWEP.Primary.Delay         = 0.04
SWEP.Primary.Ammo          = "357"
SWEP.Primary.Automatic     = true
SWEP.Primary.Sound         = Sound("Weapon_smg1.Single")
SWEP.Primary.Damage        = 100
 
SWEP.AutoSwitchTo          = false
SWEP.AutoSwitchFrom        = false

SWEP.Base = "weapon_base_muth"

SWEP.HoldType = "smg"

SWEP.Spread = Vector(0.015, 0.015, 0.015)
SWEP.UseHands              = true

if CLIENT then SWEP.Cost = 55 end


