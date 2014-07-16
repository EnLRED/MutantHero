AddCSLuaFile()

SWEP.PrintName			= "Total teleporter"			
SWEP.Author				= "HK47"
SWEP.Slot				= 1
SWEP.SlotPos			= 0

SWEP.HoldType			= "knife"
SWEP.Base				= "wep_muth_melee_base"

SWEP.ShowWorldModel = false

SWEP.DrawAmmo = false

if CLIENT then
	SWEP.Cost = 60
end

SWEP.HoldType = "knife"

SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false

SWEP.ViewModel = "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel = "models/weapons/v_knife_t.mdl"

SWEP.Weight				= 1
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay			= 0.4
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.UseHands = true

SWEP.IsBuyable = true

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 250)
	
	self.Owner:SetPos(self.Owner:GetNWVector("muth_startpoint"))
	
	self.Owner:EmitSound("ambient/energy/whiteflash.wav")
	
	local ef = EffectData()
	ef:SetOrigin(self.Owner:GetPos())
	util.Effect("effect_teleport_muth", ef)
end

