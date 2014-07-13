AddCSLuaFile()

SWEP.PrintName = "P228"

SWEP.Slot                  = 2
SWEP.SlotPos               = 0

SWEP.ViewModelFOV = 60
 
SWEP.AutoSwitchTo          = false
SWEP.AutoSwitchFrom        = false
 
SWEP.UseHands = true
 
SWEP.ViewModel             = "models/weapons/cstrike/c_pist_p228.mdl"
SWEP.WorldModel            = "models/weapons/w_pist_p228.mdl"

SWEP.DrawAmmo = true

SWEP.Base = "weapon_base_muth"

SWEP.HoldType = "smg"

SWEP.UseHands              = true

SWEP.Primary.ClipSize      = 13
SWEP.Primary.DefaultClip   = 36
SWEP.Primary.Delay         = 0.1
SWEP.Primary.Ammo          = "pistol"
SWEP.Primary.Automatic     = false
SWEP.Primary.Sound         = Sound("Weapon_P228.Single")
SWEP.Primary.Damage        = 100

--self.View = Angle(math.Rand(-3, 0), math.Rand(-0.5, 0.5), 0)
SWEP.Spread = Vector(0.005, 0.005, 0.005)

if CLIENT then SWEP.Cost = 15 end

