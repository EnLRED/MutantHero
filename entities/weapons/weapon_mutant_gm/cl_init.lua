include("shared.lua")

SWEP.PrintName = "Mutant"
SWEP.ViewModelFOV = 70
SWEP.DrawCrosshair = false

function SWEP:Reload()
end

function SWEP:DrawWeaponSelection()
	return self:BaseDrawWeaponSelection()
end
