///////////MAIN CODER WAS HK47----
///////////SOME CODING BY MR.MIND----
///////////Gamemode started make in 08/04/2014----

include("player_info.lua")

if CLIENT then
	include("hud.lua")
elseif SERVER then

end

GM.Name = "Mutant Hero"
GM.Author = "HK47"
GM.Email = ""
GM.Website = ""

team.SetUp(1, "Humans", Color(0, 0, 255))
team.SetUp(2, "Mutants", Color(255, 0, 0))