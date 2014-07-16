AddCSLuaFile()

local NotifyPosition = 0

function notify(data)
	local str = data:ReadString()

	local lab = vgui.Create("DLabel")
	lab:SetPos(ScrW() / 11, (ScrH() / 1.3) - NotifyPosition)
	lab:SetFont("mutanthero_font1")
	lab:SetText(str)
	
	lab.Think = function()
		lab:SetAlpha(lab:GetAlpha() - 0.8)
		local x, y = lab:GetPos()
		lab:SetPos(x, y - 1)
		lab:SetColor(Color(0, 255, 0))
		lab:SizeToContents()
							
		if lab:GetAlpha() <= 1 then lab:Remove() end
	end
	
	NotifyPosition = NotifyPosition + 60
	
	timer.Create("stop_notify_pos", 0.2, 1, function()
		NotifyPosition = 0
	end)
end

usermessage.Hook("notify_muth", notify)