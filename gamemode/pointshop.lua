AddCSLuaFile()

-- F3 pointshop

local ammo = {
	[1] = { ClassName = "pistol", PrintName = "Pistol", Cost = 10, WorldModel = "models/Items/BoxSRounds.mdl", IsAmmo = true, Num = 25 },
	[2] = { ClassName = "smg1", PrintName = "SMG1", Cost = 10, WorldModel = "models/Items/BoxMRounds.mdl", IsAmmo = true, Num = 35 },
	[3] = { ClassName = "357", PrintName = "357", Cost = 10, WorldModel = "models/Items/357ammobox.mdl", IsAmmo = true, Num = 25 },
	[4] = { ClassName = "ar2", PrintName = "AR2", Cost = 10, WorldModel = "models/Items/BoxMRounds.mdl", IsAmmo = true, Num = 15 },
	[5] = { ClassName = "buckshot", PrintName = "Shotgun", Cost = 10, WorldModel = "models/Items/BoxBuckshot.mdl", IsAmmo = true, Num = 5 }
}

local function open_Shop()
	local weps = weapons.GetList()
	local tobuy
	//local abilities = {}

	local win = vgui.Create("DFrame")
	win:SetSize(420, 450)
	win:ShowCloseButton(false)
	win:SetTitle(" ")
	win:Center()
	win.Paint = function()
		local w = win:GetWide()
		local t = win:GetTall()
					
		draw.RoundedBox(0, 0, 0, w, t, Color(0, 0, 0, 170))
		draw.RoundedBox(0, 10, 10, w - 20, t - 20, Color(100, 100, 100, 200))
	end
	win.Think = function()
		if GetGlobalBool("round_started") and win and IsValid(win) then win:Close() end
	end
	win:MakePopup()
	
	local close = vgui.Create("DButton", win)
	close:SetPos(50, 25)
	close:SetSize(320, 20)
	close:SetText("Close")
	close.DoClick = function() if win and IsValid(win) then win:Close() end end
	
	local weps_t = vgui.Create("DListView", win)
	weps_t:SetPos(15, 50)
	weps_t:SetSize(130, 360)
	weps_t:AddColumn("Weapon")
	local cost = weps_t:AddColumn("Cost")
	cost:SetMinWidth(30)
	cost:SetMaxWidth(30)
	weps_t.OnClickLine = function(parent, line, isselected)
		surface.PlaySound("buttons/blip1.wav")
	
		for k, v in pairs(weps) do
			if line:GetValue(1) == v.PrintName then tobuy = v end
		end
		
		for k, v in pairs(ammo) do
			if line:GetValue(1) == v.PrintName then tobuy = v end
		end
	end
	
	for k, v in pairs(weps) do
		if v.Cost then weps_t:AddLine(v.PrintName, v.Cost) end
	end
	
	local ammo_t = vgui.Create("DListView", win)
	ammo_t:SetPos(155, 50)
	ammo_t:SetSize(130, 360)
	ammo_t:AddColumn("Ammo")
	local cost = ammo_t:AddColumn("Cost")
	cost:SetMinWidth(30)
	cost:SetMaxWidth(30)
	ammo_t.OnClickLine = function(parent, line, isselected)
		surface.PlaySound("buttons/blip1.wav")
	
		for k, v in pairs(weps) do
			if line:GetValue(1) == v.PrintName then tobuy = v end
		end
		
		for k, v in pairs(ammo) do
			if line:GetValue(1) == v.PrintName then tobuy = v end
		end
	end
	
	for k, v in pairs(ammo) do
		ammo_t:AddLine(v.PrintName, v.Cost)
	end
	
	local buy = vgui.Create("DButton", win)
	buy:SetPos(15, 415)
	buy:SetSize(270, 20)
	buy:SetText("Buy")
	buy.DoClick = function()
		if tobuy then
			if LocalPlayer():GetMoney() >= tobuy.Cost then
				local amm = false
				local num = 0
				if tobuy.IsAmmo then amm = true num = tobuy.Num end
			
				net.Start("pointshop_toserv")
					net.WriteFloat(tobuy.Cost)
					net.WriteBit(amm)
					net.WriteString(tobuy.ClassName)
					net.WriteFloat(num)
				net.SendToServer()
				
				local NO_ACCES = false

				net.Receive("froms_toclient_check", function()
					local str = net.ReadString()
					
					if str != "[NULL Entity]" then NO_ACCES = true end
				end)
				
				timer.Simple(0.01, function()
					if NO_ACCES then return end
					
					surface.PlaySound("buttons/bell1.wav")
					
					local lab = vgui.Create("DLabel", win)
					lab:SetPos(290, 380)
					lab:SetFont("mutanthero_font1")
					lab:SetText("-" .. tobuy.Cost .. "$")
					lab.Think = function()
						lab:SetAlpha(lab:GetAlpha() - 2)
						local x, y = lab:GetPos()
						lab:SetPos(x, y - 0.3)
						lab:SizeToContents()
						
						if lab:GetAlpha() <= 1 then lab:Remove() end
					end
					
					local lab = vgui.Create("DLabel")
					lab:SetPos(ScrW() / 11, ScrH() / 1.3)
					lab:SetFont("mutanthero_font1")
					local isam = ""
					if tobuy.IsAmmo then isam = " ammo" end
					lab:SetText("+" .. tobuy.PrintName .. isam)
					lab.Think = function()
						lab:SetAlpha(lab:GetAlpha() - 2)
						local x, y = lab:GetPos()
						lab:SetPos(x, y - 2)
						lab:SetColor(Color(0, 255, 0))
						lab:SizeToContents()
						
						if lab:GetAlpha() <= 1 then lab:Remove() end
					end
				end)
			else
				LocalPlayer():ChatPrint("No points!")
			end
		end
	end
	
	local info = vgui.Create("DLabel", win)
	info:SetPos(300, 50)
	info:SetFont("mutanthero_verysmallf")
	info:SetText(" ")
	info.Think = function()
		if tobuy then
			info:SetText(tobuy.PrintName)
			info:SizeToContents()
		end
	end
	
	local info = vgui.Create("DLabel", win)
	info:SetPos(300, 170)
	info:SetFont("mutanthero_verysmallf")
	info:SetText(" ")
	info.Think = function()
		if tobuy then
			info:SetText("Cost: " .. tobuy.Cost)
			info:SizeToContents()
		end
	end
	
	local info = vgui.Create("DLabel", win)
	info:SetPos(300, 190)
	info:SetFont("mutanthero_verysmallf")
	info:SetText(" ")
	info.Think = function()
		if tobuy then
			if not tobuy.IsAmmo then
				info:SetText("Ammo uses: " .. string.upper(tobuy.Primary.Ammo))
			else
				info:SetText("Amount: " .. tobuy.Num)
			end
			
			info:SizeToContents()
		end
	end
	
	local info = vgui.Create("DLabel", win)
	info:SetPos(290, 380)
	info:SetFont("mutanthero_font1")
	info:SetText(" ")
	info.Think = function()
		info:SetText(LocalPlayer():GetMoney() .. "$")
		info:SizeToContents()
	end
	
	local info = vgui.Create("DModelPanel", win)
	info:SetPos(280, 70)
	info:SetModel(" ")
	info:SetSize(130, 130)
	info:SetCamPos(Vector(20, 20, 0))
	info:SetLookAt(Vector(0, 0, 0))
	info.Think = function()
		if tobuy then
			info:SetModel(tobuy.WorldModel)
		end
	end
end

usermessage.Hook("open_shop_muth", open_Shop)






-- Pointshop

local function open_Shop2()
	local weps = weapons.GetList()
	local tobuy
	//local abilities = {}

	local win = vgui.Create("DFrame")
	win:SetSize(420, 450)
	win:ShowCloseButton(false)
	win:SetTitle(" ")
	win:Center()
	win.Paint = function()
		local w = win:GetWide()
		local t = win:GetTall()
					
		draw.RoundedBox(0, 0, 0, w, t, Color(0, 0, 0, 170))
		draw.RoundedBox(0, 10, 10, w - 20, t - 20, Color(100, 100, 100, 200))
	end
	win.Think = function()
		//if GetGlobalBool("round_started") and win and IsValid(win) then win:Close() end
	end
	win:MakePopup()
	
	local close = vgui.Create("DButton", win)
	close:SetPos(50, 25)
	close:SetSize(320, 20)
	close:SetText("Close")
	close.DoClick = function() if win and IsValid(win) then win:Close() end end
	
	local weps_t = vgui.Create("DListView", win)
	weps_t:SetPos(15, 50)
	weps_t:SetSize(130, 360)
	weps_t:AddColumn("Weapon")
	local cost = weps_t:AddColumn("Cost")
	cost:SetMinWidth(30)
	cost:SetMaxWidth(30)
	weps_t.OnClickLine = function(parent, line, isselected)
		surface.PlaySound("buttons/blip1.wav")
	
		for k, v in pairs(weps) do
			if line:GetValue(1) == v.PrintName then tobuy = v end
		end
		
		for k, v in pairs(ammo) do
			if line:GetValue(1) == v.PrintName then tobuy = v end
		end
	end
	
	for k, v in pairs(weps) do
		if v.Cost then weps_t:AddLine(v.PrintName, math.ceil(v.Cost * 1.6)) end
	end
	
	local ammo_t = vgui.Create("DListView", win)
	ammo_t:SetPos(155, 50)
	ammo_t:SetSize(130, 360)
	ammo_t:AddColumn("Ammo")
	local cost = ammo_t:AddColumn("Cost")
	cost:SetMinWidth(30)
	cost:SetMaxWidth(30)
	ammo_t.OnClickLine = function(parent, line, isselected)
		surface.PlaySound("buttons/blip1.wav")
	
		for k, v in pairs(weps) do
			if line:GetValue(1) == v.PrintName then tobuy = v end
		end
		
		for k, v in pairs(ammo) do
			if line:GetValue(1) == v.PrintName then tobuy = v end
		end
	end
	
	for k, v in pairs(ammo) do
		ammo_t:AddLine(v.PrintName, math.ceil(v.Cost * 1.6))
	end
	
	local buy = vgui.Create("DButton", win)
	buy:SetPos(15, 415)
	buy:SetSize(270, 20)
	buy:SetText("Buy")
	buy.DoClick = function()
		if tobuy then
			if LocalPlayer():GetMoney() >= math.ceil(tobuy.Cost * 1.6) then
				local amm = false
				local num = 0
				if tobuy.IsAmmo then amm = true num = tobuy.Num end
			
				net.Start("pointshop_toserv")
					net.WriteFloat(math.ceil(tobuy.Cost * 1.6))
					net.WriteBit(amm)
					net.WriteString(tobuy.ClassName)
					net.WriteFloat(num)
				net.SendToServer()
				
				local NO_ACCES = false

				net.Receive("froms_toclient_check", function()
					local str = net.ReadString()
					
					if str != "[NULL Entity]" then NO_ACCES = true end
				end)
				
				timer.Simple(0.01, function()
					if NO_ACCES then return end
					
					surface.PlaySound("buttons/bell1.wav")
					
					local lab = vgui.Create("DLabel", win)
					lab:SetPos(290, 380)
					lab:SetFont("mutanthero_font1")
					lab:SetText("-" .. math.ceil(tobuy.Cost * 1.6) .. "$")
					lab.Think = function()
						lab:SetAlpha(lab:GetAlpha() - 2)
						local x, y = lab:GetPos()
						lab:SetPos(x, y - 0.3)
						lab:SizeToContents()
						
						if lab:GetAlpha() <= 1 then lab:Remove() end
					end
					
					local lab = vgui.Create("DLabel")
					lab:SetPos(ScrW() / 11, ScrH() / 1.3)
					lab:SetFont("mutanthero_font1")
					local isam = ""
					if tobuy.IsAmmo then isam = " ammo" end
					lab:SetText("+" .. tobuy.PrintName .. isam)
					lab.Think = function()
						lab:SetAlpha(lab:GetAlpha() - 2)
						local x, y = lab:GetPos()
						lab:SetPos(x, y - 2)
						lab:SetColor(Color(0, 255, 0))
						lab:SizeToContents()
						
						if lab:GetAlpha() <= 1 then lab:Remove() end
					end
				end)
			else
				LocalPlayer():ChatPrint("No points!")
			end
		end
	end
	
	local info = vgui.Create("DLabel", win)
	info:SetPos(300, 50)
	info:SetFont("mutanthero_verysmallf")
	info:SetText(" ")
	info.Think = function()
		if tobuy then
			info:SetText(tobuy.PrintName)
			info:SizeToContents()
		end
	end
	
	local info = vgui.Create("DLabel", win)
	info:SetPos(300, 170)
	info:SetFont("mutanthero_verysmallf")
	info:SetText(" ")
	info.Think = function()
		if tobuy then
			info:SetText("Cost: " .. math.ceil(tobuy.Cost * 1.6))
			info:SizeToContents()
		end
	end
	
	local info = vgui.Create("DLabel", win)
	info:SetPos(300, 190)
	info:SetFont("mutanthero_verysmallf")
	info:SetText(" ")
	info.Think = function()
		if tobuy then
			if not tobuy.IsAmmo then
				info:SetText("Ammo uses: " .. string.upper(tobuy.Primary.Ammo))
			else
				info:SetText("Amount: " .. tobuy.Num)
			end
			
			info:SizeToContents()
		end
	end
	
	local info = vgui.Create("DLabel", win)
	info:SetPos(290, 380)
	info:SetFont("mutanthero_font1")
	info:SetText(" ")
	info.Think = function()
		info:SetText(LocalPlayer():GetMoney() .. "$")
		info:SizeToContents()
	end
	
	local info = vgui.Create("DModelPanel", win)
	info:SetPos(280, 70)
	info:SetModel(" ")
	info:SetSize(130, 130)
	info:SetCamPos(Vector(20, 20, 0))
	info:SetLookAt(Vector(0, 0, 0))
	info.Think = function()
		if tobuy then
			info:SetModel(tobuy.WorldModel)
		end
	end
end

usermessage.Hook("open_shop_muth2", open_Shop2)
