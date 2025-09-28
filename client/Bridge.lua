
local dispatch = Config.Dispatch

  function minigame(tier)
	local game = Config.Minigames
	local tiered = {
		'ps_circle',
		'ps_circle',
		'ps_circle',
		'ps_circle',
		'ps_circle',
		'ps_circle',
	}
	if tiered[tier] == 'ps_circle' then
		local check = exports['ps-ui']:Circle(false, game['ps_circle'].amount, game['ps_circle'].speed) 
		return check
   elseif tiered[tier] == 'ps_maze' then
	   local check = exports['ps-ui']:Maze(false, game['ps_maze'].timelimit)
	   return check
   elseif tiered[tier] == 'ps_scrambler' then
	   local check = exports['ps-ui']:Scrambler(false, game['ps_scrambler'].type,  game['ps_scrambler'].time, game['ps_scrambler'].mirrored)
	   return check
		  
   elseif tiered[tier] == 'ps_var' then
	   local check = exports['ps-ui']:VarHack(false, game['ps_var'].numBlocks,  game['ps_var'].time)
	   return check
   elseif tiered[tier] == 'ps_thermite' then
	   local check = exports['ps-ui']:Thermite(false, game['ps_thermite'].time,  game['ps_thermite'].gridsize, game['ps_thermite'].incorrect)
	   return check
	elseif tiered[tier] == 'ox' then
		local success = lib.skillCheck(game['ox'], {'1', '2', '3', '4'})
		return success
	elseif tiered[tier] == 'blcirprog' then
		local success = exports.bl_ui:CircleProgress(game['blcirprog'].amount, game['blcirprog'].speed)
		return success
	elseif tiered[tier] == 'blprog' then
		local success = exports.bl_ui:Progress(game['blprog'].amount, game['blprog'].speed)
		return success
	elseif tiered[tier] == 'blkeyspam' then
		local success = exports.bl_ui:KeySpam(game['blkeyspam'].amount, game['blprog'].difficulty)
		return success
	elseif tiered[tier] == 'blkeycircle' then
		local success = exports.bl_ui:KeyCircle(game['blkeycircle'].amount, game['blkeycircle'].difficulty, game['blkeycircle'].keynumbers)
		return success	
	elseif tiered[tier] == 'blnumberslide' then
		local success = exports.bl_ui:NumberSlide(game['blnumberslide'].amount, game['blnumberslide'].difficulty, game['blnumberslide'].keynumbers)
		return success	
	elseif tiered[tier] == 'blrapidlines' then
		local success = exports.bl_ui:RapidLines(game['blrapidlines'].amount, game['blrapidlines'].difficulty, game['blrapidlines'].numberofline)
		return success	
	elseif tiered[tier] == 'blcircleshake' then
		local success = exports.bl_ui:CircleShake(game['blcircleshake'].amount, game['blcircleshake'].difficulty, game['blcircleshake'].stages)
		return success	
	elseif tiered[tier] == 'none' then 
		return true
	else
		print"^1 SCRIPT ERROR: Md-HouseRobberies set your minigame with one of the options!"
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
