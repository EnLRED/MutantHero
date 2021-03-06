AddCSLuaFile()

local mutant =
{
	["$pp_colour_addr"] = 0.08,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = -0.3,
	["$pp_colour_contrast"] = 1.1,
	["$pp_colour_colour"] = 0.7,
	["$pp_colour_mulr"] = 3,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local mutantz =
{
	["$pp_colour_addr"] = 0.1,
	["$pp_colour_addg"] = 0.1,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = -1,
	["$pp_colour_contrast"] = 0.9,
	["$pp_colour_colour"] = 0.9,
	["$pp_colour_mulr"] = 5,
	["$pp_colour_mulg"] = 1,
	["$pp_colour_mulb"] = 0
}

local humanh =
{
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0.05,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0.2,
	["$pp_colour_contrast"] = 0.9,
	["$pp_colour_colour"] = 0.9,
	["$pp_colour_mulr"] = 1,
	["$pp_colour_mulg"] = 1,
	["$pp_colour_mulb"] = 0
}

local function drawShit()
	local br = 0

	hook.Add("RenderScreenspaceEffects", "draw_end", function()
		if br > -1 then br = br - 0.005 end
	
		local end_r =
		{
			["$pp_colour_addr"] = 0,
			["$pp_colour_addg"] = 0,
			["$pp_colour_addb"] = 0,
			["$pp_colour_brightness"] = br,
			["$pp_colour_contrast"] = 1,
			["$pp_colour_colour"] = 1,
			["$pp_colour_mulr"] = 0,
			["$pp_colour_mulg"] = 0,
			["$pp_colour_mulb"] = 0
		}
		
		DrawColorModify(end_r)
	end)
	
	hook.Add("HUDShouldDraw", "no_draw_hud", function()
		return false
	end)
	
	timer.Simple(9, function()
		hook.Remove("RenderScreenspaceEffects", "draw_end")
		hook.Remove("HUDShouldDraw", "no_draw_hud")
	end)
end

usermessage.Hook("draw_end_muth", drawShit)

function GM:RenderScreenspaceEffects()
	if LocalPlayer():Team() == TEAM_HUMANS then
		if LocalPlayer().hvision then
			DrawColorModify(humanh)
		else
			local human =
			{
				["$pp_colour_addr"] = 0,
				["$pp_colour_addg"] = 0,
				["$pp_colour_addb"] = 0,
				["$pp_colour_brightness"] = -0.15,
				["$pp_colour_contrast"] = 1,
				["$pp_colour_colour"] = 1 - ((LocalPlayer():GetMaxHealth() - LocalPlayer():Health()) / LocalPlayer():GetMaxHealth()),
				["$pp_colour_mulr"] = 0,
				["$pp_colour_mulg"] = 0,
				["$pp_colour_mulb"] = 1
			}
		
			DrawColorModify(human)
		end
	elseif LocalPlayer():Team() == TEAM_MUTANTS then
		if LocalPlayer().zvision then
			DrawColorModify(mutantz)
		else
			DrawColorModify(mutant)
		end
	end
end