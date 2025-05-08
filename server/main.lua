local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('md-houserobbery:server:accessbreak', function(tier, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local luck = math.random(1, 100)
    if luck <= 20 then
        RemoveItem(src, item, 1)
    end
end)

RegisterNetEvent('md-houserobberies:server:sellloot', function(itemName)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local info = Player.PlayerData.charinfo
    local itemConfig

    for i = 1, #Config.BlackMarket do
        if Config.BlackMarket[i].item == itemName then
            itemConfig = Config.BlackMarket[i]
            break
        end
    end

    if not itemConfig then return end

    local price = math.random(itemConfig.minvalue, itemConfig.maxvalue)
    local itemsell = Player.Functions.GetItemByName(itemName)
    if itemsell and itemsell.amount > 0 then
        if RemoveItem(src, itemName, itemsell.amount) then
            Player.Functions.AddMoney('cash', price * itemsell.amount)
            Notifys("You received $" .. (itemsell.amount * price) .. " in cash.", "success")
            Log('ID: 1 Name: ' .. info.firstname .. ' ' .. info.lastname .. ' sold ' .. itemsell.amount .. ' ' .. itemName .. ' for $' .. (price * itemsell.amount) .. '.', 'sell')
        end
    end
end)

RegisterNetEvent('md-houserobberies:server:loseloot', function(item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local itemsell = Player.Functions.GetItemByName(item)
    local info = Player.PlayerData.charinfo
    if itemsell and itemsell.amount > 0 then
        if RemoveItem(src, item, itemsell.amount) then
            Notifys("You just got robbed of " .. itemsell.amount .. " " .. QBCore.Shared.Items[item].label .. "s!", "error")
            Log('ID: 1 Name: ' .. info.firstname .. ' ' .. info.lastname .. ' got robbed of ' .. itemsell.amount .. ' ' .. item .. '.', 'robbed')
        end
    end
end)

RegisterNetEvent('md-houserobbery:server:enterHouse', function(house)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local info = Player.PlayerData.charinfo

    TriggerClientEvent('md-houserobbery:client:enterHouse', src, house)
    Config.Houses[house]['spawned'] = true
    TriggerClientEvent('md-houserobbery:client:setHouseState', -1, house, true)
    Log('House ID ' .. house .. ' has been unlocked by ' .. info.firstname .. ' ' .. info.lastname .. '!', 'brokenin')

    Wait(1000 * 60 * Config.HouseTimer)

    Config.Houses[house]['spawned'] = false
    TriggerClientEvent('md-houserobbery:client:setHouseState', -1, house, false)
    Log('House ID ' .. house .. ' has been locked.', 'locked')
end)

RegisterNetEvent('md-houserobbery:server:setlootused', function(house, k)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local info = Player.PlayerData.charinfo

    Log('ID: ' .. src .. ' Name: ' .. info.firstname .. ' ' .. info.lastname .. ' took from ' .. house .. ' loot spot ' .. k .. '!', 'set')
    Config.Houses[house]['loot'][k].taken = true
    TriggerClientEvent('md-houserobbery:client:SetLootState', -1, house, k, true)

    Wait(1000 * 60 * Config.HouseTimer)

    Config.Houses[house]['loot'][k].taken = false
    Log(house .. ' loot spot ' .. k .. ' is available!', 'set')
    TriggerClientEvent('md-houserobbery:client:SetLootState', -1, house, k, false)
end)

RegisterNetEvent('md-houserobbery:server:setlootstatebusy', function(house, k, state)
    Config.Houses[house]['loot'][k].busy = state
    TriggerClientEvent('md-houserobbery:client:SetLootStateBusy', -1, house, k, state)
end)

RegisterNetEvent('md-houserobbery:server:closeHouse', function(house)
    Config.Houses[house]['spawned'] = false
    Log('House ID ' .. house .. ' has been locked by police.', 'locked')
    TriggerClientEvent('md-houserobbery:client:setHouseState', -1, house, false)
end)

RegisterNetEvent('md-houserobberies:server:ptfx', function(loc)
    TriggerClientEvent('md-housrobberies:client:ptfx', -1, loc)
end)

RegisterNetEvent('md-houserobbery:server:GetLoot', function(tier, rewardtype, objectCoords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not CheckDist(src, objectCoords) then return end

    local chance = math.random(1, 100)
    local cashamount = math.random(Config.CashMin, Config.CashMax)
    local rewards = Config.Rewards[tier][rewardtype]
    local randomItem = math.random(1, #rewards)
    local data = rewards[randomItem]

    if Config.EmptyChance <= chance then
        AddItem(src, data.item, data.amount)
        if Config.CashChance <= chance then
            Player.Functions.AddMoney('cash', cashamount)
        end
        Log('ID: 1 Name: ' .. GetName(src) .. ' stole ' .. data.amount .. ' of ' .. data.item .. ' from a tier ' .. tier .. ' house.', 'stole')
    else
        Notifys("This isn't worth taking.", "error")
    end
end)
