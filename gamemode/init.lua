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
	
	umsg.Start("notify_muth")
		umsg.String(note .. " Restarting round...")
	umsg.End()
	
	timer.Simple(2, function() for k, v in pairs(player.GetAll()) do v:Spawn() end end)
end

function GM:PlayerNoClip()
	return false
end

function GM:InitPostEntity()
	print("Round starts...\n")
	----Start game | it looks like  main() {} :D
	timer.Create("count_round_end", 1, 0, function()
		ROUND_TIME_SECS = ROUND_TIME_SECS - 1
		
		--Tick / Time
		if ROUND_TIME_SECS <= 0 then ROUND_SETTIME = ROUND_SETTIME - 1 SetGlobalInt("timetoend", ROUND_SETTIME) ROUND_TIME_SECS = 60 end
		
		--Humans win
		if ROUND_TIME_SECS <= 1 and ROUND_SETTIME <= 0 then IS_ROUND_END = true SetGlobalBool("round_end", IS_ROUND_END) self:RestartRound(true) end
		
		SetGlobalInt("timetoendsec", ROUND_TIME_SECS)
	end)
	print("'End round' timer created...\n")
	
	ROUND_SETTIME = old_time_standart
	ROUND_TIME_SECS = 60
	IS_ROUND_STARTED = false
	IS_ROUND_END = false
	
	SetGlobalInt("timetoend", ROUND_SETTIME)
	SetGlobalInt("timetoendsec", ROUND_TIME_SECS)
	SetGlobalBool("round_started", IS_ROUND_STARTED)
	SetGlobalBool("round_end", IS_ROUND_END)
	
	print("Bools and time activated...\n\n")
	
	timer.Create("spawn_pointshop", 120, 1, function()
		local ent = ents.Create("prop_physics")
		ent:SetPos(player.GetAll()[math.random(1, #player.GetAll())]:GetNWVector("muth_startpoint"))
		ent:SetModel("models/Items/item_item_crate.mdl")
		ent:Spawn()
		ent:SetHealth(99999)
		ent:SetNWBool("is_pointshop", true)
		ent:SetNWBool("made_by_people_muth", true)
		
		for k, v in pairs(team.GetPlayers(TEAM_HUMANS)) do v:ChatPrint("Pointshop spawned!") end
		
		hook.Add("Think", "pointshop_after", function()
			if not IsValid(ent) then hook.Remove("Think", "pointshop_after") return end
			
			for k, v in pairs(ents.FindInSphere(ent:GetPos(), 150)) do
				if v:IsPlayer() and v:Team() == TEAM_HUMANS and v:GetEyeTrace().Entity == ent and v:KeyPressed(IN_USE) then
					umsg.Start("open_shop_muth2", ply)
					umsg.End()
				end
			end
		end)
	end)
	
	print("Done!")
end

function GM:PlayerDeath(victim, inflictor, attacker)
	if IsValid(attacker) and attacker:IsPlayer() then
		attacker:AddFrags(1)
		
		if attacker:Team() == TEAM_HUMANS then
			attacker:SetMoney(attacker:GetMoney() + 10)
			
			umsg.Start("notify_muth", attacker)
				umsg.String("+10$")
			umsg.End()
		end
	end
	
	timer.Simple(0.5, function()
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
		
		umsg.Start("notify_muth")
			umsg.String("ROUND STARTED!!!")
		umsg.End()
		
		--Spawn random mutants
		if #player.GetAll() > 1 then
			local numofneeded = math.Clamp(math.random(2), #player.GetAll())
			
			for I = 1, math.random(numofneeded) do
				local p = math.random(#player.GetAll())
				
				if IsValid(player.GetAll()[p]) then
					player.GetAll()[p]:SetTeam(TEAM_MUTANTS)
					timer.Simple(0.1, function() if IsValid(player.GetAll()[p]) then player.GetAll()[p]:Spawn() end end)
				end
			end
		end
		
		IS_ROUND_STARTED = true
		SetGlobalBool("round_started", IS_ROUND_STARTED)
	end
end

function GM:PlayerSpawn(ply) --COMMMMMMMIT
	ply:UnSpectate()
	ply:DrawWorldModel(true)
	ply:DrawViewModel(true)
	ply:ShouldDropWeapon(false)
	ply:StripWeapons()
	ply:RemoveAllAmmo()
	
	timer.Stop("kill_" .. ply:EntIndex())
	
	if not IS_ROUND_STARTED then
		ply:SetTeam(TEAM_HUMANS)
	else
		ply:SetTeam(TEAM_MUTANTS)
	end
	
	timer.Simple(0.06, function()
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
			ply:SetJumpPower(170)
		
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
			ply:SetClass(math.random(1, 5))
			
			timer.Create("spawn_set_up_" .. ply:EntIndex(), 0.15, 1, function()
				if IsValid(ply) then
					ply:SetHealth(3200)
					ply:SetMaxHealth(3200)
					ply:SetWalkSpeed(255)
					ply:SetRunSpeed(255)
				
					ply:SetModel(player_manager.TranslatePlayerModel("charple"))
					ply:Give("weapon_mutant_gm")
					
					if ply:GetClassString() == "Runner" then
						ply:SetWalkSpeed(290)
						ply:SetRunSpeed(290)
					end
					
					if ply:GetClassString() == "Jumper" then
						ply:SetJumpPower(450)
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
			if math.random(1, 100) == 50 then
				local time = math.random(50, 70)
			
				ent:SetColor(Color(100, 200, 100))
				ent:ChatPrint("You have been infected. You have " .. time .. " to have antidote")
				
				timer.Create("kill_" .. ent:EntIndex(), time, 1, function()
					if IsValid(ent) and ent:Team() == TEAM_HUMANS then
						ent:Kill()
					end
				end)
			end
			
			if attacker:GetClassString() == "Berserk" then
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














