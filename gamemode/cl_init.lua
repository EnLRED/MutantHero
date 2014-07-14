AddCSLuaFile()
include("shared.lua")

local hud = { "CHudHealth", "CHudBattery", "CHudSecondaryAmmo", "CHudAmmo", "CHudVoiceStatus", "NetGraph", "CHudCrosshair" }
local zvision = false
local wait = 0
local waitp = 0
local canUse = true
pnv_life = 20

local emitter = ParticleEmitter(Vector(0, 0, 0))

function GM:HUDShouldDraw(name)
	for k, v in pairs(hud) do
		if v == name then return false end
	end
	
	return true
end

function GM:PlayerSpawn(ply)
	ply.PRINTED = false
end

function GM:StartChat(tm)
	canUse = false
end

function GM:FinishChat(tm)
	canUse = true
end

function GM:Think()
	for k, v in pairs(ents.FindInSphere(GetGlobalVector("evacuation_zone"), 1200)) do
		if GetGlobalBool("radio_clk") and v:IsPlayer() and v:Team() == TEAM_HUMANS and not v.PRINTED then v:ChatPrint("Don't leave this place!") v.PRINTED = true end
	end
	
	if LocalPlayer():Team() == TEAM_MUTANTS and input.IsKeyDown(KEY_F) and CurTime() > wait and canUse then
		LocalPlayer().zvision = !LocalPlayer().zvision
		wait = CurTime() + 0.5
		surface.PlaySound("npc/zombie/zombie_alert2.wav")
	end
	
	if LocalPlayer():Team() == TEAM_HUMANS and input.IsKeyDown(KEY_F) and CurTime() > wait and pnv_life > 0 and canUse then
		LocalPlayer().hvision = !LocalPlayer().hvision
		
		LocalPlayer():EmitSound("npc/turret_floor/deploy.wav", 50, 150)
		
		wait = CurTime() + 0.5
	end
	
	if LocalPlayer():Team() == TEAM_HUMANS and input.IsKeyDown(KEY_H) and CurTime() > wait then
		//net.Start("drop_weapon_muth")
			//net.WriteEntity(LocalPlayer():GetActiveWeapon())
		//net.SendToServer()
		
		wait = CurTime() + 0.5
	end

	if LocalPlayer():Team() == TEAM_MUTANTS and LocalPlayer().zvision then
		local dlight = DynamicLight(LocalPlayer():EntIndex())
		dlight.Pos = LocalPlayer():GetPos()
		dlight.r = 255
		dlight.g = 50
		dlight.b = 50
		dlight.Brightness = 1
		dlight.Size = 99999
		dlight.Decay = 0.1
		dlight.DieTime = CurTime() + 0.1
		dlight.Style = 0
	end
	
	if LocalPlayer():Team() == TEAM_HUMANS then
		if LocalPlayer().hvision then
			local dlight = DynamicLight(LocalPlayer():EntIndex())
			dlight.Pos = LocalPlayer():GetPos()
			dlight.r = 0
			dlight.g = 255
			dlight.b = 0
			dlight.Brightness = 0
			dlight.Size = 999
			dlight.Decay = 0.1
			dlight.DieTime = CurTime() + 0.1
			dlight.Style = 0
			
			if pnv_life > 0 then pnv_life = pnv_life - 0.01 end
			if pnv_life <= 0 then LocalPlayer().hvision = false end
		else
			if pnv_life < 20 then pnv_life = pnv_life + 0.01 end
		end
	end
	
	if CurTime() > waitp and LocalPlayer():Team() == TEAM_MUTANTS then
		for k, v in pairs(team.GetPlayers(TEAM_HUMANS)) do
			local p = emitter:Add("sprites/redglow1", v:GetPos() + Vector(0, 0, 10))

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

























