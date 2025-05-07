local QBCore = exports['qb-core']:GetCoreObject()
local progressbartype = Config.progressbartype 
local minigametype = 1
local notifytype = Config.Notify 
local dispatch = Config.Dispatch

function progressbar(text, time, anim)
	TriggerEvent('animations:client:EmoteCommandStart', {anim}) 
	if progressbartype == 'oxbar' then 
	  if lib.progressBar({ duration = time, label = text, useWhileDead = false, canCancel = true, disable = { car = true, move = true},}) then 
		if GetResourceState('scully_emotemenu') == 'started' then
			exports.scully_emotemenu:cancelEmote()
		else
			TriggerEvent('animations:client:EmoteCommandStart', {"c"}) 
		end
		return true
	  end	 
	elseif progressbartype == 'oxcir' then
	  if lib.progressCircle({ duration = time, label = text, useWhileDead = false, canCancel = true, position = 'bottom', disable = { car = true,move = true},}) then 
		if GetResourceState('scully_emotemenu') == 'started' then
			exports.scully_emotemenu:cancelEmote()
		else
			TriggerEvent('animations:client:EmoteCommandStart', {"c"}) 
		end
		return true
	  end
	elseif progressbartype == 'qb' then
	local test = false
		local cancelled = false
	  QBCore.Functions.Progressbar("drink_something", text, time, false, true, { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true, disableInventory = true,
	  }, {}, {}, {}, function()
		test = true
		if GetResourceState('scully_emotemenu') == 'started' then
			exports.scully_emotemenu:cancelEmote()
		else
			TriggerEvent('animations:client:EmoteCommandStart', {"c"}) 
		end
	  end, function()
		cancelled = true
		if GetResourceState('scully_emotemenu') == 'started' then
			exports.scully_emotemenu:cancelEmote()
		else
			TriggerEvent('animations:client:EmoteCommandStart', {"c"}) 
		end
	end)
	  repeat 
		Wait(100)
	  until cancelled or test
	  if test then Wait(200) return true end
	else
		print"dude, it literally tells you what you need to set it as in the config"
	end	  
  end

  function minigame(tier)
	local time = 0
	local game = Config.Minigames
	local hack = Config.Tiergames[tier]

	local ps_ui_map = {
		ps_circle = function()
			local check
			exports['ps-ui']:Circle(function(success) check = success end, game['ps_circle'].amount, game['ps_circle'].speed)
			return check
		end,
		ps_maze = function()
			local check
			exports['ps-ui']:Maze(function(success) check = success end, game['ps_maze'].timelimit)
			return check
		end,
		ps_scrambler = function()
			local check
			exports['ps-ui']:Scrambler(function(success) check = success end, game['ps_scrambler'].type, game['ps_scrambler'].time, game['ps_scrambler'].mirrored)
			return check
		end,
		ps_var = function()
			local check
			exports['ps-ui']:VarHack(function(success) check = success end, game['ps_var'].numBlocks, game['ps_var'].time)
			return check
		end,
		ps_thermite = function()
			local check
			exports['ps-ui']:Thermite(function(success) check = success end, game['ps_thermite'].time, game['ps_thermite'].gridsize, game['ps_thermite'].incorrect)
			return check
		end
	}

	if ps_ui_map[hack] then
		return ps_ui_map[hack]()
	elseif hack == 'ox' then
		return lib.skillCheck(game['ox'], {'1', '2', '3', '4'})
	end

	local bl_ui_map = {
		blcirprog = function() return exports.bl_ui:CircleProgress(game['blcirprog'].amount, game['blcirprog'].speed) end,
		blprog = function() return exports.bl_ui:Progress(game['blprog'].amount, game['blprog'].speed) end,
		blkeyspam = function() return exports.bl_ui:KeySpam(game['blkeyspam'].amount, game['blprog'].difficulty) end,
		blkeycircle = function() return exports.bl_ui:KeyCircle(game['blkeycircle'].amount, game['blkeycircle'].difficulty, game['blkeycircle'].keynumbers) end,
		blnumberslide = function() return exports.bl_ui:NumberSlide(game['blnumberslide'].amount, game['blnumberslide'].difficulty, game['blnumberslide'].keynumbers) end,
		blrapidlines = function() return exports.bl_ui:RapidLines(game['blrapidlines'].amount, game['blrapidlines'].difficulty, game['blrapidlines'].numberofline) end,
		blcircleshake = function() return exports.bl_ui:CircleShake(game['blcircleshake'].amount, game['blcircleshake'].difficulty, game['blcircleshake'].stages) end
	}

	if bl_ui_map[hack] then
		return bl_ui_map[hack]()
	elseif hack == 'glpath' then
		local settings = {gridSize = game['glpath'].gridSize, lives = game['glpath'].lives, timeLimit = game['glpath'].timelimit}
		local successes = false
		exports["glow_minigames"]:StartMinigame(function(success) successes = success end, "path", settings)
		repeat Wait(1000) time = time + 1 until successes or time == 100
		if successes then return true end
	elseif hack == 'glspot' then
		local settings = {gridSize = game['glspot'].gridSize, timeLimit = game['glspot'].gridSize, charSet = game['glspot'].charSet, required = game['glspot'].required}
		local successes = false
		exports["glow_minigames"]:StartMinigame(function(success) successes = success end, "spot", settings)
		repeat Wait(1000) time = time + 1 until successes or time == 100
	elseif hack == 'glmath' then
		local settings = {timeLimit = game['glmath'].timeLimit}
		local successes = false
		exports["glow_minigames"]:StartMinigame(function(success) successes = success end, "math", settings)
		repeat Wait(1000) time = time + 1 until successes or time == 100
	elseif hack == 'none' then
		return true
	else
		print("^1 SCRIPT ERROR: Md-HouseRobberies set your minigame with one of the options!")
	end
 end

 function minigame2(tier)
	local game = Config.Minigames
	local hack = Config.HouseHacks[tier]
	local time = 0

	local ps_ui_map = {
		ps_circle = function()
			local check
			exports['ps-ui']:Circle(function(success) check = success end, game['ps_circle'].amount, game['ps_circle'].speed)
			return check
		end,
		ps_maze = function()
			local check
			exports['ps-ui']:Maze(function(success) check = success end, game['ps_maze'].timelimit)
			return check
		end,
		ps_scrambler = function()
			local check
			exports['ps-ui']:Scrambler(function(success) check = success end, game['ps_scrambler'].type, game['ps_scrambler'].time, game['ps_scrambler'].mirrored)
			return check
		end,
		ps_var = function()
			local check
			exports['ps-ui']:VarHack(function(success) check = success end, game['ps_var'].numBlocks, game['ps_var'].time)
			return check
		end,
		ps_thermite = function()
			local check
			exports['ps-ui']:Thermite(function(success) check = success end, game['ps_thermite'].time, game['ps_thermite'].gridsize, game['ps_thermite'].incorrect)
			return check
		end
	}

	if ps_ui_map[hack] then
		return ps_ui_map[hack]()
	elseif hack == 'ox' then
		return lib.skillCheck(game['ox'], {'1', '2', '3', '4'})
	end

	local bl_ui_map = {
		blcirprog = function() return exports.bl_ui:CircleProgress(game['blcirprog'].amount, game['blcirprog'].speed) end,
		blprog = function() return exports.bl_ui:Progress(game['blprog'].amount, game['blprog'].speed) end,
		blkeyspam = function() return exports.bl_ui:KeySpam(game['blkeyspam'].amount, game['blprog'].difficulty) end,
		blkeycircle = function() return exports.bl_ui:KeyCircle(game['blkeycircle'].amount, game['blkeycircle'].difficulty, game['blkeycircle'].keynumbers) end,
		blnumberslide = function() return exports.bl_ui:NumberSlide(game['blnumberslide'].amount, game['blnumberslide'].difficulty, game['blnumberslide'].keynumbers) end,
		blrapidlines = function() return exports.bl_ui:RapidLines(game['blrapidlines'].amount, game['blrapidlines'].difficulty, game['blrapidlines'].numberofline) end,
		blcircleshake = function() return exports.bl_ui:CircleShake(game['blcircleshake'].amount, game['blcircleshake'].difficulty, game['blcircleshake'].stages) end
	}

	if bl_ui_map[hack] then
		return bl_ui_map[hack]()
	elseif hack == 'glpath' then
		local settings = {gridSize = game['glpath'].gridSize, lives = game['glpath'].lives, timeLimit = game['glpath'].timelimit}
		local successes = false
		exports["glow_minigames"]:StartMinigame(function(success) successes = success end, "path", settings)
		repeat Wait(1000) time = time + 1 until successes or time == 100
		if successes then return true end
	elseif hack == 'glspot' then
		local settings = {gridSize = game['glspot'].gridSize, timeLimit = game['glspot'].gridSize, charSet = game['glspot'].charSet, required = game['glspot'].required}
		local successes = false
		exports["glow_minigames"]:StartMinigame(function(success) successes = success end, "spot", settings)
		repeat Wait(1000) time = time + 1 until successes or time == 100
	elseif hack == 'glmath' then
		local settings = {timeLimit = game['glmath'].timeLimit}
		local successes = false
		exports["glow_minigames"]:StartMinigame(function(success) successes = success end, "math", settings)
		repeat Wait(1000) time = time + 1 until successes or time == 100
	elseif hack == 'none' then
		return true
	else
		print("^1 SCRIPT ERROR: Md-HouseRobberies set your minigame with one of the options!")
	end
 end

 function Notify(text, type)
	if notifytype =='ox' then
	  lib.notify({title = text, type = type})
        elseif notifytype == 'qb' then
	  QBCore.Functions.Notify(text, type)
	elseif notifytype == 'okok' then
	  exports['okokNotify']:Alert('', text, 4000, type, false)
	else 
       	print"dude, it literally tells you what you need to set it as in the config"
    	end   
  end

function GetImage(img)
    local resource = GetResourceState
    local qbItems = QBCore.Shared.Items
    if resource('ox_inventory') == 'started' then
        local Items = exports['ox_inventory']:Items()
        local client = Items[img] and Items[img]['client']
        if client and client['image'] then
            return client['image']
        end
        return "nui://ox_inventory/web/images/" .. img .. ".png"
    end

    local inventoryMap = {
        ['ps-inventory'] = "nui://ps-inventory/html/images/",
        ['lj-inventory'] = "nui://lj-inventory/html/images/",
        ['qb-inventory'] = "nui://qb-inventory/html/images/",
        ['qs-inventory'] = "nui://qs-inventory/html/img/",
        ['origen_inventory'] = "nui://origen_inventory/html/img/",
        ['core_inventory'] = "nui://core_inventory/html/img/"
    }

    for inv, path in pairs(inventoryMap) do
        if resource(inv) == 'started' then
            return path .. qbItems[img].image
        end
    end
end

function GetLabel(label)
	if GetResourceState('ox_inventory') == 'started' then
		local Items = exports['ox_inventory']:Items()
		return Items[label]['label']
	else
		return QBCore.Shared.Items[label]['label']
	end
end


function ItemCheck(item)
local success 
if GetResourceState('ox_inventory') == 'started' then
    if exports.ox_inventory:GetItemCount(item) >= 1 then return true else Notify('You Need ' .. GetLabel(item) .. " !", 'error') end
else
    if QBCore.Shared.Items[item] == nil then print("There Is No " .. item .. " In Your QB Items.lua") return end
    if QBCore.Functions.HasItem(item) then success = item return success else Notify('You Need ' .. QBCore.Shared.Items[item].label .. " !", 'error') end
end
end

function ItemCheckMulti(item)
	local need = 0
	local has = 0
	for k,v in pairs (item) do 
		need = need + 1
		if GetResourceState('ox_inventory') == 'started' then
			if exports.ox_inventory:GetItemCount(v) >= 1 then has = has + 1 else Notify('You Need ' .. GetLabel(v) .. " !", 'error') end
		else
			if QBCore.Shared.Items[v] == nil then print("There Is No " .. item .. " In Your QB Items.lua") return end
			if QBCore.Functions.HasItem(v) then has = has + 1  else Notify('You Need ' .. QBCore.Shared.Items[v].label .. " !", 'error') end
		end
	end
	if need == has then 
		return true
	else
		return false
	end
end

function PoliceCall(chance)
	local math = math.random(1,100)
	if math <= chance then
		if dispatch == 'ps' then 
			exports['ps-dispatch']:HouseRobbery()
		elseif dispatch == 'cd' then
			local data = exports['cd_dispatch']:GetPlayerInfo()
			TriggerServerEvent('cd_dispatch:AddNotification', {
				job_table = {'police', }, 
				coords = data.coords,
				title = '420-69 House Robbert',
				message = 'A '..data.sex..' robbing a store at '..data.street, 
				flash = 0,
				unique_id = data.unique_id,
				sound = 1,
				blip = {
					sprite = 431, 
					scale = 1.2, 
					colour = 3,
					flashes = false, 
					text = '420-69 HouseRobbery',
					time = 5,
					radius = 0,
				}
			})
		elseif	dispatch == 'core' then
			exports['core_dispatch']:addCall("420-69", "House Is Being Broken Into", {
				{icon="fa-ruler", info="4.5 MILES"},
				}, {GetEntityCoords(PlayerPedId())}, "police", 3000, 11, 5 )
		elseif dispatch == 'aty' then 
			exports["aty_dispatch"]:SendDispatch('House Robbery', '420-69', 40, {'police'})
		elseif dispatch == 'qs' then
			exports['qs-dispatch']:HouseRobbery()
		else
			print('Congrats, You Choose 0 of the options :)')	
		end
	else
	end
end

function GetCops(number)
	if number == 0 then return true end
	local amount = lib.callback.await('md-houserobberies:server:GetCoppers', false)
	if amount >= number then return true else Notify('You Need '.. number - amount .. ' More Cops To Do This', 'error')  end
end


function Freeze(entity, toggle, head)
		SetEntityInvincible(entity, toggle)
		SetEntityAsMissionEntity(entity, toggle, toggle)
        FreezeEntityPosition(entity, toggle)
        SetEntityHeading(entity, head)
		SetBlockingOfNonTemporaryEvents(entity, toggle)
end

function tele(coords) 
	DoScreenFadeOut(500)
	Wait(1000)
	SetEntityCoords(PlayerPedId(),coords.x, coords.y, coords.z)
	Wait(1000)
	DoScreenFadeIn(500)
end


function AddBoxZoneSingle(name, loc, data)
	if Config.Target == 'qb' then
		exports['qb-target']:AddBoxZone(name, loc, 1.5, 1.75, {name = name, minZ = loc.z-1,maxZ = loc.z +1}, 
		{ options = {
			{
			  
			  type = data.type or nil, 
			  event = data.event or nil,
			  action = data.action or nil,
			  icon = data.icon, 
			  label = data.label,
			  data = data.data,
			  canInteract = data.canInteract,
			}
		}, 
		distance = 2.0
	 })
	elseif Config.Target == 'ox' then
		exports.ox_target:addBoxZone({coords = loc, size = vec3(1,1,1), options = {
			{
			  type = data.type or nil, 
			  event = data.event or nil,
			  onSelect = data.action or nil,
			  distance = 2.5,
			  icon = data.icon, 
			  label = data.label,
			  data = data.data,
			  canInteract = data.canInteract,
			}
		}, })
	end
end

function AddBoxZoneMulti(name, table, data) 
	for k, v in pairs (table) do
		if v.gang == nil or v.gang == '' or v.gang == "" then v.gang = 1 end
		if Config.Target == 'qb' then
			exports['qb-target']:AddBoxZone(name .. k, v.loc, 1.5, 1.75, {name = name..k, minZ = v.loc.z-1.50,maxZ = v.loc.z +1.5}, 
			{ options = {
				{
				  type = data.type or nil, 
				  event = data.event or nil,
				  action = data.action or nil,
				  icon = data.icon, 
				  label = data.label,
				  data = k,
				  canInteract = data.canInteract or function()
					if QBCore.Functions.GetPlayerData().gang.name == v.gang or v.gang == 1 then return true end end
				}
			}, 
			distance = 2.5
		 })
		elseif Config.Target == 'ox' then
			exports.ox_target:addBoxZone({coords = v.loc, size = vec3(1,1,1), options = {
				{
				  type = data.type or nil, 
				  event = data.event or nil,
				  onSelect = data.action or nil,
				  icon = data.icon, 
				  label = data.label,
				  data = k,
				  distance = 2.5,
				  canInteract = data.canInteract or function()
					if QBCore.Functions.GetPlayerData().gang.name == v.gang or v.gang == 1 then return true end end
				}
			}, })
		end
	end
end

function AddSingleModel(model, data, num)
	if Config.Target == 'qb' then
		exports['qb-target']:AddTargetEntity(model, {options = {
			{icon = data.icon, label = data.label, event = data.event or nil, action = data.action or nil, data = num, canInteract = data.canInteract }
		}, distance = 2.5})
	elseif Config.Target == 'ox' then
		exports.ox_target:addLocalEntity(model, {icon = data.icon, label = data.label, event = data.event or nil, onSelect = data.action or nil, data = num, distance = 2.5, canInteract = data.canInteract })
	end
end
function AddMultiModel(model, data, num)
	if Config.Target == 'qb' then
		exports['qb-target']:AddTargetEntity(model, {options = data, distance = 2.5})
	elseif Config.Target == 'ox' then
		exports.ox_target:addLocalEntity(model, data)
	end
end

function AddBoxZoneMultiOptions(name, loc, data)
	if Config.Target == 'qb' then
		exports['qb-target']:AddBoxZone(name, loc, 1.5, 1.75, {name = name, minZ = loc.z-1,maxZ = loc.z +1}, { options = data, distance = 2.0})
	elseif Config.Target == 'ox' then
		exports.ox_target:addBoxZone({coords = loc, size = vec3(1,1,1), options = data })
	end
end

local function SpawnHomeowner(k)
    local chance = math.random(1,100)
    local weaponchance = math.random(1,100)
    if Config.pedspawnchance >= chance then
        lib.requestModel(Config.Ped, 1000)
        Wait(2000)
		local loc = vector3(Config.Houses[k]['coords'].x  + Config.PedOff[Config.Houses[k]['tier']].x, Config.Houses[k]['coords'].y + Config.PedOff[Config.Houses[k]['tier']].y, Config.Houses[k]['coords'].z + Config.PedOff[Config.Houses[k]['tier']].z - 145 )
       local homeowner = CreatePed(0, Config.Ped, loc.x, loc.y, loc.z, 0.0, true, false)
         if weaponchance <= Config.weapononechance then GiveWeaponToPed(homeowner, Config.Weaponone, 1, false, true) else  GiveWeaponToPed(homeowner, Config.Weapontwo, 1, false, true) end
         TaskCombatPed(homeowner, PlayerPedId(), 0, 16)
         SetPedCombatAttributes(homeowner, 46, true)
         SetPedAccuracy(homeowner,50)
         SetPedArmour(homeowner, 100)
         AddSingleModel(homeowner, 
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
        }, homeowner)
    end
end   

function BreakIn(k)
if not GetCops(Config.MinCops) then	return end		
local tier = Config.Houses[k]['tier']				
if not ItemCheck(Config.LockpickItems[tier].item) then return end
if not minigame2(Config.Houses[k]['tier']) then TriggerServerEvent('md-houserobbery:server:accessbreak', Config.Houses[k]['tier'], Config.LockpickItems[tier].item ) return end
	TriggerServerEvent('md-houserobbery:server:enterHouse', k)
	SpawnHomeowner(k)
	PoliceCall(Config.AlertPolice)

end
