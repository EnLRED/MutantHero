AddCSLuaFile("shared.lua")

SWEP.Weight                = 3
SWEP.AutoSwitchTo          = false
SWEP.AutoSwitchFrom        = false

SWEP.DrawAmmo              = false
SWEP.DrawCrosshair         = true
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false

SWEP.Author                = ""
SWEP.Contact               = ""
SWEP.Purpose               = ""
SWEP.Instructions          = ""
 
SWEP.Spawnable             = false
SWEP.AdminSpawnable	       = false

SWEP.ViewModel = "models/weapons/c_arms_citizen.mdl"
SWEP.WorldModel = ""
 
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Ent = ""

SWEP.UseHands = true

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
	if CLIENT then return end

	local tr = self.Owner:GetEyeTrace()
	
	if self.Owner:GetPos():Distance(tr.HitPos) <= 70 and tr.Hit then
		local ent = ents.Create(self.Ent)
		self:PreSetUp(ent)
		ent:SetPos(tr.HitPos)
		local ang = tr.HitNormal:Angle()
		ang:RotateAroundAxis(ang:Right(), -90)
		ang:RotateAroundAxis(ang:Up(), self.Owner:EyeAngles().yaw)
		ent:SetAngles(ang)
		ent:Spawn()
		
		ent:SetNWBool("made_by_people_muth", true)
		
		self:EntitySetUp(ent)
		
		self.Owner:StripWeapon(self.ClassName)
	else
		self.Owner:ChatPrint("Look at something")
	end
end

function SWEP:PreSetUp(ent)
	//do something with ent
end

function SWEP:EntitySetUp(ent)
	//do something with ent
end

function SWEP:Think()
end

function SWEP:SecondaryAttack()
end

function SWEP:Deploy()
	return true
end

function SWEP:Holster()
	return true
end

function SWEP:OnRemove()
	self:Holster()
end

if CLIENT then
	//SWEP.Cost = 60
end










