AddCSLuaFile()

SWEP.PrintName = "Para"

SWEP.Slot                  = 3
SWEP.SlotPos               = 0

SWEP.ViewModelFOV = 50
 
SWEP.AutoSwitchTo          = false
SWEP.AutoSwitchFrom        = false
 
SWEP.ViewModel             = "models/weapons/cstrike/c_mach_m249para.mdl"
SWEP.WorldModel            = "models/weapons/w_mach_m249para.mdl"

SWEP.DrawAmmo = true

SWEP.Base = "weapon_base_muth"

SWEP.HoldType = "smg"

SWEP.UseHands              = true

SWEP.Primary.ClipSize      = 200
SWEP.Primary.DefaultClip   = 200
SWEP.Primary.Delay         = 0.1
SWEP.Primary.Ammo          = "smg1"
SWEP.Primary.Automatic     = true
SWEP.Primary.Sound         = Sound("Weapon_M249.Single")
SWEP.Primary.Damage        = 120

--self.View = Angle(math.Rand(-3, 0), math.Rand(-0.5, 0.5), 0)
SWEP.Spread = Vector(0.07, 0.07, 0.08)

if CLIENT then SWEP.Cost = 70 end
