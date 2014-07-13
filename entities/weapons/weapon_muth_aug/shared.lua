AddCSLuaFile()

SWEP.PrintName = "Aug"

SWEP.Slot                  = 4
SWEP.SlotPos               = 0

SWEP.ViewModelFOV = 60
 
SWEP.AutoSwitchTo          = false
SWEP.AutoSwitchFrom        = false
 
SWEP.UseHands = true
 
SWEP.ViewModel             = "models/weapons/cstrike/c_rif_aug.mdl"
SWEP.WorldModel            = "models/weapons/w_rif_aug.mdl"

SWEP.DrawAmmo = true

SWEP.Base = "weapon_base_muth"

SWEP.HoldType = "smg"

SWEP.UseHands              = true

SWEP.Primary.ClipSize      = 30
SWEP.Primary.DefaultClip   = 200
SWEP.Primary.Delay         = 0.15
SWEP.Primary.Ammo          = "smg1"
SWEP.Primary.Automatic     = true
SWEP.Primary.Sound         = Sound("Weapon_Aug.Single")
SWEP.Primary.Damage        = 105

--self.View = Angle(math.Rand(-3, 0), math.Rand(-0.5, 0.5), 0)
SWEP.Spread = Vector(0.02, 0.02, 0.02)

if CLIENT then SWEP.Cost = 40 end

