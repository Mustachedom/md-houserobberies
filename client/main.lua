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
    TriggerServerEvent('InteractSound_SV:PlayOnSource', 'houses_door_open', 0.25)
    openHouseAnim()
    Wait(250)
    local coords = { x = Config.Houses[house].coords.x, y = Config.Houses[house].coords.y, z = Config.Houses[house].coords.z - Config.MinZOffset -100.0}
    if Config.Houses[house].tier == 1 then
        data = exports['qb-interior']:CreateCaravanShell(coords)
    elseif  Config.Houses[house].tier == 2 then
          data = exports['qb-interior']:CreateLesterShell(coords)
    elseif  Config.Houses[house].tier == 3 then
        data = exports['qb-interior']:CreateTrevorsShell(coords)
    elseif  Config.Houses[house].tier == 4 then
        data = exports['qb-interior']:CreateHouseRobbery(coords)
    elseif   Config.Houses[house].tier == 5 then
        data = exports['qb-interior']:CreateFurniMotelModern(coords)
    elseif Config.Houses[house].tier == 6 then
        data = exports['qb-interior']:CreateMichael(coords)
    end
    for k, v in pairs(Config.Houses[house]['loot']) do
        lib.requestModel(v.prop, 10000)
        if v.taken == false then
            local objectCoords = vector3(coords.x + v.coords.x, coords.y + v.coords.y, coords.z + v.coords.z)
            k = CreateObject(v.prop, objectCoords.x, objectCoords.y, objectCoords.z, false, false, false)
            if v.rotation == nil then
                v.rotation = 180.0
            end
            SetEntityHeading(k, v.rotation)
            FreezeEntityPosition(k,true)
            TriggerEvent('md-houserobbery:client:deleteobject', k)
            exports['qb-target']:AddTargetEntity(k, { -- 963.37, -2122.95, 31.47
	        debugPoly = false,
		    options = {
				{
					name = 'StealLoot',
					icon = "fas fa-sign-in-alt",
					label = "Steal Loot",
					action = function()
                        TriggerServerEvent('md-houserobbery:server:setlootstatebusy', house, v.num, true)
                       if not progressbar("Stealing", math.random(Config.MinRobTime, Config.MaxRobTIme), 'uncuff') then return end
                        if not minigame(3,6) then 
                            Notify("Dude You Cant Even Do This, C'mon", "error")
                            TriggerServerEvent('md-houserobbery:server:setlootstatebusy', house, v.num, false)
                            return end
                        DeleteObject(k)
                        TriggerServerEvent('md-houserobbery:server:setlootused', house, v.num)
                        TriggerServerEvent('md-houserobbery:server:GetLoot', Config.Houses[house].tier, v.type, objectCoords)
                        TriggerServerEvent('md-houserobbery:server:setlootstatebusy', house, v.num, false)    
					end,
                    canInteract = function()
                        if v.taken == false and v.busy == false then return true end end
				},
			},
            distance = 1.5
		    })
        end
    end
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

local function SpawnHomeowner(k)
    local chance = math.random(1,100)
    local weaponchance = math.random(1,100)
    if Config.pedspawnchance >= chance then
        lib.requestModel(Config.Ped, 1000)
        Wait(2000)
       local homeowner = CreatePed(0, Config.Ped, Config.Houses[k].ped.x, Config.Houses[k].ped.y, Config.Houses[k].ped.z - 100, 0.0, true, false)
         if weaponchance <= Config.weapononechance then
             GiveWeaponToPed(homeowner, Config.Weaponone, 1, false, true)
             TaskCombatPed(homeowner, PlayerPedId(), 0, 16)
             SetPedCombatAttributes(homeowner, 46, true)
             SetPedAccuracy(homeowner, 50)
             SetPedArmour(homeowner, 100)
         else 
             GiveWeaponToPed(homeowner, Config.Weapontwo, 1, false, true)
             TaskCombatPed(homeowner, PlayerPedId(), 0, 16)
             SetPedCombatAttributes(homeowner, 46, true)
             SetPedAccuracy(homeowner,50)
             SetPedArmour(homeowner, 100)
         end
         exports['qb-target']:AddTargetEntity(homeowner, { 
             options = {
                 { 
                     label = 'Dispose Of Body', 
                     icon = 'fas fa-example', 
                     action = function()
                         if GetSelectedPedWeapon(PlayerPedId()) == `weapon_knife` then
                            if not progressbar("Disposing Of Body", 5000,'mechanic4') then return end
                             DeleteEntity(homeowner)
                        else
                           Notify("You Think You Can Dispose Of Him With Your Hands, idiot, Grab A knife", "error")
                        end    
                     end,
                     canInteract = function()
                         if IsEntityDead(homeowner) then return true end end
                 }
             }
         })
    end
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
    if QBCore.Functions.GetPlayerData().job.type == 'leo' then return end
    dict = "scr_ba_bb"
    loadParticle(dict)
    smoke = StartParticleFxLoopedAtCoord('scr_ba_bb_plane_smoke_trail',loc.x, loc.y, loc.z - 100 - Config.MinZOffset, 0, 0, 0, 3.0, 0, 0,0)
    SetParticleFxLoopedAlpha(smoke, 1.0)
    Wait(20000)
    StopParticleFxLooped(smoke,true)
end)

CreateThread(function()
    for k, v in pairs (Config.Houses) do
        if Config.OxTarget then
            local labeltext = " "
            if Config.DebugHouseNumber then
                labeltext = "break in " .. k .."!"
            else
                labeltext = "Break In"    
            end
            robberyhouse = exports.ox_target:addBoxZone({
                coords = v.coords,
                size = vec(1,1,2),
                rotation = 0,
                debug = false,
                options = {
            { name = 'renterhouse', icon = "fas fa-sign-in-alt", label = "Re-Enter House", onSelect = function()     enterRobberyHouse(k) end, canInteract = function()
                    if Config.Houses[k]['spawned'] then return true end end
            },
            {
                name = 'makesmoke',
                icon = "fas fa-sign-in-alt",
                label = "Throw Smoke Grenade",
             --   item = "weapon_smokegrenade",
                onSelect = function()
                    if not progressbar("Throwing A Smoke Grenade", 4000, 'uncuff') then return end
                    TriggerServerEvent('md-houserobberies:server:ptfx', Config.Houses[k]['coords'])
                end,
                canInteract = function()
                    if Config.Houses[k]['spawned'] and  QBCore.Functions.GetPlayerData().job.type == 'leo' then return true end end
            },
            {
                name = 'lockup',
                icon = "fas fa-sign-in-alt",
                label = "Lock The House Down",
                onSelect = function()
                   if not progressbar("Locking Up The House", math.random(3000,6000), 'uncuff') then return end
                    TriggerServerEvent('md-houserobbery:server:closeHouse', k)
                end,
                canInteract = function()
                    if Config.Houses[k]['spawned'] and  QBCore.Functions.GetPlayerData().job.type == 'leo' then return true end end
            },
            {
                name = 'LockPickHouse',
                icon = "fas fa-sign-in-alt",
                label = labeltext,
                onSelect = function()
		        if not GetCops(Config.MinCops) then	return end						
                    if Config.Houses[k]['tier'] <= 4  then
                        if not ItemCheck('lockpick') then return end
                        if not minigame(2,6) then return end
                           TriggerServerEvent('md-houserobbery:server:enterHouse', k)
                           SpawnHomeowner(k)
                            PoliceCall(Config.AlertPolice)
                    elseif Config.Houses[k]['tier'] == 5 then
                        if not ItemCheck('houselaptop') then return end
                            exports['ps-ui']:VarHack(function(success)
                                if success then
                                    TriggerServerEvent('md-houserobbery:server:enterHouse', k)
                                    SpawnHomeowner(k)
                                    PoliceCall(Config.AlertPolice)
                                else
                                    TriggerServerEvent('md-houserobbery:server:accessbreak', Config.Houses[k]['tier'] )
                                    Notify("Its Just Some Numbers In Order It Isnt Hard","error")
                                end
                            end,5, 8)
                    elseif Config.Houses[k]['tier'] == 6 then
                        if not ItemCheck('mansionlaptop') then return end
                            exports['ps-ui']:Scrambler(function(success)
                                if success then
                                    TriggerServerEvent('md-houserobbery:server:enterHouse', k)
                                    SpawnHomeowner(k)
                                    PoliceCall(Config.AlertPolice)
                                else
                                    TriggerServerEvent('md-houserobbery:server:accessbreak', Config.Houses[k]['tier'] )
                                    Notify("Yeah This One Is Hard","error")
                                end
                            end,"numeric", 15, 0)
                    end								
                end,
                canInteract = function()
                    if Config.Houses[k]['spawned'] == false and  QBCore.Functions.GetPlayerData().job.type ~= 'leo' then return true end end
                
            }
         },
        })        
                leavehouserobbery = exports.ox_target:addBoxZone({
                coords = vector3(v.insidecoords.x, v.insidecoords.y, v.insidecoords.z-100),
                size = vec(1,1,3),
                rotation = 0,
                debug = false,
                options = {
                    {name = 'leaverobbery',icon = "fas fa-sign-in-alt",label = "Leave Robbery House",onSelect = function()    SetEntityCoords(PlayerPedId(), Config.Houses[k].coords)   end,},
                },
                distance = 2.0
                })
        else
            local labeltext = " "
            if Config.DebugHouseNumber then
                labeltext = "break in " .. k .."!"
            else
                labeltext = "Break In"    
            end
            exports['qb-target']:AddBoxZone("enterrobbery"..k, v.coords,1.5, 1.75, {     name = "enterrobbery"..k,     heading = 0.0,     debugPoly = false,     minZ = v.coords.z-2,     maxZ = v.coords.z+2,   }, {
            options = {
            {name = 'renterhouse',icon = "fas fa-sign-in-alt",label = "Re-Enter House",action = function()    enterRobberyHouse(k)end, canInteract = function()    
                if Config.Houses[k]['spawned'] then return true end end},
            {
                name = 'makesmoke',
                icon = "fas fa-sign-in-alt",
                label = "Throw Smoke Grenade",
               -- item = "weapon_smokegrenade",
                action = function()
                   if not progressbar("Throwing A Smoke Grenade", 4000, 'uncuff') then return end
                   TriggerServerEvent('md-houserobberies:server:ptfx', Config.Houses[k]['coords'])
                end,
                canInteract = function()
                        if Config.Houses[k]['spawned'] and  QBCore.Functions.GetPlayerData().job.type == 'leo' then return true end
                end
            },
            {
                name = 'lockup',
                icon = "fas fa-sign-in-alt",
                label = "Lock The House Down",
                action = function()
                   if not progressbar("Locking Up The House", math.random(3000,6000), 'uncuff') then return end
                    TriggerServerEvent('md-houserobbery:server:closeHouse', k)
                end,
                canInteract = function()
                    if Config.Houses[k]['spawned'] and  QBCore.Functions.GetPlayerData().job.type == 'leo' then return true end
                end
            },
            {
                name = 'LockPickHouse',
                icon = "fas fa-sign-in-alt",
                label = labeltext,
                action = function()
                    if not GetCops(Config.MinCops) then	return end						
                    if Config.Houses[k]['tier'] <= 4  then
                        if not ItemCheck('lockpick') then return end
                        if not minigame(2,6) then return end
                           TriggerServerEvent('md-houserobbery:server:enterHouse', k)
                           SpawnHomeowner(k)
                            PoliceCall(Config.AlertPolice)
                    elseif Config.Houses[k]['tier'] == 5 then
                        if not ItemCheck('houselaptop') then return end
                            exports['ps-ui']:VarHack(function(success)
                                if success then
                                    TriggerServerEvent('md-houserobbery:server:enterHouse', k)
                                    SpawnHomeowner(k)
                                    PoliceCall(Config.AlertPolice)
                                else
                                    TriggerServerEvent('md-houserobbery:server:accessbreak', Config.Houses[k]['tier'] )
                                    Notify("Its Just Some Numbers In Order It Isnt Hard","error")
                                end
                            end,5, 8)
                    elseif Config.Houses[k]['tier'] == 6 then
                        if not ItemCheck('mansionlaptop') then return end
                            exports['ps-ui']:Scrambler(function(success)
                                if success then
                                    TriggerServerEvent('md-houserobbery:server:enterHouse', k)
                                    SpawnHomeowner(k)
                                    PoliceCall(Config.AlertPolice)
                                else
                                    TriggerServerEvent('md-houserobbery:server:accessbreak', Config.Houses[k]['tier'] )
                                    Notify("Yeah This One Is Hard","error")
                                end
                            end,"numeric", 15, 0)
                    end			
                end,
                canInteract = function()
                    if Config.Houses[k]['spawned'] == false and  QBCore.Functions.GetPlayerData().job.type ~= 'leo' then return true end
                end
            }
         },
            distance = 2.0  
            })       
		local leavecoord = vector3(v.insidecoords.x, v.insidecoords.y, v.insidecoords.z-100)
            exports['qb-target']:AddBoxZone("leaverobbery"..k, leavecoord,1.5, 1.75, {name = "leaverobbery"..k,heading = 0.0,debugPoly = false,minZ = leavecoord.z-2,maxZ = leavecoord.z+2,}, {
                options = {
                    {name = 'leaverobbery',icon = "fas fa-sign-in-alt",label = "Leave Robbery House",action = function()    SetEntityCoords(PlayerPedId(), Config.Houses[k].coords)end,},
                },
                distance = 2.0
                })
    end         
end
end)

CreateThread(function()
    local chance = math.random(1,100)
    local current = "g_m_y_famdnf_01"
	lib.requestModel(current, 10000)
	local CurrentLocation = Config.FenceSpawn
	blackmarket = CreatePed(0, current,CurrentLocation.x,CurrentLocation.y,CurrentLocation.z-1, CurrentLocation.w, false, false)
    FreezeEntityPosition(blackmarket, true)
    SetEntityInvincible(blackmarket, true)
    if chance <= 50 then
        GiveWeaponToPed(blackmarket, Config.FenceWeaponone, 1, false, true)
    else
         GiveWeaponToPed(blackmarket, Config.FenceWeapontwo, 1, false, true)
    end     
    exports['qb-target']:AddTargetEntity(blackmarket, { 
        options = {
            {
                label = "Robbery Fence",
                icon = "fas fa-eye",
                event = "md-houserobberies:client:openblackmarket"
            },
        }
    })
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

