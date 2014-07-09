AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("changeclass.lua")
AddCSLuaFile("hud.lua")
AddCSLuaFile("pointshop.lua")
include("shared.lua")

local old_time_standart = 6

local ROUND_SETTIME = old_time_standart
local ROUND_TIME_SECS = 0

local IS_ROUND_STARTED = false
local IS_ROUND_END = false

resource.AddWorkshop("107347296") //sunnyisles

local Models = {
	"models/player/zombie_fast.mdl",
	"models/player/charple.mdl"
}

util.AddNetworkString("pointshop_toserv")
util.AddNetworkString("froms_toclient_check")

function GM:Initialize()
	util.PrecacheSound("npc/stalker/stalker_scream1.wav")
	util.PrecacheSound("npc/crow/idle3.wav")
	util.PrecacheSound("music/hl2_song3.mp3")
	util.PrecacheSound("music/radio1.mp3")
	util.PrecacheSound("music/ravenholm_1.mp3")

	SetGlobalString("timetoend", tostring(ROUND_SETTIME))
	SetGlobalString("timetoendsec", tostring(SECONDS_ROUND_SETTIME))
	
	SetGlobalBool("round_started", IS_ROUND_STARTED)
	SetGlobalBool("round_end", IS_ROUND_END)
end

function GM:Think()
	net.Receive("pointshop_toserv", pshop_handler) 
end

function GM:PlayerSpawn(ply) --COMMMMMMMIT
	--if ply:Team() == TEAM_HUMANS then
		ply:SetMoney(150)
		ply:SetModel(player_manager.TranslatePlayerModel("alyx"))
		ply:SetupHands()
	--end
end

function pshop_handler(ln, ply)
	local Class = net.ReadTable()
	
	if Class.Cost <= ply:GetMoney() then
		if Class.IsAmmo then
			ply:GiveAmmo(Class.Num, Class.ClassName, true) 
			ply:SetMoney(ply:GetMoney() - Class.Cost)
		else
			net.Start("froms_toclient_check")
				net.WriteString(tostring(ply:GetWeapon(Class.ClassName)))
			net.Send(ply)
			
			if tostring(ply:GetWeapon(Class.ClassName)) != "[NULL Entity]" then ply:ChatPrint("You already have this weapon!") return end
			ply:Give(Class.ClassName)
			ply:SetMoney(ply:GetMoney() - Class.Cost)
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














