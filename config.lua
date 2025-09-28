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
    glpath =        {    gridsize = 10,  lives = 3,     timelimit = 999999},
    glspot =        {gridSize = 6, timeLimit = 999999, charSet = "alphabet", required = 10},
    glmath =        {timeLimit = 300000},

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
            exports['qb-interior']:CreateLesterShell(coords)
        end,
        despawn = function(shell, cb)
            exports['qb-interior']:DespawnInterior(shell[1], cb)
        end
    },
    {
        name = 'qb-interior',
        func = function(coords)
            exports['qb-interior']:CreateTrevorsShell(coords)
        end,
        despawn = function(shell, cb)
            exports['qb-interior']:DespawnInterior(shell[1], cb)
        end
    },
    {
        name = 'qb-interior',
        func = function(coords)
            exports['qb-interior']:CreateHouseRobbery(coords)
        end,
        despawn = function(shell, cb)
            exports['qb-interior']:DespawnInterior(shell[1], cb)
        end
    },
    {
        name = 'qb-interior',
        func = function(coords)
            exports['qb-interior']:CreateFurniMotelModern(coords)
        end,
        despawn = function(shell, cb)
            exports['qb-interior']:DespawnInterior(shell[1], cb)
        end
    },
    {
        name = 'qb-interior',
        func = function(coords)
            exports['qb-interior']:CreateMichael(coords)
        end,
        despawn = function(shell, cb)
            exports['qb-interior']:DespawnInterior(shell[1], cb)
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
      {x = 4.0, y = 0.0, z = 3.0},     -- tier 1
      {x = 1.7, y = 1.0, z = 1.0},     -- tier 2
      {x = 3.0, y = 0.0, z = 3.0},     -- tier 3
      {x = 2.3, y = -0.0, z = 1.0},    -- tier 4
      {x = 0.0, y = 0.0, z = 1.5},     -- tier 5
      {x = -8.0, y = 1.0, z = 14.5},   -- tier 6
    }

---------------------------------------------------------------------------------------
-- if you assault the black market ped, he will try to kill you ;) --------------------
-- if fail of successchance he will keep items and not give you money------------------
---------------------------------------------------------------------------------------

Config.BlackMarket = {
    [1] = { item = 'diamond_ring',  minvalue = 10, maxvalue = 30, successchance = 90},
    [2] = { item = 'goldchain',     minvalue = 10, maxvalue = 30, successchance = 90},
    [3] = { item = 'thermite',      minvalue = 10, maxvalue = 30, successchance = 90},
    [4] = { item = 'rolex',         minvalue = 10, maxvalue = 30, successchance = 90},
    [5] = { item = 'tablet',        minvalue = 10, maxvalue = 30, successchance = 90},
    [6] = { item = 'art1',          minvalue = 10, maxvalue = 30, successchance = 90},
    [7] = { item = 'art2',          minvalue = 10, maxvalue = 30, successchance = 90},
    [8] = { item = 'art3',          minvalue = 10, maxvalue = 30, successchance = 90},
    [9] = { item = 'art4',          minvalue = 10, maxvalue = 30, successchance = 90},
    [10] = {item = 'art5',          minvalue = 10, maxvalue = 30, successchance = 90},
    [11] = {item = 'art6',          minvalue = 10, maxvalue = 30, successchance = 90},
    [12] = {item = 'art7',          minvalue = 10, maxvalue = 30, successchance = 90},
    [13] = {item = 'radioscanner',  minvalue = 10, maxvalue = 30, successchance = 90},
    [14] = {item = 'pinger',        minvalue = 10, maxvalue = 30, successchance = 90},
    [15] = {item = 'gatecrack',     minvalue = 10, maxvalue = 30, successchance = 90},
    [16] = {item = 'houselaptop',   minvalue = 10, maxvalue = 30, successchance = 90},
    [17] = {item = 'mansionlaptop', minvalue = 10, maxvalue = 30, successchance = 90},
    [18] = {item = 'electronickit', minvalue = 10, maxvalue = 30, successchance = 90},
    [19] = {item = 'boombox',       minvalue = 10, maxvalue = 30, successchance = 90},
    [20] = {item = 'mdspeakers',    minvalue = 10, maxvalue = 30, successchance = 90},
    [21] = {item = 'mdtablet',      minvalue = 10, maxvalue = 30, successchance = 90},
    [22] = {item = 'mddesktop',     minvalue = 10, maxvalue = 30, successchance = 90},
    [23] = {item = 'mdmonitor',     minvalue = 10, maxvalue = 30, successchance = 90},
    [24] = {item = 'checkbook',     minvalue = 10, maxvalue = 30, successchance = 90},
}
