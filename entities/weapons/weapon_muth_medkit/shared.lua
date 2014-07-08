AddCSLuaFile()

SWEP.PrintName			= "Medkit"

SWEP.Author				= "Original authors: robotboy655 & MaxOfS2D"

SWEP.ViewModel			= "models/weapons/c_medkit.mdl"
SWEP.WorldModel			= "models/weapons/w_medkit.mdl"

SWEP.ViewModelFOV		= 54
SWEP.Slot				= 5
SWEP.SlotPos			= 3

SWEP.Primary.ClipSize		= 100
SWEP.Primary.DefaultClip	= 100
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.HealAmount = 50
SWEP.MaxAmmo = 300

SWEP.UseHands = true

local HealSound = Sound("items/smallmedkit1.wav")
local DenySound = Sound("items/medshotno1.wav")

function SWEP:Initialize()
	self:SetWeaponHoldType("slam")

	if CLIENT then return end

	timer.Create("medkit_ammo" .. self:EntIndex(), 1, 0, function()
		if self:Clip1() < self.MaxAmmo then self:SetClip1(math.min(self:Clip1() + 10, self.MaxAmmo)) end
	end)
end

function SWEP:PrimaryAttack()
	if CLIENT then return end

	local tr = util.TraceLine  {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 75,
		filter = self.Owner
	}

	local ent = tr.Entity
	
	local need = self.HealAmount
	if IsValid(ent) then need = math.min(ent:GetMaxHealth() - ent:Health(), self.HealAmount) end

	if IsValid(ent) and self:Clip1() >= need and (ent:IsPlayer() or ent:IsNPC()) and ent:Health() < 800 then
		self:TakePrimaryAmmo(need)

		ent:SetHealth(math.min(ent:GetMaxHealth(), ent:Health() + need))
		ent:EmitSound(HealSound)

		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

		self:SetNextPrimaryFire(CurTime() + self:SequenceDuration() + 0.5)
		self.Owner:SetAnimation(PLAYER_ATTACK1)

		timer.Create( "weapon_idle" .. self:EntIndex(), self:SequenceDuration(), 1, function() if IsValid(self) then self:SendWeaponAnim(ACT_VM_IDLE) end end)
	else
		self.Owner:EmitSound(DenySound)
		self:SetNextPrimaryFire(CurTime() + 1)
	end

end

function SWEP:SecondaryAttack()
	if CLIENT then return end

	local ent = self.Owner
	
	local need = self.HealAmount
	if IsValid(ent) then need = math.min(ent:GetMaxHealth() - ent:Health(), self.HealAmount) end

	if IsValid(ent) and self:Clip1() >= need and ent:Health() < ent:GetMaxHealth() then
		self:TakePrimaryAmmo(need)

		ent:SetHealth(math.min(ent:GetMaxHealth(), ent:Health() + need))
		ent:EmitSound(HealSound)

		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

		self:SetNextSecondaryFire(CurTime() + self:SequenceDuration() + 0.5)
		self.Owner:SetAnimation(PLAYER_ATTACK1)

		timer.Create("weapon_idle" .. self:EntIndex(), self:SequenceDuration(), 1, function() if IsValid( self ) then self:SendWeaponAnim(ACT_VM_IDLE) end end)
	else
		ent:EmitSound(DenySound)
		self:SetNextSecondaryFire(CurTime() + 1)
	end
end

function SWEP:OnRemove()
	timer.Stop("medkit_ammo" .. self:EntIndex())
	timer.Stop("weapon_idle" .. self:EntIndex())
end

function SWEP:Holster()
	timer.Stop("weapon_idle" .. self:EntIndex())
	
	return true
end
