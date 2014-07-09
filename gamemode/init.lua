AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("changeclass.lua")
AddCSLuaFile("hud.lua")
AddCSLuaFile("pointshop.lua")
include("shared.lua")

local old_time_standart = 7

local ROUND_SETTIME = old_time_standart
local ROUND_TIME_SECS = 60

local IS_ROUND_STARTED = false
local IS_ROUND_END = false

resource.AddWorkshop("107347296") //sunnyisles

local Models = {
	"models/player/zombie_fast.mdl",
	"models/player/charple.mdl"
}

util.AddNetworkString("pointshop_toserv")
util.AddNetworkString("froms_toclient_check")
util.AddNetworkString("change_class")

function GM:Initialize()
	util.PrecacheSound("npc/stalker/stalker_scream1.wav")
	util.PrecacheSound("npc/crow/idle3.wav")
	util.PrecacheSound("music/hl2_song3.mp3")
	util.PrecacheSound("music/radio1.mp3")
	util.PrecacheSound("music/ravenholm_1.mp3")
end

function GM:RestartRound()
	self:InitPostEntity()
	
	for k, v in pairs(player.GetAll()) do v:SetClass(0) v:SendLua("surface.PlaySound('music/hl2_song3.mp3')") end
	
	timer.Simple(1, function() for k, v in pairs(player.GetAll()) do v:Spawn() end end)
end

function GM:PlayerNoClip()
	return false
end

function GM:InitPostEntity()
	timer.Create("count_round_end", 1, 0, function()
		ROUND_TIME_SECS = ROUND_TIME_SECS - 1
		
		if ROUND_TIME_SECS <= 0 then ROUND_SETTIME = ROUND_SETTIME - 1 SetGlobalInt("timetoend", ROUND_SETTIME) ROUND_TIME_SECS = 60 end
		if ROUND_TIME_SECS <= 1 and ROUND_SETTIME <= 0 then self:RestartRound() end
		
		SetGlobalInt("timetoendsec", ROUND_TIME_SECS)
	end)

	ROUND_SETTIME = old_time_standart
	ROUND_TIME_SECS = 0
	IS_ROUND_STARTED = false
	IS_ROUND_END = false
	
	SetGlobalInt("timetoend", ROUND_SETTIME)
	SetGlobalInt("timetoendsec", ROUND_TIME_SECS)
	SetGlobalBool("round_started", IS_ROUND_STARTED)
	SetGlobalBool("round_end", IS_ROUND_END)
end

function GM:Think()
	net.Receive("pointshop_toserv", pshop_handler) 
	net.Receive("change_class", function(ln, ply) ply:SetClass(net.ReadFloat()) ply:Spawn() end)
	
	if ROUND_SETTIME <= 5 and not IS_ROUND_STARTED then
		for k, v in pairs(player.GetAll()) do 
			v:SendLua("surface.PlaySound('music/ravenholm_1.mp3')") 
		end
		
		//for k, v in pairs(team.GetPlayers(TEAM_HUMANS)) do
			
		//end
		
		IS_ROUND_STARTED = true
		SetGlobalBool("round_started", IS_ROUND_STARTED)
	end
end

function GM:PlayerSpawn(ply) --COMMMMMMMIT
	if not IS_ROUND_STARTED and ply.Class == 0 then 
		spectator_handler(ply)
		
		return 
	end
	
	ply:UnSpectate()
	ply:DrawWorldModel(true)
	ply:DrawViewModel(true)

	if not IS_ROUND_STARTED then
		ply:SetTeam(TEAM_HUMANS)
	else
		ply:SetTeam(TEAM_MUTANTS)
	end
	
	if ply:Team() == TEAM_HUMANS and ply.Class == 0 then
		spectator_handler(ply)
	end
	
	
	if ply:Team() == TEAM_SPECTATOR then
		ply:KillSilent()
	end
	
	if ply:Team() == TEAM_HUMANS then
		ply:SetMoney(150)
		ply:SetModel(player_manager.TranslatePlayerModel("alyx"))
		ply:SetupHands()
	end
	
	if ply:Team() == TEAM_MUTANTS then
		
	end
end

function spectator_handler(ply)
	ply:SetTeam(TEAM_SPECTATOR)
	ply:DrawWorldModel(false)
	ply:DrawViewModel(false)
	ply:StripWeapons()
	ply:Spectate(OBS_MODE_ROAMING)
	
	umsg.Start("open_chngcls_muth", ply)
    umsg.End()
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














