local meta = FindMetaTable("Player")
if not meta then return end

meta.Class = 0

function meta:GetClassString() 
	if self:Team() == TEAM_HUMANS then
		if self.Class == CLASS_HUMANS_MEDIC then
			return "Medic"
		elseif self.Class == CLASS_HUMANS_GUNNER then
			return "Gunner"
		elseif self.Class == CLASS_HUMANS_BERSERK then
			return "Berserk"
		elseif self.Class == CLASS_HUMANS_ENGINEER then
			return "Berserk"
		end
	elseif self:Team() == TEAM_MUTANTS then
		if self.Class == CLASS_MUTANTS_JUMPER then
			return "Jumper"
		elseif self.Class == CLASS_MUTANTS_RUNNER then
			return "Runner"
		elseif self.Class == CLASS_MUTANTS_BERSERK then
			return "Berserk"
		elseif self.Class == CLASS_MUTANTS_STALKER then
			return "Stalker"
		elseif self.Class == CLASS_MUTANTS_NORMAL then
			return "Zombie"
		end
	end
end

function meta:SetMoney(mon)
	self:SetDTInt(1,mon)
end

function meta:GetMoney()
	return self:GetDTInt(1)
end