local KeyDownDelay = CurTime() or KeyDownDelay

hook.Add("Think", "nut_openmenus", function()
	if input.IsKeyDown(KEY_F2) and (KeyDownDelay < CurTime()) then
		KeyDownDelay = CurTime() + 1.5

		if (!LocalPlayer().vguiopen) then
			RunConsoleCommand("testvgui")
		end
	elseif input.IsKeyDown(KEY_F3) and (KeyDownDelay < CurTime()) then
		KeyDownDelay = CurTime() + 1.5
		
		if (!LocalPlayer().vguiopen) then
			RunConsoleCommand("testmedical")
		end
		
end)

concommand.Add("testvgui", function()
	LocalPlayer().vguiopen = true
	local frame = vgui.Create("DFrame")
	frame:SetSize(400, 519)
	frame:Center()
	frame:SetPos(frame:GetPos(), ScrH()*0.2)
	frame:SetTitle(LocalPlayer():Nick())
	frame:MakePopup()
	frame.OnClose = function()
		LocalPlayer().vguiopen = false
	end

	local panel = vgui.Create("DPanel", frame)
	panel:Dock(FILL)

	local charinfo = vgui.Create("DPanel", panel)
	charinfo:DockMargin(0,0,0,4)
	charinfo:Dock(TOP)
	charinfo:SetTall(68)

	local chardesc = vgui.Create("DLabel", charinfo)
	chardesc:DockMargin(6,6,6,6)
	chardesc:Dock(FILL)
	chardesc:SetWrap(true)
	chardesc:SetContentAlignment(7)
	chardesc:SetFont("nut_menufont")
	chardesc:SetText(LocalPlayer().character:GetVar("description", "No description available."))

	local changedesc = vgui.Create("DButton", panel)
	changedesc:DockMargin(0,0,0,4)
	changedesc:Dock(TOP)
	changedesc:SetFont("nut_menufont")
	changedesc:SetText("Change Description")
	changedesc.DoClick = function()
		netstream.Start("nut_RequestDesc", false)
		frame:Remove()
		LocalPlayer().vguiopen = false
	end

	local changedesc = vgui.Create("DButton", panel)
	changedesc:DockMargin(0,0,0,4)
	changedesc:Dock(TOP)
	changedesc:SetFont("nut_menufont")
	changedesc:SetText("Reconnaître les joueurs..")
	changedesc.DoClick = function()
		local menu = DermaMenu()

		menu:AddOption("Reconnaissez le joueur que vous regardez actuellement.", function()
			LocalPlayer():ConCommand("say /recognise aim")
			frame:Remove()
			LocalPlayer().vguiopen = false
		end)

		menu:AddOption("Reconnaître tous les joueurs à portée de voix.", function()
			LocalPlayer():ConCommand("say /recognise")
			frame:Remove()
			LocalPlayer().vguiopen = false
		end)

		menu:AddOption("Reconnaître tous les joueurs à portée de chuchottement.", function()
			LocalPlayer():ConCommand("say /recognise whisper")
			frame:Remove()
			LocalPlayer().vguiopen = false
		end)

		menu:AddOption("Reconnaître tous les joueurs à portée de crie.", function()
			LocalPlayer():ConCommand("say /recognise yell")
			frame:Remove()
			LocalPlayer().vguiopen = false
		end)

		menu:Open()
		menu:SetParent(p)
	end

	local quickact = vgui.Create("DButton", panel)
	quickact:DockMargin(0,0,0,4)
	quickact:Dock(TOP)
	quickact:SetText("Faire une animation")
	quickact:SetFont("nut_menufont")
	quickact.DoClick = function(pnl)
		local class = nut.anim.GetClass(string.lower(LocalPlayer():GetModel()))
		local list = PLUGIN.sequences[class]
		local menu = DermaMenu()
		if (list) then
			for uid, actdata in SortedPairs(list) do
				if (list) then
					menu:AddOption((actdata.name or uid), function()
						LocalPlayer():ConCommand(Format("say /act%s", uid))
						frame:Remove()
						LocalPlayer().vguiopen = false
					end)
				end
			end
		end
		menu:Open()
		menu:SetParent(pnl)
	end

	local quickreset = vgui.Create("DButton", panel)
	quickreset:DockMargin(0,0,0,4)
	quickreset:Dock(TOP)
	quickreset:SetText("Reinitialiser l'animation")
	quickreset:SetFont("nut_menufont")
	quickreset.DoClick = function()
		LocalPlayer():ConCommand("say /actstand")
		frame:Remove()
		LocalPlayer().vguiopen = false
	end

	local viewmedical = vgui.Create("DButton", panel)
	viewmedical:DockMargin(0,0,0,4)
	viewmedical:Dock(TOP)
	viewmedical:SetText("Voir les informations médicales")
	viewmedical:SetFont("nut_menufont")
	viewmedical.DoClick = function()
		PLUGIN:OpenMedicalInfo()
		frame:Remove()
		LocalPlayer().vguiopen = false
	end


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