AddCSLuaFile()
include("shared.lua")

local hud = { "CHudHealth", "CHudBattery", "CHudSecondaryAmmo", "CHudAmmo", "CHudVoiceStatus", "NetGraph", "CHudCrosshair" }
local zvision = false
local wait = 0
local waitp = 0

local emitter = ParticleEmitter(Vector(0, 0, 0))

function GM:HUDShouldDraw(name)
	for k, v in pairs(hud) do
		if v == name then return false end
	end
	
	return true
end

function GM:Think()
	if LocalPlayer():Team() == TEAM_MUTANTS and LocalPlayer().zvision then
		local dlight = DynamicLight(LocalPlayer():EntIndex())
		dlight.Pos = LocalPlayer():GetPos()
		dlight.r = 50
		dlight.g = 255
		dlight.b = 50
		dlight.Brightness = 1
		dlight.Size = 99999
		dlight.Decay = 0.1
		dlight.DieTime = CurTime() + 0.1
		dlight.Style = 0
	end
	
	if CurTime() > waitp and LocalPlayer():Team() == TEAM_MUTANTS then
		for k, v in pairs(team.GetPlayers(TEAM_HUMANS)) do
			local p = emitter:Add("sprites/blueglow2", v:GetPos() + Vector(0, 0, 10))

			p:SetDieTime(10)
			p:SetStartAlpha(255)
			p:SetEndAlpha(0)
			p:SetStartSize(math.random(10, 20))
			p:SetRoll(math.Rand(-10, 10))
			p:SetRollDelta(math.Rand(-10, 10))
			p:SetEndSize(0)		
			p:SetCollide(true)
			p:SetGravity(Vector(0, 0, -20))
			//p:SetColor(Color(0, 255, 0, 255))
		end
		
		waitp = CurTime() + 0.1
	end
end

function GM:KeyPress()
	if LocalPlayer():Team() == TEAM_MUTANTS and LocalPlayer():KeyPressed(IN_ATTACK2) and CurTime() > wait then
		LocalPlayer().zvision = !LocalPlayer().zvision
		wait = CurTime() + 0.5
	end
end

function GM:ContextMenuOpen()
	return false
end

function GM:SpawnMenuEnabled()
	return false
end

function GM:SpawnMenuOpen()
	return false
end

























