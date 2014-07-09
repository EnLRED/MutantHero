AddCSLuaFile()

SWEP.PrintName = "XM1014"

SWEP.Slot                  = 3
SWEP.SlotPos               = 0

SWEP.ViewModelFOV = 50
 
SWEP.AutoSwitchTo          = false
SWEP.AutoSwitchFrom        = false
 
SWEP.ViewModel             = "models/weapons/cstrike/c_shot_xm1014.mdl"
SWEP.WorldModel            = "models/weapons/w_shot_xm1014.mdl"

SWEP.DrawAmmo = true

SWEP.Base = "weapon_base_muth"

SWEP.HoldType = "smg"

SWEP.UseHands              = true

SWEP.Primary.ClipSize      = 6
SWEP.Primary.DefaultClip   = 30
SWEP.Primary.Delay         = 0.2
SWEP.Primary.Ammo          = "buckshot"
SWEP.Primary.Automatic     = false
SWEP.Primary.Sound         = Sound("Weapon_XM1014.Single")
SWEP.Primary.Damage        = 40

--self.View = Angle(math.Rand(-3, 0), math.Rand(-0.5, 0.5), 0)
SWEP.Spread = Vector(0.06, 0.06, 0.06)

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then return end
	if self.Owner:GetActiveWeapon() != self then return end
	
	timer.Stop("reload_" .. self:EntIndex())
	timer.Stop("idle_" .. self:EntIndex())
	
	self.Owner:LagCompensation(true)
	
	self:TakePrimaryAmmo(1)
	
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

    local bullet = {}
    bullet.Num = 6
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

function SWEP:Reload()
	if self:Clip1() >= 6 then return end
	if self:Ammo1() <= 0 then return end

	self:SetNextPrimaryFire(CurTime() + 0.15)

	local num = math.min(6 - self:Clip1(), self:Ammo1())
	
	timer.Create("reload_" .. self:EntIndex(), 0.4, num, function()
		self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
		self.Owner:SetAnimation(PLAYER_RELOAD)
		
		self:SetClip1(self:Clip1() + 1)
		self.Owner:RemoveAmmo(1, "buckshot")
	end)
	
	timer.Create("idle_" .. self:EntIndex(), (6 - self:Clip1()) * 0.5, 1, function()
		self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
	end)
end

if CLIENT then SWEP.Cost = 50 end
