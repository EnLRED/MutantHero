AddCSLuaFile()

SWEP.PrintName = "MP5"

SWEP.Slot                  = 3
SWEP.SlotPos               = 0

SWEP.ViewModelFOV = 60
 
SWEP.AutoSwitchTo          = false
SWEP.AutoSwitchFrom        = false
 
SWEP.UseHands = true
 
SWEP.ViewModel             = "models/weapons/cstrike/c_smg_mp5.mdl"
SWEP.WorldModel            = "models/weapons/w_smg_mp5.mdl"

SWEP.DrawAmmo = true

SWEP.Base = "weapon_base_muth"

SWEP.HoldType = "smg"

SWEP.UseHands              = true

SWEP.Primary.ClipSize      = 30
SWEP.Primary.DefaultClip   = 400
SWEP.Primary.Delay         = 0.08
SWEP.Primary.Ammo          = "smg1"
SWEP.Primary.Automatic     = true
SWEP.Primary.Sound         = Sound("Weapon_MP5Navy.Single")
SWEP.Primary.Damage        = 105

--self.View = Angle(math.Rand(-3, 0), math.Rand(-0.5, 0.5), 0)
SWEP.Spread = Vector(0.02, 0.02, 0.02)

if CLIENT then SWEP.Cost = 35 end