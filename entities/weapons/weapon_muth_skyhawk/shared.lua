AddCSLuaFile()

SWEP.PrintName = "Sky hawk"

SWEP.Slot                  = 2
SWEP.SlotPos               = 0
 
SWEP.ViewModel             = "models/weapons/v_crossbow.mdl"
SWEP.WorldModel            = "models/weapons/w_crossbow.mdl"

SWEP.DrawAmmo = true

SWEP.Base = "weapon_base"
 
SWEP.Primary.ClipSize      = 5
SWEP.Primary.DefaultClip   = 25
SWEP.Primary.Delay         = 0.4
SWEP.Primary.Ammo          = "ar2"
SWEP.Primary.Automatic     = true

function SWEP:Initialize()
	self:SetWeaponHoldType("crossbow")
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
	self.Weapon:DefaultReload(ACT_VM_DRAW)
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
	bullet.TracerName = "ar2tracer" 
    bullet.Spread = 0
    bullet.Tracer = 1
	bullet.Force = 25
	bullet.Damage = math.random(400, 800)
	
	self.Weapon:EmitSound(Sound("weapon_crossbow.Single"))

    self.Owner:FireBullets(bullet)
    self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    self.Owner:MuzzleFlash()
    self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	self.Owner:LagCompensation(false)
end

