AddCSLuaFile()

SWEP.PrintName			= "Antidote"

SWEP.Author				= "HK47"

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

SWEP.UseHands = true

local HealSound = Sound("items/smallmedkit1.wav")

function SWEP:Initialize()
	self:SetWeaponHoldType("slam")
end

function SWEP:PrimaryAttack()
	if CLIENT then return end

	local tr = util.TraceLine  {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 80,
		filter = self.Owner
	}

	local ent = tr.Entity
	
	if IsValid(ent) and ent:IsPlayer() and ent:Team() == TEAM_MUTANTS and timer.Exists("kill_" .. ent:EntIndex()) then
		self.Weapon:EmitSound(HealSound)
		
		ent:ChatPrint("You have been healed")
		
		timer.Stop("kill_" .. ent:EntIndex())
		ent:SetColor(Color(255, 255, 255))
		
		self.Owner:StripWeapon(self.ClassName)
	end
end

function SWEP:SecondaryAttack()
	if CLIENT then return end

	local ent = self.Owner
	
	if IsValid(ent) and ent:Team() == TEAM_MUTANTS and timer.Exists("kill_" .. ent:EntIndex()) then
		self.Weapon:EmitSound(HealSound)
		
		ent:ChatPrint("You have been healed")
		
		timer.Stop("kill_" .. ent:EntIndex())
		ent:SetColor(Color(255, 255, 255))
		
		self.Owner:StripWeapon(self.ClassName)
	end
end

function SWEP:Holster()
	return true
end
