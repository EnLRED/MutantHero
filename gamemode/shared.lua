
///////////Gamemode started make in 08/04/2014----

AddCSLuaFile()

if CLIENT then
	include("hud.lua")
	include("pointshop.lua")
elseif SERVER then

end
include("player_info.lua")

GM.Name = "Mutant Hero"
GM.Author = "HK47"
GM.Email = ""
GM.Website = ""

TEAM_HUMANS = 1
TEAM_MUTANTS = 2

team.SetUp(TEAM_HUMANS, "Humans", Color(0, 0, 255))
team.SetUp(TEAM_MUTANTS, "Mutants", Color(255, 0, 0))