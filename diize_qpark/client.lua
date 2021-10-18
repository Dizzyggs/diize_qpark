ESX = nil
local plate = nil
local inTicketMission = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

end)


function refreshjob()
    Citizen.Wait(1)
    PlayerData = ESX.GetPlayerData()
end

    
		RegisterCommand("qpark", function()
			refreshjob()
			    if PlayerData.job.name == Config.RequiredJob then
					inTicketMission = true	
				local dialog = exports['zf_dialog']:DialogInput({
					header = Config.HeaderText,
					rows = {
						{
							id = 0,
							txt = Config.RegPlateText
						},
						{
							id = 1,
							txt = Config.billAmount
						},
						{
							id = 2,
							txt = Config.Notes
						},
					}
				})

				if dialog ~= nil then
					if dialog[1].input == nil or dialog[2].input == nil then
						if Config.Notifications == "mythic" then
								exports['mythic_notify']:DoHudText('error', Config.InvalidInputs)
						elseif Config.Notifications == "okok" then exports['okokNotify']:Alert("QPARK", Config.InvalidInputs, 5000, 'error')
						elseif Config.Notifications == "default" then ESX.ShowNotification(Config.InvalidInputs, true)
						end
		        else
							plate = dialog[1].input
							price = dialog[2].input
							notes = dialog[3].input
							TriggerServerEvent('diize_qpark:GetPlateOwner', plate, price, notes)
				end
							
end
end
end)


Citizen.CreateThread(function() -- Writing ticket animation.
	while true do 
		Citizen.Wait(0)
		if inTicketMission then
			local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, "CODE_HUMAN_MEDIC_TIME_OF_DEATH", -5, false)
	
end
end
end)

Citizen.CreateThread(function() -- In order to cancel anim, press X.
	while true do
	Citizen.Wait(0)
	local ped = PlayerPedId()
	if inTicketMission and ( IsControlJustPressed( 1, 105 ) ) then
		ClearPedTasks(ped)
    ClearPedSecondaryTask(ped)
	ClearPedTasksImmediately(ped)
		inTicketMission = false
		
	end
end
end)
