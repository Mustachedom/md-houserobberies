local QBCore = exports['qb-core']:GetCoreObject()
local houseObj = {}
local CurrentCops = 0

-- Functions
local function loadParticle(dict)
    lib.requestNamedPtfxAsset(dict, 1000)
    SetPtfxAssetNextCall(dict)
end

local function loadAnimDict(dict)
    RequestAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do Wait(5) end
end


local function openHouseAnim()
    loadAnimDict('anim@heists@keycard@')
    TaskPlayAnim(PlayerPedId(), 'anim@heists@keycard@', 'exit', 5.0, 1.0, -1, 16, 0, 0, 0, 0)
    Wait(400)
    ClearPedTasks(PlayerPedId())
end

local function enterRobberyHouse(house)
    local home = Config.Houses[house] 
    TriggerServerEvent('InteractSound_SV:PlayOnSource', 'houses_door_open', 0.25)
    openHouseAnim()
    Wait(250)
    local coords = { x = Config.Houses[house].coords.x, y = Config.Houses[house].coords.y, z = Config.Houses[house].coords.z - 145.0} -- dont change this z value i swear to fucking god
    if home.tier == 1 then
        data = exports['qb-interior']:CreateCaravanShell(coords)
    elseif  home.tier == 2 then
          data = exports['qb-interior']:CreateLesterShell(coords)
    elseif  home.tier == 3 then
        data = exports['qb-interior']:CreateTrevorsShell(coords)
    elseif  home.tier == 4 then
        data = exports['qb-interior']:CreateHouseRobbery(coords)
    elseif   home.tier == 5 then
        data = exports['qb-interior']:CreateFurniMotelModern(coords)
    elseif home.tier == 6 then
        data = exports['qb-interior']:CreateMichael(coords)
    end
    for k, v in pairs(home['loot']) do
        lib.requestModel(v.prop, 10000)
        if v.taken == false then
            local objectCoords = vector3(coords.x + v.coords.x, coords.y + v.coords.y, coords.z + v.coords.z)
            k = CreateObject(v.prop, objectCoords.x, objectCoords.y, objectCoords.z, false, false, false)
            SetEntityHeading(k, v.rotation or 180.0)
            FreezeEntityPosition(k,true)
            TriggerEvent('md-houserobbery:client:deleteobject', k)
            AddSingleModel(k, {name = 'StealLoot',
                 icon = "fas fa-sign-in-alt",
                 label = "Steal Loot",
                 action = function()
                     TriggerServerEvent('md-houserobbery:server:setlootstatebusy', house, v.num, true)
                     if not progressbar("Stealing", math.random(Config.MinRobTime, Config.MaxRobTIme), 'uncuff') then return end
                     if not minigame(home.tier) then 
                         Notify("This Nerd Failed", "error")
                         TriggerServerEvent('md-houserobbery:server:setlootstatebusy', house, v.num, false)
                         return end
                     DeleteObject(k)
                     TriggerServerEvent('md-houserobbery:server:setlootused', house, v.num)
                     TriggerServerEvent('md-houserobbery:server:GetLoot', Config.Houses[house].tier, v.type, objectCoords)
                     TriggerServerEvent('md-houserobbery:server:setlootstatebusy', house, v.num, false)    
                 end,
                 canInteract = function()
                     if v.taken == false and v.busy == false then return true end end}, k)
        end
    end
    local loc = vector3(coords.x + Config.OffSet[home.tier].x, coords.y + Config.OffSet[home.tier].y, coords.z + Config.OffSet[home.tier].z )
    
    houseObj = data[1]
    Wait(500)
    TriggerEvent('qb-weathersync:client:DisableSync')
    Wait(1000 * 60 * Config.HouseTimer)
    exports['qb-interior']:DespawnInterior(houseObj, function()
        if #(GetEntityCoords(PlayerPedId()) - vector3(coords.x, coords.y, coords.z)) <= 15.0 then
            SetEntityCoords(PlayerPedId(),Config.Houses[house]['coords'])
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
    Config.Houses[house]['spawned'] = state
end)

RegisterNetEvent('md-houserobbery:client:SetLootState', function(house, k, state)
    Config.Houses[house]['loot'][k].taken = state
end)
RegisterNetEvent('md-houserobbery:client:SetLootStateBusy', function(house, k, state)
    Config.Houses[house]['loot'][k].busy = state
end)

RegisterNetEvent('md-housrobberies:client:ptfx', function(loc)
    dict = "scr_ba_bb"
    loadParticle(dict)
    smoke = StartParticleFxLoopedAtCoord('scr_ba_bb_plane_smoke_trail',loc.x, loc.y, loc.z - 145.0, 0, 0, 0, 3.0, 0, 0,0)
    SetParticleFxLoopedAlpha(smoke, 1.0)
    Wait(20000)
    StopParticleFxLooped(smoke,true)
end)

CreateThread(function()
    for k, v in pairs (Config.Houses) do
            local labeltext = " "
            if Config.DebugHouseNumber then
                labeltext = "break in " .. k .."!"
            else
                labeltext = "Break In"    
            end
            AddBoxZoneMultiOptions('breakin' .. k, v.coords,{
                {   name = 'renterhouse', icon = "fas fa-sign-in-alt", label = "Re-Enter House", 
                    action = function()     enterRobberyHouse(k) end, 
                    onSelect = function()     enterRobberyHouse(k) end, 
                    canInteract = function()
                        if Config.Houses[k]['spawned']  and QBCore.Functions.GetPlayerData().job.type ~= 'leo' then return true end end
                },
                {
                    name = 'makesmoke',
                    icon = "fas fa-sign-in-alt",
                    label = "Throw Smoke Grenade",
                    action = function()
                        if not progressbar("Throwing A Smoke Grenade", 4000, 'uncuff') then return end
                        TriggerServerEvent('md-houserobberies:server:ptfx', Config.Houses[k]['coords'])
                    end,    
                    onSelect = function()
                        if not progressbar("Throwing A Smoke Grenade", 4000, 'uncuff') then return end
                        TriggerServerEvent('md-houserobberies:server:ptfx', Config.Houses[k]['coords'])
                    end,
                    canInteract = function()
                        if Config.Houses[k]['spawned'] and QBCore.Functions.GetPlayerData().job.type == 'leo'  then return true end end
                },
                {
                    name = 'lockup',
                    icon = "fas fa-sign-in-alt",
                    label = "Lock The House Down",
                    action = function()
                        if not progressbar("Locking Up The House", math.random(3000,6000), 'uncuff') then return end
                         TriggerServerEvent('md-houserobbery:server:closeHouse', k)
                     end,
                    onSelect = function()
                       if not progressbar("Locking Up The House", math.random(3000,6000), 'uncuff') then return end
                        TriggerServerEvent('md-houserobbery:server:closeHouse', k)
                    end,
                    canInteract = function()
                        if Config.Houses[k]['spawned']  and QBCore.Functions.GetPlayerData().job.type == 'leo' then return true end end
                },
                {
                    name = 'LockPickHouse',
                    icon = "fas fa-sign-in-alt",
                    label = labeltext,
                    onSelect = function()
                        BreakIn(k)								
                    end,
                    action = function()
                        BreakIn(k)								
                    end,
                    canInteract = function()
                        if Config.Houses[k]['spawned'] == false  and QBCore.Functions.GetPlayerData().job.type ~= 'leo' then return true end end
                    
                }, })
                local loc = vector3(Config.Houses[k]['coords'].x  + Config.OffSet[Config.Houses[k]['tier']].x, Config.Houses[k]['coords'].y + Config.OffSet[Config.Houses[k]['tier']].y, Config.Houses[k]['coords'].z + Config.OffSet[Config.Houses[k]['tier']].z - 145 )
                AddBoxZoneSingle('leavehouse'..k, loc, 
                {name = 'leaverobbery', icon = "fas fa-sign-in-alt",label = "Leave Robbery House",action = function()   SetEntityCoords(PlayerPedId(), Config.Houses[k].coords)   end,})
end
end)

CreateThread(function()
    local chance = math.random(1,100)
    local current = "g_m_y_famdnf_01"
	lib.requestModel(current, 10000)
	local CurrentLocation = Config.FenceSpawn
	local blackmarket = CreatePed(0, current,CurrentLocation.x,CurrentLocation.y,CurrentLocation.z-1, CurrentLocation.w, false, false)
    Freeze(blackmarket, true, CurrentLocation.w)
    if chance <= 50 then
        GiveWeaponToPed(blackmarket, Config.FenceWeaponone, 1, false, true)
    else
         GiveWeaponToPed(blackmarket, Config.FenceWeapontwo, 1, false, true)
    end     
    AddSingleModel(blackmarket,{label = "Robbery Fence",icon = "fas fa-eye",event = "md-houserobberies:client:openblackmarket"}, blackmarket )
end)

RegisterNetEvent("md-houserobberies:client:openblackmarket", function(data)
    local blackmarketmenu = {}
    local notify = 0
    for k, v in pairs (Config.BlackMarket) do
        if QBCore.Functions.HasItem(v.item) then
            notify = 1
            if Config.Oxmenu then
                blackmarketmenu[#blackmarketmenu + 1] = {
                    icon = GetImage(v.item),
                     header = GetLabel(v.item),
                     title = GetLabel(v.item),
                     description = "$".. v.minvalue .. "  -  $" .. v.maxvalue,
                     event = "md-houserobberies:client:sellloot",
                     args = {
                        item = v.item,
                        min = v.minvalue,
                        max = v.maxvalue,
                        success = v.successchance,
                     }
                 }
                lib.registerContext({id = 'blackmarketmd',title = "Black Market", options = blackmarketmenu})
            else
                blackmarketmenu[#blackmarketmenu + 1] = {
                    icon = GetImage(v.item),
                    header = GetLabel(v.item),
                    txt =  "$".. v.minvalue .. "  -  $" .. v.maxvalue,
                    params = {
                        event = "md-houserobberies:client:sellloot",
                        args = {
                            item = v.item,
                            min = v.minvalue,
                            max = v.maxvalue,
                            success = v.successchance,
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
    local chance = math.random(1,100)
   
    if data.success >= chance then 
        TriggerServerEvent('md-houserobberies:server:sellloot', data.item)
    else
        TriggerServerEvent('md-houserobberies:server:loseloot', data.item)
    end
end)

