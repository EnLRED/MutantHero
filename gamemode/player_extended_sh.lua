AddCSLuaFile()

local meta = FindMetaTable("Player")
if not meta then return end

function meta:SetClass(cls)
	self:SetDTInt(2, cls)
end

function meta:GetClassConc()
	return self:GetDTInt(2)
end

function meta:GetClassTable()
	local tbl = {}
	
	if self:Team() == TEAM_HUMANS then
		tbl.health = 800
		tbl.jumpp = 170
		tbl.mdlscale = 1
		tbl.speed = 240
	
		if self:GetClassString() == "Medic" then
			tbl.model = "alyx"
			tbl.health = 750
		elseif self:GetClassString() == "Light soldier" then
			tbl.model = "male11"
			tbl.health = 700
		elseif self:GetClassString() == "Heavy soldier" then
			tbl.model = "male18"
			tbl.health = 1100
			tbl.speed = 210
		elseif self:GetClassString() == "Berserk" then
			tbl.model = "odessa"
			tbl.speed = 245
			tbl.health = 850
		elseif self:GetClassString() == "Engineer" then
			tbl.model = "eli"
			tbl.health = 700
		end
	elseif self:Team() == TEAM_MUTANTS then
		tbl.health = 1300
		tbl.jumpp = 170
		tbl.mdlscale = 1
		tbl.speed = 265
	
		if self:GetClassString() == "Faster" then
			tbl.model = "zombiefast"
			tbl.jumpp = 450
			tbl.speed = 295
			tbl.health = 800
		elseif self:GetClassString() == "Berserk" then
			tbl.model = "zombine"
		elseif self:GetClassString() == "Zombie" then
			tbl.model = "zombie"
		elseif self:GetClassString() == "The child of darkness" then
			tbl.model = "corpse"
			tbl.health = 3200
			tbl.speed = 260
			tbl.jumpp = 200
			tbl.mdlscale = 1.4
		end
	end
	
	return tbl
end

function meta:GetClassString() 
	if self:Team() == TEAM_HUMANS then
		if self:GetDTInt(2) == CLASS_HUMANS_MEDIC then
			return "Medic"
		elseif self:GetDTInt(2) == CLASS_HUMANS_LIGHTS then
			return "Light soldier"
		elseif self:GetDTInt(2) == CLASS_HUMANS_HEAVYS then
			return "Heavy soldier"
		elseif self:GetDTInt(2) == CLASS_HUMANS_BERSERK then
			return "Berserk"
		elseif self:GetDTInt(2) == CLASS_HUMANS_ENGINEER then
			return "Engineer"
		else
			return "NoCLS"
		end
	elseif self:Team() == TEAM_MUTANTS then
		if self:GetDTInt(2) == CLASS_MUTANTS_FASTER then
			return "Faster"
		elseif self:GetDTInt(2) == CLASS_MUTANTS_BERSERK then
			return "Berserk"
		elseif self:GetDTInt(2) == CLASS_MUTANTS_NORMAL then
			return "Zombie"
		elseif self:GetDTInt(2) == CLASS_MUTANTS_DARK then
			return "The child of darkness"
		else
			return "NoCLS"
		end
	end
end

function meta:SetMoney(mon)
	if SERVER then
		self:SetDTInt(1, mon)
	end
end

function meta:GetMoney()
	return self:GetDTInt(1)
end


