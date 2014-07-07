AddCSLuaFile()

function open_ChangeCls()
	local win = vgui.Create("DFrame")
	win:SetSize(1100, 260)
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
	close:SetPos(390, 25)
	close:SetSize(320, 20)
	close:SetText("Close (If you pressed your class will be heavy)")
	close.DoClick = function() 
		if win and IsValid(win) then win:Close() end 
		
		LocalPlayer():ChatPrint("Your class is heavy now")
	end
	
	//medic
	local info = vgui.Create("SpawnIcon", win)
	info:SetPos(50, 50)
	info:SetModel("models/player/alyx.mdl")
	info:SetSize(100, 100)
	info.OnMousePressed = function()
		if win and IsValid(win) then win:Close() end
		
		LocalPlayer():ChatPrint("Your class is medic now")
		
		return false
	end
	
	local info = vgui.Create("DLabel", win)
	info:SetPos(50, 150)
	info:SetFont("mutanthero_verysmallf")
	info:SetText("Classname: medic\nMedic can heal players\nMedic isn't soldier\nBut he can attack too")
	info:SizeToContents()
	///////
	
	
	
	//engineer
	local info = vgui.Create("SpawnIcon", win)
	info:SetPos(250, 50)
	info:SetModel("models/player/eli.mdl")
	info:SetSize(100, 100)
	info.OnMousePressed = function()
		if win and IsValid(win) then win:Close() end
		
		LocalPlayer():ChatPrint("Your class is engineer now")
		
		return false
	end
	
	local info = vgui.Create("DLabel", win)
	info:SetPos(250, 150)
	info:SetFont("mutanthero_verysmallf")
	info:SetText("Classname: engineer\nEngineer have turrets\nEngineer isn't soldier\nBut he can attack too")
	info:SizeToContents()
	////////
	
	
	
	//light soldier
	local info = vgui.Create("SpawnIcon", win)
	info:SetPos(450, 50)
	info:SetModel("models/Humans/Group03/male_02.mdl")
	info:SetSize(100, 100)
	info.OnMousePressed = function()
		if win and IsValid(win) then win:Close() end
		
		LocalPlayer():ChatPrint("Your class is light soldier now")
		
		return false
	end
	
	local info = vgui.Create("DLabel", win)
	info:SetPos(450, 150)
	info:SetFont("mutanthero_verysmallf")
	info:SetText("Classname: light soldier\nFaster soldier\nCan have light guns\nCan't use big guns")
	info:SizeToContents()
	/////////
	
	
	
	//heavy soldier
	local info = vgui.Create("SpawnIcon", win)
	info:SetPos(650, 50)
	info:SetModel("models/Humans/Group03/male_09.mdl")
	info:SetSize(100, 100)
	info.OnMousePressed = function()
		if win and IsValid(win) then win:Close() end
		
		LocalPlayer():ChatPrint("Your class is heavy now")
		
		return false
	end
	
	local info = vgui.Create("DLabel", win)
	info:SetPos(650, 150)
	info:SetFont("mutanthero_verysmallf")
	info:SetText("Classname: heavy soldier\nHeavy soldier is slowly\nCan have big guns and light guns\nHave big damage")
	info:SizeToContents()
	/////////
	
	
	
	//berserk
	local info = vgui.Create("SpawnIcon", win)
	info:SetPos(850, 50)
	info:SetModel("models/odessa.mdl")
	info:SetSize(100, 100)
	info.OnMousePressed = function()
		if win and IsValid(win) then win:Close() end
		
		LocalPlayer():ChatPrint("Your class is berserk now")
		
		return false
	end
	
	local info = vgui.Create("DLabel", win)
	info:SetPos(850, 150)
	info:SetFont("mutanthero_verysmallf")
	info:SetText("Classname: berserk\nBerserk is faster\nHave big damage with melee weapons\n")
	info:SizeToContents()
	/////////
end

concommand.Add("open_chngcls", open_ChangeCls)
usermessage.Hook("open_chngcls_muth", open_ChangeCls)