ESX = nil 
 
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 

RegisterServerEvent('esx_bitblack:sellBitcoin')
AddEventHandler('esx_bitblack:sellBitcoin', function(itemName, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = 2000
	local xItem = xPlayer.getInventoryItem(itemName)

	if not price then
		print(('[BILGI]: %s geçersiz bir eşya satmaya çalıştı.'):format(xPlayer.identifier))
		return
	end

	if xItem.count < amount then
		xPlayer.showNotification('Satmak için yeterli yok!')
		return
	end

	price = ESX.Math.Round(price * amount)

    xPlayer.addAccountMoney('black_money', price)

	xPlayer.removeInventoryItem(xItem.name, amount)
end)