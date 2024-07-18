local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('md-houserobbery:server:accessbreak', function(tier)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local info = Player.PlayerData.charinfo
    local luck = math.random(1,100)
    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    if tier <= 4 then 
        if luck <= 20 then 
           RemoveItem('lockpick', 1)
           Log('ID: 1 Name: ' .. info.firstname .. ' ' .. info.lastname .. ' Broke A Lockpick At A Tier ' .. tier .. ' House At ' .. playerCoords .. '!', 'break')
        end
    elseif tier == 5 then 
        if luck <= 45 then 
           RemoveItem('houselaptop', 1)
           Log('ID: 1 Name: ' .. info.firstname .. ' ' .. info.lastname .. ' Broke A House Laptop At A Tier ' .. tier .. ' House At ' .. playerCoords .. '!', 'break')
        end
    else
        if luck <= 85 then 
           RemoveItem('mansionlaptop', 1)
           Log('ID: 1 Name: ' .. info.firstname .. ' ' .. info.lastname .. ' Broke A Mansion Laptop At A Tier ' .. tier .. ' House At ' .. playerCoords .. '!', 'break')
        end 
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
    if not itemConfig then return end -- Don't allow players to turn any item into any amount of money
    local price = math.random(itemConfig.minvalue, itemConfig.maxvalue) -- Retrieve price from config don't trust client
    local itemsell = Player.Functions.GetItemByName(itemName)
    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    if itemsell and itemsell.amount > 0 then
        if RemoveItem(itemName, itemsell.amount) then
            Player.Functions.AddMoney('cash', price * itemsell.amount)
            Notifys("You received " .. itemsell.amount * price .. " of Cash.", "success")
            Log('ID: 1 Name: ' .. info.firstname .. ' ' .. info.lastname .. ' Sold  ' .. itemsell.amount .. ' ' .. itemName .. ' For A Price Of ' .. price * itemsell.amount .. ' At ' .. playerCoords .. '!', 'sell')
        end
    end
end)

RegisterNetEvent('md-houserobberies:server:loseloot', function(item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local itemsell = Player.Functions.GetItemByName(item)
    local info = Player.PlayerData.charinfo
    if itemsell and itemsell.amount > 0 then
        if RemoveItem(item, itemsell.amount) then
            Notifys("You Just Got Robbed of " ..itemsell.amount .." ".. QBCore.Shared.Items[item].label .. "s!", "error")
            Log('ID: 1 Name: ' .. info.firstname .. ' ' .. info.lastname .. ' Got Robbed Of   ' .. itemsell.amount .. ' ' .. itemName .. ' Like A Nerd!', 'robbed')
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
    Log('House ID ' .. house .. ' Has Been Unlocked By ' .. info.firstname .. ' ' .. info.lastname .. '!', 'brokenin')
    Wait(1000 * 60 * Config.HouseTimer)
    Config.Houses[house]['spawned'] = false
    TriggerClientEvent('md-houserobbery:client:setHouseState', -1, house, false)
    Log('House ID ' .. house .. ' Has Been Locked', 'locked')
end)

RegisterNetEvent('md-houserobbery:server:setlootused', function(house, k)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local info = Player.PlayerData.charinfo
    Log('ID: ' .. src .. 'Name:' .. info.firstname .. ' ' .. info.lastname .. ' Took From ' .. house .. ' Loot Spot ' .. k .. '!', 'set' )
    Config.Houses[house]['loot'][k].taken = true
    TriggerClientEvent('md-houserobbery:client:SetLootState', -1, house, k, true)
    Wait(1000 * 60 * Config.HouseTimer)
    Config.Houses[house]['loot'][k].taken = false
    Log('' .. house .. ' Loot Spot ' .. k .. ' Is Availavble!', 'set' )
    TriggerClientEvent('md-houserobbery:client:SetLootState', -1, house, k, false)
end)

RegisterNetEvent('md-houserobbery:server:setlootstatebusy', function(house, k,state)
    Config.Houses[house]['loot'][k].busy = state
    TriggerClientEvent('md-houserobbery:client:SetLootStateBusy', -1, house, k, state)
end)

RegisterNetEvent('md-houserobbery:server:closeHouse', function(house)
    Config.Houses[house]['spawned'] = false
    Log('House ID ' .. house .. ' Has Been Locked By Police', 'locked')
    TriggerClientEvent('md-houserobbery:client:setHouseState', -1, house, false)
end)

RegisterNetEvent('md-houserobberies:server:ptfx', function(loc)
TriggerClientEvent('md-housrobberies:client:ptfx', -1, loc)
end)
RegisterNetEvent('md-houserobbery:server:GetLoot', function(tier, rewardtype, objectCoords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local info = Player.PlayerData.charinfo
    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    if #(playerCoords - objectCoords) > 3 then return end -- Prevent loot vacuums
    local chance = math.random(1,100)
    local cashamount = math.random(Config.CashMin, Config.CashMax)
    local randomItem = Config.Rewards[tier][rewardtype][math.random(1, #Config.Rewards[tier][rewardtype])]
    local itemInfo = QBCore.Shared.Items[randomItem]
    if Config.EmptyChance <= chance then 
        AddItem(randomItem, Config.ItemAmounts[randomItem])
        if Config.CashChance <= chance then
            Player.Functions.AddMoney('cash', cashamount)
        end
        Log('ID: 1 Name: ' .. info.firstname .. ' ' .. info.lastname .. ' Stole ' .. Config.ItemAmounts[randomItem] .. ' Of ' .. randomItem .. ' From A Tier ' .. tier .. ' House', 'stole')
    else
        Notifys("This Isn't Worth Taking", "error") 
    end
end)
