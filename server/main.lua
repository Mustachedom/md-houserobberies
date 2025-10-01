local insideHouse = {}


ps.registerCallback('md-houserobberies:server:getLootItems', function(source, loc)
    local src = source
    if not ps.checkDistance(src, fencePeds[loc].coords, 5.0) then
        return false, "You are too far away"
    end
    return fenceItems
end)

ps.registerCallback('md-houserobberies:server:GetFence', function() return fencePeds end)

RegisterNetEvent('md-houseRobberies:server:sellLoot', function(loc, item)
    local src = source
    if not ps.checkDistance(src, fencePeds[loc].coords, 5.0) then
        return
    end

    local itemCount = ps.getItemCount(src, item)
    if itemCount < 1 then
        ps.notify(src, 'You do not have any ' .. item, 'error')
        return
    end

    if not fenceItems[item] then
        ps.warn(ps.getPlayerName(src) .. ' Is Trying To Exploit The Sell Loot Event | Item: ' .. item)
        return
    end

    if math.random(1, 100) <= fenceItems[item].robChance then
        TriggerClientEvent('md-houseRobberies:client:fenceRobbery', src, loc)
        ps.removeItem(src, item, itemCount)
        ps.notify(src, 'Damn You Just Got Robbed Of All Your ' .. ps.getItemLabel(item), 'error')
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

ps.registerCallback('md-houseRobberies:server:getHouses', function()
    return Houses
end)

for k, v in pairs(GlobalState.HouseRobbery) do
    insideHouse[k] = {}
end

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
    if not ps.checkDistance(src, vector3(Houses[house].coords.x, Houses[house].coords.y, Houses[house].coords.z - 145.0), 5.0) then
        catch = catch + 1
        if not ps.checkDistance(src, Houses[house].coords, 5.0) then
            catch = catch + 1
            return
        end
    end
    if catch == 2 then
        ps.warn(ps.getPlayerName(src) .. ' Is Trying To Exploit The MD HouseRobbery Event', 'Failed 2 Checks on location for front door and exit door')
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
        ps.notify(src, 'This House Is Not Spawned', 'error')
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
    if not ps.checkDistance(src, trueLocation, 5.0) then
        table.insert(reasons, 'too far from the house')
        catch = catch + 1
    end

    if not home.spawned then
        table.insert(reasons, 'This House Is Not Spawned')
        catch = catch + 1
    end

    if not home.loot[lootKey] then
        table.insert(reasons, 'This Loot Does Not Exist')
        catch = catch + 1
    end

    if home.loot[lootKey].taken then
        table.insert(reasons, 'This Loot Has Already Been Taken')
        catch = catch + 1
    end

    if not insideHouse[house][ps.getIdentifier(src)] then
        table.insert(reasons, 'You Are Not Inside The House')
        catch = catch + 1
    end

    if home.loot[lootKey].busy then
        catch = catch + 1
        table.insert(reasons, 'This Loot Is Not Being Robbed')
    end

    local copCheck = ps.getJobTypeCount('leo')
    if copCheck < Config.TierData[home.tier].police then
        catch = catch + 1
        table.insert(reasons, 'Not Enough Cops To Do This')
    end

    if catch > 0 then
        ps.debug(ps.getPlayerName(src) .. ' Is Trying To Exploit The Take Loot Event | Reasons: ', reasons)
        return
    end

    local itemGiven = generateLoot(home.tier, home.loot[lootKey].type)
    ps.addItem(src, itemGiven.item, itemGiven.amount)
    home.loot[lootKey].taken = true
    home.loot[lootKey].busy = false
    GlobalState.HouseRobbery = Houses
    TriggerClientEvent('md-houseRobberies:client:syncLoot', -1, house, lootKey)
end)

ps.registerCallback('md-houserobberies:server:GetCoppers', function(source, house)
   local src = source
   if not ps.checkDistance(src, Houses[house].coords, 5.0) then
       return -1
   end
   return ps.getJobTypeCount('leo')
end)

RegisterNetEvent('md-houseRobberies:server:lockHouse', function(house)
    local src = source
    local home = Houses[house]
    if not home then return end
    local jobType = ps.getJobType(src)

    if jobType ~= 'leo' then
        ps.notify(src, 'You are not a cop', 'error')
        return
    end
    if not ps.checkDistance(src, home.coords, 5.0) then
        ps.notify(src, 'You are too far from the house', 'error')
        return
    end

    if not home.spawned then
        ps.notify(src, 'This House Is Not Spawned', 'error')
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
    local jobType = ps.getJobType(src)

    if jobType ~= 'leo' then
        ps.notify(src, 'You are not a cop', 'error')
        return
    end

    if not Houses[house] then return end
    if not ps.checkDistance(src, Houses[house].coords, 5.0) then
        ps.notify(src, 'You are too far from the house', 'error')
        return
    end
    if not Houses[house].spawned then
        ps.notify(src, 'This House Is Not Spawned', 'error')
        return
    end
    TriggerClientEvent('md-houseRobberies:client:smokeBomb', -1, house)
end)

RegisterNetEvent('md-houseRobberies:server:failMini', function(house)
    local src = source
    if not Houses[house] then return end
    if not checkproperHouse(src, house) then return end

    if not ps.removeItem(src, Config.TierData[Houses[house].tier].robGameItem, 1) then
        ps.warn(ps.getPlayerName(src) .. ' Is Trying To Exploit The Fail Mini Event | Does Not Have The Required Item But Had It On Client Check: ', Config.TierData[Houses[house].tier].robGameItem)
        return
    end
end)