
///////////Gamemode started make in 08/04/2014----

AddCSLuaFile()

if CLIENT then
	include("hud.lua")
	include("pointshop.lua")
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
CLASS_HUMANS_MEDIC = 1
CLASS_HUMANS_GUNNER = 2
CLASS_HUMANS_BERSERK = 3
CLASS_HUMANS_ENGINEER = 4
CLASS_MUTANTS_JUMPER = 1
CLASS_MUTANTS_RUNNER = 2
CLASS_MUTANTS_BERSERK = 3
CLASS_MUTANTS_STALKER = 4
CLASS_MUTANTS_NORMAL = 5

team.SetUp(TEAM_HUMANS, "Humans", Color(0, 0, 255))
team.SetUp(TEAM_MUTANTS, "Mutants", Color(255, 0, 0))