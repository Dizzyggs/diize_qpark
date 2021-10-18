ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('diize_qpark:GetPlateOwner')
AddEventHandler('diize_qpark:GetPlateOwner', function(datplate, price, notes)
	print('Plate being runned: '..tostring(datplate))
	local _source = source
	local xTarget = ESX.GetPlayerFromId(source)
	local sender = ESX.GetPlayerFromId(source)
	local notes = notes
	local query = [[
	SELECT * FROM owned_vehicles LEFT JOIN users ON owned_vehicles.owner = users.identifier WHERE owned_vehicles.plate LIKE @plate LIMIT 1
	]]

	MySQL.Async.fetchAll(query, {
	['plate'] = datplate,
	['@owner'] = xTarget.identifier
	}, function(result)
		
		if result[1] then
			print("^2 Vehicle with plate: ^7["..datplate.."] ^2found in owned_vehicles.^7")
			print("the owner is "..xTarget.identifier)
			if Config.okoB then
				TriggerEvent('okokBilling:qPark', xTarget, price, notes)
				TriggerEvent('diize:notify', _source)
			else
				TriggerEvent('esx_billing:diize_qpark', xTarget, price, notes)
				TriggerEvent('diize:notify', _source)
			end
		elseif not result[1] then
			TriggerEvent('diize:notify_NoOwner', _source)
			print("^1 Vehicle with plate: ^7["..datplate.."] ^1 not found.^7")
		end
	end)
end)

RegisterServerEvent('diize:notify')
AddEventHandler('diize:notify', function(source)
	local _source = source
	if Config.Notification == "okok" then
		TriggerClientEvent('okokNotify:Alert', _source, "QPARK", Config.YouSentBill, 5000, 'success')
	elseif Config.Notifications == "mythic" then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'success', text = Config.YouSentBill, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
	elseif Config.Notifications == "default" then
		TriggerClientEvent('esx:showNotification', _source, Config.YouSentBill)
	end
end)

RegisterServerEvent('diize:notify_NoOwner')
AddEventHandler('diize:notify_NoOwner', function(source)
	local _source = source
	if Config.Notifications == "okok" then
		TriggerClientEvent('okokNotify:Alert', _source, "QPARK", Config.NoOwner, 5000, 'error')
	elseif Config.Notifications == "mythic" then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = Config.NoOwner, style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
	elseif Config.Notifications == "default" then
		TriggerClientEvent('esx:showNotification', _source, Config.NoOwner)
	end
end)