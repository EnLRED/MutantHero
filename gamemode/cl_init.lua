include("shared.lua")

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

local hud = { "CHudHealth", "CHudBattery", "CHudSecondaryAmmo", "CHudAmmo", "CHudVoiceStatus", "NetGraph", "CHudCrosshair" }

local Current = 1
local Current2 = 1

function GM:HUDShouldDraw(name)
	for k, v in pairs(hud) do
		if v == name then return false end
	end
	
	return true
end

function GM:SpawnMenuEnabled()
	return false
end

function GM:SpawnMenuOpen()
	return false
end

local wind = nil

/////set up points////
local points = 125
//////////////////////
local boots = 500

local function Weapon(wep, cost)
	net.Start("check_wep")
		net.WriteString(wep)
		net.WriteEntity(LocalPlayer())
	net.SendToServer()
	
	RunConsoleCommand("check_wep_shop")
	
	net.Receive("check_wep_ready", function()
		if net.ReadString() != "[NULL Entity]" then return end
		
		if points <= 0 then return end
			
		if points < cost then return end
			
		points = points - cost
			
		net.Start("pointshop_wepname")
			net.WriteString(wep)
			net.WriteEntity(LocalPlayer())
		net.SendToServer()
			
		RunConsoleCommand("givewep_shop")
	end)
	
	surface.PlaySound("UI/hint.wav")
end

local function Ammo(typea, num, cost)
	if points <= 0 then return end
			
	if points < cost then return end
			
	points = points - cost
			
	net.Start("pointshop_ammoname")
		net.WriteString(typea)
		net.WriteInt(num, 32)
		net.WriteEntity(LocalPlayer())
	net.SendToServer()
	
	RunConsoleCommand("giveammo_shop")
	
	surface.PlaySound("UI/hint.wav")
end

local function PointShop()
	--if GetGlobalBool("round_started") then LocalPlayer():ChatPrint("Round has already started! You can't use pointshop!") return end

	wind = vgui.Create("DFrame")
	wind:SetTitle("")
	wind:SetSize(400, 500)
	wind:Center()
	wind:SetDraggable(false)
	wind:ShowCloseButton(true)
	wind:MakePopup()
	wind.Paint = function()
		if wind and IsValid(wind) and wind:IsActive() then
			draw.RoundedBox(16, 0, 0, wind:GetWide(), wind:GetTall(), Color(0, 0, 0, 250))
			draw.RoundedBox(16, 7.5, 7.5, wind:GetWide() - 15, wind:GetTall() - 15, Color(150, 150, 120, 255))
		end
	end
	
	local labp = vgui.Create("DLabel", wind)
	labp:SetPos(200, 420)
	timer.Simple(0.01, function()
		labp:SetText("Points: " .. points .. "$")
	end)
	labp:SetFont("mutanthero_font3")
	labp:SetSize(350, 100)
	
	local lab = vgui.Create("DLabel", wind)
	lab:SetPos(230, 20)
	lab:SetText("<- Select type")
	lab:SetFont("mutanthero_font3")
	lab:SetSize(350, 30)
	
	local po = vgui.Create("DTextEntry", wind)
	po:SetPos(20, 420)
	po:SetText("Set points (Admin function)")
	po:SetSize(350, 25)
	
	local ava = vgui.Create("AvatarImage", wind)
	ava:SetPos(20, 350)
	ava:SetPlayer(LocalPlayer())
	ava:SetSize(64, 64)
	
	local givep = vgui.Create("DButton", wind)
	givep:SetText("Set points")
	givep:SetPos(20, 460)
	givep:SetSize(60, 20)
	givep.DoClick = function()
		if not LocalPlayer():IsSuperAdmin() then LocalPlayer():ChatPrint("You must be admin!") return end
		if not tonumber(po:GetValue()) then LocalPlayer():ChatPrint("Type num") return end
		
		points = tonumber(po:GetValue())

		timer.Simple(0.01, function() labp:SetText("Points: " .. points .. "$") end)
	end
	
	//set up pointshop things ->
	local crowbar, ak, obs, ammoqg, defg, hookw, predator, ammop, skyhawk, ammosh, speed, hp, ammor, famas, mp5, boot, fuel
	
	local listshop = vgui.Create("DComboBox", wind)
	listshop:SetPos(20, 20)
	listshop:SetSize(200, 30)
	listshop:SetValue("Menu")
	listshop:AddChoice("Weapons")
	listshop:AddChoice("Melee Weapons")
	listshop:AddChoice("Ammo")
	listshop:AddChoice("Abilities")
	listshop.OnSelect = function( panel, index, value )
		if index == 1 then		
			--timer.Simple(0.01, function()
				if ak and obs and defg and predator and skyhawk and famas and mp5 and flamt then
					ak:Remove()
					obs:Remove()
					defg:Remove()
					predator:Remove()
					skyhawk:Remove()
					famas:Remove()
					mp5:Remove()
					flamt:Remove()
				end
			--end)
		
			ak = vgui.Create("DButton", wind)
			ak:SetText("Buy AK47    COST: 35")
			ak:SetPos(50, 60)
			ak:SetSize(300, 20)
			ak.DoClick = function()
				Weapon("weapon_muth_ak47", 35)
				timer.Simple(0.01, function() labp:SetText("Points: " .. points .. "$") end)
			end
			
			obs = vgui.Create("DButton", wind)
			obs:SetText("Buy ORBITAL STRIKE (ONE SHOT)    COST: 60")
			obs:SetPos(50, 80)
			obs:SetSize(300, 20)
			obs.DoClick = function()
				Weapon("weapon_muth_obs", 60)
				timer.Simple(0.01, function() labp:SetText("Points: " .. points .. "$") end)
			end
			
			defg = vgui.Create("DButton", wind)
			defg:SetText("Buy Quick Gun    COST: 30")
			defg:SetPos(50, 100)
			defg:SetSize(300, 20)
			defg.DoClick = function()
				Weapon("weapon_laser_gm", 30)
				timer.Simple(0.01, function() labp:SetText("Points: " .. points .. "$") end)
			end
			
			predator = vgui.Create("DButton", wind)
			predator:SetText("Buy Predator Pistol    COST: 25")
			predator:SetPos(50, 120)
			predator:SetSize(300, 20)
			predator.DoClick = function()
				Weapon("weapon_muth_predator", 25)
				timer.Simple(0.01, function() labp:SetText("Points: " .. points .. "$") end)
			end
			
			skyhawk = vgui.Create("DButton", wind)
			skyhawk:SetText("Buy SkyHawk    COST: 45")
			skyhawk:SetPos(50, 140)
			skyhawk:SetSize(300, 20)
			skyhawk.DoClick = function()
				Weapon("weapon_muth_skyhawk", 45)
				timer.Simple(0.01, function() labp:SetText("Points: " .. points .. "$") end)
			end
			
			famas = vgui.Create("DButton", wind)
			famas:SetText("Buy Famas    COST: 25")
			famas:SetPos(50, 160)
			famas:SetSize(300, 20)
			famas.DoClick = function()
				Weapon("weapon_muth_famas", 25)
				timer.Simple(0.01, function() labp:SetText("Points: " .. points .. "$") end)
			end
			
			mp5 = vgui.Create("DButton", wind)
			mp5:SetText("Buy MP5    COST: 25")
			mp5:SetPos(50, 180)
			mp5:SetSize(300, 20)
			mp5.DoClick = function()
				Weapon("weapon_muth_mp5", 25)
				timer.Simple(0.01, function() labp:SetText("Points: " .. points .. "$") end)
			end
			
			flamt = vgui.Create("DButton", wind)
			flamt:SetText("Buy Flamethrower    COST: 35")
			flamt:SetPos(50, 200)
			flamt:SetSize(300, 20)
			flamt.DoClick = function()
				Weapon("weapon_muth_flamethrower", 35)
				timer.Simple(0.01, function() labp:SetText("Points: " .. points .. "$") end)
			end
		else
			timer.Simple(0.01, function()
				if ak and obs and defg and predator and skyhawk and famas and mp5 and flamt then
					ak:Remove()
					obs:Remove()
					defg:Remove()
					predator:Remove()
					skyhawk:Remove()
					famas:Remove()
					mp5:Remove()
					flamt:Remove()
				end
			end)
		end
		
		if index == 2 then
			--timer.Simple(0.01, function()
				if crowbar and hookw then
					crowbar:Remove()
					hookw:Remove()
				end
			--end)
		
			crowbar = vgui.Create("DButton", wind)
			crowbar:SetText("Buy crowbar    COST: 1")
			crowbar:SetPos(50, 60)
			crowbar:SetSize(300, 20)
			crowbar.DoClick = function()
				Weapon("weapon_crowbar", 1)
				timer.Simple(0.01, function() labp:SetText("Points: " .. points .. "$") end)
			end
			
			hookw = vgui.Create("DButton", wind)
			hookw:SetText("Buy hook    COST: 10")
			hookw:SetPos(50, 80)
			hookw:SetSize(300, 20)
			hookw.DoClick = function()
				Weapon("weapon_hook_muth", 10)
				timer.Simple(0.01, function() labp:SetText("Points: " .. points .. "$") end)
			end
		else
			timer.Simple(0.01, function()
				if crowbar and hookw then
					crowbar:Remove()
					hookw:Remove()
				end
			end)
		end
		
		if index == 3 then
			--timer.Simple(0.01, function()
				if ammoqg and ammop and ammosh and ammor and fuel then
					ammor:Remove()
					ammoqg:Remove()
					ammop:Remove()
					ammosh:Remove()
					fuel:Remove()
				end
			--end)
		
			ammoqg = vgui.Create("DButton", wind)
			ammoqg:SetText("Buy Quick Gun ammo    COST: 10")
			ammoqg:SetPos(50, 60)
			ammoqg:SetSize(300, 20)
			ammoqg.DoClick = function()
				Ammo("357", 60, 10)
				timer.Simple(0.01, function() labp:SetText("Points: " .. points .. "$") end)
			end
			
			ammop = vgui.Create("DButton", wind)
			ammop:SetText("Buy Predator ammo    COST: 5")
			ammop:SetPos(50, 80)
			ammop:SetSize(300, 20)
			ammop.DoClick = function()
				Ammo("pistol", 50, 10)
				timer.Simple(0.01, function() labp:SetText("Points: " .. points .. "$") end)
			end
			
			ammosh = vgui.Create("DButton", wind)
			ammosh:SetText("Buy SkyHawk ammo    COST: 10")
			ammosh:SetPos(50, 100)
			ammosh:SetSize(300, 20)
			ammosh.DoClick = function()
				Ammo("ar2", 5, 10)
				timer.Simple(0.01, function() labp:SetText("Points: " .. points .. "$") end)
			end
			
			ammor = vgui.Create("DButton", wind)
			ammor:SetText("Buy rifle ammo    COST: 5")
			ammor:SetPos(50, 120)
			ammor:SetSize(300, 20)
			ammor.DoClick = function()
				Ammo("smg1", 30, 5)
				timer.Simple(0.01, function() labp:SetText("Points: " .. points .. "$") end)
			end
			
			fuel = vgui.Create("DButton", wind)
			fuel:SetText("Buy +50 rocket boots fuel    COST: 10")
			fuel:SetPos(50, 140)
			fuel:SetSize(300, 20)
			fuel.DoClick = function()
				if not LocalPlayer():GetNetworkedBool("boots") then LocalPlayer():ChatPrint("You don't have rocket boots!") return end
				if points <= 0 then return end
				local cost = 10
				if points < cost then return end
				
				points = points - cost
				
				boots = boots + 50
				
				surface.PlaySound("UI/hint.wav")
				timer.Simple(0.01, function() labp:SetText("Points: " .. points .. "$") end)
			end
		else
			timer.Simple(0.01, function()
				if ammoqg and ammop and ammosh and ammor and fuel then
					ammor:Remove()
					ammoqg:Remove()
					ammop:Remove()
					ammosh:Remove()
					fuel:Remove()
				end
			end)
		end
		
		if index == 4 then
			--timer.Simple(0.01, function()
				if speed and hp and boot then
					hp:Remove()
					speed:Remove()
					boot:Remove()
				end
			--end)
		
			speed = vgui.Create("DButton", wind)
			speed:SetText("Buy +50 speed bonus    COST: 15")
			speed:SetPos(50, 60)
			speed:SetSize(300, 20)
			speed.DoClick = function()
				if LocalPlayer():GetWalkSpeed() >= 400 then LocalPlayer():ChatPrint("You have maximum of speed!") return end
				if points <= 0 then return end
				local cost = 15
				if points < cost then return end
				
				points = points - cost
						
				net.Start("pointshop_speed")
					net.WriteEntity(LocalPlayer())
				net.SendToServer()
				
				RunConsoleCommand("givespeed_shop")
				
				surface.PlaySound("UI/hint.wav")
				timer.Simple(0.01, function() labp:SetText("Points: " .. points .. "$") end)
			end
			
			hp = vgui.Create("DButton", wind)
			hp:SetText("Buy +200 health bonus    COST: 25")
			hp:SetPos(50, 80)
			hp:SetSize(300, 20)
			hp.DoClick = function()
				if LocalPlayer():Health() >= 1000 then LocalPlayer():ChatPrint("You have maximum of health!") return end
				if points <= 0 then return end
				local cost = 20
				if points < cost then return end
				
				points = points - cost
						
				net.Start("pointshop_hp")
					net.WriteEntity(LocalPlayer())
				net.SendToServer()
				
				RunConsoleCommand("givehp_shop")
				
				surface.PlaySound("UI/hint.wav")
				timer.Simple(0.01, function() labp:SetText("Points: " .. points .. "$") end)
			end
			
			boot = vgui.Create("DButton", wind)
			boot:SetText("Buy Rocket boots bonus    COST: 35")
			boot:SetPos(50, 100)
			boot:SetSize(300, 20)
			boot.DoClick = function()
				if LocalPlayer():GetNetworkedBool("boots") then return end
				if points <= 0 then return end
				local cost = 35
				if points < cost then return end
				
				points = points - cost
				
				net.Start("pointshop_boots")
					net.WriteEntity(LocalPlayer())
					net.WriteInt(1, 32)
				net.SendToServer()
				
				boots = 500
				
				RunConsoleCommand("giveboots_shop")
				
				surface.PlaySound("UI/hint.wav")
				timer.Simple(0.01, function() labp:SetText("Points: " .. points .. "$") end)
			end
		else
			timer.Simple(0.01, function()
				if speed and hp and boot then
					hp:Remove()
					speed:Remove()
					boot:Remove()
				end
			end)
		end
	end
end

concommand.Add("open_pointshop", PointShop)

//set up standart abilities
local invisible = false
local offinvisible = false
local zvision = false
local nightvision = false
local offzvis = false
////////////////////////////

function GM:Think()
	if LocalPlayer():KeyDown(IN_JUMP) and LocalPlayer():GetNetworkedBool("boots") then
		boots = boots - 1
	end
	
	if GetGlobalBool("round_started") and wind and IsValid(wind) and wind:IsActive() then wind:SetVisible(false) end
	
	if boots <= 0 then
		net.Start("pointshop_boots")
			net.WriteEntity(LocalPlayer())
			net.WriteInt(0, 32)
		net.SendToServer()
				
		RunConsoleCommand("giveboots_shop")
		
		boots = 500
	end

	if not LocalPlayer():Alive() then invisible = false offinvisible = false nightvision = false points = 125 end
	if (not LocalPlayer():Alive() or LocalPlayer():Team() == 2) and wind and IsValid(wind) and wind:IsActive() then wind:SetVisible(false) end
	
	if LocalPlayer():Team() == 1 then invisible = false end
	if LocalPlayer():Team() == 2 then nightvision = false end
	
	if nightvision then
		local light = DynamicLight(LocalPlayer():EntIndex())
			
		light.Pos = LocalPlayer():GetBonePosition(LocalPlayer():LookupBone("ValveBiped.Bip01_Head1"))
		light.r = 0
		light.g = 255
		light.b = 0
		light.Brightness = 1
		light.Size = 3000
		light.Decay = 0
		light.DieTime = CurTime() + 0.1 
	end
	
	if invisible then
		local light = DynamicLight(LocalPlayer():EntIndex())
			
		light.Pos = LocalPlayer():GetPos()
		light.r = 255
		light.g = 255
		light.b = 255
		light.Brightness = 1
		light.Size = 1000
		light.Decay = 0
		light.DieTime = CurTime() + 0.1 
	end
	
	if nightvision and LocalPlayer():HelmetBroken() then nightvision = false end
	if zvision and LocalPlayer():HelmetBroken() then zvision = false end
end

function GM:KeyPress(ply, key)
	if key == IN_USE and LocalPlayer():Team() == 1 and not LocalPlayer():HelmetBroken() and not zvision then
		if not nightvision then nightvision = true else nightvision = false end
		LocalPlayer():EmitSound("buttons/button1.wav", 100, 150)
	end
	
	if key == IN_ZOOM and LocalPlayer():Team() == 1 and not LocalPlayer():HelmetBroken() then
		if zvision then return end
		if offzvis then return end
		
		if not zvision then zvision = true else zvision = false end
		if nightvision then nightvision = false end
		LocalPlayer():EmitSound("buttons/button1.wav", 100, 150)
		
		timer.Simple(10, function()
			if not LocalPlayer():Alive() then return end
			offzvis = true
			
			timer.Simple(30, function()
				if not LocalPlayer():Alive() then return end
				offzvis = false
			end)
			
			zvision = false
		end)
	end
	
	
	if key == IN_USE and LocalPlayer():Team() == 2 and not LocalPlayer():GetNetworkedBool("invisiblem") then
		if invisible then return end
		if offinvisible then return end
		
		invisible = true
		
		timer.Simple(30, function()
			offinvisible = true
			
			timer.Simple(30, function()
				if not LocalPlayer():Alive() then return end
				offinvisible = false
			end)
			
			invisible = false
			
			net.Start("invisible")
				net.WriteInt(0, 32)
				net.WriteEntity(LocalPlayer())
			net.SendToServer()
			
			RunConsoleCommand("invisible_mut")
		end)
		
		net.Start("invisible")
			if invisible then net.WriteInt(1, 32) else net.WriteInt(0, 32) end
			net.WriteEntity(LocalPlayer())
		net.SendToServer()
		
		RunConsoleCommand("invisible_mut")
	end
end

local ef =
{
	["$pp_colour_addr"] = 0.4,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = -0.15,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 0.2,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0	
}

local ef2inv =
{
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 0,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0	
}

local ef3 =
{
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0.6,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = -0.5,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0	
}

local ef4 =
{
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 0,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 2,
	["$pp_colour_mulb"] = 0	
}

function GM:RenderScreenspaceEffects()
	if LocalPlayer():Team() == 2 and not invisible then
		DrawColorModify(ef)
	end
	
	if invisible then
		DrawColorModify(ef2inv)
	end
	
	if LocalPlayer():Team() == 1 then
		--DrawColorModify(ef2)
		--DrawMotionBlur(0.5, 0.4, 0.04)
	end
	
	if nightvision then
		DrawColorModify(ef3)
	end
	
	if zvision then
		DrawColorModify(ef4)
	end
	
	if LocalPlayer():HelmetBroken() and LocalPlayer():Team() == 1 then
		DrawMotionBlur(55, 0.5, 0.04)
	end
end

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
	if LocalPlayer():Team() == TEAM_SPECTATOR then return false end

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
	
	local time = GetGlobalString("timetoend")
	local SECONDS_ROUND_SETTIME = GetGlobalString("timetoendsec")
	
	surface.DrawRect(sh / 25, sw / 2.15, sh / 2.5, sw / 12.5)
	
	draw.DrawText("HP", "mutanthero_font1", sh / 2.9, sw / 1.96, Color(255, 255, 255))
	draw.DrawText("B", "mutanthero_font1", sh / 2.9, sw / 2.12, Color(255, 255, 255))
	
	if LocalPlayer():Team() == 2 then
		Current = math.Approach(Current, LocalPlayer():Health() / 10500, 1)
	elseif LocalPlayer():Team() == 1 then
		Current = math.Approach(Current, LocalPlayer():Health() / 3000, 1)
	end
	
	Current2 = math.Approach(Current2, LocalPlayer():Armor() / 600, 1)
	
	surface.SetDrawColor(Color(255, 0, 0))
	
	surface.DrawOutlinedRect((sh / 18) - 2, (sw / 1.94) - 2, (sw / 6.3) + 6, (sh / 30) + 4)
	surface.DrawRect(sh / 18, sw / 1.94, (sw - 1000) * Current, sw / 52)
	
	surface.SetDrawColor(Color(0, 0, 255))
	
	surface.DrawOutlinedRect((sh / 18) - 2, (sw / 2.1) - 2, (sw / 6.3) + 6, (sh / 30) + 4)
	surface.DrawRect(sh / 18, sw / 2.1, (sw - 1000) * Current2, sw / 52)
	
	surface.SetDrawColor(Color(255, 0, 255))
	
	local tr = LocalPlayer():GetEyeTrace()
	
	if not tr.Entity:IsPlayer() then
		surface.DrawCircle((sw / 2) - 0.4, sh / 2, sh / 70, Color(255, 255, 255))
	elseif tr.Entity:IsPlayer() and tr.Entity:Team() != LocalPlayer():Team() then
		surface.DrawCircle((sw / 2) - 0.4, sh / 2, sh / 70, Color(255, 0, 0))
	elseif tr.Entity:IsPlayer() and tr.Entity:Team() == LocalPlayer():Team() then
		surface.DrawCircle((sw / 2) - 0.4, sh / 2, sh / 70, Color(0, 255, 0))
	end
	
	if LocalPlayer():Team() == 2 then ---//mutant's hud
		for k, v in pairs(team.GetPlayers(1)) do
			local pos = (v:GetPos() + Vector(0, 0, 50)):ToScreen()
		
			surface.DrawCircle(pos.x, pos.y, sh / 170, Color(255, 0, 0))
		end
	end
	
	if LocalPlayer():Team() == 1 then ---///human's helmet settings
		if zvision then
			for k, v in pairs(ents.FindInSphere(LocalPlayer():GetPos(), 1700)) do
				if v:IsPlayer() and v:Team() == 2 then
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
	
		if tr.Entity:IsPlayer() and not LocalPlayer():HelmetBroken() then
			if tr.Entity:Team() == 2 then
				surface.SetDrawColor(Color(255, 0, 0))
				
				drawLines(tr.Entity)
			
				surface.DrawTexturedRectRotated(sw / 20, sh / 3.5, sw / 1.15, sh / 7, 2)
				draw3DText("WARNING! UNKNOWN OBJECT!", (sw / 20) + math.tan(CurTime() * 14) / 2, (sh / 4.2) + math.tan(CurTime() * 20) / 2, 1, 1, -2, "mutanthero_font3")
			elseif tr.Entity:Team() == 1 then			
				surface.SetDrawColor(Color(0, 255, 0))
				
				surface.DrawTexturedRectRotated(sw / 20, sh / 3.5, sw / 1.15, sh / 7, 2)
			
				draw3DText(tr.Entity:Nick(), (sw / 20) + math.tan(CurTime() * 14) / 2, (sh / 4.4) + math.tan(CurTime() * 15) / 2, 1, 1, -2, "mutanthero_font3")
				draw3DText("Code name: " .. tr.Entity:UniqueID(), (sw / 20) + math.tan(CurTime() * 14) / 2, (sh / 4) + math.tan(CurTime() * 20) / 2, 1, 1, -2, "mutanthero_font3")
				draw3DText("Costume health scanner: " .. tr.Entity:Health(), (sw / 20) + math.tan(CurTime() * 14) / 2, (sh / 3.6) + math.tan(CurTime() * 15) / 2, 1, 1, -2, "mutanthero_font3")
				draw3DText("Ally", (sw / 20) + math.tan(CurTime() * 14) / 2, (sh / 3.2) + math.tan(CurTime() * 20) / 2, 1, 1, -2, "mutanthero_font3")
			end
		end
	
		for k, v in pairs(ents.FindInSphere(LocalPlayer():GetPos(), 900)) do
			if v:IsPlayer() then
				if v:Team() == 2 and not LocalPlayer():HelmetBroken() then
					draw.SimpleText("", "mutanthero_font1", 5, 5, Color(255, 0, 0, 255), 1, 2)
					draw3DText("WARNING!!! Unknown objects in short radius!", (sw / 20) + math.tan(CurTime() * 14) / 2, (sh / 7) + math.tan(CurTime() * 20) / 2, 1, 1, -2, "mutanthero_font3")
					
					surface.SetDrawColor(Color(250, 50, 50, 80))
					surface.DrawTexturedRect(sw / 2.4, sh / 1.3, sw / 4.8, sh / 37)
					
					draw.DrawText("WARNING!!! Unknown objects in short radius!", "mutanthero_smallf", (sw / 2.4) + math.tan(CurTime() * 50) / 10, (sh / 1.3) + math.tan(CurTime() * 50) / 10, Color(0, 0, 0))
				end
				
				if v:Team() == 1 then
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
	
		if not LocalPlayer():HelmetBroken() then
			draw.SimpleText("", "mutanthero_font1", 5, 5, Color(255, 255, 255, 255), 1, 2)
			draw3DText("Helmet system status: OK", (sw / 20) + math.tan(CurTime() * math.random(-2, 2)) / 2, (sh / 10) + math.tan(CurTime() * math.random(-2, 2)) / 2, 1, 1, -2, "mutanthero_font1")
		else
			surface.SetTexture(surface.GetTextureID("decals/blood6"))
			surface.DrawTexturedRect(sw / 4, sh / 3, sh / 5, sw / 5)
			
			surface.SetTexture(surface.GetTextureID("decals/blood3"))
			surface.DrawTexturedRect(sw / 2, sh / 2, sh / 3, sw / 3)
		
			draw.SimpleText("", "mutanthero_font1", 5, 5, Color(255, 0, 0, 255), 1, 2)
			draw3DText("Helmet system status: BAD", (sw / 20) + math.tan(CurTime() * math.random(-2, 2)) / 2, (sh / 10) + math.tan(CurTime() * math.random(-2, 2)) / 2, 1, 1, -2, "mutanthero_font1")
			draw.SimpleText("", "mutanthero_font1", 5, 5, Color(255, 0, 0, 255), 1, 2)
			draw3DText("Nightvision is broken!", (sw / 2) + math.tan(CurTime() * math.random(-2, 2)) / 2, (sh / 10) + math.tan(CurTime() * math.random(-2, 2)) / 2, 1, 1, 3, "mutanthero_font1")
		end
	
		for k, v in pairs(team.GetPlayers(1)) do
			local pos = (v:GetBonePosition(v:LookupBone("ValveBiped.Bip01_Head1")) + Vector(0, 0, 20)):ToScreen()
		
			if v != LocalPlayer() and not LocalPlayer():HelmetBroken() then
				draw.DrawText(v:Nick(), "ChatFont", pos.x, pos.y, Color(0, 255, 0), TEXT_ALIGN_CENTER)
			end
		end
	end
	
	if tonumber(SECONDS_ROUND_SETTIME) >= 10 then
		--draw.DrawText(time .. ":" .. tonumber(SECONDS_ROUND_SETTIME), "mutanthero_font2", sh / 2.2, sw / 2.12, Color(255, 255, 255, 150))
		draw.SimpleText("", "mutanthero_font2", 5, 5, Color(255, 255, 255, 255), 1, 2)
		draw3DText("End in: " .. time .. ":" .. tonumber(SECONDS_ROUND_SETTIME), (sh / 0.8) + math.tan(CurTime()) / 2, (sw / 24) + math.tan(CurTime() * math.random(1, 5)) / 5, 1, 1, 2, "mutanthero_font2")
	else
		draw.SimpleText("", "mutanthero_font2", 5, 5, Color(255, 255, 255, 255), 1, 2)
		draw3DText("End in: " .. time .. ":0" .. tonumber(SECONDS_ROUND_SETTIME), (sh / 0.8) + math.tan(CurTime()) / 2, (sw / 24) + math.tan(CurTime() * math.random(1, 5)) / 5, 1, 1, 2, "mutanthero_font2")
	end
end
























