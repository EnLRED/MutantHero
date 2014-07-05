AddCSLuaFile()
include("shared.lua")

local hud = { "CHudHealth", "CHudBattery", "CHudSecondaryAmmo", "CHudAmmo", "CHudVoiceStatus", "NetGraph", "CHudCrosshair" }

local Current = 1
local Current2 = 1

function GM:HUDShouldDraw(name)
	for k, v in pairs(hud) do
		if v == name then return false end
	end
	
	return true
end

function GM:Think()
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

























