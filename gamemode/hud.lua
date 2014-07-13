AddCSLuaFile()

surface.CreateFont("mutanthero_font1", {
	font = "Arial",
	size = ScrH() / 20,
	weight = 1500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = true,
})

surface.CreateFont("mutanthero_font2", {
	font = "Arial",
	size = ScrH() / 15,
	weight = 1500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = true,
})

surface.CreateFont("mutanthero_font3", {
	font = "Arial",
	size = ScrH() / 40,
	weight = 1500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	--shadow = true,
	additive = false,
	--outline = true,
})

surface.CreateFont("mutanthero_smallf", {
	font = "Arial",
	size = ScrH() / 50,
	weight = 1500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	--shadow = true,
	additive = false,
	--outline = true,
})

surface.CreateFont("mutanthero_verysmallf", {
	font = "Arial",
	size = ScrH() / 70,
	weight = 1500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	--shadow = true,
	additive = false,
	--outline = true,
})
 
local mat = Matrix()
local txtang = Angle(0, 0, 0)
local tra = Vector(0, 0, 0)
local scale = Vector(0, 0, 0)

local function draw3DText(txt, x, y, sx, sy, ang, font)
    txtang.y = ang
	
    mat:SetAngles(txtang)

    tra.x = x
    tra.y = y
	
    mat:SetTranslation(tra)
	
    scale.x = sx
    scale.y = sy
    mat:SetScale(scale)
	
    surface.SetTextPos(0, 0)
	surface.SetFont(font)
	
    cam.PushModelMatrix(mat)
	
    surface.DrawText(txt)
		
    cam.PopModelMatrix()
end

function GM:HUDPaint()
	if LocalPlayer():Team() == TEAM_SPECTATOR then return end
	if not LocalPlayer():Alive() then return end

	local sw = surface.ScreenWidth()--ScrW()
	local sh = surface.ScreenHeight()--ScrH()
	
	local wep = LocalPlayer():GetActiveWeapon()
	
	if IsValid(wep) and LocalPlayer():Team() != TEAM_MUTANTS then
		if wep:Clip1() >= 0 then
			surface.SetDrawColor(Color(50, 50, 50, 200))
		
			surface.DrawRect(sh * 1.3, sw / 2.2, sw / 1, sw / 1)
			
			surface.SetDrawColor(Color(0, 255, 0))
			
			surface.DrawRect(sh * 1.3, sw / 2.2, sw / 1, sh / 150)
			surface.DrawRect(sh * 1.3, sw / 2.2, sw / 250, sw / 1)
			
			draw.DrawText("Ammo", "mutanthero_font1", sh * 1.31, sw / 2.2, Color(150, 150, 150))
			draw.DrawText(wep:Clip1(), "mutanthero_font2", sh * 1.45, sw / 1.96, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
			draw.DrawText(LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()), "mutanthero_font2", sh * 1.7, sw / 1.96, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
		end
	end
	
	surface.SetDrawColor(Color(50, 50, 50, 200))
	
	surface.DrawRect(sh / 25, sw / 2.15, sh / 3.6, sw / 12.5)
	
	draw.DrawText(LocalPlayer():Health() .. " HP", "mutanthero_font1", sh / 18, sw / 1.96, Color(255, 255, 255))
	draw.DrawText(LocalPlayer():Armor() .. " Armor", "mutanthero_font1", sh / 18, sw / 2.12, Color(255, 255, 255))
	
	surface.DrawCircle((sw / 2) - 0.4, sh / 2, sh / 70, Color(255, 255, 255))
	
	//------------------------------------------------------------lal-----------------\\
	
	
	if LocalPlayer():Team() == TEAM_HUMANS then ---///human's helmet settings
		for k, v in pairs(ents.FindInSphere(LocalPlayer():GetPos(), 6000)) do
			if v:GetNWBool("isBeacon") then
				local pos = v:GetPos():ToScreen()
				
				surface.DrawCircle(pos.x, pos.y, math.abs(math.sin(CurTime() * 5) * 10), Color(0, 255, 0))
				
				for z, g in pairs(ents.FindInSphere(v:GetPos(), 2000)) do 
					if g:GetClass() == "ent_radio_muth" then
						local pos = g:GetPos():ToScreen() 
						surface.DrawCircle(pos.x, pos.y, math.abs(math.sin(CurTime() * 5) * 10), Color(0, 255, 255))
					end
				end
			end
		end
		
		surface.SetDrawColor(Color(0, 150, 0))
		surface.DrawRect(ScrW() / 13, 11, pnv_life * 6, 20)
		surface.DrawOutlinedRect(ScrW() / 13, 11, 120, 20)
		draw.DrawText("N.V.D Power:", "mutanthero_smallf", ScrW() / 150, 10, Color(0, 150, 0))
	
		surface.SetTexture(surface.GetTextureID("gui/center_gradient"))
		surface.SetDrawColor(Color(0, 0, 255))
		
		//surface.DrawTexturedRectRotated(sw / 25, sh / 7, sw / 1.15, sh / 7, 2)
		surface.DrawTexturedRectRotated(sw / 1, sh / 7, sw / 1.15, sh / 7, -2)
	
		if LocalPlayer():Health() < 400 then
			surface.SetTexture(surface.GetTextureID("decals/blood6"))
			surface.DrawTexturedRect(sw / 10, sh / 6, sh / 3, sw / 3)
		end
		
		if LocalPlayer():Health() < 500 then
			surface.SetTexture(surface.GetTextureID("decals/blood2"))
			surface.DrawTexturedRect(sw / 1.3, sh / 5, sh / 3, sw / 4)
		end
	end
	
	local ent = LocalPlayer():GetEyeTrace().Entity
	
	if ent:GetNWBool("is_pointshop") and ent:GetPos():Distance(LocalPlayer():GetPos()) <= 200 then
		local pos = ent:GetPos():ToScreen()
		
		draw.DrawText("[E]\nHP: " .. ent:Health(), "mutanthero_font2", pos.x, pos.y, Color(255, 255, 255), TEXT_ALIGN_CENTER)
	end
	
	if ent:IsPlayer() and ent:Team() == LocalPlayer():Team() then
		local pos = (ent:GetPos() + Vector(0, 0, 40)):ToScreen()
	
		draw.DrawText(ent:Nick(), "mutanthero_smallf", pos.x, pos.y, Color(255, 255, 255), TEXT_ALIGN_CENTER)
	end
	
	if ent:GetClass() == "ent_radio_muth" and ent:GetPos():Distance(LocalPlayer():GetPos()) <= 200 then
		local pos = ent:GetPos():ToScreen()
		
		draw.DrawText("Hold [E]", "mutanthero_font2", pos.x, pos.y, Color(255, 255, 255), TEXT_ALIGN_CENTER)
	end
	
	
	surface.SetTextColor(Color(0, 255, 255))
	if not GetGlobalBool("round_started") and not GetGlobalBool("radio_clk") then
		draw3DText("Start in: " .. GetGlobalInt("timetostart"), (sh / 0.8) + math.tan(CurTime()) / 2, (sw / 24) + math.tan(CurTime() * math.random(1, 5)) / 5, 1, 1, 2, "mutanthero_font2")
	end
	
	if GetGlobalBool("radio_clk") then
		draw3DText("End in: " .. GetGlobalInt("timetoendsec"), (sh / 0.8) + math.tan(CurTime()) / 2, (sw / 24) + math.tan(CurTime() * math.random(1, 5)) / 5, 1, 1, 2, "mutanthero_font2")
		
		local pos = GetGlobalVector("evacuation_zone")
		if not pos then pos = Vector(0, 0, 0) end
		pos = pos:ToScreen()
			
		surface.DrawCircle(pos.x, pos.y, math.abs(math.sin(CurTime() * 5) * 10), Color(255, 0, 0))
		draw.DrawText("EVACUATION ZONE", "DefaultFixed", pos.x, pos.y, Color(255, 0, 0), TEXT_ALIGN_CENTER)
	end
end
