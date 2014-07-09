AddCSLuaFile()

SWEP.PrintName = "Ump45"

SWEP.Slot                  = 3
SWEP.SlotPos               = 0

SWEP.ViewModelFOV = 50
 
SWEP.AutoSwitchTo          = false
SWEP.AutoSwitchFrom        = false
 
SWEP.ViewModel             = "models/weapons/cstrike/c_smg_ump45.mdl"
SWEP.WorldModel            = "models/weapons/w_smg_ump45.mdl"

SWEP.DrawAmmo = true

SWEP.Base = "weapon_base_muth"

SWEP.HoldType = "smg"

SWEP.UseHands              = true

SWEP.Primary.ClipSize      = 30
SWEP.Primary.DefaultClip   = 200
SWEP.Primary.Delay         = 0.07
SWEP.Primary.Ammo          = "smg1"
SWEP.Primary.Automatic     = true
SWEP.Primary.Sound         = Sound("Weapon_ump45.Single")
SWEP.Primary.Damage        = 90

--self.View = Angle(math.Rand(-3, 0), math.Rand(-0.5, 0.5), 0)
SWEP.Spread = Vector(0.03, 0.03, 0.03)

if CLIENT then SWEP.Cost = 40 end
