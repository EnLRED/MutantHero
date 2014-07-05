AddCSLuaFile()

local points = 150

function open_Shop()
	local weps = weapons.GetList()
	local ammo = {
		["pistol"] = { PrintName = "Pistol", Cost = 5, WorldModel = "" },
		["smg1"] = { PrintName = "SMG1", Cost = 5, WorldModel = LocalPlayer():GetModel() }
	}
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
		for k, v in pairs(weps) do
			if line:GetValue(1) == v.PrintName then tobuy = v end
		end
		
		for k, v in pairs(ammo) do
			if line:GetValue(1) == v.PrintName then tobuy = v end
		end
	end
	
	for k, v in pairs(weps) do
		if weps_t.Cost then weps_t:AddLine(v.PrintName, 1) end
	end
	
	local ammo_t = vgui.Create("DListView", win)
	ammo_t:SetPos(155, 50)
	ammo_t:SetSize(130, 360)
	ammo_t:AddColumn("Ammo")
	local cost = ammo_t:AddColumn("Cost")
	cost:SetMinWidth(30)
	cost:SetMaxWidth(30)
	ammo_t.OnClickLine = function(parent, line, isselected)
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
			if points >= tobuy.Cost then
				points = points - tobuy.Cost
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
	info:SetPos(290, 380)
	info:SetFont("mutanthero_font1")
	info:SetText(" ")
	info.Think = function()
		info:SetText(points .. "$")
		info:SizeToContents()
	end
	
	local info = vgui.Create("DModelPanel", win)
	info:SetPos(280, 70)
	info:SetModel(LocalPlayer():GetModel())
	info:SetSize(100, 100)
	info:SetCamPos(Vector(50, 50, 120))
	info:SetLookAt(Vector(0, 0, 0))
	info.Think = function()
		if tobuy then
			info:SetModel(tobuy.WorldModel)
		end
	end
end

concommand.Add("open_shop", open_Shop)
usermessage.Hook("open_shop_muth", open_Shop)

