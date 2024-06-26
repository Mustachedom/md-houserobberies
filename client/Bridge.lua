local QBCore = exports['qb-core']:GetCoreObject()

local progressbartype = Config.progressbartype 
local minigametype = Config.minigametype
local notifytype = Config.Notify 
local dispatch = Config.Dispatch


function progressbar(text, time, anim)
	TriggerEvent('animations:client:EmoteCommandStart', {anim}) 
	if progressbartype == 'oxbar' then 
	  if lib.progressBar({ duration = time, label = text, useWhileDead = false, canCancel = true, disable = { car = true, move = true},}) then 
		TriggerEvent('animations:client:EmoteCommandStart', {"c"}) 
		if GetResourceState('scully_emotemenu') == 'started' then
			exports.scully_emotemenu:cancelEmote()
		end
		return true
	  end	 
	elseif progressbartype == 'oxcir' then
	  if lib.progressCircle({ duration = time, label = text, useWhileDead = false, canCancel = true, position = 'bottom', disable = { car = true,move = true},}) then 
		TriggerEvent('animations:client:EmoteCommandStart', {"c"}) 
		if GetResourceState('scully_emotemenu') == 'started' then
			exports.scully_emotemenu:cancelEmote()
		end	
		return true
	  end
	elseif progressbartype == 'qb' then
		local test = false
		local cancelled = false
	  QBCore.Functions.Progressbar("drink_something", text, time, false, true, { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true, disableInventory = true,
	  }, {}, {}, {}, function()-- Done
		test = true
		TriggerEvent('animations:client:EmoteCommandStart', {"c"}) 
		if GetResourceState('scully_emotemenu') == 'started' then
			exports.scully_emotemenu:cancelEmote()
		end		
	  end, function()
		cancelled = true
		if GetResourceState('scully_emotemenu') == 'started' then
			exports.scully_emotemenu:cancelEmote()
		end		
	end)
	  repeat 
		Wait(100)
	  until cancelled or test
	  if test then return true end
	else
		print"dude, it literally tells you what you need to set it as in the config"
	end	  
  end

function minigame(num1, num2)
    local check
	if minigametype == 'ps' then
    	exports['ps-ui']:Circle(function(success)
        	check = success
    	end, num1, num2) 
    	return check
	elseif minigametype == 'ox' then
		num1 = 'easy'
		if num2 <= 8 then num2 = 'hard' elseif num2 >= 8 and num2 <= 12 then num2 = 'medium' else num2 = 'easy' end
		local success = lib.skillCheck({num1, num2}, {'1', '2', '3', '4'})
		return success 
    else
        print"dude, it literally tells you what you need to set it as in the config"
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

  function ItemCheck(item)
	local success 
		 if GetResourceState('ox_inventory') == 'started' then
			local Items = exports['ox_inventory']:Items()
			if Items[item] == nil then print("There Is No " .. item .. " In Your OX Items.lua") return end
			if exports.ox_inventory:GetItemCount(item) >= 1 then return true else Notify('You Need ' .. Items[item].label .. " !", 'error') end
		else
			if QBCore.Shared.Items[item] == nil then print("There Is No " .. item .. " In Your QB Items.lua") return end
			if QBCore.Functions.HasItem(item) then success = item return success else Notify('You Need ' .. QBCore.Shared.Items[item].label .. " !", 'error') end
		end
	end
	
	function Email(sender, subject, message)
		if Config.Phone == 'yflip' then
			local receiver = GetPlayerServerId(PlayerId())
			local insertId, received = exports["yflip-phone"]:SendMail({
				title = subject,
				sender = sender,
				senderDisplayName = sender,
				content = message,
				
			}, 'phoneNumber', receiver)
		elseif Config.Phone == 'qs' then
			TriggerServerEvent('qs-smartphone:server:sendNewMail', {
			   sender = sender,
			   subject = subject,
				message = message,
				button = {}
			})
		else
			TriggerServerEvent('qb-phone:server:sendNewMail', {
				sender = sender,
				subject = subject,
				message = message,
			})
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
	local need = false
	local nope = false
	QBCore.Functions.TriggerCallback('md-houserobberies:server:GetCoppers', function(amount)
		if amount >= number then need = true else Notify('You Need '.. number - amount .. ' More Cops To Do This', 'error') nope = true end
	end)
	repeat 
		Wait(100)
	until need or nope
	if need then return true end
end


function GetImage(img)
	if GetResourceState('ox_inventory') == 'started' then
		local Items = exports['ox_inventory']:Items()
		if Items[img]['client'] == nil then 
			return Items[img]
		else
			return Items[img]['client']['image']
		end
	elseif GetResourceState('qb-inventory') == 'started' then
		return "nui://qb-inventory/html/images/".. QBCore.Shared.Items[img].image
	elseif GetResourceState('lj-inventory') == 'started' then
		return "nui://lj-inventory/html/images/".. QBCore.Shared.Items[img].image
	elseif GetResourceState('qb-inventory') == 'started' then
		return "nui://qb-inventory/html/images/".. QBCore.Shared.Items[img].image
	elseif GetResourceState('qs-inventory') == 'started' then
		return "nui://qs-inventory/html/imgages/".. QBCore.Shared.Items[img].image
	elseif GetResourceState('origen_inventory') == 'started' then
		return "nui://origen_inventory/html/img/".. QBCore.Shared.Items[img].image
	elseif GetResourceState('core_inventory') == 'started' then
		return "nui://core_inventory/html/img/".. QBCore.Shared.Items[img].image
	end
end

function GetLabel(img)
	if GetResourceState('ox_inventory') == 'started' then
		local Items = exports['ox_inventory']:Items()
			return Items[img]['label']
	else
		return QBCore.Shared.Items[img].label
	end
end
