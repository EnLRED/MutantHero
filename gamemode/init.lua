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

util.AddNetworkString("pointshop_toserv")
util.AddNetworkString("froms_toclient_check")
util.AddNetworkString("change_class")
util.AddNetworkString("drop_weapon_muth")

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
	
	restart_Humans = false
	restart_Mutant = false
	
	SetGlobalInt("timetoendsec", 180) --stufffff
	SetGlobalInt("timetostart", time_pause) --stuffff
	SetGlobalBool("round_started", false) --not stuffff
	SetGlobalBool("radio_clk", false) --stufffff
	
	timer.Stop("count_round_end")
	timer.Stop("start_round")
	timer.Stop("count_round_start")
	
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
	
	timer.Simple(7, function() 
		game.CleanUpMap()
	
		self:InitPostEntity() 
		for k, v in pairs(player.GetAll()) do v:Spawn() end 
	end)
end

function GM:PlayerNoClip(ply, on)
	if ply:IsAdmin() then
		return true
	end

	return false
end

function GM:InitPostEntity()
	ROUND_TIME_SECS = 180
	IS_ROUND_STARTED = false
	
	SetGlobalInt("timetoendsec", ROUND_TIME_SECS) --stufffff
	SetGlobalInt("timetostart", time_pause) --stuffff
	SetGlobalBool("round_started", IS_ROUND_STARTED) --not stuffff
	SetGlobalBool("radio_clk", false) --stufffff
	
	SetGlobalVector("evacuation_zone", random_evacuation[game.GetMap()][math.random(1, 5)])

	timer.Create("count_round_start", 1, time_pause, function() --stufffffffff
		SetGlobalInt("timetostart", GetGlobalInt("timetostart") - 1)
	end)
	
	for k, pos in pairs(weapon_spawn[game.GetMap()]) do
		local wep = table.Random(GetAllWeapons()).ClassName
		
		local ent = ents.Create(wep)
		ent:SetPos(pos + vector_up * 3)
		ent:Spawn()
		ent:SetNWBool("made_by_people_muth", true)
		
		if IsValid(ent:GetPhysicsObject()) then ent:GetPhysicsObject():AddAngleVelocity(VectorRand() * 200) end
			
		print(wep .. " spawned")
	end
	
	--Start round
	timer.Create("start_round", time_pause, 1, function()
		for k, v in pairs(player.GetAll()) do 
			v:SendLua("surface.PlaySound('music/ravenholm_1.mp3')") 
		end
		
		umsg.Start("notify_muth")
			umsg.String("Round started")
		umsg.End()
		
		IS_ROUND_STARTED = true
		SetGlobalBool("round_started", true)
		
		--Spawn random mutants
		if #player.GetAll() > 1 then
			for I = 1, math.ceil(#player.GetAll() / 3) do
				local p = math.random(1, #player.GetAll())
				
				if IsValid(player.GetAll()[p]) then
					player.GetAll()[p]:SetTeam(TEAM_MUTANTS)
					player.GetAll()[p]:Spawn()
				else
					print("Invalid mutant!")
				end
			end
		end
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
			
			attacker:SetNWFloat("killed_muth", attacker:GetNWFloat("killed_muth") + 1)
		
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
			
			for k, v in pairs(team.GetPlayers(TEAM_MUTANTS)) do v.WinRound_Mutant = true end
		end
	end)
	
	victim:AddDeaths(1)
end

local wait_muth = 0

function GM:CanPlayerSuicide(ply)
	ply:PrintMessage(HUD_PRINTTALK, "You can't suicide!")
	
	return false
end

function GM:Think()
	if restart_Humans and CurTime() > wait_muth then
		self:RestartRound(true)
		
		wait_muth = CurTime() + 1
	end
	
	if restart_Mutant and CurTime() > wait_muth then
		self:RestartRound(false)
		
		wait_muth = CurTime() + 1
	end

	if ROUND_TIME_SECS <= 1 and CurTime() > wait_muth then
		local count = 0
		
		local rad = GetGlobalVector("evacuation_zone")
		if not rad then rad = Vector(0, 0, 0) end
		
		for k, v in pairs(ents.FindInSphere(rad, 1200)) do
			if v:IsPlayer() and v:Team() == TEAM_HUMANS then
				count = count + 1
				v.WinRound_Human = true
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
		
		if v:Team() == TEAM_HUMANS and v:KeyPressed(IN_JUMP) then
			if v.Force > 0 then v.Force = v.Force - math.min(10, v.Force) end
			v:SetJumpPower(v.Force * 1.7)
		end
		
		if v:Team() == TEAM_HUMANS and v:IsOnGround() and v:KeyDown(IN_SPEED) and (v:KeyDown(IN_FORWARD) or v:KeyDown(IN_BACK) or v:KeyDown(IN_MOVELEFT) or v:KeyDown(IN_MOVERIGHT)) then
			v:SetRunSpeed(v:GetClassTable().speed + v.Force * 1.2)
			if v.Force > 0 then v.Force = v.Force - 0.5 v:SetNWFloat("force_muth", v.Force) end
		elseif not v:KeyDown(IN_SPEED) and not v:KeyDown(IN_FORWARD) or not v:KeyDown(IN_BACK) or not v:KeyDown(IN_MOVELEFT) or not v:KeyDown(IN_MOVERIGHT) then
			if v.Force < 100 then v.Force = v.Force + 0.1 v:SetNWFloat("force_muth", v.Force) end
		end
		
		if v:Team() == TEAM_HUMANS and v:WaterLevel() >= 3 then
			if v.Air > 0 then v.Air = v.Air - 0.1 end
			v:SetNWFloat("air_muth", v.Air)
			
			if v.Air <= 0 then v:Kill() end
		elseif v:WaterLevel() < 3 then
			if v.Air < 100 then v.Air = v.Air + 1 v:SetNWFloat("air_muth", v.Air) end
			if v.Air > 100 then v.Air = 100 v:SetNWFloat("air_muth", v.Air) end
		end
	end

	net.Receive("pointshop_toserv", pshop_handler) 
	net.Receive("change_class", function(ln, ply) local n = net.ReadFloat() ply:SetClass(n) ply:Spawn() end)
end

function GM:ShowSpare1(ply)
	if ply:Team() == TEAM_MUTANTS then return end

	local wep = ply:GetActiveWeapon()
	
	if not IsValid(wep) or wep.ClassName == "weapon_muth_knife" then ply:ChatPrint("You can't drop this weapon!") return end
	
	local weight = 1
	if wep.ClassName == "weapon_muth_para" then weight = 2 end
	
	ply.Weight = ply.Weight - weight
	
	ply:SetNWFloat("weight_muth", ply.Weight)
	
	wep.Primary.DefaultClip = 0
	
	ply:DropWeapon(wep)
end

function GM:PlayerCanPickupWeapon(ply, wep)
	if ply:Team() == TEAM_MUTANTS then
		if wep.ClassName == "weapon_mutant_gm" then
			return true
		else
			return false
		end
	end
	
	if ply:Team() == TEAM_HUMANS then
		if ply:GetClassString() != "Heavy soldier" and wep.IsHeavy then
			return false
		end
		
		if not ply:HasWeapon(wep.ClassName) then
			local weight = 1
			if wep.ClassName == "weapon_muth_para" then weight = 2 end
			
			if (ply.Weight + weight) > 4 then return false end
				
			ply.Weight = ply.Weight + weight
			
			ply:SetNWFloat("weight_muth", ply.Weight)
				
			umsg.Start("notify_muth", ply)
				umsg.String("+" .. wep.PrintName)
			umsg.End()
		end
		
		return true
	end
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
	ply:SetCanZoom(false)
	
	ply:SetNWFloat("killed_muth", 0)
	
	ply.Weight = 0
	ply.Force = 100
	ply.Air = 100
	ply:SetNWFloat("weight_muth", 0)
	ply:SetNWFloat("force_muth", 100)
	ply:SetNWFloat("air_muth", 100)
	
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
			local money = 50
			
			if ply.WinRound_Human then umsg.Start("notify_muth", ply) umsg.String("You got +20$ money bonus") umsg.End() ply:ChatPrint("You got +20$ money bonus") money = 70 end
			if ply.ClkedRadio then umsg.Start("notify_muth", ply) umsg.String("You got +10$ money bonus") umsg.End() ply:ChatPrint("You got +10$ money bonus") money = money + 10 end
		
			ply:SetMoney(money)
			
			ply.ClkedRadio = false
			ply.WinRound_Human = false
			
			ply:Give("weapon_muth_knife")
			
			ply:SetWalkSpeed(ply:GetClassTable().speed)
			ply:SetRunSpeed(ply:GetClassTable().speed)
			ply:SetJumpPower(ply:GetClassTable().jumpp)
			ply:SetHealth(ply:GetClassTable().health)
			ply:SetMaxHealth(ply:GetClassTable().health)
			
			local Pistols = {}
			
			for k, v in pairs(weapons.GetList()) do
				if v.IsPistol_muth then
					table.insert(Pistols, v)
				end
			end
			
			ply:Give(table.Random(Pistols).ClassName)
			
			ply:SetModel(player_manager.TranslatePlayerModel(ply:GetClassTable().model))
			
			if ply:GetClassString() == "Engineer" then
				ply:Give("weapon_turret_muth")
				ply:Give("weapon_muth_beacon")
			end
			
			if ply:GetClassString() == "Medic" then
				ply:Give("weapon_medkit_muth")
				ply:Give("weapon_muth_antidote")
			end
			
			if ply:GetClassString() == "Berserk" then
				ply:Give("weapon_hook_muth")
			end
			
			ply:SetupHands()
		elseif ply:Team() == TEAM_MUTANTS then
			ply:SetClass(math.random(1, 3))
			
			ply:DrawWorldModel(false)

			if math.random(1, 70) == 40 then ply:SetClass(CLASS_MUTANTS_DARK) end
			
			timer.Create("spawn_set_up_" .. ply:EntIndex(), 0.4, 1, function()
				if IsValid(ply) then
					ply:DrawWorldModel(true)
				
					local pos
					local ent
					
					if not map_coordinates[game.GetMap()].radio_spawn then pos = Vector(0, 0, 0) else pos = map_coordinates[game.GetMap()].radio_spawn end
					
					local vec = pos + (VectorRand() * math.random(180, 350))
					vec.z = pos.z + 1
					
					for k, v in pairs(ents.FindByClass("ent_radio_muth")) do ent = v break end
					
					local tr = util.TraceLine {
						start = pos + Vector(0, 0, 6),
						endpos = vec,
						filter = { ent, player.GetAll() }
					}
						
					ply:SetPos(tr.HitPos - (tr.HitNormal * 50))
				
					local bonus = 0
					
					if ply.WinRound_Mutant then umsg.Start("notify_muth", ply) umsg.String("You got +100 health bonus") umsg.End() ply:ChatPrint("You got +100 health bonus") bonus = 100 end
					
					ply.WinRound_Human = false
					ply.WinRound_Mutant = false
				
					ply:SetWalkSpeed(ply:GetClassTable().speed)
					ply:SetRunSpeed(ply:GetClassTable().speed)
					ply:SetJumpPower(ply:GetClassTable().jumpp)
					ply:SetHealth(ply:GetClassTable().health + bonus)
					ply:SetMaxHealth(ply:GetClassTable().health)
					
					ply:ChatPrint("F - mutant vision")
				
					ply:SetModel(player_manager.TranslatePlayerModel(ply:GetClassTable().model))
					ply:Give("weapon_mutant_gm")
					
					ply:ChatPrint("Your class is " .. string.lower(ply:GetClassString()))
				end
			end)
		end
	end)
end



function GM:PlayerDeathThink(ply)
	if ply:Team() != TEAM_SPECTATOR then return end
	
	if ply:KeyPressed(IN_ATTACK) then
		ply.Spectated = (ply.Spectated or 0) + 1
		
		local tospec = {}
		
		for k, v in pairs(player.GetAll()) do
			if v:Alive() then 
				table.insert(tospec, v) 
			end
		end
		
		local spec = tospec[ply.Spectated]
		
		if spec then
			if spec:IsPlayer() then
				ply:Spectate(OBS_MODE_IN_EYE)
			else
				ply:Spectate(OBS_MODE_CHASE)
			end
			
			ply:SpectateEntity(spec)
		else
			ply:Spectate(OBS_MODE_ROAMING)
			ply:SpectateEntity(NULL)
			ply.Spectated = nil
		end
	end
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
			if ent:IsPlayer() and ent:Team() == TEAM_HUMANS then
				ent.Force = ent.Force - math.min(ent.Force, 20)
			end
		
			if ent:IsPlayer() and ent:Team() == TEAM_HUMANS and math.random(1, 15) == 10 and not timer.Exists("kill_" .. ent:EntIndex()) then
				local time = math.random(50, 70)
			
				ent:SetColor(Color(150, 200, 150))
				ent:ChatPrint("You have been infected. You have " .. time .. " to have antidote")
				
				timer.Create("kill_" .. ent:EntIndex(), time, 1, function()
					if IsValid(ent) then
						ent:Kill()
					end
				end)
			end
			
			if attacker:GetClassString() == "Berserk" or attacker:GetClassString() == "The child of darkness" then
				dmginfo:SetDamage(dmginfo:GetDamage() + 250)
			end	
			
			if attacker:GetClassString() == "Runner" then
				dmginfo:SetDamage(dmginfo:GetDamage() - 80)
			end
		end
	
		if attacker:IsNPC() and attacker:GetClass() == "npc_turret_floor" then
			dmginfo:SetDamage(dmginfo:GetDamage() * 7)
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
	if ply:Team() == TEAM_HUMANS then 
		ply:SendLua("surface.PlaySound('muth/dead.wav')") 
		
		timer.Create("stop_snd" .. ply:EntIndex(), 4, 1, function()
			if IsValid(ply) then ply:ConCommand("stopsound") end
		end)
	end

	ply:CreateRagdoll()
	ply:SetTeam(TEAM_SPECTATOR)
	ply:Spectate(OBS_MODE_ROAMING)
	ply:KillSilent()
	
	timer.Simple(13, function()
		if ply:Alive() then return end
		
		ply:Spawn()
	end)
end


--Handlers

function GM:PlayerDisconnected(ply)
	timer.Simple(1.2, function()
		if #team.GetPlayers(TEAM_HUMANS) <= 0 then
			self:RestartRound(false)
		end
		
		if #team.GetPlayers(TEAM_MUTANTS) <= 0 then
			self:RestartRound(true)
		end
	end)
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
			if ply:HasWeapon(ClassName) then ply:ChatPrint("You already have this weapon!") return end
			ply:Give(ClassName)
			print(ClassName)
		end
		
		ply:SetMoney(ply:GetMoney() - Cost)
	end
end

restart_Humans = false
restart_Mutant = false

concommand.Add("muth_restart_humanwin", function(caller)
	if not caller:IsSuperAdmin() then caller:ChatPrint("You can't restart round!") return end

	restart_Humans = true
end)

concommand.Add("muth_restart_mutantwin", function(caller)
	if not caller:IsSuperAdmin() then caller:ChatPrint("You can't restart round!") return end

	restart_Mutant = true
end)


















--[[----------------------------------------------------------------------------------------------
	 ______    __    __    _____           _____    ___      __    __
	|      |  |  |  |  |  |  ___|         |  ___|  |   \    |  |  |   \\
	|__  __|  |  |__|  |  | |___          | |___   |  |\ \  |  |  |  _ \\
	  |  |    |   __   |  |  ___|         |  ___|  |  | \ \ |  |  | |_|||
	  |  |    |  |  |  |  | |___          | |___   |  |  \ \|  |  |    //
	  |__|    |__|  |__|  |_____|         |_____|  |__|   \____|  |___//
--]]----------------------------------------------------------------------------------------------














