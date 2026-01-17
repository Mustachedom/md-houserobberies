
local dispatch = Config.Dispatch

  function minigame(tier)
	local game = Config.Minigames
	if tier == 'ps_circle' then
		local check = exports['ps-ui']:Circle(false, game['ps_circle'].amount, game['ps_circle'].speed) 
		return check
   elseif tier == 'ps_maze' then
	   local check = exports['ps-ui']:Maze(false, game['ps_maze'].timelimit)
	   return check
   elseif tier == 'ps_scrambler' then
	   local check = exports['ps-ui']:Scrambler(false, game['ps_scrambler'].type,  game['ps_scrambler'].time, game['ps_scrambler'].mirrored)
	   return check
   elseif tier == 'ps_var' then
	   local check = exports['ps-ui']:VarHack(false, game['ps_var'].numBlocks,  game['ps_var'].time)
	   return check
   elseif tier == 'ps_thermite' then
	   local check = exports['ps-ui']:Thermite(false, game['ps_thermite'].time,  game['ps_thermite'].gridsize, game['ps_thermite'].incorrect)
	   return check
	elseif tier == 'ox' then
		local success = lib.skillCheck(game['ox'], {'1', '2', '3', '4'})
		return success
	elseif tier == 'blcirprog' then
		local success = exports.bl_ui:CircleProgress(game['blcirprog'].amount, game['blcirprog'].speed)
		return success
	elseif tier == 'blprog' then
		local success = exports.bl_ui:Progress(game['blprog'].amount, game['blprog'].speed)
		return success
	elseif tier == 'blkeyspam' then
		local success = exports.bl_ui:KeySpam(game['blkeyspam'].amount, game['blprog'].difficulty)
		return success
	elseif tier == 'blkeycircle' then
		local success = exports.bl_ui:KeyCircle(game['blkeycircle'].amount, game['blkeycircle'].difficulty, game['blkeycircle'].keynumbers)
		return success	
	elseif tier == 'blnumberslide' then
		local success = exports.bl_ui:NumberSlide(game['blnumberslide'].amount, game['blnumberslide'].difficulty, game['blnumberslide'].keynumbers)
		return success	
	elseif tier == 'blrapidlines' then
		local success = exports.bl_ui:RapidLines(game['blrapidlines'].amount, game['blrapidlines'].difficulty, game['blrapidlines'].numberofline)
		return success	
	elseif tier == 'blcircleshake' then
		local success = exports.bl_ui:CircleShake(game['blcircleshake'].amount, game['blcircleshake'].difficulty, game['blcircleshake'].stages)
		return success	
	elseif tier == 'none' then 
		return true
	else
		Bridge.Prints.Warn(Bridge.Language.Locale('Error.noGame'))
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
				job_table = {'police'},
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
		else
			Bridge.Prints.Warn(Bridge.Language.Locale('Error.noDispatch'))
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


if Config.Emotes == 'rp' then
	function playEmote(emote)
		return exports["rpemotes"]:EmoteCommandStart(emote)
	end
	function stopEmote()
		return exports["rpemotes"]:EmoteCancel()
	end
end

if Config.Emotes == 'dp' then
	function playEmote(emote)
		TriggerEvent('animations:client:EmoteCommandStart', {emote})
	end
	function stopEmote()
		TriggerEvent('animations:client:EmoteCommandStart', {"c"})
	end
end

if Config.Emotes == 'scully' then
	function playEmote(emote)
		exports.scully_emotemenu:playEmoteByCommand(emote)
	end
	function stopEmote()
		exports.scully_emotemenu:cancelEmote()
	end
end

if Config.Emotes == 'custom' then
	function playEmote(emote)
		TriggerEvent('animations:client:EmoteCommandStart', {emote})
	end
	function stopEmote()
		TriggerEvent('animations:client:EmoteCommandStart', {"c"})
	end
end

function progressbar(text, time, emote, cancel)
	playEmote(emote)
	if not cancel then
		cancel =  {
			move = true,
			car = true,
			combat = true
		}
	end
	local success = Bridge.ProgressBar.Open({
		duration = time,
		label = text,
		canCancel = true,
		disable = cancel,
	})
	stopEmote()
	return success
end