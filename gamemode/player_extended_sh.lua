AddCSLuaFile()

local meta = FindMetaTable("Player")
if not meta then return end

function meta:SetClass(cls)
	self:SetDTInt(2, cls)
end

function meta:GetClassConc()
	return self:GetDTInt(2)
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
		if self:GetDTInt(2) == CLASS_MUTANTS_JUMPER then
			return "Jumper"
		elseif self:GetDTInt(2) == CLASS_MUTANTS_RUNNER then
			return "Runner"
		elseif self:GetDTInt(2) == CLASS_MUTANTS_BERSERK then
			return "Berserk"
		elseif self:GetDTInt(2) == CLASS_MUTANTS_STALKER then
			return "Stalker"
		elseif self:GetDTInt(2) == CLASS_MUTANTS_NORMAL then
			return "Zombie"
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