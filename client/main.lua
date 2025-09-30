local loot = {}

if not GlobalState.HouseRobbery then
    repeat
        Wait(100)
    until GlobalState.HouseRobbery
end
for k, v in pairs(GlobalState.HouseRobbery) do
    loot[k] = {}
end

local function spawnLoot(house)
    for lootKey, value in pairs (GlobalState.HouseRobbery[house].loot) do
        if value.taken then goto continue end
        local coords = vector3(GlobalState.HouseRobbery[house].coords.x, GlobalState.HouseRobbery[house].coords.y, GlobalState.HouseRobbery[house].coords.z - 145.0)
        ps.requestModel(value.prop, 10000)
        loot[house][#loot[house]+1] = CreateObject(value.prop, coords.x + value.coords.x, coords.y + value.coords.y, coords.z + value.coords.z, false, false, false)
        Freeze(loot[house][#loot[house]], true, value.rotation)
        ps.entityTarget(loot[house][#loot[house]], {
            {
                label = 'Search ' .. value.type,
                icon = 'fa-solid fa-box-open',
                action = function()
                    TriggerServerEvent('md-houseRobberies:server:busyLoot', house, lootKey)
                    if not minigame(1) then
                        TriggerServerEvent('md-houseRobberies:server:busyLoot', house, lootKey)
                        return
                    end
                    if not ps.progressbar('Stealing Loot', 5000, 'uncuff') then
                        TriggerServerEvent('md-houseRobberies:server:busyLoot', house, lootKey)
                        return
                    end
                    TriggerServerEvent('md-houseRobberies:server:takeLoot', house, lootKey)
                end,
                canInteract = function()
                    if not GlobalState.HouseRobbery[house].loot[lootKey].taken and not GlobalState.HouseRobbery[house].loot[lootKey].busy then
                        return true
                    else
                        return false
                    end
                end,
            }
        })
        ::continue::
    end
end
local peds = {}

local function beATotalAsshole(ped)
    local timeout = 60 * 5
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
            ps.entityTarget(ped, {
                {
                    label = 'hide body',
                    icon = 'fa-solid fa-box-open',
                    action = function()
                        if not ps.progressbar('Hiding Body', 5000, 'uncuff') then
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
    local pedModel = Config.PedOff[tier].pedModel
    ps.requestModel(pedModel, 10000)
    local ped = CreatePed(4, pedModel, coords.x + Config.PedOff[tier].loc.x, coords.y + Config.PedOff[tier].loc.y, coords.z + Config.PedOff[tier].loc.z, 0.0, false, false)
    local chance = math.random(1,100)
    if 50 <= chance then
        GiveWeaponToPed(ped, 'weapon_pistol', 255, false, true)
    else
        GiveWeaponToPed(ped, 'weapon_combatshotgun', 255, false, true)
    end
    beATotalAsshole(ped)
end

local function spawnHouse(tier, coords)
    local loc = vector3(coords.x, coords.y, coords.z - 145.0)
    local houseData = Config.TierExports[tier].func(loc)
    CreateThread(function()
        Wait(1000 * 60 * 5)
        Config.TierExports[tier].despawn(houseData, function()
            if #(GetEntityCoords(PlayerPedId()) - loc) <= 15.0 then
                SetEntityCoords(PlayerPedId(), coords)
            end
        end)
        if Config.spawnChance <= math.random(1,100) then
            spawnPed(coords, tier)
        end
    end)
    return houseData
end

local function initTargets()
    for k, v in pairs(GlobalState.HouseRobbery) do
        local off = Config.OffSet[v.tier]
        ps.boxTarget('mdhouseRob'..k, v.coords, {}, {
            {
                label = 'Rob House',
                icon = 'fa-solid fa-house',
                action = function()
                    local copCheck = ps.callback('md-houserobberies:server:GetCoppers', k)
                    if copCheck < 0 then
                        ps.notify('Not Enough Cops To Do This', 'error')
                        return
                    end
                    PoliceCall(20)
                    TriggerServerEvent('md-houseRobberies:server:busyState', k)
                    if not minigame(v.tier) then
                        TriggerServerEvent('md-houseRobberies:server:busyState', k)
                        return
                    end
                    TriggerServerEvent('md-houseRobberies:server:spawnHouse', k)
                    TriggerServerEvent('md-houseRobberies:server:busyState', k)
                    spawnHouse(v.tier, v.coords)
                    spawnLoot(k)
                end,
                canInteract = function()
                    if not GlobalState.HouseRobbery[k].spawned and ps.getJobName() ~= 'police' and not GlobalState.HouseRobbery[k].busy then
                        return true
                    else
                        return false
                    end
                end,
            },
            {
                label = 'Enter Broken In House',
                icon = 'fa-solid fa-house',
                action = function()
                    TriggerServerEvent('md-houseRobberies:server:enterHouse', k)
                    SetEntityCoords(PlayerPedId(), vector3(v.coords.x + off.x, v.coords.y + off.y, v.coords.z + off.z - 145.0))
                    spawnLoot(k)
                end,
                canInteract = function()
                    if GlobalState.HouseRobbery[k].spawned then
                        return true
                    else
                        return false
                    end
                end,
            },
            {
                label = 'Lock House',
                icon = 'fa-solid fa-house',
                action = function()
                    TriggerServerEvent('md-houseRobberies:server:busyState', k)
                    if not minigame(v.tier) then
                        TriggerServerEvent('md-houseRobberies:server:busyState', k)
                        return
                    end
                    TriggerServerEvent('md-houseRobberies:server:busyState', k)
                    TriggerServerEvent('md-houseRobberies:server:lockHouse', k)
                end,
                canInteract = function()
                    if GlobalState.HouseRobbery[k].spawned and ps.getJobType() == 'leo' and not GlobalState.HouseRobbery[k].busy then
                        return true
                    else
                        return false
                    end
                end,
            },
            {
                label = 'Throw Smoke Bomb',
                icon = 'fa-solid fa-house',
                action = function()
                    TriggerServerEvent('md-houseRobberies:server:smokeBomb', k)
                end,
                canInteract = function()
                    if GlobalState.HouseRobbery[k].spawned and ps.getJobType() == 'leo' and not GlobalState.HouseRobbery[k].busy then
                        return true
                    else
                        return false
                    end
                end,
            }
        })
        ps.boxTarget('mdHRexit'..k, vector3(v.coords.x + off.x, v.coords.y + off.y, v.coords.z + off.z - 145.0), {}, {
            {
                label = 'leave House',
                icon = 'fa-solid fa-house',
                action = function()
                    SetEntityCoords(PlayerPedId(), v.coords)
                    for i = 1, #loot[k] do
                        if DoesEntityExist(loot[k][i]) then
                            DeleteEntity(loot[k][i])
                        end
                    end
                    TriggerServerEvent('md-houseRobberies:server:leaveHouse', k)
                end,
            }
        })
    end
end

initTargets()

RegisterNetEvent('md-houseRobberies:client:forceLeave', function(house)
    if #(GetEntityCoords(PlayerPedId()) - vector3(GlobalState.HouseRobbery[house].coords.x, GlobalState.HouseRobbery[house].coords.y, GlobalState.HouseRobbery[house].coords.z - 145.0)) <= 30.0 then
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

RegisterNetEvent('md-houseRobberies:client:smokeBomb', function(house)
    local loc = vector3(GlobalState.HouseRobbery[house].coords.x, GlobalState.HouseRobbery[house].coords.y, GlobalState.HouseRobbery[house].coords.z - 145.0)
    local dict = "scr_ba_bb"
    ps.requestPTFX(dict, 10000)
    SetPtfxAssetNextCall(dict)
    local fx = StartParticleFxLoopedAtCoord('scr_ba_bb_plane_smoke_trail',loc.x + math.random(-2,2), loc.y + math.random(-2,2), loc.z, 0, 0, 0, 3.0, 0, 0,0)
    StopParticleFxLooped(fx, 0)
end)
local peds = {}

local function spawnFence()
    local fence = ps.callback('md-houserobberies:server:GetFence')
    for k, v in pairs (fence) do
        ps.requestModel(v.ped, 10000)
        peds[#peds+1] = CreatePed(4, v.ped, v.coords.x, v.coords.y, v.coords.z, v.coords.w, false, false)
        SetEntityInvincible(peds[#peds], true)
        FreezeEntityPosition(peds[#peds], true)
        GiveWeaponToPed(peds[#peds], 'weapon_pistol', 255, false, true)
        ps.entityTarget(peds[#peds], {
            {
                label = 'Sell Loot',
                icon = 'fa-solid fa-hand-holding-dollar',
                action = function()
                    local itemList = ps.callback('md-houserobberies:server:getLootItems', k)
                    local menu = {}
                    for item, values in pairs(itemList) do
                        if ps.hasItem(item) then
                            menu[#menu+1] = {
                                title = ps.getLabel(item),
                                icon = ps.getImage(item),
                                description = '$' .. values.price,
                                action = function()
                                    TriggerServerEvent('md-houseRobberies:server:sellLoot', k, item)
                                end
                            }
                        end
                    end
                    if #menu < 1 then
                        ps.notify('You do not have any items to sell', 'error')
                        return
                    end
                    ps.menu('House Robbery Fence', 'House Robbery Fence', menu)
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
    ps.requestAnim('missminuteman_1ig_2', 10000)
    TaskPlayAnim(PlayerPedId(), 'missminuteman_1ig_2', 'handsup_base', 8.0, -8.0, -1, 49, 0, false, false, false)
    Wait(3000)
    ClearPedTasks(peds[loc])
    StopAnimTask(PlayerPedId(),'missminuteman_1ig_2', 'handsup_base', 1.0)
    ClearPedTasks(PlayerPedId())
end)