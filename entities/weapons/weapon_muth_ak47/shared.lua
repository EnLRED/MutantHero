AddCSLuaFile()

SWEP.PrintName = "AK47"

SWEP.Slot                  = 3
SWEP.SlotPos               = 0

SWEP.ViewModelFOV = 50
 
SWEP.AutoSwitchTo          = false
SWEP.AutoSwitchFrom        = false
 
SWEP.UseHands = true
 
SWEP.ViewModel             = "models/weapons/cstrike/c_rif_ak47.mdl"
SWEP.WorldModel            = "models/weapons/w_rif_ak47.mdl"

SWEP.DrawAmmo = true

SWEP.Base = "weapon_base_muth"

SWEP.HoldType = "smg"

SWEP.UseHands              = true

SWEP.Primary.ClipSize      = 30
SWEP.Primary.DefaultClip   = 400
SWEP.Primary.Delay         = 0.1
SWEP.Primary.Ammo          = "smg1"
SWEP.Primary.Automatic     = true
SWEP.Primary.Sound         = Sound("Weapon_AK47.Single")
SWEP.Primary.Damage        = 120

--self.View = Angle(math.Rand(-3, 0), math.Rand(-0.5, 0.5), 0)
SWEP.Spread = Vector(0.06, 0.06, 0.06)

if CLIENT then SWEP.Cost = 50 end
