AddCSLuaFile()

function open_Shop()
	local win = vgui.Create("DFrame")
	win:SetSize(350, 450)
	win:SetTitle(" ")
	win:Center()
	win.Paint = function()
		local w = win:GetWide()
		local t = win:GetTall()
					
		draw.RoundedBox(0, 0, 0, w, t, Color(0, 0, 0, 170))
		draw.RoundedBox(0, 10, 10, w - 20, t - 20, Color(150, 0, 0, 255))
	end
	win:MakePopup()
end

concommand.Add("open_shop", open_Shop)