AddCSLuaFile()

SWEP.PrintName = "Quick Gun"

SWEP.Slot                  = 1
SWEP.SlotPos               = 0
 
SWEP.ViewModel             = "models/weapons/v_smg1.mdl"
SWEP.WorldModel            = "models/weapons/w_smg1.mdl"

SWEP.DrawAmmo = true

SWEP.Base = "weapon_base_muth"

SWEP.Primary.ClipSize      = 60
SWEP.Primary.DefaultClip   = 600
SWEP.Primary.Delay         = 0.04
SWEP.Primary.Ammo          = "357"
SWEP.Primary.Automatic     = true
SWEP.Primary.Sound         = Sound("Weapon_smg1.Single")
SWEP.Primary.Damage        = 100
 
SWEP.AutoSwitchTo          = false
SWEP.AutoSwitchFrom        = false

SWEP.Base = "weapon_base_muth"

SWEP.HoldType = "smg"

SWEP.UseHands              = true

--function SWEP:Reload()
	--self.Weapon:DefaultReload(ACT_VM_RELOAD)
	--if self:Clip1() <= 0 then self.Weapon:EmitSound(Sound("weapon_smg1.Reload")) end
--end



