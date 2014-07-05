local ply = FindMetaTable("Player")

if not ply then return end

function ply:HelmetBroken()
	return self:Health() < 200
end
