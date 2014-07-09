AddCSLuaFile()

SWEP.PrintName = "Turret"

SWEP.Slot                  = 2
SWEP.SlotPos               = 0

SWEP.ViewModelFOV = 50
 
SWEP.AutoSwitchTo          = false
SWEP.AutoSwitchFrom        = false
 
SWEP.ViewModel = "models/weapons/c_arms_citizen.mdl"
SWEP.WorldModel            = "models/combine_turrets/floor_turret.mdl"

SWEP.DrawAmmo = true

SWEP.Base = "weapon_baseput_muth"

SWEP.HoldType = "slam"

SWEP.Ent = "npc_turret_floor"

function SWEP:EntitySetUp(ent)
	for k, v in pairs(team.GetPlayers(TEAM_HUMANS)) do
		ent:AddEntityRelationship(v, D_LI, 999)
	end
	
	for k, v in pairs(team.GetPlayers(TEAM_MUTANTS)) do
		ent:AddEntityRelationship(v, D_HT, 999)
	end
	
	hook.Add("PlayerSpawn", "check_" .. ent:EntIndex(), function(ply)
		if not IsValid(ent) then hook.Remove("PlayerSpawn", "check_" .. ent:EntIndex()) end
		
		timer.Simple(0.4, function()
			if ply:Team() == TEAM_HUMANS then
				ent:AddEntityRelationship(ply, D_LI, 999)
			else
				ent:AddEntityRelationship(ply, D_HT, 999)
			end
		end)
	end)
end