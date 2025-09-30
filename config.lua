Config = {}
ps = exports.ps_lib:init()

Config.Dispatch = 'ps' -- either ps/aty/qs/core/cd
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

Config.TierExports = {
    {
        name = 'qb-interior',
        func = function(coords)
            return exports['qb-interior']:CreateCaravanShell(coords)
        end,
        despawn = function(shell, cb)
            exports['qb-interior']:DespawnInterior(shell[1], cb)
        end
    },
    {
        name = 'qb-interior',
        func = function(coords)
            return exports['qb-interior']:CreateLesterShell(coords)
        end,
        despawn = function(shell, cb)
            exports['qb-interior']:DespawnInterior(shell[1], cb)
        end
    },
    {
        name = 'qb-interior',
        func = function(coords)
            return exports['qb-interior']:CreateTrevorsShell(coords)
        end,
        despawn = function(shell, cb)
            exports['qb-interior']:DespawnInterior(shell[1], cb)
        end
    },
    {
        name = 'qb-interior',
        func = function(coords)
            return exports['qb-interior']:CreateHouseRobbery(coords)
        end,
        despawn = function(shell, cb)
            exports['qb-interior']:DespawnInterior(shell[1], cb)
        end
    },
    {
        name = 'qb-interior',
        func = function(coords)
            return exports['qb-interior']:CreateFurniMotelModern(coords)
        end,
        despawn = function(shell, cb)
            exports['qb-interior']:DespawnInterior(shell[1], cb)
        end
    },
    {
        name = 'qb-interior',
        func = function(coords)
            return exports['qb-interior']:CreateMichael(coords)
        end,
        despawn = function(shell, cb)
            return exports['qb-interior']:DespawnInterior(shell[1], cb)
        end 
    }
}
Config.OffSet = {
      {x = -1.5, y = -2.0, z = 3.0},     -- tier 1
      {x = -1.7, y = -1.0, z = 1.0},     -- tier 2
      {x = -0.1, y = -3.8, z = 3.0},      -- tier 3
      {x = 1.8, y = -10.0, z = 1.0},     -- tier 4
      {x = 5.2, y = 4.5, z = 1.5},       -- tier 5
      {x = -10.0, y = 5.8, z = 10.5},    -- tier 6
    }


    Config.PedOff = {
      {pedModel = 'ig_priest', loc = vector3(4.0, 0.0, 3.0)},     -- tier 1
      {pedModel = 'ig_priest', loc = vector3(1.7, 1.0, 1.0)},     -- tier 2
      {pedModel = 'ig_priest', loc = vector3(3.0, 0.0, 3.0)},     -- tier 3
      {pedModel = 'ig_priest', loc = vector3(2.3, -0.0, 1.0)},    -- tier 4
      {pedModel = 'ig_priest', loc = vector3(0.0, 0.0, 1.5)},     -- tier 5
      {pedModel = 'ig_priest', loc = vector3(-8.0, 1.0, 14.5)},   -- tier 6
    }
    Config.spawnChance = 50 -- chance in percent that a ped will spawn in the house
---------------------------------------------------------------------------------------
-- if you assault the black market ped, he will try to kill you ;) --------------------
-- if fail of successchance he will keep items and not give you money------------------
---------------------------------------------------------------------------------------