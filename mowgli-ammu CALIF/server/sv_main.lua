ESX = nil

local ServerConfig = {
    webhooks = "TON WEBHOOK",
    webhooksTitle = "63 DEV BY MOWGLI ET JOKER",
    webhooksColor = 2061822,
}

TriggerEvent(Config.getESX, function(obj) ESX = obj end)

RegisterServerEvent("mowgli-ammunation:buyWeapon")
AddEventHandler("mowgli-ammunation:buyWeapon", function(item, type, price)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    for k, v in pairs(Config.Ammunation.Items) do
        if item == v.item then
            if price ~= v.price then
                print("Cheater !?")
                --> TODO BAN
            end
        end
    end
    if type == "weapon" then
        if xPlayer.getAccount('cash').money >= tonumber(price) then
            if not xPlayer.hasWeapon(item) then
                xPlayer.removeAccountMoney('cash',tonumber(price))
                xPlayer.addWeapon(item, 255)
                xPlayer.showNotification("~r~Armurerie\n~s~Vous venez d'acheter une arme (-".. price .." ~g~$~s~)")
                ServerToDiscord(ServerConfig.webhooksTitle, '[ARMURIE] ' ..xPlayer.getName().. ' vient d\'acheter une arme (NOM : ' ..item..' - PRIX : ' ..price.. ')', ServerConfig.webhooksColor)
            else
                xPlayer.showNotification('~r~Vous avez déjà cette arme')
            end
      	else
          	xPlayer.showNotification("~r~Il semblerait que vous ne possésez pas l'argent nécessaire")
      	end
    elseif type == "item" then
       	if xPlayer.getAccount('cash').money >= tonumber(price) then
            xPlayer.removeAccountMoney('cash',tonumber(price))
            xPlayer.addInventoryItem(item, 1)
            xPlayer.showNotification("~r~Armurerie\n~s~Vous venez d'acheter un item (-".. price .." ~g~$~s~)")
            ServerToDiscord(ServerConfig.webhooksTitle, '[ARMURIE] ' ..xPlayer.getName().. ' vient d\'acheter un accessoire (NOM : ' ..item..' - PRIX : ' ..price.. ')', ServerConfig.webhooksColor)
       	else
       		xPlayer.showNotification("~r~Il semblerait que vous ne possésez pas l'argent nécessaire")
       	end
    end
end)

RegisterServerEvent('mowgli-weapon:removeClip')
AddEventHandler('mowgli-weapon:removeClip', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('clip', 1)
end)

ESX.RegisterUsableItem('clip', function(source)
	TriggerClientEvent('mowgli-weapon:useClip', source)
end)

ServerToDiscord = function(name, message, color)
	date_local1 = os.date('%H:%M:%S', os.time())
	local date_local = date_local1
	local DiscordWebHook = ServerConfig.webhooks

    local embeds = {
	    {
		    ["title"]= message,
		    ["type"]="rich",
		    ["color"] =color,
		    ["footer"]=  {
			    ["text"]= "Heure : " ..date_local.. "",
		    },
	    }
    }

	if message == nil or message == '' then return FALSE end
	PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end 
