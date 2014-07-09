AddCSLuaFile()

SWEP.PrintName = "Predator"

SWEP.Slot                  = 2
SWEP.SlotPos               = 0
 
SWEP.ViewModel             = "models/weapons/v_pistol.mdl"
SWEP.WorldModel            = "models/weapons/w_pistol.mdl"

SWEP.DrawAmmo = true

SWEP.Base = "weapon_base"
 
SWEP.Primary.ClipSize      = 15
SWEP.Primary.DefaultClip   = 80
SWEP.Primary.Delay         = 0.3
SWEP.Primary.Ammo          = "pistol"
SWEP.Primary.Automatic     = false

if CLIENT then SWEP.Cost = 35 end

function SWEP:Initialize()
	self:SetWeaponHoldType("pistol")
end

function SWEP:SecondaryAttack()
end

function SWEP:Holster()
	return true
end

function SWEP:OnRemove()
	self:Holster()
end

function SWEP:OnDrop()
	return false
end

function SWEP:Reload()
	self.Weapon:DefaultReload(ACT_VM_RELOAD)
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
    bullet.Spread = 0
    bullet.Tracer = 1

	local tr = self.Owner:GetEyeTrace()
	
	if tr.Entity:IsPlayer() and tr.Entity:Team() == 1 then
		bullet.Force = 0
		bullet.Damage = 0
	else
		bullet.Force = 15
		bullet.Damage = 70
	end
	
	self.Weapon:EmitSound(Sound("weapon_357.Single"))

    self.Owner:FireBullets(bullet)
    self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    self.Owner:MuzzleFlash()
    self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	self.Owner:LagCompensation(false)
end


