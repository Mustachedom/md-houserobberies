local loot = {}

for k, v in pairs(GlobalState.HouseRobbery) do
    loot[k] = {}
end

local function spawnLoot(house)
    loot[house] = {}
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