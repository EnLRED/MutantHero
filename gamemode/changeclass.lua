AddCSLuaFile()

function open_ChangeCls()
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
	
	
end

concommand.Add("open_shop", open_ChangeCls)
usermessage.Hook("open_shop_muth", open_ChangeCls)