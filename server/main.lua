local insideHouse = {}

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

RegisterNetEvent('md-houseRobberies:server:busyState', function(house)
    local src = source
    if not Houses[house] then return end
    local catch = 0
    if not ps.checkDistance(src, vector3(Houses[house].coords.x, Houses[house].coords.y, Houses[house].coords.z - 145.0), 5.0) then
        catch = catch + 1
        if not ps.checkDistance(src, Houses[house].coords, 5.0) then
            catch = catch + 1
            ps.notify(src, 'You are too far from the house', 'error')
            return
        end
    end
    if catch == 2 then
        ps.warn(ps.getPlayerName(src) .. ' Is Trying To Exploit The busyState Event')
        return
    end
    Houses[house].busy = not Houses[house].busy
    GlobalState.HouseRobbery = Houses
end)

RegisterNetEvent('md-houseRobberies:server:spawnHouse', function(house)
    local src = source
    if not Houses[house] then return end
    local catch = 0
    if not ps.checkDistance(src, vector3(Houses[house].coords.x, Houses[house].coords.y, Houses[house].coords.z - 145.0), 5.0) then
        catch = catch + 1
        if not ps.checkDistance(src, Houses[house].coords, 5.0) then
            catch = catch + 1
            ps.notify(src, 'You are too far from the house', 'error')
            return
        end
    end
    if catch == 2 then
        ps.warn(ps.getPlayerName(src) .. ' Is Trying To Exploit The spawn House Event')
        return
    end
    if Houses[house].spawned then
        ps.notify(src, 'This House Is Already Spawned', 'error')
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
    local catch = 0
    if not ps.checkDistance(src, vector3(Houses[house].coords.x, Houses[house].coords.y, Houses[house].coords.z - 145.0), 5.0) then
        catch = catch + 1
        if not ps.checkDistance(src, Houses[house].coords, 5.0) then
            catch = catch + 1
            ps.notify(src, 'You are too far from the house', 'error')
            return
        end
    end
    if catch == 2 then
        ps.warn(ps.getPlayerName(src) .. ' Is Trying To Exploit The Enter House Event')
        return
    end
    if not Houses[house].spawned then
        ps.notify(src, 'This House Is Not Spawned', 'error')
        return
    end
    insideHouse[house][ps.getIdentifier(src)] = true
end)

RegisterNetEvent('md-houseRobberies:server:leaveHouse', function(house)
    local src = source
    if not Houses[house] then return end
    local catch = 0
    if not ps.checkDistance(src, vector3(Houses[house].coords.x, Houses[house].coords.y, Houses[house].coords.z - 145.0), 5.0) then
        catch = catch + 1
        if not ps.checkDistance(src, Houses[house].coords, 5.0) then
            catch = catch + 1
            ps.notify(src, 'You are too far from the house', 'error')
            return
        end
    end
    if catch == 2 then
        ps.warn(ps.getPlayerName(src) .. ' Is Trying To Exploit The Leave House Event')
        return
    end
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
    if copCheck < 1 then
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
