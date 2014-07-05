AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("player_info.lua")

include("shared.lua")
include("player_info.lua")

local old_time_standart = 6

ROUND_SETTIME = old_time_standart
ROUND_STARTED = false
SECONDS_ROUND_SETTIME = 0
ENDROUND = false

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

--[[-----------------
	Function for open pointshop
--]]-----------------
function GM:ShowSpare1(ply)
	if ply:Team() == 1 and not ROUND_STARTED then
		ply:SendLua("LocalPlayer():ConCommand('open_pointshop')")
	end
end

--[[-----------------
	Main function for set the round
--]]-----------------
function GM:RestartRound()
	self:InitPostEntity()
	
	SECONDS_ROUND_SETTIME = 0
	ROUND_SETTIME = old_time_standart
	
	for k, v in pairs(player.GetAll()) do
		v:ChatPrint("RESTARTING ROUND!!!")	
		v:SetTeam(TEAM_SPECTATOR)
		v:KillSilent()
		
		timer.Simple(3, function()
			self:PlayerInitialSpawn(v)
			v:Spawn()
		end)
	end
end

--[[-----------------
	Function for start the round and some shit too
--]]-----------------
function GM:Think()
	SetGlobalBool("round_started", ROUND_STARTED)

	for k, v in pairs(player.GetAll()) do
		if v:WaterLevel() > 0 then
			v:Extinguish()
		end
	end
	
	for k, v in pairs(team.GetPlayers(1)) do
		if v:GetNetworkedBool("boots") and v:KeyDown(IN_JUMP) then
			v:SetVelocity((v:GetAimVector() * 5) + vector_up * 15)

			local ef = EffectData()
			ef:SetOrigin(v:GetBonePosition(v:LookupBone("ValveBiped.Bip01_L_Foot")))
			util.Effect("effect_muth_rb", ef)
				
			ef:SetOrigin(v:GetBonePosition(v:LookupBone("ValveBiped.Bip01_R_Foot")))
			util.Effect("effect_muth_rb", ef)
		end
	end

	if CurTime() - ROUNDTIME >= 60 then
		if ROUND_STARTED then return end
		ROUND_STARTED = true
	
		for k, v in pairs(player.GetAll()) do
			v:ChatPrint("ROUND STARTED!")
			v:SendLua("surface.PlaySound('music/ravenholm_1.mp3')")
		end
	
		for i = 1, math.ceil(math.Clamp(#player.GetAll() / 4, 1, 16)) do //set up mutants
			for k, v in pairs(player.GetAll()) do
				if math.random(1, 4) == 2 then
					v:SetTeam(2)
					v:Spawn()
					
					break
				end
			end
		end
		
		timer.Simple(7, function() //checking mutants
			if #team.GetPlayers(2) <= 0 then 
				for i = 1, math.ceil(math.Clamp(#player.GetAll() / 4, 1, 16)) do
					for k, v in pairs(player.GetAll()) do
						if math.random(1, 4) == 2 then
							v:SetTeam(2)
							v:Spawn()
							
							break
						end
					end
				end
			end
		end)
		
		timer.Simple(12, function() //checking mutants 2
			if #team.GetPlayers(2) <= 0 then 
				for i = 1, math.ceil(math.Clamp(#player.GetAll() / 4, 1, 16)) do
					for k, v in pairs(player.GetAll()) do
						if math.random(1, 4) == 2 then
							v:SetTeam(2)
							v:Spawn()
							
							break
						end
					end
				end
			end
		end)
	end
end

--[[-----------------
	Function for some mutant's shit
--]]-----------------
function GM:KeyPress(ply, key)
	if ply:Team() == 2 and ply:GetNetworkedBool("jumper") and key == IN_JUMP and not ply:IsOnGround() and not ply:GetNetworkedBool("cantjump") then
		ply:SetVelocity(Vector(0, 0, 400) + (ply:GetForward() * 200))
		ply:SetNetworkedBool("cantjump", true)
	elseif ply:IsOnGround() then
		ply:SetNetworkedBool("cantjump", false)
	end
end

--[[-----------------
	Function for make player's death
--]]-----------------
function GM:DoPlayerDeath(ply, attacker, dmginfo)
	ply:CreateRagdoll()
	ply:SetTeam(TEAM_SPECTATOR)
	ply:Spectate(OBS_MODE_ROAMING)
	
	timer.Simple(15, function()
		if ply:Alive() then return end
		
		ply:SetTeam(2)
		ply:Spawn()
	end)
	
	if #team.GetPlayers(1) <= 0 then //set up mutants win
		if ENDROUND then return end
		ROUNDTIME = 999
	
		for k,v in pairs(player.GetAll()) do
			v:ChatPrint("MUTANTS WIN! Restarting round... please wait 15 seconds")
			v:SendLua("surface.PlaySound('music/radio1.mp3')")
		end
	
		ENDROUND = true
	
		timer.Simple(15, function()
			self:RestartRound()
		end)	
	end
end

--[[-----------------
	Function for some speaking
--]]-----------------
function GM:PlayerSay(ply, text, team_only)
	if not IsValid(ply) then return end
	
	local exp = string.Explode(" ", text)
	
	if exp[1] == "!rest" then
		if not ply:IsSuperAdmin() then return end
		
		self:RestartRound()
	end
	
	if exp[1] == "!creatoroh" then //omg my function! only my function omg!
		if ply:SteamID() == "STEAM_0:1:56534091" then
			ply:SetHealth(1337)
			return ""
		end
	end
	
	if exp[1] == "!setmyteam" then
		if not ply:IsSuperAdmin() then return end
		
		if not tonumber(exp[2]) then ply:ChatPrint("Type 1 or 2") return end
		if tonumber(exp[2]) == ply:Team() then ply:ChatPrint("You're already in that team!") return end
	
		if not ply:Alive() then timer.Stop("spawn_player" .. ply:EntIndex()) end
		ply:SetTeam(tonumber(exp[2]))
		ply:KillSilent()
		ply:Spawn()
	end
	
	if exp[1] == "!mutantwin" then
		if not ply:IsSuperAdmin() then return end
		
		for k, v in pairs(team.GetPlayers(1)) do
			v:Kill()
		end
	end
	
	if (ply:Team() == 2 or ply:Team() == 1) and team_only then
		return ""
	end

	if ply:Team() == TEAM_SPECTATOR and not team_only then
		ply:ChatPrint("Use TEAM chat while you're spectator!")
		return ""
	end
   
    return text
end

--[[-----------------
	Function for spectate mode
--]]-----------------
function GM:PlayerDeathThink(pl)
	if pl:Team() != TEAM_SPECTATOR then return end
	
	pl:Spectate(OBS_MODE_ROAMING)
	
	if pl:KeyDown(IN_ATTACK) then end
end

--[[-----------------
	Changing some damage
--]]-----------------
function GM:EntityTakeDamage(ent, dmginfo)
	local attacker = dmginfo:GetAttacker()
	
	if attacker:IsPlayer() and ent:IsPlayer() and attacker:Team() == ent:Team() then
		dmginfo:SetDamage(0)
		dmginfo:ScaleDamage(0)
		
		return
	end
	
	if attacker:IsPlayer() and attacker:Team() == 2 and attacker:GetNetworkedBool("stronger") then //stronger mutant muhaha \o/
		dmginfo:SetDamage(dmginfo:GetDamage() + 70)
		dmginfo:ScaleDamage(dmginfo:GetDamage() + 70)
	end
	
	if attacker:IsPlayer() and attacker:Team() == 2 and attacker:GetNetworkedBool("invisiblem") or attacker:GetNetworkedBool("jumper") then //invisible and jumper mutant have easy damage
		dmginfo:SetDamage(10)
		dmginfo:ScaleDamage(10)
	end
end

--[[-----------------
	Jumper dont take fall damage
--]]-----------------
function GM:GetFallDamage(ply, speed)
	if ply:Team() == 2 and ply:GetNetworkedBool("jumper") then
		return 0
	end
	
	return speed / 10
end

--[[-----------------
	Players cant noclip!!!!1111!1!
--]]-----------------
function GM:PlayerNoClip(pl, on)
	return false
end

--[[-----------------
	Opening pointshop when player has spawned
--]]-----------------
function GM:PlayerInitialSpawn(ply)
	ply:ConCommand("open_pointshop")

	if CurTime() - ROUNDTIME > 60 then
		ply:SetTeam(2)
	else
		ply:SetTeam(1)
	end
end

--[[-----------------
	Checking humans and mutants and here we set up mutants win (2)
--]]-----------------
function GM:PlayerDisconnected(pl)
	if #team.GetPlayers(1) <= 0 then
		if ENDROUND then return end
		ROUNDTIME = 999
	
		for k, v in pairs(player.GetAll()) do
			v:ChatPrint("MUTANTS WIN! Restarting round... please wait 15 seconds")
			v:SendLua("surface.PlaySound('music/radio1.mp3')")
		end
	
		ENDROUND = true
	
		timer.Simple(15, function()
			self:RestartRound()
		end)	
	end
end

--[[-----------------
	Function for set up some timers for client, timer for humans win and vars
--]]-----------------
function GM:InitPostEntity()
	/////////--set up round functions
	ROUNDTIME = CurTime()
	ROUND_STARTED = false
	ENDROUND = false
	//////////////
	
	SetGlobalBool("round_started", ROUND_STARTED)
	
	timer.Create("roundend", 1, 0, function()
		SECONDS_ROUND_SETTIME = math.Approach(SECONDS_ROUND_SETTIME, 0, 1)
		SetGlobalString("timetoendsec", tostring(SECONDS_ROUND_SETTIME))
		
		if SECONDS_ROUND_SETTIME <= 0 then 
			SECONDS_ROUND_SETTIME = 60 
			
			ROUND_SETTIME = math.Approach(ROUND_SETTIME, 0, 1)
			SetGlobalString("timetoend", tostring(ROUND_SETTIME))
		end
	end)
	
	
	timer.Create("endround", 359, 1, function()
		if ENDROUND then return end
		ROUNDTIME = 999
	
		for k, v in pairs(player.GetAll()) do
			v:ChatPrint("HUMANS WIN! Restarting round... please wait 15 seconds")
			v:SendLua("surface.PlaySound('music/hl2_song3.mp3')")
		end
		
		ENDROUND = true
		
		timer.Simple(15, function()
			self:RestartRound()
		end)
	end)
end

--[[-----------------
	Pointshop things
--]]-----------------
util.AddNetworkString("pointshop_wepname")
util.AddNetworkString("pointshop_ammoname")

util.AddNetworkString("pointshop_speed")
util.AddNetworkString("pointshop_hp")

util.AddNetworkString("check_wep")
util.AddNetworkString("check_wep_ready")

util.AddNetworkString("invisible")

util.AddNetworkString("pointshop_boots")

local function speedBuy()
	net.Receive("pointshop_speed", function()
		local p = net.ReadEntity()
		
		p:SetWalkSpeed(p:GetWalkSpeed() + 50)
		p:SetRunSpeed(p:GetRunSpeed() + 50)
	end)
end

concommand.Add("givespeed_shop", speedBuy)

local function bootsBuy()
	net.Receive("pointshop_boots", function()
		local p = net.ReadEntity()
		local num = net.ReadInt(32)
		
		if num == 1 then 
			p:SetNetworkedBool("boots", true)
		else 
			p:SetNetworkedBool("boots", false)
		end
	end)
end

concommand.Add("giveboots_shop", bootsBuy)

local function speedBuy()
	net.Receive("pointshop_hp", function()
		local p = net.ReadEntity()
		local num = net.ReadInt(32)
		
		p:SetHealth(math.min(p:GetMaxHealth(), p:Health() + 200))
	end)
end

concommand.Add("givehp_shop", speedBuy)

local function BuyWeapons()
	net.Receive("pointshop_wepname", function()
		local wep = net.ReadString()
		local p = net.ReadEntity()
		
		p:Give(wep)
	end)
end

concommand.Add("givewep_shop", BuyWeapons)

local function Invisible()
	net.Receive("invisible", function()
		local num = net.ReadInt(32)
		local p = net.ReadEntity()
		
		if p:GetNetworkedBool("invisiblem") then return end
		
		if num == 1 then
			p:SetNoDraw(true)
		else
			p:SetNoDraw(false)
		end
	end)
end

concommand.Add("invisible_mut", Invisible)

local function BuyAmmo()
	net.Receive("pointshop_ammoname", function()
		local ammo = net.ReadString()
		local num = net.ReadInt(32)
		local p = net.ReadEntity()
		
		p:GiveAmmo(num, ammo, true)
	end)
end

concommand.Add("giveammo_shop", BuyAmmo)

local function CheckWeapons()
	net.Receive("check_wep", function()
		local wep = net.ReadString()
		local p = net.ReadEntity()
		
		net.Start("check_wep_ready")
			net.WriteString(tostring(p:GetWeapon(wep)))
		net.Send(p)
	end)
end

concommand.Add("check_wep_shop", CheckWeapons)


--[[-----------------
	Will players take the frag?
--]]-----------------
function GM:PlayerDeath(victim, inflictor, attacker)
	if IsValid(attacker) and attacker:IsPlayer() then
		attacker:AddFrags(1)
	end
	victim:AddDeaths(1)
end

--[[-----------------
	Called when player has spawned (lol)
	Set up humans and mutants teams
--]]-----------------
function GM:PlayerSpawn(ply)
	ply:UnSpectate()
	ply:SetCanZoom(false)
	ply:ChatPrint("  ")
	
	if game.GetMap() == "gm_sunnyisles" then //check map
		local vec = VectorRand()
		vec.z = 0
		ply:SetPos(ply:GetPos() + (vec * 250) + vector_up * math.random(60, 170))
	end
	
	ply:StripWeapons()
	ply:ShouldDropWeapon(false)
	
	ply:SetNetworkedBool("stronger", false)
	ply:SetNetworkedBool("jumper", false)
	ply:SetNetworkedBool("cantjump", true)
	ply:SetNetworkedBool("invisiblem", false)
	ply:SetNetworkedBool("boots", false)
	
	ply:RemoveAllAmmo()
	ply:SetModelScale(1, 0)
	
	if ply:Team() == 1 then
		ply:SetDeaths(0)
		ply:SetFrags(0)
		
		ply:ChatPrint("----- F3 - pointshop")
		ply:ChatPrint("----- Key use - nightvision")
		ply:ChatPrint("----- Key zoom - mutant vision")
		
		ply:SetHealth(800)
		ply:SetMaxHealth(1000)
		ply:SetArmor(200)
		ply:SetJumpPower(200)
		
		ply:EmitSound("npc/crow/idle3.wav")
		
		ply:SetModel(player_manager.TranslatePlayerModel("combine"))
		ply:SetMaterial("omglol")
		
		ply:SetNoDraw(false)
		ply:DrawShadow(true)
		
		ply:SetWalkSpeed(320)
		ply:SetRunSpeed(320)
	elseif ply:Team() == 2 then
		ply:SetHealth(3500)
		ply:SetMaxHealth(3500)
		
		ply:ChatPrint("----- Key use - invisible")
		
		ply:SetJumpPower(200)
		
		ply:SetArmor(200)
		
		ply:EmitSound("npc/stalker/stalker_scream1.wav")
		
		ply:DrawShadow(false)
		
		ply:Give("weapon_mutant_gm")
		
		ply:SetModel(Models[math.random(1, #Models)])
		
		local rand = math.random(1, 25)
		
		if rand == 11 or rand == 12 or rand == 13 or rand == 14 or rand == 15 then
			ply:SetWalkSpeed(500)
			ply:SetRunSpeed(500)
			ply:ChatPrint("You're faster mutant!")
		elseif rand == 10 or rand == 9 or rand == 8 or rand == 7 or rand == 6 then
			ply:SetWalkSpeed(360)
			ply:SetRunSpeed(360)
		
			ply:SetNetworkedBool("stronger", true)
			ply:ChatPrint("You're strong mutant!")
		elseif rand == 16 or rand == 17 or rand == 18 then			
			ply:SetWalkSpeed(380)
			ply:SetRunSpeed(380)
			ply:SetJumpPower(380)
		
			ply:SetNetworkedBool("jumper", true)
			ply:SetNetworkedBool("cantjump", false)
			ply:ChatPrint("You're jumper mutant!")
		elseif rand == 19 or rand == 20 or rand == 21 or rand == 21 then
			ply:SetWalkSpeed(370)
			ply:SetRunSpeed(370)
			
			ply:SetNetworkedBool("invisiblem", true)
			
			ply:SetNoDraw(true)
			
			ply:ChatPrint("You're invisible mutant!")
		else
			ply:SetWalkSpeed(410)
			ply:SetRunSpeed(410)
			ply:ChatPrint("You're typical mutant!")
		end
		
		
	elseif ply:Team() == TEAM_SPECTATOR then
		ply:KillSilent()
	end
end



--[[----------------------------------------------------------------------------------------------
	 ______    __    __    _____           _____    ___      __    __
	|      |  |  |  |  |  |  ___|         |  ___|  |   \    |  |  |   \\
	|__  __|  |  |__|  |  | |___          | |___   |  |\ \  |  |  |  _ \\
	  |  |    |   __   |  |  ___|         |  ___|  |  | \ \ |  |  | |_||| 08/04/2014
	  |  |    |  |  |  |  | |___          | |___   |  |  \ \|  |  |    //
	  |__|    |__|  |__|  |_____|         |_____|  |__|   \____|  |___//
--]]----------------------------------------------------------------------------------------------














