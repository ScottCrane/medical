ITEM.name = "Sac de médecin"
ITEM.model = "models/props_c17/TrapPropeller_Lever.mdl" -- à définir
ITEM.cures = "docbag"
ITEM.uses = 1
ITEM.price = 150
ITEM.width = 2
ITEM.height = 1
ITEM.functions = {}

	ITEM.functions.TreatSelf = {
		text = "Se soigner",
		run = function(itemTable, client, data)
			if (SERVER) then
				if (client:GetMedicalConditions()) then
					local data = {}
					data.conditions = client:GetMedicalConditions()
					data.cure = itemTable.cure
					data.name = itemTable.name
					data.uniqueID = itemTable.uniqueID
					netstream.Start(client, "nut_SendSelfTreatmentInfo", data)
				end
			end

			return false
		end
	}

	ITEM.functions.TreatForward = {
		text = "Soigner la cible",
		run = function(itemTable, client, data)
			if (SERVER) then
				local trdata = {}
					trdata.start = client:GetShootPos()
					trdata.endpos = trdata.start + client:GetAimVector()*96
					trdata.filter = client
				local trace = util.TraceLine(trdata)
				local target = trace.Entity

				if (target:GetMedicalConditions()) then
					local data = {}
					data.conditions = target:GetMedicalConditions()
					data.cure = itemTable.cure
					data.name = itemTable.name
					data.uniqueID = itemTable.uniqueID
					netstream.Start(client, "nut_SendTreatmentInfo", data)
				end
			end

			return false
		end,
		shouldDisplay = function(itemTable, data, entity)
			local client = LocalPlayer()
			local trdata = {}
				trdata.start = client:GetShootPos()
				trdata.endpos = trdata.start + client:GetAimVector()*96
				trdata.filter = client
			local trace = util.TraceLine(trdata)
			local target = trace.Entity

			return trace.Hit and target:IsPlayer()
		end
	}

---- Fonction que j'utiliserais dans le futur, une fois le reste stabilisé.
	function ITEM:GetDesc(data)
		local data = data 
        --if (data.uses and data.uses != 1) then
		--	return data.uses.." Uses remaining"
		--elseif (data.uses and data.uses == 1) then
			return "Cet objet n'as qu'une seule utilisation"
		--else
		--	return "This item has infinite uses"
		--end
	end


if (CLIENT) then
	netstream.Hook("nut_SendTreatmentInfo", function(data)
		local menu = DermaMenu()

		for k, v in pairs(data.conditions) do
			for k2, v2 in pairs(v) do
				if PLUGIN:CanCure(k2, data.cure) then
					menu:AddOption("Traite "..k2.." chez le patient "..string.lower(PLUGIN:GetMedicalEnums()[k]).." en utilisant "..string.lower(data.name)..".", function()
						local info = {}
						info.condition = k2
						info.limb = k
						info.uniqueID = data.uniqueID
						netstream.Start("nut_SendTreatmentInfo", info)
					end)
				end
			end
		end

		menu:Open()
	end)

	netstream.Hook("nut_SendSelfTreatmentInfo", function(data)
		local menu = DermaMenu()

		for k, v in pairs(data.conditions) do
			for k2, v2 in pairs(v) do
				if PLUGIN:CanCure(k2, data.cure) then
					menu:AddOption("Traite "..k2.." sur vous "..string.lower(PLUGIN:GetMedicalEnums()[k]).." en utilisant "..string.lower(data.name)..".", function()
						local info = {}
						info.condition = k2
						info.limb = k
						info.uniqueID = data.uniqueID
						netstream.Start("nut_SendSelfTreatmentInfo", info)
					end)
				end
			end
		end

		menu:Open()
	end)
else
	netstream.Hook("nut_SendTreatmentInfo", function(client, data)
		local condition, limb, uniqueID = data.condition, data.limb, data.uniqueID
		local trdata = {}
			trdata.start = client:GetShootPos()
			trdata.endpos = data.start + client:GetAimVector()*96
			trdata.filter = client
		local trace = util.TraceLine(trdata)
		local target = trace.Entity

		if (client:HasItem(uniqueID) and target:IsPlayer()) then
			if (target:HasMedicalCondition(condition)) then
				target:RemoveHitgroupDamage(limb, 20, condition)
				client:UpdateInv(uniqueID, -1)
			end
		end
	end)

	netstream.Hook("nut_SendSelfTreatmentInfo", function(client, data)
		local condition, limb, uniqueID = data.condition, data.limb, data.uniqueID
		if (client:HasItem(uniqueID)) then
			if (client:HasMedicalCondition(condition)) then

				client:RemoveHitgroupDamage(limb, 20, condition)
				client:UpdateInv(uniqueID, -1)
			end
		end
	end)
end