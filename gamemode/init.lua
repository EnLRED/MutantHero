AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("changeclass.lua")
AddCSLuaFile("hud.lua")
AddCSLuaFile("pointshop.lua")
AddCSLuaFile("notify.lua")
AddCSLuaFile("player_extended_sh.lua")
AddCSLuaFile("player_extended_cl.lua")
AddCSLuaFile("postpr.lua")
include("shared.lua")

local time_pause = 15 //pause time

ROUND_TIME_SECS = 180
IS_ROUND_STARTED = false

local radio_spawn = {
	["gm_construct"] = Vector(-4187.1948242188, -1833.9692382813, -143.96875),
	["gm_flatgrass"] = Vector(0, 0, 0),
	["gm_bigcity"] = Vector(-1420.9265136719, 4894.9672851563, -11135.96875)
}

local Models = {
	"models/player/zombie_fast.mdl",
	"models/player/charple.mdl"
}

util.AddNetworkString("pointshop_toserv")
util.AddNetworkString("froms_toclient_check")
util.AddNetworkString("change_class")

function GM:Initialize() --stuff trash scrap
	util.PrecacheSound("npc/stalker/stalker_scream1.wav")
	util.PrecacheSound("npc/crow/idle3.wav")
	util.PrecacheSound("music/hl2_song3.mp3")
	util.PrecacheSound("music/radio1.mp3")
	util.PrecacheSound("music/ravenholm_1.mp3")
end

function GM:RestartRound(whoWin) //1 - humans, 0 - mutants
	ROUND_TIME_SECS = 180
	IS_ROUND_STARTED = false
	
	SetGlobalInt("timetoendsec", ROUND_TIME_SECS) --stufffff
	SetGlobalInt("timetostart", time_pause) --stuffff
	SetGlobalBool("round_started", IS_ROUND_STARTED) --not stuffff
	SetGlobalBool("radio_clk", false) --stufffff
	
	timer.Stop("count_round_end")
	
	local str = "nil"
	local note = "ERROR"
	
	if whoWin then
		umsg.Start("draw_end_muth")
		umsg.End()
	
		note = "HUMANS WIN!!!" 
		str = "surface.PlaySound('music/hl2_song3.mp3')" 
	else 
		note = "MUTANTS WIN!!!" 
		str = "surface.PlaySound('music/radio1.mp3')" 
	end
	for k, v in pairs(player.GetAll()) do v:SetClass(0) v:SendLua(str) v:ChatPrint(note .. " Restarting round...") end
	
	umsg.Start("notify_muth")
		umsg.String(note .. " Restarting round...")
	umsg.End()
	
	timer.Simple(4, function() 
		for k, v in pairs(ents.GetAll()) do
			if v:GetNWBool("made_by_people_muth") then v:Remove() end
		end
	
		self:InitPostEntity() 
		for k, v in pairs(player.GetAll()) do v:Spawn() end 
	end)
end

function GM:PlayerNoClip()
	return false
end

function GM:InitPostEntity()
	ROUND_TIME_SECS = 180
	IS_ROUND_STARTED = false
	
	SetGlobalInt("timetoendsec", ROUND_TIME_SECS) --stufffff
	SetGlobalInt("timetostart", time_pause) --stuffff
	SetGlobalBool("round_started", IS_ROUND_STARTED) --not stuffff
	SetGlobalBool("radio_clk", false) --stufffff
	
	SetGlobalVector("evacuation_zone", random_evacuation[game.GetMap()][math.random(1, 3)])

	timer.Create("count_round_start", 1, time_pause, function() --stufffffffff
		SetGlobalInt("timetostart", GetGlobalInt("timetostart") - 1)
	end)
	
	--Start round
	timer.Create("start_round", time_pause, 1, function()
		for k, v in pairs(player.GetAll()) do 
			v:SendLua("surface.PlaySound('music/ravenholm_1.mp3')") 
		end
		
		umsg.Start("notify_muth")
			umsg.String("ROUND STARTED!!!")
		umsg.End()
		
		--Spawn random mutants
		if #player.GetAll() > 1 then
			local numofneeded = math.Clamp(math.random(2), #player.GetAll())
			
			for I = 1, math.random(1, numofneeded) do
				local p = math.random(#player.GetAll())
				
				if IsValid(player.GetAll()[p]) then
					player.GetAll()[p]:SetTeam(TEAM_MUTANTS)
					timer.Simple(0.1, function() if IsValid(player.GetAll()[p]) then player.GetAll()[p]:Spawn() end end)
				end
			end
		end
		
		IS_ROUND_STARTED = true
		SetGlobalBool("round_started", IS_ROUND_STARTED)
	end)
	
	
	--Set up radio
	local ent = ents.Create("ent_radio_muth")
	if map_coordinates[game.GetMap()].radio_spawn then
		ent:SetPos(map_coordinates[game.GetMap()].radio_spawn)
	else
		ent:SetPos(Vector(0, 0, 0))
		for k, v in pairs(player.GetAll()) do v:ChatPrint("Sorry this map is not included for Mutant-hero :(") end
	end
	ent:SetAngles(Angle(0, math.random(0, 360), 0))
	ent:Spawn()
	
	
	timer.Create("spawn_pointshop", 10, 1, function()
		local ent = ents.Create("ent_pointshop_muth")
		ent:SetPos(map_coordinates[game.GetMap()].pointshop_spawn)
		ent:Spawn()
		ent:GetPhysicsObject():EnableMotion(false)
		
		for k, v in pairs(team.GetPlayers(TEAM_HUMANS)) do v:ChatPrint("Pointshop spawned!") end
	end)
end

function GM:PlayerDeath(victim, inflictor, attacker)
	if IsValid(attacker) and attacker:IsPlayer() then
		attacker:AddFrags(1)
		
		if attacker:Team() == TEAM_HUMANS then
			local str = "+0$"
		
			--Monneeeey $
			if victim:GetClassString() == "Faster" or victim:GetClassString() == "Berserk" then
				str = "+20$"
				attacker:SetMoney(attacker:GetMoney() + 20)
			elseif victim:GetClassString() == "The child of darkness" then
				str = "+60$"
				attacker:SetMoney(attacker:GetMoney() + 60)
			else
				str = "+10$"
				attacker:SetMoney(attacker:GetMoney() + 10)
			end
			
			umsg.Start("notify_muth", attacker)
				umsg.String(str)
			umsg.End()
		end
	end
	
	timer.Create("restart", 0.2, 1, function()
		--Mutants win
		if #team.GetPlayers(TEAM_HUMANS) <= 0 then
			self:RestartRound(false)
		end
	end)
	
	victim:AddDeaths(1)
end

local wait_muth = 0

function GM:Think()
	if ROUND_TIME_SECS <= 1 and CurTime() > wait_muth then
		local count = 0
		
		local rad = GetGlobalVector("evacuation_zone")
		if not rad then rad = Vector(0, 0, 0) end
		
		for k, v in pairs(ents.FindInSphere(rad, 1200)) do
			if v:IsPlayer() and v:Team() == TEAM_HUMANS then
				count = count + 1
			end
		end
		
		if count > 0 then
			self:RestartRound(true)
			for p, pl in pairs(player.GetAll()) do pl:ChatPrint(count .. " evacuated!") end
		else
			self:RestartRound(false)
			for p, pl in pairs(player.GetAll()) do pl:ChatPrint("People not evacuated...") end
		end
		
		wait_muth = CurTime() + 1
	end

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
end



function GM:PlayerSpawn(ply) --COMMMMMMMIT
	ply:UnSpectate()
	ply:DrawWorldModel(true)
	ply:DrawViewModel(true)
	ply:ShouldDropWeapon(false)
	ply:StripWeapons()
	ply:RemoveAllAmmo()
	ply:SetJumpPower(170)
	ply:SetColor(Color(255, 255, 255))
	
	timer.Stop("kill_" .. ply:EntIndex())
	
	if not IS_ROUND_STARTED then
		ply:SetTeam(TEAM_HUMANS)
	else
		ply:SetTeam(TEAM_MUTANTS)
	end
	
	timer.Simple(0.2, function()
		if not IS_ROUND_STARTED and ply:GetClassString() == "NoCLS" then
			spectator_handler(ply)
			
			return
		end
	
		if ply:Team() == TEAM_HUMANS and ply:GetClassString() == "NoCLS" then
			spectator_handler(ply)
		end
		
		ply:SetNWVector("muth_startpoint", ply:GetPos())
		
		if ply:Team() == TEAM_SPECTATOR then
			ply:KillSilent()
		elseif ply:Team() == TEAM_HUMANS then
			ply:SetMoney(150)
			
			if ply:GetClassString() == "Engineer" then
				ply:SetModel(player_manager.TranslatePlayerModel("eli"))
				ply:SetWalkSpeed(240)
				ply:SetHealth(700)
				ply:SetRunSpeed(240)
				ply:SetMaxHealth(700)
				ply:Give("weapon_muth_turret")
				ply:Give("weapon_muth_beacon")
			end
			
			if ply:GetClassString() == "Medic" then
				ply:SetModel(player_manager.TranslatePlayerModel("alyx"))
				ply:Give("weapon_muth_medkit")
				ply:Give("weapon_muth_antidote")
				ply:SetWalkSpeed(240)
				ply:SetRunSpeed(240)
				ply:SetHealth(750)
				ply:SetMaxHealth(750)
			end
			
			if ply:GetClassString() == "Berserk" then
				ply:SetModel(player_manager.TranslatePlayerModel("odessa"))
				ply:SetWalkSpeed(245)
				ply:SetHealth(850)
				ply:SetMaxHealth(850)
				ply:SetRunSpeed(245)
				ply:Give("weapon_hook_muth")
			end
			
			if ply:GetClassString() == "Heavy soldier" then
				ply:SetModel(player_manager.TranslatePlayerModel("male18"))
				ply:SetWalkSpeed(210)
				ply:Give("weapon_muth_ak47")
				ply:SetHealth(1100)
				ply:SetMaxHealth(1100)
				ply:SetRunSpeed(210)
			end
			
			if ply:GetClassString() == "Light soldier" then
				ply:SetModel(player_manager.TranslatePlayerModel("male11"))
				ply:SetWalkSpeed(240)
				ply:SetHealth(700)
				ply:SetMaxHealth(700)
				ply:Give("weapon_muth_mp5")
				ply:SetRunSpeed(240)
			end
			
			ply:SetupHands()
		elseif ply:Team() == TEAM_MUTANTS then
			ply:SetClass(math.random(1, 4))

			if math.random(1, 70) == 40 then ply:SetClass(5) end
			
			timer.Create("spawn_set_up_" .. ply:EntIndex(), 0.35, 1, function()
				if IsValid(ply) then
					local pos
					local ent
					
					if not radio_spawn[game.GetMap()] then pos = Vector(0, 0, 0) else pos = radio_spawn[game.GetMap()] end
					
					local vec = pos + (VectorRand() * math.random(150, 280))
					vec.z = pos.z + 1
					
					for k, v in pairs(ents.FindByClass("ent_radio_muth")) do ent = v break end
					
					local tr = util.TraceLine {
						start = pos + Vector(0, 0, 6),
						endpos = vec,
						filter = ent
					}
						
					timer.Simple(0.035, function() if IsValid(ply) then ply:SetPos(tr.HitPos - (tr.HitNormal * 20)) end end)
				
					ply:SetHealth(1000)
					ply:SetMaxHealth(3200)
					ply:SetWalkSpeed(265)
					ply:SetRunSpeed(265)
					ply:ChatPrint("F - mutant vision")
				
					ply:SetModel(player_manager.TranslatePlayerModel("corpse"))
					ply:Give("weapon_mutant_gm")
					
					if ply:GetClassString() == "Faster" then
						ply:SetJumpPower(450)
						ply:SetWalkSpeed(295)
						ply:SetRunSpeed(295)
						ply:SetHealth(800)
						//ply:SetModel("models/player/Zombiefast.mdl")
					end
					
					if ply:GetClassString() == "The child of darkness" then
						ply:SetHealth(2000)
						ply:SetModelScale(1.6, 0)
						ply:SetModel(player_manager.TranslatePlayerModel("charple"))
					end
					
					ply:ChatPrint("Your class is " .. string.lower(ply:GetClassString()))
				end
			end)
		end
	end)
end



function GM:PlayerDeathThink(ply) //no spawn
	if ply:Team() != TEAM_SPECTATOR then return end
	ply:Spectate(OBS_MODE_ROAMING)
	
	if ply:KeyDown(IN_ATTACK) then end
end

function GM:EntityTakeDamage(ent, dmginfo)
	local attacker = dmginfo:GetAttacker()
	
	if IsValid(attacker) then
		-- No kill friends :3
		if attacker:IsPlayer() and ent:IsPlayer() and attacker:Team() == ent:Team() then
			dmginfo:SetDamage(0)
			dmginfo:ScaleDamage(0)
		end
		
		-- Mutant's damage
		if attacker:IsPlayer() and attacker:Team() == TEAM_MUTANTS then
			if math.random(1, 50) == 25 then
				local time = math.random(50, 70)
			
				ent:SetColor(Color(100, 200, 100))
				ent:ChatPrint("You have been infected. You have " .. time .. " to have antidote")
				
				timer.Create("kill_" .. ent:EntIndex(), time, 1, function()
					if IsValid(ent) and ent:Team() == TEAM_HUMANS then
						ent:Kill()
					end
				end)
			end
			
			if attacker:GetClassString() == "Berserk" or attacker:GetClassStirng() == "The child of darkness" then
				dmginfo:SetDamage(dmginfo:GetDamage() + 150)
			end	
			
			if attacker:GetClassString() == "Runner" then
				dmginfo:SetDamage(dmginfo:GetDamage() - 80)
			end
		end
	
		if attacker:IsNPC() and attacker:GetClass() == "npc_turret_floor" then
			dmginfo:SetDamage(dmginfo:GetDamage() * 40)
		end
		
		-- Human's damage
		if attacker:IsPlayer() and attacker:Team() == TEAM_HUMANS then 
			dmginfo:SetDamage(dmginfo:GetDamage() / 3)
		
			if attacker:GetClassString() == "Medic" then
				dmginfo:SetDamage(dmginfo:GetDamage() - 15)
			elseif attacker:GetClassString() == "Heavy soldier" then
				dmginfo:SetDamage(dmginfo:GetDamage() * 1.25)
			elseif attacker:GetClassString() == "Berserk" and attacker:GetActiveWeapon().IsMelee then
				dmginfo:SetDamage(dmginfo:GetDamage() * 1.35)
			end
		end
	end
end

function GM:DoPlayerDeath(ply)
	ply:CreateRagdoll()
	ply:SetTeam(TEAM_SPECTATOR)
	ply:Spectate(OBS_MODE_ROAMING)
	ply:KillSilent()
	
	timer.Simple(15, function()
		if ply:Alive() then return end
		
		ply:Spawn()
	end)
end


--Handlers

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














