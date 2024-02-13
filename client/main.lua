local QBCore = exports['qb-core']:GetCoreObject()
local inside = false
local currentHouse = nil
local closestHouse
local houseObj = {}
local POIOffsets = nil


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

local function PoliceCall()
    print"Were no strangers to love You know the rules and so do I A full commitment's what I'm thinking of You wouldn't get this from any other guy"
        print"I just wanna tell you how I'm feeling Gotta make you understand"
        print"Never gonna give you up Never gonna let you down Never gonna run around and desert you"
        print"Never gonna make you cry Never gonna say goodbye Never gonna tell a lie and hurt you"
        print"Weve known each other for so long Your hearts been aching, but Youre too shy to say it Inside, we both know what's been going on We know the game and were gonna play it"
        print"And if you ask me how I'm feeling Don't tell me you're too blind to see"
        print"Never gonna give you up Never gonna let you down Never gonna run around and desert you"
        print"Never gonna make you cry Never gonna say goodbye Never gonna tell a lie and hurt you"
        print"Never gonna give you up Never gonna let you down Never gonna run around and desert you"
        print"Never gonna make you cry Never gonna say goodbye Never gonna tell a lie and hurt you"
        print"Weve known each other for so long Your hearts been aching, but Youre too shy to say it Inside, we both know what's been going on We know the game and were gonna play it"
        print"Never gonna give you up Never gonna let you down Never gonna run around and desert you"
        print"Never gonna make you cry Never gonna say goodbye Never gonna tell a lie and hurt you"
        print"Never gonna give you up Never gonna let you down Never gonna run around and desert you"
        print"Never gonna make you cry Never gonna say goodbye Never gonna tell a lie and hurt you"
        QBCore.Functions.Notify("Were no strangers to love You know the rules and so do I A full commitment's what I'm thinking of You wouldn't get this from any other guy", 'error')
        Wait(5000)
        QBCore.Functions.Notify("I just wanna tell you how I'm feeling Gotta make you understand", 'error')
        Wait(5000)
        QBCore.Functions.Notify("Never gonna give you up Never gonna let you down Never gonna run around and desert you", 'error')
        Wait(5000)
        QBCore.Functions.Notify("Never gonna make you cry Never gonna say goodbye Never gonna tell a lie and hurt you", 'error')
        Wait(5000)
        QBCore.Functions.Notify("Weve known each other for so long Your hearts been aching, but Youre too shy to say it Inside, we both know what's been going on We know the game and were gonna play it", 'error')
        Wait(5000)
        QBCore.Functions.Notify("And if you ask me how I'm feeling Don't tell me you're too blind to see", 'error')
        Wait(5000)
        QBCore.Functions.Notify("Never gonna give you up Never gonna let you down Never gonna run around and desert you", 'error')
        Wait(5000)
        QBCore.Functions.Notify("Never gonna make you cry Never gonna say goodbye Never gonna tell a lie and hurt you", 'error')
        Wait(5000)
        QBCore.Functions.Notify("Never gonna give you up Never gonna let you down Never gonna run around and desert you", 'error')
        Wait(5000)
        QBCore.Functions.Notify("Never gonna make you cry Never gonna say goodbye Never gonna tell a lie and hurt you", 'error')
        Wait(5000)
        QBCore.Functions.Notify("Weve known each other for so long Your hearts been aching, but Youre too shy to say it Inside, we both know what's been going on We know the game and were gonna play it", 'error')
        Wait(5000)
        QBCore.Functions.Notify("Never gonna give you up Never gonna let you down Never gonna run around and desert you", 'error')
        Wait(5000)
        QBCore.Functions.Notify("Never gonna make you cry Never gonna say goodbye Never gonna tell a lie and hurt you", 'error')
        Wait(5000)
        QBCore.Functions.Notify("Never gonna give you up Never gonna let you down Never gonna run around and desert you", 'error')
        Wait(5000)
        QBCore.Functions.Notify("Never gonna make you cry Never gonna say goodbye Never gonna tell a lie and hurt you", 'error')
        Wait(5000)
end

local function enterRobberyHouse(house)
    TriggerServerEvent('InteractSound_SV:PlayOnSource', 'houses_door_open', 0.25)
    openHouseAnim()
    Wait(250)
    local coords = { x = Config.Houses[house].coords.x, y = Config.Houses[house].coords.y, z = Config.Houses[house].coords.z - Config.MinZOffset }
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
                        TriggerEvent('animations:client:EmoteCommandStart', {"uncuff"}) 
                        QBCore.Functions.Progressbar("drink_something", "Stealing", math.random(Config.MinRobTime, Config.MaxRobTIme), false, true, {
                            disableMovement = true,
                            disableCarMovement = false,
                            disableMouse = false,
                            disableCombat = true,
                            disableInventory = true,
                        }, {}, {}, {}, function()
                            exports['ps-ui']:Circle(function(success)
                                if success then
                                    ClearPedTasks(PlayerPedId())
						            DeleteObject(k)
                                    TriggerServerEvent('md-houserobbery:server:setlootused', house, v.num)
                                    TriggerServerEvent('md-houserobbery:server:GetLoot', Config.Houses[house].tier, v.type, objectCoords)
                                else
                                   QBCore.Functions.Notify("Dude You Cant Even Do This, C'mon", "error")
                                end
                            end, 2, 8) -- NumberOfCircles, MS
                            
                        end)    
					end,
                    canInteract = function()
                        if v.taken == false then return true end end
                   
				},
			},
            distance = 1.5
		    })
        end
    end
    houseObj = data[1]
    inside = true
    currentHouse = house
    Wait(500)
    TriggerEvent('qb-weathersync:client:DisableSync')
    Wait(Config.HouseTimer * 60000)
    exports['qb-interior']:DespawnInterior(houseObj, function()
       
        inside = false
        currentHouse = nil
      
    end)
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.TriggerCallback('md-houserobbery:server:GetHouseConfig', function(HouseConfig)
        Config.Houses = HouseConfig
    end)
end)

RegisterNetEvent('md-houserobbery:client:deleteobject', function(k, house)
   Wait(Config.HouseTimer * 60000)
    DeleteObject(k)
end)

RegisterNetEvent('md-houserobbery:client:ResetHouseState', function(house)
    Config.Houses[house]['spawned'] = false
end)


RegisterNetEvent('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

RegisterNetEvent('md-houserobbery:client:enterHouse', function(house)
    enterRobberyHouse(house)
end)

RegisterNetEvent('md-houserobbery:client:setHouseState', function(house, state)
    Config.Houses[house]['spawned'] = state
    local chance = math.random(1,100)
    local weaponchance = math.random(1,100)
    if Config.pedspawnchance >= chance then
        lib.requestModel(Config.Ped, 1000)
        Wait(3200)
       local homeowner = CreatePed(0, Config.Ped, Config.Houses[house].ped.x, Config.Houses[house].ped.y, Config.Houses[house].ped.z, 0.0, false, false)
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
                             exports["rpemotes"]:EmoteCommandStart("mechanic4", 0)
                              QBCore.Functions.Progressbar("pick_cane", "Disposing Of Body", 5000, false, true, {
                              disableMovement = true, 
                              disableCarMovement = true, 
                              disableMouse = false, 
                              disableCombat = true, 
                               },{},{}, {}, function()
                              ClearPedTasks(PlayerPedId())
                             DeleteEntity(homeowner)
                               end)
                        else
                            QBCore.Functions.Notify("You Think You Can Dispose Of Him With Your Hands, idiot, Grab A knife", "error")
                        end    
                     end,
                     canInteract = function()
                         if IsEntityDead(homeowner) then return true end end
                 }
             }
         })
    end
   
end)


RegisterNetEvent('md-houserobbery:client:SetLootState', function(house, k, state)
    Config.Houses[house]['loot'][k].taken = state
end)

RegisterNetEvent('md-houserobbery:client:SetBusyState', function(lootspot, house, bool)
    Config.Houses[house]['loot'][lootspot] = bool
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
                size = vec(1,1,3),
                rotation = 0,
                debug = false,
                options = {
            {
                name = 'renterhouse',
                icon = "fas fa-sign-in-alt",
                label = "Re-Enter House",
                onSelect = function()
                    enterRobberyHouse(k)
                end,
                canInteract = function()
                    if Config.Houses[k]['spawned'] then return true end end
            },
            {
                name = 'makesmoke',
                icon = "fas fa-sign-in-alt",
                label = "Throw Smoke Grenade",
             --   item = "weapon_smokegrenade",
                onSelect = function()
                    TriggerEvent('animations:client:EmoteCommandStart', {"uncuff"}) 
                    QBCore.Functions.Progressbar("drink_something", "Throwing A Smoke Grenade", 4000, false, true, {
                        disableMovement = true,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = true,
                        disableInventory = true,
                    }, {}, {}, {}, function()
                        dict = "scr_ba_bb"
                        loadParticle(dict)
                        smoke = StartParticleFxLoopedAtCoord('scr_ba_bb_plane_smoke_trail',Config.Houses[k].coords.x, Config.Houses[k].coords.y, Config.Houses[k].coords.z-45.0, 0, 0, 0, 3.0, 0, 0,0)
                        SetParticleFxLoopedAlpha(smoke, 1.0)
                        Wait(20000)
                        StopParticleFxLooped(smoke,true)
                    end)
                end,
                canInteract = function()
                    if Config.Houses[k]['spawned'] and  QBCore.Functions.GetPlayerData().job.type == 'leo' then return true end end
            },
            {
                name = 'lockup',
                icon = "fas fa-sign-in-alt",
                label = "Lock The House Down",
                onSelect = function()
                    TriggerEvent('animations:client:EmoteCommandStart', {"uncuff"}) 
                    QBCore.Functions.Progressbar("drink_something", "Locking Up The House", math.random(3000,6000), false, true, {
                        disableMovement = true,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = true,
                        disableInventory = true,
                    }, {}, {}, {}, function()
                    TriggerServerEvent('md-houserobbery:server:closeHouse', k)
                    end)
                end,
                canInteract = function()
                    if Config.Houses[k]['spawned'] and  QBCore.Functions.GetPlayerData().job.type == 'leo' then return true end end
            },
            {
                name = 'LockPickHouse',
                icon = "fas fa-sign-in-alt",
                label = labeltext,
                onSelect = function()
                    if Config.Houses[k]['tier'] <= 4  then
                        if QBCore.Functions.HasItem('lockpick') then
                            exports['ps-ui']:Circle(function(success)
                                if success then
                                    TriggerServerEvent('md-houserobbery:server:enterHouse', k)
                                    if 20 <= math.random(1,100) then
                                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 150.0, "siren", 0.5)
                                        PoliceCall()
                                    end
                                else
                                    QBCore.Functions.Notify("Its Just A Circle It Isnt Hard","error")
                                end
                            end,2, 15)
                        else
                            QBCore.Functions.Notify("You Need A Lock Pick To Do This","error")
                        end
                    elseif Config.Houses[k]['tier'] == 5 then
                        if QBCore.Functions.HasItem('houselaptop') then
                            exports['ps-ui']:VarHack(function(success)
                                if success then
                                    TriggerServerEvent('md-houserobbery:server:enterHouse', k)
                                    if 20 <= math.random(1,100) then
                                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 150.0, "siren", 0.5)
                                        PoliceCall()
                                    end
                                else
                                    TriggerServerEvent('md-houserobbery:server:accessbreak', Config.Houses[k]['tier'] )
                                    QBCore.Functions.Notify("Its Just Some Numbers In Order It Isnt Hard","error")
                                end
                            end,5, 8)
                        else
                            QBCore.Functions.Notify("You Need A House Laptop","error")
                        end
                    elseif Config.Houses[k]['tier'] == 6 then
                        if QBCore.Functions.HasItem('mansionlaptop') then
                            exports['ps-ui']:Scrambler(function(success)
                                if success then
                                  TriggerServerEvent('md-houserobbery:server:enterHouse', k)
                                    if 20 <= math.random(1,100) then
                                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 150.0, "siren", 0.5)
                                        PoliceCall()
                                    end
                                else
                                    TriggerServerEvent('md-houserobbery:server:accessbreak', Config.Houses[k]['tier'] )
                                    QBCore.Functions.Notify("Yeah This One Is Hard","error")
                                end
                            end,"numeric", 15, 0)
                        else
                            QBCore.Functions.Notify("You Need A Mansion Laptop","error")
                        end
                    end

                end,
                canInteract = function()
                    if Config.Houses[k]['spawned'] == false and  QBCore.Functions.GetPlayerData().job.type ~= 'leo' then return true end end
                
            }
         },
        })        
            leavehouserobbery = exports.ox_target:addBoxZone({
                coords = v.insidecoords,
                size = vec(1,1,3),
                rotation = 0,
                debug = false,
                options = {
                    {
                        name = 'leaverobbery',
                        icon = "fas fa-sign-in-alt",
                        label = "Leave Robbery House",
                        onSelect = function()
                            SetEntityCoords(PlayerPedId(), Config.Houses[k].coords)
                            inside = false
                            currentHouse = nil
                        end,
                    
                    },
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
            exports['qb-target']:AddBoxZone("enterrobbery"..k, v.coords,1.5, 1.75, {
            }, {
            options = {
            {
                name = 'renterhouse',
                icon = "fas fa-sign-in-alt",
                label = "Re-Enter House",
                action = function()
                    enterRobberyHouse(k)
                end,
                canInteract = function()
                    if Config.Houses[k]['spawned'] then return true end end
            },
            {
                name = 'makesmoke',
                icon = "fas fa-sign-in-alt",
                label = "Throw Smoke Grenade",
               -- item = "weapon_smokegrenade",
                action = function()
                    TriggerEvent('animations:client:EmoteCommandStart', {"uncuff"}) 
                    QBCore.Functions.Progressbar("drink_something", "Throwing A Smoke Grenade", 4000, false, true, {
                        disableMovement = true,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = true,
                        disableInventory = true,
                    }, {}, {}, {}, function()
                        dict = "scr_ba_bb"
                        loadParticle(dict)
                        smoke = StartParticleFxLoopedAtCoord('scr_ba_bb_plane_smoke_trail',Config.Houses[k].coords.x, Config.Houses[k].coords.y, Config.Houses[k].coords.z-45.0, 0, 0, 0, 3.0, 0, 0,0)
                        SetParticleFxLoopedAlpha(smoke, 1.0)
                        Wait(20000)
                        StopParticleFxLooped(smoke,true)
                    end)
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
                    TriggerEvent('animations:client:EmoteCommandStart', {"uncuff"}) 
                    QBCore.Functions.Progressbar("drink_something", "Locking Up The House", math.random(3000,6000), false, true, {
                        disableMovement = true,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = true,
                        disableInventory = true,
                    }, {}, {}, {}, function()
                    TriggerServerEvent('md-houserobbery:server:closeHouse', k)
                    end)
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
                    if Config.Houses[k]['tier'] <= 4  then
                        if QBCore.Functions.HasItem('lockpick') then
                            exports['ps-ui']:Circle(function(success)
                                if success then
                                    TriggerServerEvent('md-houserobbery:server:enterHouse', k)
                                    if 20 <= math.random(1,100) then
                                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 150.0, "siren", 0.5)
                                        PoliceCall()
                                    end
                                else
                                    QBCore.Functions.Notify("Its Just A Circle It Isnt Hard","error")
                                end
                            end,2, 15)
                        else
                            QBCore.Functions.Notify("You Need A Lock Pick To Do This","error")
                        end
                    elseif Config.Houses[k]['tier'] == 5 then
                        if QBCore.Functions.HasItem('houselaptop') then
                            exports['ps-ui']:VarHack(function(success)
                                if success then
                                    TriggerServerEvent('md-houserobbery:server:enterHouse', k)
                                    if 20 <= math.random(1,100) then
                                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 150.0, "siren", 0.5)
                                        PoliceCall()
                                    end
                                else
                                    TriggerServerEvent('md-houserobbery:server:accessbreak', Config.Houses[k]['tier'] )
                                    QBCore.Functions.Notify("Its Just Some Numbers In Order It Isnt Hard","error")
                                end
                            end,5, 8)
                        else
                            QBCore.Functions.Notify("You Need A House Laptop","error")
                        end
                    elseif Config.Houses[k]['tier'] == 6 then
                        if QBCore.Functions.HasItem('mansionlaptop') then
                            exports['ps-ui']:Scrambler(function(success)
                                if success then
                                  TriggerServerEvent('md-houserobbery:server:enterHouse', k)
                                    if 20 <= math.random(1,100) then
                                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 150.0, "siren", 0.5)
                                        PoliceCall()
                                    end
                                else
                                    TriggerServerEvent('md-houserobbery:server:accessbreak', Config.Houses[k]['tier'] )
                                    QBCore.Functions.Notify("Yeah This One Is Hard","error")
                                end
                            end,"numeric", 15, 0)
                        else
                            QBCore.Functions.Notify("You Need A Mansion Laptop","error")
                        end
                    end

                end,
                canInteract = function()
                    if Config.Houses[k]['spawned'] == false and  QBCore.Functions.GetPlayerData().job.type ~= 'leo' then return true end
                end
            }
         },
            distance = 2.0  
            })        
            exports['qb-target']:AddBoxZone("leaverobbery"..k, v.insidecoords,1.5, 1.75, {
                name = "leaverobbery"..k,
                heading = 0.0,
                debugPoly = false,
                minZ = v.insidecoords.z-2,
                maxZ = v.insidecoords.z+2,
                }, {
                options = {
                    {
                        name = 'leaverobbery',
                        icon = "fas fa-sign-in-alt",
                        label = "Leave Robbery House",
                        action = function()
                            SetEntityCoords(PlayerPedId(), Config.Houses[k].coords)
                            inside = false
                            currentHouse = nil
                        end,
                    
                    },
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
                    icon = "nui://"..Config.Inventoryimagelink..QBCore.Shared.Items[v.item].image,
                     header = QBCore.Shared.Items[v.item].label,
                     title = QBCore.Shared.Items[v.item].label,
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
                lib.showContext('blackmarketmd')
            else
                blackmarketmenu[#blackmarketmenu + 1] = {
                    icon = "nui://"..Config.Inventoryimagelink..QBCore.Shared.Items[v.item].image,
                    header = QBCore.Shared.Items[v.item].label,
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
                    exports['qb-menu']:openMenu(blackmarketmenu)  	
            end
        end
    end
    if notify == 0 then
        QBCore.Functions.Notify("Nothing To Sell", 'error')
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
