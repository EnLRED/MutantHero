
///////////Gamemode started make in 08/04/2014----

AddCSLuaFile()

if CLIENT then
	include("hud.lua")
	include("pointshop.lua")
	include("changeclass.lua")
	include("notify.lua")
	include("postpr.lua")
	include("player_extended_cl.lua")
elseif SERVER then
	include("player_extended_sv.lua")
end
include("player_extended_sh.lua")

GM.Name = "Mutant Hero"
GM.Author = "HK47"
GM.Email = ""
GM.Website = ""

TEAM_HUMANS = 1
TEAM_MUTANTS = 2
TEAM_SPECTATOR = 3

CLASS_HUMANS_MEDIC = 1
CLASS_HUMANS_LIGHTS = 2
CLASS_HUMANS_BERSERK = 3
CLASS_HUMANS_ENGINEER = 4
CLASS_HUMANS_HEAVYS = 5

CLASS_MUTANTS_FASTER = 1
CLASS_MUTANTS_BERSERK = 2
CLASS_MUTANTS_STALKER = 3
CLASS_MUTANTS_NORMAL = 4
CLASS_MUTANTS_DARK = 5

random_evacuation = {
	["gm_construct"] = {
		[1] = Vector(1123.0928955078, 5691.1801757813, -31.96875),
		[2] = Vector(-4292.921875, 3547.5361328125, -100.99945831299),
		[3] = Vector(-322.11758422852, -1292.7222900391, -143.96875)
	},
	
	["gm_bigcity"] = {
		[1] = Vector(0, 0, 0),
		[2] = Vector(0, 0, 0),
		[3] = Vector(0, 0, 0)
	},
	
	["gm_flatgrass"] = {
		[1] = Vector(0, 0, 0),
		[2] = Vector(0, 0, 0),
		[3] = Vector(0, 0, 0)
	}
}

map_coordinates = {
	["gm_construct"] = { 
		radio_spawn = Vector(-4187.1948242188, -1833.9692382813, -143.96875), 
		pointshop_spawn = Vector(523.30065917969, -102.16304016113, -148.40969848633) 
	},
	
	["gm_bigcity"] = { 
		radio_spawn = Vector(-1420.9265136719, 4894.9672851563, -11135.96875), 
		pointshop_spawn = Vector(0, 0, 0) 
	}
}

team.SetUp(TEAM_HUMANS, "Humans", Color(0, 0, 255))
team.SetUp(TEAM_MUTANTS, "Mutants", Color(255, 0, 0))
team.SetUp(TEAM_SPECTATOR, "Spectator", Color(0, 255, 0))






