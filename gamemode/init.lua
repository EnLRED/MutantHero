AddCSLuaFile()
include("shared.lua")

local old_time_standart = 6

local ROUND_SETTIME = old_time_standart
local ROUND_STARTED = false
local ROUND_TIME_SECS = 0
local ROUND_ENT = false

resource.AddWorkshop("107347296") //sunnyisles

util.PrecacheSound("npc/stalker/stalker_scream1.wav")
util.PrecacheSound("npc/crow/idle3.wav")
util.PrecacheSound("music/hl2_song3.mp3")
util.PrecacheSound("music/radio1.mp3")
util.PrecacheSound("music/ravenholm_1.mp3")

SetGlobalString("timetoend", tostring(ROUND_SETTIME))
SetGlobalString("timetoendsec", tostring(SECONDS_ROUND_SETTIME))
SetGlobalBool("round_started", ROUND_STARTED)

local Models = {
	"models/player/zombie_fast.mdl",
	"models/player/charple.mdl"
}

function GM:Initialize()
	util.PrecacheSound("npc/stalker/stalker_scream1.wav")
	util.PrecacheSound("npc/crow/idle3.wav")
	util.PrecacheSound("music/hl2_song3.mp3")
	util.PrecacheSound("music/radio1.mp3")
	util.PrecacheSound("music/ravenholm_1.mp3")

	SetGlobalString("timetoend", tostring(ROUND_SETTIME))
	SetGlobalString("timetoendsec", tostring(SECONDS_ROUND_SETTIME))
	SetGlobalBool("round_started", ROUND_STARTED)
	
	util.AddNetworkString("pointshop_toserv")
	net.Receive("pointshop_toserv",pshop_handler) 
end

function GM:Think()

end

function GM:PlayerSpawn(ply) --COMMMMMMMIT
	if ply:Team() == TEAM_HUMANS then
		ply:SetMoney(150)
	end
end

function pshop_handler(ln, ply)
	Class = net.ReadTable()
	
	if Class.Cost<ply:GetMoney() then
		if Class.IsAmmo then
			Player:GiveAmmo(Class.Num, Class.ClassName, True) 
			ply:SetMoney(ply:GetMoney()-Class.Cost)
		else
			Player:Give(Class.ClassName)
			ply:SetMoney(ply:GetMoney()-Class.Cost)
		end
	end
end




















--[[----------------------------------------------------------------------------------------------
	 ______    __    __    _____           _____    ___      __    __
	|      |  |  |  |  |  |  ___|         |  ___|  |   \    |  |  |   \\
	|__  __|  |  |__|  |  | |___          | |___   |  |\ \  |  |  |  _ \\
	  |  |    |   __   |  |  ___|         |  ___|  |  | \ \ |  |  | |_|||
	  |  |    |  |  |  |  | |___          | |___   |  |  \ \|  |  |    //
	  |__|    |__|  |__|  |_____|         |_____|  |__|   \____|  |___//
--]]----------------------------------------------------------------------------------------------














