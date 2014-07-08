AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("changeclass.lua")
AddCSLuaFile("hud.lua")
AddCSLuaFile("pointshop.lua")
AddCSLuaFile("player_extended_sh.lua")
AddCSLuaFile("player_extended_cl.lua")
AddCSLuaFile("postpr.lua")
include("shared.lua")

local old_time_standart = 7

ROUND_SETTIME = old_time_standart
ROUND_TIME_SECS = 60
IS_ROUND_STARTED = false
IS_ROUND_END = false

local Models = {
	"models/player/zombie_fast.mdl",
	"models/player/charple.mdl"
}

util.AddNetworkString("pointshop_toserv")
util.AddNetworkString("froms_toclient_check")
util.AddNetworkString("change_class")

function GM:ShowSpare1(ply)
	if IS_ROUND_STARTED or ply:Team() == TEAM_MUTANTS then return end
	
	umsg.Start("open_shop_muth", ply)
    umsg.End()
end

function GM:Initialize()
	util.PrecacheSound("npc/stalker/stalker_scream1.wav")
	util.PrecacheSound("npc/crow/idle3.wav")
	util.PrecacheSound("music/hl2_song3.mp3")
	util.PrecacheSound("music/radio1.mp3")
	util.PrecacheSound("music/ravenholm_1.mp3")
end

function GM:RestartRound(whoWin) //1 - humans, 0 - mutants
	self:InitPostEntity()
	
	local str = "nil"
	local note = "Error! Sorry somethings has crashed (no argument?)"
	
	if whoWin then note = "HUMANS WIN!!!" str = "surface.PlaySound('music/hl2_song3.mp3')" else note = "MUTANTS WIN!!!" str = "surface.PlaySound('music/radio1.mp3')" end
	for k, v in pairs(player.GetAll()) do v:SetClass(0) v:SendLua(str) v:ChatPrint(note .. " Restarting round...") end
	
	timer.Simple(2, function() for k, v in pairs(player.GetAll()) do v:Spawn() end end)
end

function GM:PlayerNoClip()
	return false
end

function GM:InitPostEntity()
	----Start game | it looks like  main() {} :D
	timer.Create("count_round_end", 1, 0, function()
		ROUND_TIME_SECS = ROUND_TIME_SECS - 1
		
		--Tick / Time
		if ROUND_TIME_SECS <= 0 then ROUND_SETTIME = ROUND_SETTIME - 1 SetGlobalInt("timetoend", ROUND_SETTIME) ROUND_TIME_SECS = 60 end
		
		--Humans win
		if ROUND_TIME_SECS <= 1 and ROUND_SETTIME <= 0 then IS_ROUND_END = true SetGlobalBool("round_end", IS_ROUND_END) self:RestartRound(true) end
		
		SetGlobalInt("timetoendsec", ROUND_TIME_SECS)
	end)

	ROUND_SETTIME = old_time_standart
	ROUND_TIME_SECS = 60
	IS_ROUND_STARTED = false
	IS_ROUND_END = false
	
	SetGlobalInt("timetoend", ROUND_SETTIME)
	SetGlobalInt("timetoendsec", ROUND_TIME_SECS)
	SetGlobalBool("round_started", IS_ROUND_STARTED)
	SetGlobalBool("round_end", IS_ROUND_END)
end

function GM:PlayerDeath(victim, inflictor, attacker)
	if IsValid(attacker) and attacker:IsPlayer() then
		attacker:AddFrags(1)
	end
	
	timer.Simple(0.3, function()
		--Mutants win
		if #team.GetPlayers(TEAM_HUMANS) <= 0 and not IS_ROUND_END then
			IS_ROUND_END = true
			SetGlobalBool("round_end", IS_ROUND_END)
			self:RestartRound(false)
		end
	end)
	
	victim:AddDeaths(1)
end

function GM:Think()
	net.Receive("pointshop_toserv", pshop_handler) 
	net.Receive("change_class", function() local ply = net.ReadEntity() local n = net.ReadFloat() ply:SetClass(n) ply:Spawn() end)
	
	--Start round
	if ROUND_SETTIME <= 6 and not IS_ROUND_STARTED then
		for k, v in pairs(player.GetAll()) do 
			v:SendLua("surface.PlaySound('music/ravenholm_1.mp3')") 
		end
		
		--Spawn random mutants
		if #player.GetAll() > 1 then
			local numofneeded = math.Clamp(math.random(3), math.ceil(#player.GetAll() / 2))
			
			for I = 1, numofneeded do
				local p = math.random(#player.GetAll())
				
				if IsValid(player.GetAll()[p]) then
					player.GetAll()[p]:SetTeam(TEAM_MUTANTS)
					player.GetAll()[p]:Kill()
					
					timer.Simple(0.2, function() if not player.GetAll()[p]:Alive() then player.GetAll()[p]:Spawn() end end)
				end
			end
		end
		
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
	ply:ShouldDropWeapon(false)
	ply:StripWeapons()
	ply:RemoveAllAmmo()
	
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
	elseif ply:Team() == TEAM_HUMANS then
		ply:SetHealth(800)
		ply:SetMaxHealth(1000)
		ply:SetArmor(200)
		ply:SetJumpPower(200)
	
		ply:SetMoney(150)
		ply:SetModel(player_manager.TranslatePlayerModel("alyx"))
		ply:SetupHands()
	elseif ply:Team() == TEAM_MUTANTS then
		ply:SetHealth(3500)
		ply:SetMaxHealth(3500)
	
		ply:SetModel(player_manager.TranslatePlayerModel("zombie"))
		ply:Give("weapon_mutant_gm")
	end
end

function GM:EntityTakeDamage(ent, dmginfo)
	local attacker = dmginfo:GetAttacker()
	
	if attacker:IsPlayer() and ent:IsPlayer() and attacker:Team() == ent:Team() then
		dmginfo:SetDamage(0)
		dmginfo:ScaleDamage(0)
	end
end

function GM:DoPlayerDeath(ply)
	ply:CreateRagdoll()
end


function spectator_handler(ply)
	if ply:IsBot() then
		ply:SetClass(CLASS_HUMANS_LIGHTS)
		
		ply:Spawn()
		
		return
	end

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














