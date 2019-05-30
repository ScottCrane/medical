local PLUGIN = PLUGIN
local KeyDownDelay = CurTime() + 5

hook.Add("Think", "nut_openmenus", function()
	if input.IsKeyDown(KEY_F2) and (KeyDownDelay <= CurTime()) then
		KeyDownDelay = CurTime() + 1.5
		
		if (!LocalPlayer().vguiopen) then
			RunConsoleCommand("testmedical")
		end
	end	
end)


function PLUGIN:OpenMedicalInfo(target, medinfo)
	if (!target and !medinfo) then
		target = LocalPlayer()
		medinfo = von.deserialize(LocalPlayer():GetNetVar("MedicalData"))
	end

	LocalPlayer().vguiopen = true

	local frame = vgui.Create("DFrame")
	frame:SetSize(400, 364)
	frame:Center()
	frame:SetPos(frame:GetPos(), ScrH()*0.2)
	frame:SetTitle(target:Nick().." - Information Médicale")
	frame:MakePopup()
	frame.OnClose = function()
		LocalPlayer().vguiopen = false
	end

	local panel = vgui.Create("DPanel", frame)
	panel:Dock(FILL)

	for k, hitgroup in ipairs(medinfo) do
		local hit = vgui.Create("DPanel", panel)
		hit:DockMargin(0,0,0,-1)
		hit:Dock(TOP)
		hit:SetTall(48)

		local medicalText = vgui.Create("DLabel", hit)
		medicalText:DockMargin(2,2,2,2)
		medicalText:Dock(FILL)
		medicalText:SetContentAlignment(7)
		medicalText:SetWrap(true)

		local medtext = PLUGIN:GetMedicalEnums()[k].." - "..hitgroup.health.."%"

		if (hitgroup.health > 75) then
			medtext = medtext.."\n".."En bonne santé"
		else
			medtext = medtext.."\n".."En mauvais état"
		end

		for k, v in pairs(hitgroup.conditions) do
			medtext = medtext..", "..PLUGIN:GetMedicalCondition(k).name
		end

		medicalText:SetText(medtext)
	end
end

netstream.Hook("nut_OpenCondition", function(data)
	PLUGIN:OpenMedicalInfo(data.target, data.medinfo)
end)

concommand.Add("testmedical", function()
	PLUGIN:OpenMedicalInfo()
end)