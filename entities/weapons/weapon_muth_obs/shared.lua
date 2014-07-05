AddCSLuaFile()
AddCSLuaFile("effect_muth_obs")

SWEP.PrintName = "Orbital Strike"

SWEP.Slot                  = 3
SWEP.SlotPos               = 0
 
SWEP.ViewModel             = ""
SWEP.WorldModel            = ""

SWEP.DrawAmmo = true

SWEP.Base = "weapon_base"
 
SWEP.Primary.ClipSize      = -1
SWEP.Primary.DefaultClip   = -1
SWEP.Primary.Delay         = 1
SWEP.Primary.Ammo          = "none"
SWEP.Primary.Automatic     = false

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

function SWEP:PrimaryAttack()
	if self.Owner:GetActiveWeapon() != self then return end
	
	if CLIENT then return end
	
	local tr = self.Owner:GetEyeTrace()
	
	self.Owner:StripWeapon("weapon_muth_obs")
	 
	timer.Create("strike" .. math.random(1, 1337) .. self:EntIndex(), 0.6, 6, function()
	
		for k, v in pairs(player.GetAll()) do
			v:SendLua("surface.PlaySound('ambient/explosions/explode_7.wav')")
		end
		
		for k, v in pairs(ents.FindInSphere(tr.HitPos, 700)) do
			if v:IsPlayer() then
				v:SetVelocity((v:GetPos() - tr.HitPos):GetNormal() * math.random(500, 1000))
			end
		
			if v:IsPlayer() and v:Team() != 1 then
				v:Fire("sethealth", "0", 0)
			end
		end
	
	util.ScreenShake(tr.HitPos, 10, 10, 1, 3000)
	
	local ef = EffectData()
	ef:SetOrigin(tr.HitPos)
	util.Effect("effect_muth_obs", ef, true, true)
	
	end)
end

