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
 
SWEP.Primary.Sound			= Sound("")
SWEP.Primary.Recoil			= 1.5
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.Delay			= 0.5

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Damage         = 0

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Spread = Vector(0, 0, 0)
SWEP.View = Angle(0, 0, 0)

SWEP.UseHands = true

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then return end
	if self.Owner:GetActiveWeapon() != self then return end
	
	self.Owner:LagCompensation(true)
	
	self:TakePrimaryAmmo(1)
	
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    local bullet = {}
    bullet.Num = 1
    bullet.Src = self.Owner:GetShootPos()
    bullet.Dir = self.Owner:GetAimVector()
    bullet.Spread = self.Spread
	bullet.Force = 0
    bullet.Tracer = 1
	bullet.Damage = self.Primary.Damage
	
	self.Weapon:EmitSound(self.Primary.Sound)

    self.Owner:FireBullets(bullet)
    self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    self.Owner:MuzzleFlash()
	--self.Owner:ViewPunch(self.View)
    self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	self.Owner:LagCompensation(false)
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










