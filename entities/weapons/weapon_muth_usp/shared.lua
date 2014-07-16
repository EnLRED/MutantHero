AddCSLuaFile()

SWEP.PrintName = "USP"

SWEP.Slot                  = 2
SWEP.SlotPos               = 0

SWEP.ViewModelFOV = 60
 
SWEP.AutoSwitchTo          = false
SWEP.AutoSwitchFrom        = false
 
SWEP.UseHands = true
 
SWEP.ViewModel             = "models/weapons/cstrike/c_pist_usp.mdl"
SWEP.WorldModel            = "models/weapons/w_pist_usp.mdl"

SWEP.DrawAmmo = true

SWEP.Base = "weapon_base_muth"

SWEP.HoldType = "pistol"

SWEP.IsPistol_muth = true
SWEP.UseHands              = true

SWEP.Primary.ClipSize      = 13
SWEP.Primary.DefaultClip   = 36
SWEP.Primary.Delay         = 0.2
SWEP.Primary.Ammo          = "pistol"
SWEP.Primary.Automatic     = false
SWEP.Primary.Sound         = Sound("Weapon_USP.Single")
SWEP.Primary.Damage        = 105

--self.View = Angle(math.Rand(-3, 0), math.Rand(-0.5, 0.5), 0)
SWEP.Spread = Vector(0.006, 0.006, 0.006)

if CLIENT then SWEP.Cost = 15 end

