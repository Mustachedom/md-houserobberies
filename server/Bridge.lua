local QBCore = exports['qb-core']:GetCoreObject()
local notify = Config.Notify

local logs = false
local logapi = GetConvar("fivemerrLogs", "")
local endpoint = 'https://api.fivemerr.com/v1/logs'
local headers = {
    ['Authorization'] = logapi,
    ['Content-Type'] = 'application/json',
}

CreateThread(function()
    if logs then
        print('^2 Logs Enabled for md-houserobberies')
        if not logapi then
            print('^1 homie you gotta set your api in your server.cfg')
        else
            print('^2 API Key Looks Good, Dont Trust Me Though, Im Not Smart')
        end
    else
        print('^1 logs disabled for md-drugs')
    end
end)

function Log(message, type)
    if not logs then return end
    local buffer = {
        level = "info",
        message = message,
        resource = GetCurrentResourceName(),
        metadata = {
            drugs = type,
            playerid = source
        }
    }
    SetTimeout(500, function()
        PerformHttpRequest(endpoint, function(status, _, _, response)
            if status ~= 200 and type(response) == 'string' then
                response = json.decode(response) or response
            end
        end, 'POST', json.encode(buffer), headers)
        buffer = nil
    end)
end

local invname = ''
CreateThread(function()
    if GetResourceState('ps-inventory') == 'started' then
        invname = 'ps-inventory'
    elseif GetResourceState('qb-inventory') == 'started' then
        invname = 'qb-inventory'
    else
        invname = 'inventory'
    end
end)

local inventory = ''
CreateThread(function()
    if GetResourceState('ox_inventory') == 'started' then
        inventory = 'ox'
    else
        inventory = 'qb'
    end
end)

function Notifys(source, text, type)
    if notify == 'qb' then
        TriggerClientEvent("QBCore:Notify", source, text, type)
    elseif notify == 'ox' then
        lib.notify(source, { title = text, type = type })
    elseif notify == 'okok' then
        TriggerClientEvent('okokNotify:Alert', source, '', text, 4000, type, false)
    else
        print("^1 Look At The Config For Proper Alert Options")
    end
end

function GetLabels(item)
    if inventory == 'qb' then
        return QBCore.Shared.Items[item].label
    elseif inventory == 'ox' then
        local items = exports.ox_inventory:Items()
        return items[item].label
    end
end

function Itemcheck(source, item, amount)
    if inventory == 'qb' then
        local Player = QBCore.Functions.GetPlayer(source)
        local itemchecks = Player.Functions.GetItemByName(item)
        if itemchecks and itemchecks.amount >= amount then
            return true
        else
            Notifys(source, 'You Need ' .. amount .. ' Of ' .. GetLabels(item) .. ' To Do this', 'error')
            return false
        end
    elseif inventory == 'ox' then
        local has = exports.ox_inventory:GetItem(source, item, nil, true)
        if has.count >= amount then
            return true
        else
            Notifys(source, 'You Need ' .. amount .. ' Of ' .. GetLabels(item) .. ' To Do This', 'error')
            return false
        end
    end
end

function GetCoords(source)
    local ped = GetPlayerPed(source)
    return GetEntityCoords(ped)
end

function dist(source, coords)
    local playerPed = GetPlayerPed(source)
    return #(GetEntityCoords(playerPed) - coords)
end

function CheckDist(source, coords)
    local playerPed = GetPlayerPed(source)
    local pcoords = GetEntityCoords(playerPed)
    print(pcoords, coords, #(pcoords - coords))
    if #(pcoords - coords) < 4.0 then
        return true
    else
        DropPlayer(source, 'md-houseRobberies: You Were A Total Of ' .. #(pcoords - coords) .. ' Too Far Away To Trigger This Event')
        return false
    end
end

function checkTable(tbl)
    local need, have = 0, 0
    for k, v in pairs(tbl) do
        need = need + 1
        if Itemcheck(source, k, v) then
            have = have + 1
        end
    end
    return need == have
end

function RemoveItem(source, item, amount)
    if inventory == 'qb' then
        local Player = QBCore.Functions.GetPlayer(source)
        if Player.Functions.RemoveItem(item, amount) then
            TriggerClientEvent(invname .. ":client:ItemBox", source, QBCore.Shared.Items[item], "remove", amount)
            return true
        else
            Notifys(source, 'You Need ' .. amount .. ' Of ' .. GetLabels(item) .. ' To Do This', 'error')
        end
    elseif inventory == 'ox' then
        if exports.ox_inventory:RemoveItem(source, item, amount) then
            return true
        else
            Notifys(source, 'You Need ' .. amount .. ' Of ' .. GetLabels(item) .. ' To Do This', 'error')
        end
    end
end

function AddItem(source, item, amount)
    if inventory == 'qb' then
        local Player = QBCore.Functions.GetPlayer(source)
        if Player.Functions.AddItem(item, amount) then
            TriggerClientEvent(invname .. ":client:ItemBox", source, QBCore.Shared.Items[item], "add", amount)
            return true
        else
            print('Failed To Give Item: ' .. item .. ' Check Your qb-core/shared/items.lua')
            return false
        end
    else
        if not exports.ox_inventory:CanCarryItem(source, item, amount) then
            Notifys(source, 'You Cant Carry that Much Weight!', 'error')
            return false
        end
        if exports.ox_inventory:AddItem(source, item, amount) then
            return true
        else
            print('Failed To Give Item: ' .. item .. ' Check Your ox_inventory/data/items.lua')
            return false
        end
    end
end

function GetName(source)
    local Player = QBCore.Functions.GetPlayer(source)
    return Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
end

function ChecknRemove(source, tbl)
    local Player = QBCore.Functions.GetPlayer(source)
    local hass, need = 0, 0
    for k, v in pairs(tbl) do
        need = need + 1
        if inventory == 'qb' then
            local itemchecks = Player.Functions.GetItemByName(k)
            if itemchecks and itemchecks.amount >= v then
                hass = hass + 1
            else
                Notifys(source, 'You Need ' .. v .. ' Of ' .. GetLabels(k) .. ' To Do this', 'error')
            end
        elseif inventory == 'ox' then
            local has = exports.ox_inventory:GetItem(source, k, nil, true)
            if has.count >= v then
                hass = hass + 1
            else
                Notifys(source, 'You Need ' .. v .. ' Of ' .. GetLabels(k) .. ' To Do This', 'error')
            end
        end
    end
    if hass == need then
        for k, v in pairs(tbl) do
            RemoveItem(source, k, v)
        end
        return true
    else
        return false
    end
end

lib.callback.register('md-houserobberies:server:GetCoppers', function(source, cb, args)
    local amount = 0
    local players = QBCore.Functions.GetQBPlayers()
    for _, v in pairs(players) do
        if v.PlayerData.job.type == 'leo' and v.PlayerData.job.onduty then
            amount = amount + 1
        end
    end
    return amount
end)

function dist(source, Player, coords)
    return #(GetEntityCoords(Player) - coords)
end

CreateThread(function()
    if not GetResourceState('ox_lib'):find("start") then
        print('^1 ox_lib Is A Depndancy, Not An Optional ')
    end
end)

CreateThread(function()
    local url = "https://raw.githubusercontent.com/Mustachedom/md-houserobberies/main/version.txt"
    local version = GetResourceMetadata('md-houserobberies', "version")
    PerformHttpRequest(url, function(err, text, headers)
        if text then
            print('^2 Your Version:' .. version .. ' | Current Version:' .. text)
        end
    end, "GET", "", "")
end)
