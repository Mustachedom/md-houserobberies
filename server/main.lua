local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('md-houserobbery:server:accessbreak', function(tier)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local luck = math.random(1,100)
    if tier <= 4 then 
        if luck <= 20 then 
           RemoveItem('lockpick', 1)
        end
    elseif tier == 5 then 
        if luck <= 45 then 
           RemoveItem('houselaptop', 1)
        end
    else
        if luck <= 85 then 
           RemoveItem('mansionlaptop', 1)
        end 
    end
end)

RegisterNetEvent('md-houserobberies:server:sellloot', function(itemName)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
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

    if itemsell and itemsell.amount > 0 then
        if RemoveItem(itemName, itemsell.amount) then
            Player.Functions.AddMoney('cash', price * itemsell.amount)
            Notifys("You received " .. itemsell.amount * price .. " of Cash.", "success")
        end
    end
end)

RegisterNetEvent('md-houserobberies:server:loseloot', function(item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local itemsell = Player.Functions.GetItemByName(item)

    if itemsell and itemsell.amount > 0 then
        if RemoveItem(item, itemsell.amount) then
            Notifys("You Just Got Robbed of " ..itemsell.amount .." ".. QBCore.Shared.Items[item].label .. "s!", "error")
        end
    end
end)

RegisterNetEvent('md-houserobbery:server:enterHouse', function(house)
    local src = source
    TriggerClientEvent('md-houserobbery:client:enterHouse', src, house)
    Config.Houses[house]['spawned'] = true
    TriggerClientEvent('md-houserobbery:client:setHouseState', -1, house, true)
    Wait(1000 * 60 * Config.HouseTimer)
    Config.Houses[house]['spawned'] = false
    TriggerClientEvent('md-houserobbery:client:setHouseState', -1, house, false)
end)

RegisterNetEvent('md-houserobbery:server:setlootused', function(house, k)
    Config.Houses[house]['loot'][k].taken = true
    TriggerClientEvent('md-houserobbery:client:SetLootState', -1, house, k, true)
    Wait(1000 * 60 * Config.HouseTimer)
    Config.Houses[house]['loot'][k].taken = false
    TriggerClientEvent('md-houserobbery:client:SetLootState', -1, house, k, false)
end)

RegisterNetEvent('md-houserobbery:server:setlootstatebusy', function(house, k,state)
    Config.Houses[house]['loot'][k].busy = state
    TriggerClientEvent('md-houserobbery:client:SetLootStateBusy', -1, house, k, state)
end)

RegisterNetEvent('md-houserobbery:server:closeHouse', function(house)
    Config.Houses[house]['spawned'] = false
    TriggerClientEvent('md-houserobbery:client:setHouseState', -1, house, false)
end)
RegisterNetEvent('md-houserobberies:server:ptfx', function(loc)
TriggerClientEvent('md-housrobberies:client:ptfx', -1, loc)
end)
RegisterNetEvent('md-houserobbery:server:GetLoot', function(tier, rewardtype, objectCoords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    if #(playerCoords - objectCoords) > 3 then return end -- Prevent loot vacuums
    local chance = math.random(1,100)
    local cashamount = math.random(Config.CashMin, Config.CashMax)
    local randomItem = Config.Rewards[tier][rewardtype][math.random(1, #Config.Rewards[tier][rewardtype])]
    local itemInfo = QBCore.Shared.Items[randomItem]
    if Config.EmptyChance <= chance then 
        for k, v in pairs (Config.ItemAmounts) do 
            if k == randomItem then 
                if v == nil then v = 1 end
                AddItem(randomItem, v)
            end  
        end
        if Config.CashChance <= chance then
            Player.Functions.AddMoney('cash', cashamount)
        end
    else
        Notifys("This Isn't Worth Taking", "error") 
    end
end)


