
function EFFECT:Init(data)
	self.StartPos = data:GetOrigin()
	
	self.Emitter = ParticleEmitter(self.StartPos)
	
	for i = 1, 360 do
		local vec = VectorRand()
		vec.z = 0
		local pos = self.StartPos + vec * 1
	
		local p = self.Emitter:Add("particle/smokesprites_000" .. math.random(1, 9), pos)

		p:SetDieTime(math.Rand(1, 3))
		p:SetStartAlpha(50)
		p:SetEndAlpha(0)
		p:SetStartSize(math.random(80, 120))
		p:SetEndSize(math.Rand(150, 200))			
		p:SetVelocity((self.StartPos - pos):GetNormal() * math.random(460, 500))
		p:SetRoll(math.random(-10, 10))
		p:SetRollDelta(math.random(-10, 10))
		p:SetColor(0, 0, 0)
		p:SetCollide(false)
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
