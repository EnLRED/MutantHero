AddCSLuaFile()

SWEP.PrintName			= "Knife"			
SWEP.Author				= "HK47"
SWEP.Slot				= 1
SWEP.SlotPos			= 0

SWEP.HoldType			= "grenade"
SWEP.Base				= "wep_muth_melee_base"

SWEP.ShowWorldModel = false

SWEP.DrawAmmo = false

if CLIENT then
	SWEP.Cost = 15
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

SWEP.Dmg = 80
SWEP.MissSound = "weapons/iceaxe/iceaxe_swing1.wav"
SWEP.HitSound = "weapons/knife/knife_hitwall1.wav"
SWEP.SlashSound = "weapons/knife/knife_hit2.wav"

function SWEP:PrimaryAttack()
	pos = self.Owner:GetShootPos()
	ang = self.Owner:GetAimVector()
	
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	
	self.Owner:ViewPunch(Angle(1, 1, 0))
	
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	if IsValid(self.Owner) and IsValid(self.Weapon) then
		if self.Owner:Alive() then 
			local slash = {}
			slash.start = pos
			slash.endpos = pos + (ang * 32)
			slash.filter = self.Owner
			slash.mins = Vector(-5, -5, -5)
			slash.maxs = Vector(5, 5, 5)
				
			local slashtrace = util.TraceHull(slash)
			
			self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
			
			if slashtrace.Hit then
				targ = slashtrace.Entity
				
				if targ:IsPlayer() then
					self.Weapon:EmitSound(self.SlashSound)
				
					local dmg = DamageInfo()
					dmg:SetDamage(self.Dmg)
					dmg:SetDamageType(DMG_SLASH)
					dmg:SetAttacker(self.Owner)
					dmg:SetInflictor(self.Weapon)
					dmg:SetDamageForce(Vector(100, 100, 100))
						
					if SERVER then 
						targ:TakeDamageInfo(dmg) 
					end
				else
					self.Weapon:EmitSound(self.HitSound)
					
					tr = self.Owner:GetEyeTrace()
					util.Decal("impact.manhack", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
				end
			else
				self.Weapon:EmitSound(self.MissSound)
			end
		end
	end
end

