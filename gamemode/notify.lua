AddCSLuaFile()

function notify(data)
	local str = data:ReadString()

	local lab = vgui.Create("DLabel")
	lab:SetPos(ScrW() / 11, ScrH() / 1.3)
	lab:SetFont("mutanthero_font1")
	lab:SetText(str)
	
	lab.Think = function()
		lab:SetAlpha(lab:GetAlpha() - 2)
		local x, y = lab:GetPos()
		lab:SetPos(x, y - 2)
		lab:SetColor(Color(0, 255, 0))
		lab:SizeToContents()
							
		if lab:GetAlpha() <= 1 then lab:Remove() end
	end
end

usermessage.Hook("notify_muth", notify)