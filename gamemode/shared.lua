
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

function GetAllWeapons()
	local tbl = {}
	
	for k, v in pairs(weapons.GetList()) do
		if string.sub(v.ClassName, 1, 11) == "weapon_muth" then
			table.insert(tbl, v)
		end
	end
	
	return tbl
end

weapon_spawn = {
	["gm_construct"] = {
		[1] = Vector(793.68499755859, -1109.7891845703, -143.96875),
		[2] = Vector(-1841.3033447266, -2253, 256.03125),
		[3] = Vector(-2768.9919433594, -3316.4318847656, 256.03125),
		[4] = Vector(-5601.6440429688, -3392.841796875, 256.03125),
		[5] = Vector(-1846.5968017578, -2387.2412109375, 256.03125),
		[6] = Vector(695.86083984375, 1754.2144775391, -64.451965332031),
		[7] = Vector(-2816.9567871094, -949.46704101563, -37.150238037109),
		[8] = Vector(-3166.8403320313, -1122.7133789063, 48.031242370605),
		[9] = Vector(-2607.6301269531, -2004.4455566406, -143.96875),
		[10] = Vector(-2273.6372070313, -2451.9965820313, -255.96875),
		[11] = Vector(-2599.7893066406, -2015.703125, -399.96875),
		[12] = Vector(1791.322265625, -2240.4116210938, -143.96873474121),
		[13] = Vector(-1104.0848388672, -1116.3616943359, -143.96875),
		[14] = Vector(-1781.9641113281, -1839.3065185547, 240.03125),
		[15] = Vector(-3295.5290527344, -3412.6372070313, 249.99998474121),
		[16] = Vector(582.76141357422, 4163.4653320313, -31.96875),
		[17] = Vector(1112.3157958984, -791.23272705078, -143.96875),
		[18] = Vector(828.32507324219, -1333.9375, -143.96875),
		[19] = Vector(-2764.1611328125, 2744.9560546875, -157.47860717773),
		[20] = Vector(-4075.560546875, 5077.65625, -95.96875)
	}
}

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






