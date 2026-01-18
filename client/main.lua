local loot = {}

if not GlobalState.HouseRobbery then
    repeat
        Wait(100)
    until GlobalState.HouseRobbery
end
for k, v in pairs(GlobalState.HouseRobbery) do
    loot[k] = {}
end

local function requestModel(model, timeout)
    local modelHash =  GetHashKey(model)
    if not HasModelLoaded(modelHash) then
        RequestModel(modelHash)
        local start = GetGameTimer()
        while not HasModelLoaded(modelHash) do
            Wait(10)
            if GetGameTimer() - start >= timeout then
                return false
            end
        end
    end
    return true
end

local function spawnLoot(house)
    for lootKey, value in pairs (GlobalState.HouseRobbery[house].loot) do
        if value.taken then goto continue end
        local houseCoords = GlobalState.HouseRobbery[house].coords
        local coords = vector3(houseCoords.x, houseCoords.y, houseCoords.z - 145.0)
        local tier = GlobalState.HouseRobbery[house].tier
        requestModel(value.prop, 10000)
        local newCoords = vector3(coords.x + value.coords.x, coords.y + value.coords.y, coords.z + value.coords.z)
        loot[house][#loot[house]+1] = CreateObject(value.prop, newCoords.x, newCoords.y, newCoords.z, false, false, false)
        Freeze(loot[house][#loot[house]], true, value.rotation)
        Bridge.Target.AddLocalEntity(loot[house][#loot[house]], {
            {
                label = Bridge.Language.Locale('Targets.search', value.type),
                icon = Bridge.Language.Locale('Targets.searchIcon'),
                action = function()
                    TriggerServerEvent('md-houseRobberies:server:busyLoot', house, lootKey)
                    if not minigame(Config.TierData[tier].robGame) then
                        TriggerServerEvent('md-houseRobberies:server:busyLoot', house, lootKey)
                        return
                    end
                    if not progressbar(Bridge.Language.Locale('Progress.searching'), Config.TierData[tier].progressbarRob, 'uncuff') then
                        TriggerServerEvent('md-houseRobberies:server:busyLoot', house, lootKey)
                        return
                    end
                    TriggerServerEvent('md-houseRobberies:server:takeLoot', house, lootKey)
                end,
                canInteract = function()
                    if  GlobalState.HouseRobbery[house].loot[lootKey].taken then
                        return false
                    end
                    if GlobalState.HouseRobbery[house].loot[lootKey].busy then
                        return false
                    end
                    local job = Bridge.Framework.GetPlayerJob()
                    if job == 'police' or job == 'ambulance' then
                        return false
                    end
                    return true
                end,
            }
        })
        ::continue::
    end
end

local function beATotalAsshole(ped)
    local timeout = 1000 * 60 * 5
    CreateThread(function()
        repeat
            TaskCombatPed(ped, PlayerPedId(), 0, 16)
            Wait(1000)
            timeout = timeout - 1
        until timeout == 0 or IsEntityDead(ped)
        if DoesEntityExist(ped) and not IsEntityDead(ped) then
            DeleteEntity(ped)
        end
        if DoesEntityExist(ped) and IsEntityDead(ped) then
            Bridge.Target.AddLocalEntity(ped, {
                {
                    label = Bridge.Language.Locale('Targets.hideBody'),
                    icon = Bridge.Language.Locale('Targets.hideBodyIcon'),
                    action = function()
                        if not progressbar(Bridge.Language.Locale('Progress.hidingBody'), 5000, 'uncuff') then
                            return
                        end
                        if DoesEntityExist(ped) then
                            DeleteEntity(ped)
                        end
                    end,
                }
            })
        end
    end)
end

local function spawnPed(coords, tier)
    local pedData = Config.TierData[tier].ped
    local loc = pedData.loc

    requestModel(pedData.pedModel, 10000)
    local ped = CreatePed(4, pedData.pedModel, coords.x + loc.x, coords.y + loc.y, coords.z + loc.z, 0.0, false, false)
    GiveWeaponToPed(ped, pedData.weapon, 255, false, true)
    beATotalAsshole(ped)
end

local function spawnHouse(tier, coords, house, bool)
    local loc = vector3(coords.x, coords.y, coords.z - 145.0)
    local houseData = Config.TierData[tier].export.func(loc)

    CreateThread(function()
        Wait(1000 * 60 * 5)
        Config.TierData[tier].export.despawn(houseData, function()
            TriggerServerEvent('md-houseRobberies:server:houseClosed', house)
        end)
    end)
    if bool then
        if Config.TierData[tier].ped.chance >= math.random(1,100) then
            spawnPed(loc, tier)
        end
    end
    return houseData
end

local function initTargets()
    for k, v in pairs(GlobalState.HouseRobbery) do
        local off = Config.TierData[v.tier].offset
        Bridge.Target.AddBoxZone('mdhouseRob'..k, v.coords, vector3(1.0, 1.0, 2.0), v.coords.w or 180.0, {
            {
                label = Bridge.Language.Locale('Targets.robHouse'),
                icon = Bridge.Language.Locale('Targets.robHouseIcon'),
                action = function()
                    TriggerServerEvent('md-houseRobberies:server:busyState', k)

                    local copCheck = Bridge.Callback.Trigger('md-houserobberies:server:GetCoppers', k)
                    if copCheck < Config.TierData[v.tier].police then
                        Bridge.Notify.SendNotify(Bridge.Language.Locale('Error.notEnoughCops'), 'error')
                        TriggerServerEvent('md-houseRobberies:server:busyState', k)
                        return
                    end

                    PoliceCall(Config.TierData[v.tier].policeCallChance)

                    if not Bridge.Inventory.HasItem(Config.TierData[v.tier].breakInItem) then
                        Bridge.Notify.SendNotify(Bridge.Language.Locale('Error.dontHaveItem', Config.TierData[v.tier].breakInItem), 'error')
                        TriggerServerEvent('md-houseRobberies:server:busyState', k)
                        return
                    end

                    if not minigame(Config.TierData[v.tier].breakInGame) then
                        TriggerServerEvent('md-houseRobberies:server:busyState', k)
                        TriggerServerEvent('md-houseRobberies:server:failMini', k)
                        return
                    end

                    TriggerServerEvent('md-houseRobberies:server:spawnHouse', k)
                    TriggerServerEvent('md-houseRobberies:server:busyState', k)
                    spawnHouse(v.tier, v.coords, k, true)
                    spawnLoot(k)
                end,
                canInteract = function()
                    if not GlobalState.HouseRobbery[k] then
                        return false
                    end
                    local jobName = Bridge.Framework.GetPlayerJob()
                    if jobName == 'police' or jobName == 'ambulance' then
                        return false
                    end
                    if GlobalState.HouseRobbery[k].busy then
                        return false
                    end
                    if GlobalState.HouseRobbery[k].spawned then
                        return false
                    end
                    return true
                end,
            },
            {
                label = Bridge.Language.Locale('Targets.enterHome'),
                icon = Bridge.Language.Locale('Targets.enterHomeIcon'),
                action = function()
                    TriggerServerEvent('md-houseRobberies:server:enterHouse', k)
                    spawnHouse(v.tier, v.coords, k, false)
                    spawnLoot(k)
                end,
                canInteract = function()
                    if GlobalState.HouseRobbery[k].spawned then
                        return true
                    end
                    return false
                end,
            },
            {
                label = Bridge.Language.Locale('Targets.lockDoor'),
                icon = Bridge.Language.Locale('Targets.lockDoorIcon'),
                action = function()
                    TriggerServerEvent('md-houseRobberies:server:busyState', k)
                    TriggerServerEvent('md-houseRobberies:server:lockHouse', k)
                    TriggerServerEvent('md-houseRobberies:server:busyState', k)
                end,
                canInteract = function()
                    if not GlobalState.HouseRobbery[k].spawned then
                        return false
                    end
                    local job = Bridge.Framework.GetPlayerJob()
                    if job ~= 'police' then
                        return false
                    end
                    return true
                end,
            },
        })
        Bridge.Target.AddBoxZone('mdHRexit'..k, vector3(v.coords.x + off.x, v.coords.y + off.y, v.coords.z + off.z - 145.0), vector3(1.0, 1.0, 2.0), v.coords.w or 180.0, {
            {
                label = Bridge.Language.Locale('Targets.leaveHouse'),
                icon = Bridge.Language.Locale('Targets.leaveHouseIcon'),
                action = function()
                    SetEntityCoords(PlayerPedId(), v.coords)
                    for i = 1, #loot[k] do
                        if DoesEntityExist(loot[k][i]) then
                            DeleteEntity(loot[k][i])
                        end
                    end
                    loot[k] = {}
                    TriggerServerEvent('md-houseRobberies:server:leaveHouse', k)
                end,
            }
        })
    end
end

initTargets()

RegisterNetEvent('md-houseRobberies:client:forceLeave', function(house)
    local coords = vector3(GlobalState.HouseRobbery[house].coords.x, GlobalState.HouseRobbery[house].coords.y, GlobalState.HouseRobbery[house].coords.z - 145.0)
    if #(GetEntityCoords(PlayerPedId()) - coords) <= 30.0 then
        SetEntityCoords(PlayerPedId(), GlobalState.HouseRobbery[house].coords)
    end
    for i = 1, #loot[house] do
        if DoesEntityExist(loot[house][i]) then
            DeleteEntity(loot[house][i])
        end
    end
    loot[house] = {}
end)

RegisterNetEvent('md-houseRobberies:client:syncLoot', function(house, lootKey)
    if DoesEntityExist(loot[house][lootKey]) then
        DeleteEntity(loot[house][lootKey])
    end
end)

local peds = {}

local function spawnFence()
    local fence = GlobalState.MDHouseRobberyFence.fencePeds
    for k, v in pairs (fence) do
        requestModel(v.ped, 10000)
        peds[#peds+1] = CreatePed(4, v.ped, v.coords.x, v.coords.y, v.coords.z, v.coords.w, false, false)
        SetEntityInvincible(peds[#peds], true)
        FreezeEntityPosition(peds[#peds], true)
        GiveWeaponToPed(peds[#peds], 'weapon_pistol', 255, false, true)
        Bridge.Target.AddLocalEntity(peds[#peds], {
            {
                label = Bridge.Language.Locale('Targets.sellLoot'),
                icon = Bridge.Language.Locale('Targets.sellLootIcon'),
                distance = 2.0,
                action = function()
                    local menu = {}
                    for item, values in pairs(GlobalState.MDHouseRobberyFence.fenceItems) do
                        if Bridge.Inventory.HasItem(item) then
                            local itemInfo = Bridge.Inventory.GetItemInfo(item)
                            menu[#menu+1] = {
                                title = itemInfo.label,
                                icon =  itemInfo.image,
                                description = Bridge.Language.Locale('Info.currency') .. values.price,
                                onSelect = function()
                                    TriggerServerEvent('md-houseRobberies:server:sellLoot', k, item)
                                end
                            }
                        end
                    end
                    if #menu < 1 then
                        Bridge.Notify.SendNotify(Bridge.Language.Locale('Error.dontHaveLoot'), 'error')
                        return
                    end
                    Bridge.Menu.Open({
                        id='fenceMenu',
                        title= Bridge.Language.Locale('Menu.fence'),
                        options=menu
                    })
                end,
            }
        })
    end
end

spawnFence()

RegisterNetEvent('md-houseRobberies:client:fenceRobbery', function(loc)
    TaskTurnPedToFaceEntity(peds[loc], PlayerPedId(), 1.0)
    TaskAimGunAtEntity(peds[loc], PlayerPedId(), 5000, true)
    TaskTurnPedToFaceEntity(PlayerPedId(), peds[loc], 1.0)
    Bridge.Anim.RequestDict('missminuteman_1ig_2', 10000)
    TaskPlayAnim(PlayerPedId(), 'missminuteman_1ig_2', 'handsup_base', 8.0, -8.0, -1, 49, 0, false, false, false)
    Wait(3000)
    ClearPedTasks(peds[loc])
    StopAnimTask(PlayerPedId(),'missminuteman_1ig_2', 'handsup_base', 1.0)
    ClearPedTasks(PlayerPedId())
    Bridge.Anim.RequestDict('melee@pistol@streamed_fps', 10000)
    TaskPlayAnim(peds[loc], 'melee@pistol@streamed_fps', 'pistol_idle_whip', 8.0, -8.0, -1, 49, 0, false, false, false)
    Wait(500)
    StopAnimTask(peds[loc],'melee@pistol@streamed_fps', 'pistol_idle_whip', 1.0)
    ClearPedTasks(peds[loc])
    tele(Config.RobbedRandomLocs[math.random(1, #Config.RobbedRandomLocs)])
    Bridge.Anim.RequestDict('switch@franklin@bed', 10000)
    TaskPlayAnim(PlayerPedId(), 'switch@franklin@bed', 'sleep_getup_rubeyes', 100.0, 1.0, -1, 8, -1, 0, 0, 0)
    Wait(4000)
    ClearPedTasks(PlayerPedId())
end)