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

local function GetCoordiantes(ent)
    local min, max = ent:OBBMins(), ent:OBBMaxs()
	
    local corners = {
        Vector(min.x, min.y,min.z),
        Vector(min.x, min.y, max.z),
		
        Vector(min.x, max.y, min.z),
        Vector(min.x, max.y, max.z),
		
        Vector(max.x, max.y, max.z),
        Vector(max.x, min.y, min.z),
		
        Vector(max.x, max.y, min.z),
        Vector(max.x, max.y, max.z)
    }

    local minx, miny, maxx, maxy = ScrW() * 2, ScrH() * 2, 0, 0
	
    for _,corner in pairs(corners) do
        local screen = ent:LocalToWorld(corner):ToScreen()
		
        minx, miny = math.min(minx, screen.x), math.min(miny, screen.y)
        maxx, maxy = math.max(maxx, screen.x), math.max(maxy, screen.y)
    end
	
    return minx, miny, maxx, maxy
end

local function drawLines(ent)
	local x1, y1, x2, y2 = GetCoordiantes(ent)
	local edgesize = 18
					
	surface.DrawLine(x1, y1, math.min(x1 + edgesize,x2), y1)
	surface.DrawLine(x1, y1, x1, math.min(y1 + edgesize, y2))

	surface.DrawLine(x2, y1, math.max(x2 - edgesize,x1), y1)
	surface.DrawLine(x2, y1, x2, math.min(y1 + edgesize, y2))

	surface.DrawLine(x1, y2, math.min(x1 + edgesize,x2), y2)
	surface.DrawLine(x1, y2, x1, math.max(y2 - edgesize, y1))
					
	surface.DrawLine(x2, y2, math.max(x2 - edgesize,x1), y2)
	surface.DrawLine(x2, y2, x2, math.max(y2 - edgesize, y1))
end
 
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
	
	if IsValid(wep) and LocalPlayer():Team() != 2 and LocalPlayer():Team() != TEAM_SPECTATOR then
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
	
	local time_minutes = GetGlobalInt("timetoend")
	local time_seconds = GetGlobalInt("timetoendsec")
	
	surface.DrawRect(sh / 25, sw / 2.15, sh / 2.5, sw / 12.5)
	
	draw.DrawText("HP", "mutanthero_font1", sh / 2.9, sw / 1.96, Color(255, 255, 255))
	draw.DrawText("B", "mutanthero_font1", sh / 2.9, sw / 2.12, Color(255, 255, 255))
	
	surface.SetDrawColor(Color(255, 0, 0))
	
	surface.DrawOutlinedRect((sh / 18) - 2, (sw / 1.94) - 2, (sw / 6.3) + 6, (sh / 30) + 4)
	surface.DrawRect((sh / 18) + 0.5, (sw / 1.94), (sw / (LocalPlayer():Health() / (LocalPlayer():GetMaxHealth() * 0.128))), sh / 30)
	
	surface.SetDrawColor(Color(0, 0, 255))
	
	surface.DrawOutlinedRect((sh / 18) - 2, (sw / 2.1) - 2, (sw / 6.3) + 6, (sh / 30) + 4)
	
	surface.SetDrawColor(Color(255, 0, 255))
	
	local tr = LocalPlayer():GetEyeTrace()
	
	if not tr.Entity:IsPlayer() then
		surface.DrawCircle((sw / 2) - 0.4, sh / 2, sh / 70, Color(255, 255, 255))
	elseif tr.Entity:IsPlayer() and tr.Entity:Team() != LocalPlayer():Team() then
		surface.DrawCircle((sw / 2) - 0.4, sh / 2, sh / 70, Color(255, 0, 0))
	elseif tr.Entity:IsPlayer() and tr.Entity:Team() == LocalPlayer():Team() then
		surface.DrawCircle((sw / 2) - 0.4, sh / 2, sh / 70, Color(0, 255, 0))
	end
	
	//------------------------------------------------------------lal-----------------\\
	
	if LocalPlayer():Team() == TEAM_MUTANTS then ---//mutant's hud
		for k, v in pairs(team.GetPlayers(1)) do
			local pos = (v:GetPos() + Vector(0, 0, 50)):ToScreen()
		
			surface.DrawCircle(pos.x, pos.y, sh / 170, Color(255, 0, 0))
		end
	end
	
	
	
	if LocalPlayer():Team() == TEAM_HUMANS then ---///human's helmet settings
		if zvision then
			for k, v in pairs(ents.FindInSphere(LocalPlayer():GetPos(), 1700)) do
				if v:IsPlayer() and v:Team() == TEAM_MUTANTS then
					local pos = (v:GetPos() + Vector(0, 0, 80)):ToScreen()
					
					draw.DrawText("UNKNOWN OBJECT!", "DefaultFixed", pos.x, pos.y, Color(255, 0, 0), TEXT_ALIGN_CENTER)
					
					surface.SetDrawColor(Color(255, 0, 0))
					drawLines(v)
				end
			end
		end
	
		surface.SetDrawColor(Color(0, 255, 0))
		surface.DrawRect((sh / 3.5) - 3, sw / 1.94, (sh / 18) + 1, sw / 52)
	
		surface.SetTexture(surface.GetTextureID("gui/center_gradient"))
		surface.SetDrawColor(Color(0, 0, 255))
		
		surface.DrawTexturedRectRotated(sw / 25, sh / 7, sw / 1.15, sh / 7, 2)
		surface.DrawTexturedRectRotated(sw / 1, sh / 7, sw / 1.15, sh / 7, -2)
	
		if tr.Entity:IsPlayer() then
			if tr.Entity:Team() == TEAM_MUTANTS then
				surface.SetDrawColor(Color(255, 0, 0))
				
				drawLines(tr.Entity)
			
				surface.DrawTexturedRectRotated(sw / 20, sh / 3.5, sw / 1.15, sh / 7, 2)
				draw3DText("WARNING! UNKNOWN OBJECT!", (sw / 20) + math.tan(CurTime() * 14) / 2, (sh / 4.2) + math.tan(CurTime() * 20) / 2, 1, 1, -2, "mutanthero_font3")
			elseif tr.Entity:Team() == TEAM_HUMANS then			
				surface.SetDrawColor(Color(0, 255, 0))
				
				surface.DrawTexturedRectRotated(sw / 20, sh / 3.5, sw / 1.15, sh / 7, 2)
			
				draw3DText(tr.Entity:Nick(), (sw / 20) + math.tan(CurTime() * 14) / 2, (sh / 4.4) + math.tan(CurTime() * 5) / 2, 1, 1, -2, "mutanthero_font3")
				draw3DText("Code name: " .. tr.Entity:UniqueID(), (sw / 20) + math.tan(CurTime() * 14) / 2, (sh / 4) + math.tan(CurTime() * 5) / 2, 1, 1, -2, "mutanthero_font3")
				draw3DText("Health: " .. tr.Entity:Health(), (sw / 20) + math.tan(CurTime() * 14) / 2, (sh / 3.6) + math.tan(CurTime() * 5) / 2, 1, 1, -2, "mutanthero_font3")
				draw3DText("Ally", (sw / 20) + math.tan(CurTime() * 14) / 2, (sh / 3.2) + math.tan(CurTime() * 5) / 2, 1, 1, -2, "mutanthero_font3")
			end
		end
	
		for k, v in pairs(ents.FindInSphere(LocalPlayer():GetPos(), 900)) do
			if v:IsPlayer() then
				if v:Team() == TEAM_MUTANTS then
					draw.SimpleText("", "mutanthero_font1", 5, 5, Color(255, 0, 0, 255), 1, 2)
					draw3DText("WARNING!!! Unknown objects in short radius!", (sw / 20) + math.tan(CurTime() * 14) / 2, (sh / 7) + math.tan(CurTime() * 20) / 2, 1, 1, -2, "mutanthero_font3")
					
					surface.SetDrawColor(Color(250, 50, 50, 80))
					surface.DrawTexturedRect(sw / 2.4, sh / 1.3, sw / 4.8, sh / 37)
					
					draw.DrawText("WARNING!!! Unknown objects in short radius!", "mutanthero_smallf", (sw / 2.4) + math.tan(CurTime() * 50) / 10, (sh / 1.3) + math.tan(CurTime() * 50) / 10, Color(0, 0, 0))
				end
				
				if v:Team() == TEAM_HUMANS then
					surface.SetDrawColor(Color(0, 255, 0))
					drawLines(v)
				end
			elseif v:GetClass() == "prop_physics" then
				surface.SetDrawColor(Color(0, 255, 255))
				drawLines(v)
			end
		end
	
		if LocalPlayer():Health() < 400 then
			surface.SetTexture(surface.GetTextureID("decals/blood6"))
			surface.DrawTexturedRect(sw / 10, sh / 6, sh / 3, sw / 3)
		end
		
		if LocalPlayer():Health() < 500 then
			surface.SetTexture(surface.GetTextureID("decals/blood2"))
			surface.DrawTexturedRect(sw / 1.3, sh / 5, sh / 3, sw / 4)
		end
	
		for k, v in pairs(team.GetPlayers(TEAM_HUMANS)) do
			if not IsValid(v) or not v:Alive() or not v:LookupBone("ValveBiped.Bip01_Head1") then return end
			local pos = (v:GetBonePosition(v:LookupBone("ValveBiped.Bip01_Head1")) + Vector(0, 0, 20)):ToScreen()
			if not pos then return end
		
			draw.DrawText(v:Nick(), "ChatFont", pos.x, pos.y, Color(0, 255, 0), TEXT_ALIGN_CENTER)
		end
	end
	
	if time_seconds >= 10 then
		//draw.DrawText(time_minutes .. ":" .. time_seconds, "mutanthero_font2", sh / 2.2, sw / 2.12, Color(255, 255, 255, 150))
		draw.SimpleText("", "mutanthero_font2", 5, 5, Color(255, 255, 255, 255), 1, 2)
		draw3DText("End in: " .. time_minutes .. ":" .. time_seconds, (sh / 0.8) + math.tan(CurTime()) / 2, (sw / 24) + math.tan(CurTime() * math.random(1, 5)) / 5, 1, 1, 2, "mutanthero_font2")
	else
		draw.SimpleText("", "mutanthero_font2", 5, 5, Color(255, 255, 255, 255), 1, 2)
		draw3DText("End in: " .. time_minutes .. ":0" .. time_seconds, (sh / 0.8) + math.tan(CurTime()) / 2, (sw / 24) + math.tan(CurTime() * math.random(1, 5)) / 5, 1, 1, 2, "mutanthero_font2")
	end
end
