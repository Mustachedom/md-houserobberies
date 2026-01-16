local insideHouse = {}

local function checkDistance(source, coords, dist)
    local src = source
    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    local distance = #(playerCoords - coords)
    if distance > dist then
        Bridge.Prints.Warn(Bridge.Language.Locale('Warn.distanceCheckFail', Bridge.Framework.GetPlayerIdentifier(src)))
        return false
    end
    return true
end

Bridge.Callback.Register('md-houserobberies:server:getLootItems', function(source, loc)
    local src = source
    if not checkDistance(src, fencePeds[loc].coords, 5.0) then
        return false
    end
    return fenceItems
end)

Bridge.Callback.Register('md-houserobberies:server:GetFence', function() return fencePeds end)

RegisterNetEvent('md-houseRobberies:server:sellLoot', function(loc, item)
    local src = source
    if not checkDistance(src, fencePeds[loc].coords, 5.0) then
        return
    end

    local itemCount = ps.getItemCount(src, item)
    if itemCount < 1 then
        Bridge.Notify.SendNotify(src, Bridge.Language.Locale('Error.dontHaveSale', item), 'error')
        return
    end

    if not fenceItems[item] then
        Bridge.Prints.Warn(Bridge.Language.Locale('Warn.fence.wrongItem', Bridge.Framework.GetPlayerIdentifier(src), item))
        return
    end

    if math.random(1, 100) <= fenceItems[item].robChance then
        TriggerClientEvent('md-houseRobberies:client:fenceRobbery', src, loc)
        ps.removeItem(src, item, itemCount)
        Bridge.Notify.SendNotify(src, Bridge.Language.Locale('Error.robbed', ps.getItemLabel(item)), 'error')
        return
    end

    local price = fenceItems[item].price * itemCount
    if ps.removeItem(src, item, itemCount) then
        ps.addMoney(src, 'cash', price)
        return
    end
end)

local function generateLoot(tier, room)
    local lootTable = Rewards[tier][room]
    if not lootTable then return nil end
    local lootItem = lootTable[math.random(1, #lootTable)]
    return lootItem
end

Bridge.Callback.Register('md-houseRobberies:server:getHouses', function()
    return Houses
end)


local function removeHouse(house)
    CreateThread(function()
        Wait(1000 * 60 * 5)
        Houses[house].spawned = false
        Houses[house].busy = false
        for k, v in pairs(Houses[house].loot) do
            Houses[house].loot[k].taken = false
            Houses[house].loot[k].busy = false
        end
        GlobalState.HouseRobbery = Houses
        for k, v in pairs(insideHouse[house]) do
            local getSource = ps.getSource(k)
            TriggerClientEvent('md-houseRobberies:client:forceLeave', getSource, house)
        end
        insideHouse[house] = {}
    end)
end

local function checkproperHouse(src, house)
    local catch = 0
    if not Houses[house] then return false end
    if not checkDistance(src, vector3(Houses[house].coords.x, Houses[house].coords.y, Houses[house].coords.z - 145.0), 20.0) then
        catch = catch + 1
        if not checkDistance(src, Houses[house].coords, 5.0) then
            catch = catch + 1
            return
        end
    end
    if catch == 2 then
        Bridge.Prints.Warn(Bridge.Language.Locale('Warn.faileddistChecks', Bridge.Framework.GetPlayerIdentifier(src)))
        return
    end
    return true
end

RegisterNetEvent('md-houseRobberies:server:busyState', function(house)
    local src = source
    if not Houses[house] then return end
    if not checkproperHouse(src, house) then return end
    Houses[house].busy = not Houses[house].busy
    GlobalState.HouseRobbery = Houses
end)

RegisterNetEvent('md-houseRobberies:server:spawnHouse', function(house)
    local src = source
    if not Houses[house] then return end
    if not checkproperHouse(src, house) then return end
    if Houses[house].spawned then
        return
    end
    Houses[house].spawned = true
    GlobalState.HouseRobbery = Houses
    insideHouse[house][ps.getIdentifier(src)] = house
    removeHouse(house)
end)

RegisterNetEvent('md-houseRobberies:server:enterHouse', function(house)
    local src = source
    if not Houses[house] then return end
    if not checkproperHouse(src, house) then return end
    
    if not Houses[house].spawned then
        return
    end
    insideHouse[house][ps.getIdentifier(src)] = true
end)

RegisterNetEvent('md-houseRobberies:server:leaveHouse', function(house)
    local src = source
    if not Houses[house] then return end
    if not checkproperHouse(src, house) then return end
    if not Houses[house].spawned then
        return
    end
    insideHouse[house][ps.getIdentifier(src)] = nil
end)

RegisterNetEvent('md-houseRobberies:server:takeLoot', function(house, lootKey)
    local src = source
    local home = Houses[house]
    if not home then return end
    if not home.loot[lootKey] then return end
    local houseCoords = vector3(home.coords.x, home.coords.y, home.coords.z - 145.0)
    local objectCoords = vector3(home.loot[lootKey].coords.x, home.loot[lootKey].coords.y, home.loot[lootKey].coords.z)
    local trueLocation = vector3((houseCoords.x + objectCoords.x), (houseCoords.y + objectCoords.y), (houseCoords.z + objectCoords.z))
    local catch = 0
    local reasons = {}
    if not checkDistance(src, trueLocation, 5.0) then
        table.insert(reasons, Bridge.Language.Locale('Warn.takeLootEvent.dist'))
        catch = catch + 1
    end

    if not home.spawned then
        table.insert(reasons, Bridge.Language.Locale('Warn.takeLootEvent.notSpawn'))
        catch = catch + 1
    end

    if not home.loot[lootKey] then
        table.insert(reasons, Bridge.Language.Locale('Warn.takeLootEvent.lootDoesntExist'))
        catch = catch + 1
    end

    if home.loot[lootKey].taken then
        table.insert(reasons, Bridge.Language.Locale('Warn.takeLootEvent.lootTaken'))
        catch = catch + 1
    end

    if not insideHouse[house][ps.getIdentifier(src)] then
        table.insert(reasons, Bridge.Language.Locale('Warn.takeLootEvent.notInside'))
        catch = catch + 1
    end

    if home.loot[lootKey].busy then
        catch = catch + 1
        table.insert(reasons, Bridge.Language.Locale('Warn.takeLootEvent.lootBusy'))
    end

    local copCheck = ps.getJobTypeCount('leo')
    if copCheck < Config.TierData[home.tier].police then
        catch = catch + 1
        table.insert(reasons, Bridge.Language.Locale('Warn.takeLootEvent.notEnoughCops'))
    end

    if catch > 0 then
        Bridge.Prints.Warn(Bridge.Language.Locale('Warn.takeLootEvent.main', Bridge.Framework.GetPlayerIdentifier(src)), table.concat(reasons, ', '))
        return
    end

    local itemGiven = generateLoot(home.tier, home.loot[lootKey].type)
    Bridge.Inventory.AddItem(src, itemGiven.item, itemGiven.amount)
    home.loot[lootKey].taken = true
    home.loot[lootKey].busy = false
    GlobalState.HouseRobbery = Houses
    TriggerClientEvent('md-houseRobberies:client:syncLoot', -1, house, lootKey)
end)

Bridge.Callback.Register('md-houserobberies:server:GetCoppers', function(source, house)
   local src = source
   if not checkDistance(src, Houses[house].coords, 5.0) then
       return -1
   end
   return ps.getJobTypeCount('leo')
end)

RegisterNetEvent('md-houseRobberies:server:lockHouse', function(house)
    local src = source
    local home = Houses[house]
    if not home then return end
    local jobName = Bridge.Framework.GetJobData(src).jobName

    if jobName ~= 'police' then
        Bridge.Notify.SendNotify(src, Bridge.Language.Locale('Warn.lockhouse.notCop'), 'error')
        return
    end
    
    if not checkDistance(src, home.coords, 5.0) then
        Bridge.Notify.SendNotify(src, Bridge.Language.Locale('Warn.lockhouse.dist'), 'error')
        return
    end

    if not home.spawned then
        Bridge.Notify.SendNotify(src, Bridge.Language.Locale('Warn.lockhouse.notSpawn'), 'error')
        return
    end

    home.spawned = false
    home.busy = false
    for k, v in pairs(home.loot) do
        home.loot[k].taken = false
        home.loot[k].busy = false
    end
    GlobalState.HouseRobbery = Houses
    for k, v in pairs(insideHouse[house]) do
        local getSource = ps.getSource(k)
        TriggerClientEvent('md-houseRobberies:client:forceLeave', getSource, house)
    end
end)

RegisterNetEvent('md-houseRobberies:server:smokeBomb', function(house)
    local src = source
    local jobName = Bridge.Framework.GetJobData(src).jobName

    if jobName ~= 'police' then
        Bridge.Notify.SendNotify(src, Bridge.Language.Locale('Warn.lockhouse.notCop'), 'error')
        return
    end

    if not Houses[house] then return end
    if not checkDistance(src, Houses[house].coords, 5.0) then
        Bridge.Notify.SendNotify(src, Bridge.Language.Locale('Warn.lockhouse.dist'), 'error')
        return
    end
    if not Houses[house].spawned then
        Bridge.Notify.SendNotify(src, Bridge.Language.Locale('Warn.lockhouse.notSpawn'), 'error')
        return
    end
    TriggerClientEvent('md-houseRobberies:client:smokeBomb', -1, house)
end)

RegisterNetEvent('md-houseRobberies:server:failMini', function(house)
    local src = source
    if not Houses[house] then return end
    if not checkproperHouse(src, house) then return end

    if not Bridge.Inventory.RemoveItem(src, Config.TierData[Houses[house].tier].robGameItem, 1) then
        Bridge.Prints.Warn(Bridge.Language.Locale('Warn.minigame.failed', Bridge.Framework.GetPlayerIdentifier(src), Config.TierData[Houses[house].tier].robGameItem))
        return
    end
end)

repeat
    Wait(100)
until GlobalState.HouseRobbery
for k, v in pairs(GlobalState.HouseRobbery) do
    insideHouse[k] = {}
end
