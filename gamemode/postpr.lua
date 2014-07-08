AddCSLuaFile()

local human =
{
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0.5,
	["$pp_colour_brightness"] = -0.03,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0.1
}

local mutant =
{
	["$pp_colour_addr"] = 1,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = -0.06,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 0.8,
	["$pp_colour_mulr"] = 1,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

function GM:RenderScreenspaceEffects()
	if LocalPlayer():Team() == TEAM_HUMANS then
		DrawColorModify(human)
	elseif LocalPlayer():Team() == TEAM_MUTANTS then
		DrawColorModify(mutant)
	end
end