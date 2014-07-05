
function EFFECT:Init(data)
	self.StartPos = data:GetOrigin()
	
	self.Emitter = ParticleEmitter(self.StartPos)
	
	for i = 1, math.random(2, 10) do
		local p = self.Emitter:Add("particles/flamelet" .. math.random(1, 5), self.StartPos)

		p:SetDieTime(math.Rand(1, 2))
		p:SetStartAlpha(math.random(200, 255))
		p:SetEndAlpha(0)
		p:SetStartSize(math.random(8, 15))
		p:SetEndSize(0)			
		p:SetRoll(math.random(-10, 10))
		p:SetRollDelta(math.random(-10, 10))
		p:SetGravity(Vector(0, 0, -80))
		
		local p = self.Emitter:Add("particles/smokey", self.StartPos)

		p:SetDieTime(math.Rand(1, 2))
		p:SetStartAlpha(math.random(150, 200))
		p:SetEndAlpha(0)
		p:SetStartSize(math.random(8, 15))
		p:SetEndSize(0)			
		p:SetRoll(math.random(-10, 10))
		p:SetRollDelta(math.random(-10, 10))
		p:SetGravity(Vector(0, 0, -80))
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
