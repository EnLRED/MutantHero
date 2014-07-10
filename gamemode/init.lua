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
	if IS_ROUND_STARTED or ply:Team() == TEAM_MUTANTS then ply:ChatPrint("You can't use pointshop because round is started!") return end
	
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
	for k, v in pairs(ents.GetAll()) do
		if v:GetNWBool("made_by_people_muth") then v:Remove() end
	end

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
	print("Round starts...\n\n\n")
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
	
	print("Done!")
end

function GM:PlayerDeath(victim, inflictor, attacker)
	if IsValid(attacker) and attacker:IsPlayer() then
		attacker:AddFrags(1)
	end
	
	timer.Simple(1, function()
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
	for k, v in pairs(player.GetAll()) do
		-- Rotate left
		if v:KeyDown(IN_MOVELEFT) and v:IsOnGround() then
			v:ViewPunch(Angle(0, 0, -0.1))
		end
		
		-- Rotate right
		if v:KeyDown(IN_MOVERIGHT) and v:IsOnGround() then
			v:ViewPunch(Angle(0, 0, 0.1))
		end
	end

	net.Receive("pointshop_toserv", pshop_handler) 
	net.Receive("change_class", function(ln, ply) local n = net.ReadFloat() ply:SetClass(n) ply:Spawn() end)
	
	--Start round
	if ROUND_SETTIME <= 6 and not IS_ROUND_STARTED then
		for k, v in pairs(player.GetAll()) do 
			v:SendLua("surface.PlaySound('music/ravenholm_1.mp3')") 
		end
		
		--Spawn random mutants
		if #player.GetAll() > 1 then
			local numofneeded = math.Clamp(math.random(2), #player.GetAll())
			
			for I = 1, numofneeded do
				local p = math.random(#player.GetAll())
				
				if IsValid(player.GetAll()[p]) then
					player.GetAll()[p]:SetTeam(TEAM_MUTANTS)
					timer.Simple(0.1, function() player.GetAll()[p]:Spawn() end)
				end
			end
		end
		
		IS_ROUND_STARTED = true
		SetGlobalBool("round_started", IS_ROUND_STARTED)
	end
end

function GM:PlayerSpawn(ply) --COMMMMMMMIT
	if not IS_ROUND_STARTED and ply:GetClassString() == "NoCLS" then
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
	
	if ply:Team() == TEAM_HUMANS and ply:GetClassString() == "NoCLS" then
		spectator_handler(ply)
	end
	
	if ply:Team() == TEAM_SPECTATOR then
		ply:KillSilent()
	elseif ply:Team() == TEAM_HUMANS then
		ply:SetNWVector("muth_startpoint", ply:GetPos())
		ply:SetHealth(800)
		ply:SetMaxHealth(1000)
		ply:SetArmor(200)
		ply:SetJumpPower(170)
	
		ply:SetMoney(150)
		
		if ply:GetClassString() == "Engineer" then
			ply:SetModel(player_manager.TranslatePlayerModel("eli"))
			ply:SetWalkSpeed(230)
			ply:SetHealth(700)
			ply:SetRunSpeed(230)
			ply:Give("weapon_muth_turret")
			ply:Give("weapon_muth_beacon")
		end
		
		if ply:GetClassString() == "Medic" then
			ply:SetModel(player_manager.TranslatePlayerModel("alyx"))
			ply:Give("weapon_muth_medkit")
			ply:SetHealth(750)
		end
		
		if ply:GetClassString() == "Berserk" then
			ply:SetModel(player_manager.TranslatePlayerModel("odessa"))
			ply:SetWalkSpeed(240)
			ply:SetHealth(850)
			ply:SetRunSpeed(240)
			ply:Give("weapon_hook_muth")
		end
		
		if ply:GetClassString() == "Heavy soldier" then
			ply:SetModel(player_manager.TranslatePlayerModel("male18"))
			ply:SetWalkSpeed(190)
			ply:Give("weapon_muth_ak47")
			ply:SetHealth(1000)
			ply:SetRunSpeed(190)
		end
		
		if ply:GetClassString() == "Light soldier" then
			ply:SetModel(player_manager.TranslatePlayerModel("male11"))
			ply:SetWalkSpeed(240)
			ply:SetHealth(700)
			ply:Give("weapon_muth_mp5")
			ply:SetRunSpeed(240)
		end
		
		ply:SetupHands()
	elseif ply:Team() == TEAM_MUTANTS then
		ply:SetHealth(3200)
		ply:SetMaxHealth(3200)
		ply:SetWalkSpeed(250)
		ply:SetRunSpeed(250)
	
		ply:SetModel(player_manager.TranslatePlayerModel("charple"))
		ply:Give("weapon_mutant_gm")
	end
end

function GM:EntityTakeDamage(ent, dmginfo)
	local attacker = dmginfo:GetAttacker()
	
	if IsValid(attacker) and attacker:IsPlayer() and ent:IsPlayer() and attacker:Team() == ent:Team() then
		dmginfo:SetDamage(0)
		dmginfo:ScaleDamage(0)
	end
	
	if IsValid(attacker) and attacker:IsPlayer() then 
		if attacker:GetClassString() == "Medic" then
			dmginfo:SetDamage(dmginfo:GetDamage() - 10)
		elseif attacker:GetClassString() == "Heavy soldier" then
			dmginfo:SetDamage(dmginfo:GetDamage() * 1.25)
		elseif attacker:GetClassString() == "Berserk" and attacker:GetActiveWeapon().IsMelee then
			dmginfo:SetDamage(dmginfo:GetDamage() * 1.35)
		end
	end
end

function GM:DoPlayerDeath(ply)
	ply:CreateRagdoll()
end


function spectator_handler(ply)
	if ply:IsBot() then //go away bots
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
	//no table!!1!!!1! aahahaha
	local Cost = net.ReadFloat()
	local IsAmmo = net.ReadBit()
	local ClassName = net.ReadString()
	local Num = net.ReadFloat()
	
	if Cost <= ply:GetMoney() then
		if IsAmmo == 1 then
			ply:GiveAmmo(Num, ClassName, true) 
		else
			net.Start("froms_toclient_check")
				net.WriteString(tostring(ply:GetWeapon(ClassName)))
			net.Send(ply)
			
			if tostring(ply:GetWeapon(ClassName)) != "[NULL Entity]" then ply:ChatPrint("You already have this weapon!") return end
			ply:Give(ClassName)
			print(ClassName)
		end
		
		ply:SetMoney(ply:GetMoney() - Cost)
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














