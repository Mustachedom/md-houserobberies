Config = {}
ps = exports.ps_lib:init()
ps.loadLangs('en')
Bridge = exports.community_bridge:Bridge()
Config.Dispatch = 'ps' -- either ps/aty/core/cd
Config.Minigames = {
    ps_circle =            {    amount = 2,     speed = 8,},
    ps_maze =            {    timelimit = 15},
    ps_scrambler =            {    type = 'numeric', time = 15, mirrored = 0},
    ps_var =            {    numBlocks = 5, time = 10},
    ps_thermite =            {  time = 10, gridsize = 5, incorrect = 3},
    ox =            { 'easy', 'easy'},   --easy medium or hard each one corresponds to how many skillchecks and the difficulty
    blcirprog =     {    amount = 2,     speed = 50},       -- speed = 1-100
    blprog =        {    amount = 1,     speed = 50},       -- speed = 1-100
    blkeyspam =     {    amount = 1,     difficulty = 50}, -- difficulty = 1-100
    blkeycircle =   {    amount = 1,     difficulty = 50, keynumbers = 3},
    blnumberslide = {    amount = 1,     difficulty = 50, keynumbers = 3},
    blrapidlines =  {    amount = 1,     difficulty = 50, numberofline = 3},
    blcircleshake = {    amount = 1,     difficulty = 50, stages = 3},
}


Config.TierData = {
    {
        offset = {x = -1.5, y = -2.0, z = 3.0}, -- this is front door
        ped = {pedModel = 'ig_priest', loc = vector3(4.0, 0.0, 3.0), weapon = 'WEAPON_PISTOL', chance = 100}, -- if you dont want a ped make chance 0
        police = 0, -- police required to break in 
        policeCallChance = 20, -- chance dispatch alert is sent out
        robGame = 'ps_circle', -- minigame to use for robbing
        progressbarRob = 8000, -- time in ms for robbing loot 
        breakInGame = 'ps_circle', -- minigame to use for breaking in
        breakInItem = 'lockpick', -- item required to break in
        export = {
            func = function(coords)
                return exports['qb-interior']:CreateCaravanShell(coords)
            end,
            despawn = function(shell, cb)
                exports['qb-interior']:DespawnInterior(shell[1], cb)
            end
        }
    },
    {
        offset = {x = -1.7, y = -1.0, z = 1.0},
        ped = {pedModel = 'ig_priest', loc = vector3(1.7, 1.0, 1.0), weapon = 'WEAPON_PISTOL', chance = 30},
        police = 2,
        policeCallChance = 30,
        robGame = 'ps_circle',
        progressbarRob = 10000,
        breakInGame = 'ps_maze',
        breakInItem = 'lockpick',
        export = {
            func = function(coords)
                return exports['qb-interior']:CreateLesterShell(coords)
            end,
            despawn = function(shell, cb)
                exports['qb-interior']:DespawnInterior(shell[1], cb)
            end
        }
    },
    {
        offset = {x = -0.1, y = -3.8, z = 3.0},
        ped = {pedModel = 'ig_priest', loc = vector3(3.0, 0.0, 3.0),weapon = 'WEAPON_PISTOL', chance = 40},
        police = 3,
        policeCallChance = 40,
        robGame = 'ps_circle',
        progressbarRob = 12000,
        breakInGame = 'ps_scrambler',
        breakInItem = 'advancedlockpick',
        export = {
            func = function(coords)
                return exports['qb-interior']:CreateTrevorsShell(coords)
            end,
            despawn = function(shell, cb)
                exports['qb-interior']:DespawnInterior(shell[1], cb)
            end
        }
    },
    {
        offset = {x = 1.8, y = -10.0, z = 1.0},
        ped = {pedModel = 'ig_priest', loc = vector3(2.3, -0.0, 1.0),weapon = 'WEAPON_PISTOL', chance = 50},
        police = 4,
        policeCallChance = 50,
        robGame = 'ps_circle',
        progressbarRob = 15000,
        breakInGame = 'ps_var',
        breakInItem = 'advancedlockpick',
        export = {
            func = function(coords)
                return exports['qb-interior']:CreateHouseRobbery(coords)
            end,
            despawn = function(shell, cb)
                exports['qb-interior']:DespawnInterior(shell[1], cb)
            end
        }
    },
    {
        offset = {x = 5.2, y = 4.5, z = 1.5},
        ped = {pedModel = 'ig_priest', loc = vector3(0.0, 0.0, 1.5),weapon = 'WEAPON_PISTOL', chance = 70},
        police = 5,
        policeCallChance = 60,
        robGame = 'ps_circle',
        progressbarRob = 18000,
        breakInGame = 'ps_thermite',
        breakInItem = 'houselaptop',
        export = {
            func = function(coords)
                return exports['qb-interior']:CreateFurniMotelModern(coords)
            end,
            despawn = function(shell, cb)
                exports['qb-interior']:DespawnInterior(shell[1], cb)
            end
        }
    },
    {
        offset = {x = -10.0, y = 5.8, z = 10.5},
        ped = {pedModel = 'ig_priest', loc = vector3(-8.0, 1.0, 14.5),weapon = 'WEAPON_PISTOL', chance = 90},
        police = 6,
        policeCallChance = 70,
        robGame = 'ps_circle',
        progressbarRob = 20000,
        breakInGame = 'ox',
        breakInItem = 'houselaptop',
        export = {
        name = 'qb-interior',
            func = function(coords)
                return exports['qb-interior']:CreateMichael(coords)
            end,
            despawn = function(shell, cb)
                return exports['qb-interior']:DespawnInterior(shell[1], cb)
            end
        }
    }
}

Config.RobbedRandomLocs = { -- if robbed by fence they will be teleported to one of these locations
    vector3(984.76, 3579.28, 33.64),
    vector3(899.73, 3561.92, 34.57)
}