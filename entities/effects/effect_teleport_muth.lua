if SERVER then AddCSLuaFile() end

local glow = Material("sprites/orangecore1")

function EFFECT:Init(data)
	self.Start = data:GetOrigin()
	self.ssize = 100
	self.diet = CurTime() + 2

	self.Emitter = ParticleEmitter(self.Start)
		
	for i = 1, math.random(40, 80) do
		local vec = VectorRand()
		vec.z = 0
		
		local p = self.Emitter:Add("sprites/blueglow2", self.Start + vec * 20)

		p:SetDieTime(math.Rand(2, 5))
		p:SetStartAlpha(255)
		p:SetEndAlpha(0)
		p:SetStartSize(math.random(5, 10))
		p:SetRoll(math.Rand(-10, 10))
		p:SetRollDelta(math.Rand(-10, 10))
		p:SetEndSize(0)		
		p:SetGravity(Vector(0, 0, math.random(10, 100)))
	end
	
	self.Emitter:Finish()
end

function EFFECT:Think()
	if CurTime() > self.diet then return false end
	
	if self.ssize > 0 then self.ssize = self.ssize - 0.8 end
	
	return true
end

function EFFECT:Render()
	render.SetMaterial(glow)
	render.DrawQuadEasy(self.Start, Vector(0, 0, 1), self.ssize, self.ssize)
end

