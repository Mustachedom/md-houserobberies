local QBCore = exports['qb-core']:GetCoreObject()

-- Functions

local function ResetHouseStateTimer(house)
    CreateThread(function()
        Wait(Config.HouseTimer * 60000)
        Config.Houses[house].spawned = false
        TriggerClientEvent('qb-houserobbery:client:ResetHouseState', -1, house)
    end)
end
local function Resetobject(house)
    CreateThread(function()
        Wait(Config.HouseTimer * 60000)
         Config.Houses[house]['loot'].taken = false
        TriggerClientEvent('md-houserobbery:client:ResetHouseState', -1, house, k, false)
    end)
end

-- Callbacks
RegisterNetEvent('md-houserobbery:server:accessbreak', function(tier)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local luck = math.random(1,100)
    if tier <= 4 then 
        if luck <= 20 then 
            Player.Functions.RemoveItem('lockpick', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['lockpick'], "remove")
        end
    elseif tier == 5 then 
        if luck <= 45 then 
            Player.Functions.RemoveItem('houselaptop', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['houselaptop'], "remove")
        end
    else
        if luck <= 85 then 
            Player.Functions.RemoveItem('mansionlaptop', 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['mansionlaptop'], "remove")
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
        if   Player.Functions.RemoveItem(itemName, itemsell.amount) then
            Player.Functions.AddMoney('cash', price * itemsell.amount)
              TriggerClientEvent('QBCore:Notify', src, "You received " .. itemsell.amount * price .. " of Cash.", "success")
        end
    end
end)

RegisterNetEvent('md-houserobberies:server:loseloot', function(item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local itemsell = Player.Functions.GetItemByName(item)

    if itemsell and itemsell.amount > 0 then
        if Player.Functions.RemoveItem(item, itemsell.amount) then
              TriggerClientEvent('QBCore:Notify', src, "You Just Got Robbed of " ..itemsell.amount .." ".. QBCore.Shared.Items[item].label .. "s!", "error")
        end
    end
end)

QBCore.Functions.CreateCallback('md-houserobbery:server:GetHouseConfig', function(_, cb)
    cb(Config.Houses)
end)

-- Events
RegisterNetEvent('md-houserobbery:server:closeHouse', function(house)
    TriggerClientEvent('md-houserobbery:client:ResetHouseState', -1, house)
end)    
RegisterNetEvent('md-houserobbery:server:SetBusyState', function(lootspot, house, bool)
    Config.Houses[house]['loot'][lootspot] = bool
    TriggerClientEvent('md-houserobbery:client:SetBusyState', -1, lootspot, house, bool)
end)

RegisterNetEvent('md-houserobbery:server:enterHouse', function(house)
    local src = source
    if not Config.Houses[house]['spawned'] then
        ResetHouseStateTimer(house)
        TriggerClientEvent('md-houserobbery:client:setHouseState', -1, house, true)
    end
    TriggerClientEvent('md-houserobbery:client:enterHouse', src, house)
    Config.Houses[house]['spawned'] = true
end)

RegisterNetEvent('md-houserobbery:server:setlootused', function(house, k)
    local src = source 
    if not Config.Houses[house]['loot'][k].taken then
        Resetobject(house)
        TriggerClientEvent('md-houserobbery:client:SetLootState', -1, house, k, true)
    end
    Config.Houses[house]['loot'][k].taken = true
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
                    Player.Functions.AddItem(randomItem, v)
                    TriggerClientEvent("inventory:client:ItemBox", src, itemInfo, "add",  v)
            end  
        end
        if Config.CashChance <= chance then
            Player.Functions.AddMoney('cash', cashamount)
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "This Isn't Worth Taking", "error") 
    end   
end)


