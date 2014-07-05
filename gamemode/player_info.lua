AddCSLuaFile()

local ply = FindMetaTable("Player")

if not ply then return end

function ply:HelmetBroken()
	if ply:Team() != 1 then return false end
	return self:Health() < 200
end
