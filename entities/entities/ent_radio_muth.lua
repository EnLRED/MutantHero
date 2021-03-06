AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.Spawnable = false

ENT.Wait = 0

function ENT:Draw()
	if SERVER then return end
	self:DrawModel()
end

function ENT:Initialize()
	if CLIENT then return end

	self:SetModel("models/props_lab/citizenradio.mdl")
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetNWBool("made_by_people_muth", true)
	self:SetNWFloat("count_clk", 0)
	
	local phys = self:GetPhysicsObject()
	
	if IsValid(phys) then phys:EnableMotion(false) end
end

function ENT:Think()
	if CLIENT then return end
	
	if self.Wait > 0 then self:SetNWFloat("count_clk", self.Wait) self.Wait = self.Wait - 0.5 end
	
	for k, v in pairs(ents.FindInSphere(self:GetPos(), 150)) do
		if GetGlobalBool("radio_clk") then return end

		if v:IsPlayer() and v:Team() == TEAM_HUMANS then
			if v:GetEyeTrace().Entity == self then
				if v:KeyDown(IN_USE) then
					self.Wait = self.Wait + 1
				
					if self.Wait >= 9 then
						SetGlobalBool("radio_clk", true)
						
						v.ClkedRadio = true
						
						for _, p in pairs(player.GetAll()) do
							p:ChatPrint("Go to evacuation zone! Hurry up!")
							
							p:SendLua("surface.PlaySound('muth/creepy_sound.mp3')")
						end
						
						timer.Create("count_round_end", 1, 181, function()
							ROUND_TIME_SECS = ROUND_TIME_SECS - 1
							
							--Humans win
							//if ROUND_TIME_SECS <= 1 then  end
							
							SetGlobalInt("timetoendsec", ROUND_TIME_SECS)
						end)
					end
				end
			end
		end
	end
end







