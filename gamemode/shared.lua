
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
CLASS_MUTANTS_NORMAL = 3
CLASS_MUTANTS_DARK = 4

random_evacuation = {
	["gm_construct"] = {
		[1] = Vector(-2958.9360351563, -1435.1108398438, 240.03125),
		[2] = Vector(-1228.9128417969, -2790.0529785156, 258.07858276367),
		[3] = Vector(-4590.8208007813, -3048.0549316406, 250),
		[4] = Vector(-649.92492675781, -1485.2258300781, -143.96875),
		[5] = Vector(-1896.8890380859, -15.099151611328, -148.00018310547)
	},
	
	["gm_bigcity"] = {
		[1] = Vector(0, 0, 0),
		[2] = Vector(0, 0, 0),
		[3] = Vector(0, 0, 0),
		[4] = Vector(0, 0, 0),
		[5] = Vector(0, 0, 0)
	},
	
	["gm_flatgrass"] = {
		[1] = Vector(0, 0, 0),
		[2] = Vector(0, 0, 0),
		[3] = Vector(0, 0, 0),
		[4] = Vector(0, 0, 0),
		[5] = Vector(0, 0, 0)
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






