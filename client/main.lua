local QBCore = exports['qb-core']:GetCoreObject()
local houseObj = {}
local CurrentCops = 0

local function loadParticle(dict)
    lib.requestNamedPtfxAsset(dict, 1000)
    SetPtfxAssetNextCall(dict)
end

local function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(5) end
end

local function openHouseAnim()
    loadAnimDict('anim@heists@keycard@')
    TaskPlayAnim(PlayerPedId(), 'anim@heists@keycard@', 'exit', 5.0, 1.0, -1, 16, 0, 0, 0, 0)
    Wait(400)
    ClearPedTasks(PlayerPedId())
end

local function getShellFunction(tier)
    local shells = {
        [1] = 'CreateCaravanShell',
        [2] = 'CreateLesterShell',
        [3] = 'CreateTrevorsShell',
        [4] = 'CreateHouseRobbery',
        [5] = 'CreateFurniMotelModern',
        [6] = 'CreateMichael'
    }
    return shells[tier]
end

local function enterRobberyHouse(house)
    local home = Config.Houses[house]
    TriggerServerEvent('InteractSound_SV:PlayOnSource', 'houses_door_open', 0.25)
    openHouseAnim()
    Wait(250)
    local coords = {
        x = home.coords.x,
        y = home.coords.y,
        z = home.coords.z - 145.0
    }
    local shellFunc = getShellFunction(home.tier)
    local data = shellFunc and exports['qb-interior'][shellFunc](coords) or nil

    for k, v in pairs(home.loot) do
        lib.requestModel(v.prop, 10000)
        if not v.taken then
            local objectCoords = vector3(coords.x + v.coords.x, coords.y + v.coords.y, coords.z + v.coords.z)
            k = CreateObject(v.prop, objectCoords.x, objectCoords.y, objectCoords.z, false, false, false)
            SetEntityHeading(k, v.rotation or 180.0)
            FreezeEntityPosition(k, true)
            TriggerEvent('md-houserobbery:client:deleteobject', k)
            AddSingleModel(k, {
                name = 'StealLoot',
                icon = "fas fa-sign-in-alt",
                label = "Steal Loot",
                action = function()
                    TriggerServerEvent('md-houserobbery:server:setlootstatebusy', house, v.num, true)
                    if not progressbar("Stealing", math.random(Config.MinRobTime, Config.MaxRobTime), 'uncuff') then return end
                    if not minigame(home.tier) then
                        Notify("This Nerd Failed", "error")
                        TriggerServerEvent('md-houserobbery:server:setlootstatebusy', house, v.num, false)
                        return
                    end
                    DeleteObject(k)
                    TriggerServerEvent('md-houserobbery:server:setlootused', house, v.num)
                    TriggerServerEvent('md-houserobbery:server:GetLoot', home.tier, v.type, objectCoords)
                    TriggerServerEvent('md-houserobbery:server:setlootstatebusy', house, v.num, false)
                end,
                canInteract = function()
                    return not v.taken and not v.busy
                end
            }, k)
        end
    end

    houseObj = data and data[1] or nil
    Wait(500)
    TriggerEvent('qb-weathersync:client:DisableSync')
    Wait(1000 * 60 * Config.HouseTimer)
    exports['qb-interior']:DespawnInterior(houseObj, function()
        if #(GetEntityCoords(PlayerPedId()) - vector3(coords.x, coords.y, coords.z)) <= 15.0 then
            SetEntityCoords(PlayerPedId(), home.coords)
        end
    end)
end

RegisterNetEvent('md-houserobbery:client:deleteobject', function(k, house)
    Wait(1000 * 60 * Config.HouseTimer)
    DeleteObject(k)
end)

RegisterNetEvent('md-houserobbery:client:enterHouse', function(house)
    enterRobberyHouse(house)
end)

RegisterNetEvent('md-houserobbery:client:setHouseState', function(house, state)
    Config.Houses[house].spawned = state
end)

RegisterNetEvent('md-houserobbery:client:SetLootState', function(house, k, state)
    Config.Houses[house].loot[k].taken = state
end)

RegisterNetEvent('md-houserobbery:client:SetLootStateBusy', function(house, k, state)
    Config.Houses[house].loot[k].busy = state
end)

RegisterNetEvent('md-housrobberies:client:ptfx', function(loc)
    local dict = "scr_ba_bb"
    loadParticle(dict)
    local smoke = StartParticleFxLoopedAtCoord('scr_ba_bb_plane_smoke_trail', loc.x, loc.y, loc.z - 145.0, 0, 0, 0, 3.0, 0, 0, 0)
    SetParticleFxLoopedAlpha(smoke, 1.0)
    Wait(20000)
    StopParticleFxLooped(smoke, true)
end)

CreateThread(function()
    for k, v in pairs(Config.Houses) do
        local labeltext = Config.DebugHouseNumber and ("break in " .. k .. "!") or "Break In"
        AddBoxZoneMultiOptions('breakin' .. k, v.coords, {
            {
                name = 'renterhouse',
                icon = "fas fa-sign-in-alt",
                label = "Re-Enter House",
                action = function() enterRobberyHouse(k) end,
                onSelect = function() enterRobberyHouse(k) end,
                canInteract = function() return Config.Houses[k].spawned end
            },
            {
                name = 'makesmoke',
                icon = "fas fa-sign-in-alt",
                label = "Throw Smoke Grenade",
                action = function()
                    if not progressbar("Throwing A Smoke Grenade", 4000, 'uncuff') then return end
                    TriggerServerEvent('md-houserobberies:server:ptfx', Config.Houses[k].coords)
                end,
                onSelect = function()
                    if not progressbar("Throwing A Smoke Grenade", 4000, 'uncuff') then return end
                    TriggerServerEvent('md-houserobberies:server:ptfx', Config.Houses[k].coords)
                end,
                canInteract = function()
                    return Config.Houses[k].spawned and QBCore.Functions.GetPlayerData().job.type == 'leo'
                end
            },
            {
                name = 'lockup',
                icon = "fas fa-sign-in-alt",
                label = "Lock The House Down",
                action = function()
                    if not progressbar("Locking Up The House", math.random(3000, 6000), 'uncuff') then return end
                    TriggerServerEvent('md-houserobbery:server:closeHouse', k)
                end,
                onSelect = function()
                    if not progressbar("Locking Up The House", math.random(3000, 6000), 'uncuff') then return end
                    TriggerServerEvent('md-houserobbery:server:closeHouse', k)
                end,
                canInteract = function()
                    return Config.Houses[k].spawned and QBCore.Functions.GetPlayerData().job.type == 'leo'
                end
            },
            {
                name = 'LockPickHouse',
                icon = "fas fa-sign-in-alt",
                label = labeltext,
                onSelect = function() BreakIn(k) end,
                action = function() BreakIn(k) end,
                canInteract = function()
                    return not Config.Houses[k].spawned and QBCore.Functions.GetPlayerData().job.type ~= 'leo'
                end
            }
        })
        local loc = vector3(
            v.coords.x + Config.OffSet[v.tier].x,
            v.coords.y + Config.OffSet[v.tier].y,
            v.coords.z + Config.OffSet[v.tier].z - 145
        )
        AddBoxZoneSingle('leavehouse' .. k, loc, {
            name = 'leaverobbery',
            icon = "fas fa-sign-in-alt",
            label = "Leave Robbery House",
            action = function() SetEntityCoords(PlayerPedId(), v.coords) end
        })
    end
end)

CreateThread(function()
    local chance = math.random(1, 100)
    local current = "g_m_y_famdnf_01"
    lib.requestModel(current, 10000)
    local CurrentLocation = Config.FenceSpawn
    local blackmarket = CreatePed(0, current, CurrentLocation.x, CurrentLocation.y, CurrentLocation.z - 1, CurrentLocation.w, false, false)
    Freeze(blackmarket, true, CurrentLocation.w)
    local weapon = chance <= 50 and Config.FenceWeaponone or Config.FenceWeapontwo
    GiveWeaponToPed(blackmarket, weapon, 1, false, true)
    AddSingleModel(blackmarket, {
        label = "Robbery Fence",
        icon = "fas fa-eye",
        event = "md-houserobberies:client:openblackmarket"
    }, blackmarket)
end)

RegisterNetEvent("md-houserobberies:client:openblackmarket", function(data)
    local blackmarketmenu, notify = {}, 0
    for k, v in pairs(Config.BlackMarket) do
        if QBCore.Functions.HasItem(v.item) then
            notify = 1
            local entry = {
                icon = GetImage(v.item),
                header = GetLabel(v.item),
                title = GetLabel(v.item),
                description = "$" .. v.minvalue .. "  -  $" .. v.maxvalue,
                event = "md-houserobberies:client:sellloot",
                args = {
                    item = v.item,
                    min = v.minvalue,
                    max = v.maxvalue,
                    success = v.successchance
                }
            }
            if Config.Oxmenu then
                blackmarketmenu[#blackmarketmenu + 1] = entry
                lib.registerContext({ id = 'blackmarketmd', title = "Black Market", options = blackmarketmenu })
            else
                blackmarketmenu[#blackmarketmenu + 1] = {
                    icon = GetImage(v.item),
                    header = GetLabel(v.item),
                    txt = "$" .. v.minvalue .. "  -  $" .. v.maxvalue,
                    params = {
                        event = "md-houserobberies:client:sellloot",
                        args = {
                            item = v.item,
                            min = v.minvalue,
                            max = v.maxvalue,
                            success = v.successchance
                        }
                    }
                }
            end
        end
    end
    if Config.Oxmenu then
        lib.showContext('blackmarketmd')
    else
        exports['qb-menu']:openMenu(blackmarketmenu)
    end
    if notify == 0 then
        Notify("Nothing To Sell", 'error')
    end
end)

RegisterNetEvent("md-houserobberies:client:sellloot", function(data)
    local chance = math.random(1, 100)
    if data.success >= chance then
        TriggerServerEvent('md-houserobberies:server:sellloot', data.item)
    else
        TriggerServerEvent('md-houserobberies:server:loseloot', data.item)
    end
end)

