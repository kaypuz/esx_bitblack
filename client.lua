ESX = nil
local menuOpen = false
local wasOpen = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	PlayerLoaded = true
	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)
 
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		local rcdDistance = GetDistanceBetweenCoords(coords, Config.rcdCoords.rcdNPC.coords, true)
		
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)

			if GetDistanceBetweenCoords(coords, 2077.94, 2955.13, 49.92, true) < 1.5 then
				if not menuOpen then
					ESX.ShowHelpNotification('Bitcoin satmak için ~INPUT_CONTEXT~ tuşuna basın.')
					if IsControlJustReleased(0, 119) then
						wasOpen = true
						OpenBitShop()
					end
				else
					Citizen.Wait(500)
				end
			else
				if wasOpen then
					wasOpen = false
					ESX.UI.Menu.CloseAll()
				end

				Citizen.Wait(500)
			end
		end
	end
end)

-- Lester Ped
Citizen.CreateThread(function()
    local ped_hash = 0xB8CC92B4
    local ped_coords = Config.rcdCoords.rcdNPC.coords

    RequestModel(ped_hash)
    while not HasModelLoaded(ped_hash) do
        Citizen.Wait(1)
    end

    ped_info = CreatePed(1, ped_hash, ped_coords, 115.0, false, true)
    SetBlockingOfNonTemporaryEvents(ped_info, true)
    SetEntityInvincible(ped_info, true)
    FreezeEntityPosition(ped_info, true)
end)
-- Lester Ped

function OpenBitShop()
	ESX.UI.Menu.CloseAll()
	local elements = {}
	menuOpen = true

		local price = 2000

		if price and 1 > 0 then
			--local elements = {
			table.insert(elements, {
				label = ('Bitcoin - <span style="color:green;">$2000</span>'),
				name = 'bitcoin',
				price = price,

				-- menu properties
				type = 'slider',
				value = 1,
				min = 1,
				max = 30
			--}
		})
		end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'bit_shop', {
		title    = 'Bitcoin satıcısı',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('esx_bitblack:sellBitcoin', data.current.name, data.current.value)
	end, function(data, menu)
		menu.close()
		menuOpen = false
	end)
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if menuOpen then
			ESX.UI.Menu.CloseAll()
		end
	end
end)