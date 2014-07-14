
AddCSLuaFile()

SWEP.PrintName = "Mutant"
 
SWEP.ViewModelFOV = 70
SWEP.DrawCrosshair = false 

SWEP.ViewModel = "models/Weapons/v_zombiearms.mdl"
SWEP.WorldModel = ""

SWEP.ShowViewModel = true
 
SWEP.Primary.ClipSize      = -1
SWEP.Primary.DefaultClip   = -1
SWEP.Primary.Delay         = 1.2
SWEP.Primary.Ammo          = "none"
SWEP.Primary.Automatic     = true

function SWEP:Initialize()
	self:SetWeaponHoldType("fist")
end

function SWEP:SecondaryAttack()

end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	timer.Simple(0.4, function()
	if not IsValid(self) or not IsValid(self.Owner) then return end
	
	pos = self.Owner:GetShootPos()
	ang = self.Owner:GetAimVector()
	
	if IsValid(self.Owner) and IsValid(self.Weapon) then
		if self.Owner:Alive() then 
			local slash = {}
			slash.start = pos
			slash.endpos = pos + (ang * 32)
			slash.filter = self.Owner
			slash.mins = Vector(-20, -20, -20)
			slash.maxs = Vector(20, 20, 20)
				
			local slashtrace = util.TraceHull(slash)
				
			if slashtrace.Hit then
				targ = slashtrace.Entity
				
				self.Owner:EmitSound("npc/zombie/claw_strike" .. math.random(3) .. ".wav")
				
				if targ:IsPlayer() and targ:Team() == TEAM_MUTANTS then return end
				
				local dmg = DamageInfo()
				dmg:SetDamage(250)
				dmg:SetDamageType(DMG_SLASH)
				dmg:SetAttacker(self.Owner)
				dmg:SetInflictor(self.Weapon)
				dmg:SetDamageForce(Vector(300, 300, 300))
					
				self.Weapon:EmitSound("")
					
				self.Owner:EmitSound("npc/zombie/zombie_die" .. math.random(1, 3) .. ".wav")
						
				if SERVER then 
					targ:TakeDamageInfo(dmg) 
				end
			else
				self.Owner:EmitSound("npc/zombie/claw_miss" .. math.random(2) .. ".wav")
			end
		end
	end
	
	end)
end
