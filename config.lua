Config = {}

Config.MinZOffset = 45 -- how far down the shell spawns
Config.MinimumHouseRobberyPolice = 2 -- how many cops on to rob house
Config.MinimumTime = 5 -- what time to start robberies
Config.MaximumTime = 22 -- what time to end robberies
Config.Ped = "csb_reporter"  -- what ped model
Config.pedspawnchance = 20 -- how many % ped will spawn
Config.weapononechance = 80  -- % chance to have weapon one 
Config.Weaponone = "weapon_pistol"
Config.Weapontwo = "weapon_bullpupshotgun"
Config.ShowItems = true -- shows players they are at a house and what items they need
Config.PoliceLockDoors = true -- allows police to lock doors of houses

Config.Rewards = {
    [1] = {
        ["cabin"] = {"plastic", "diamond_ring", "goldchain", "weed_skunk", "thermite", "cryptostick", "weapon_golfclub"},
        ["kitchen"] = {"tosti", "sandwich", "goldchain"},
        ["chest"] = {"plastic", "rolex", "diamond_ring", "goldchain", "weed_skunk", "thermite", "cryptostick", "weapon_combatpistol"},
        ["livingroom"] = {"plastic", "rolex", "diamond_ring", "goldchain", "thermite", "cryptostick", "tablet", "pistol_ammo"}
    },
	
	[2] = {
        ["cabin"] = {"advancedlockpick", "diamond_ring", "goldchain", "weed_white-widow", "thermite", "cryptostick", "advancedrepairkit"},
        ["kitchen"] = {"tosti", "sandwich", "goldchain"},
        ["chest"] = {"advancedlockpick", "rolex", "diamond_ring", "goldchain", "weed_white-widow", "xtcbaggy", "cryptostick", "weapon_knife"},
        ["livingroom"] = {"advancedlockpick", "rolex", "diamond_ring", "goldchain", "thermite", "cryptostick", "tablet", "pistol_ammo"}
    },
	[3] = {
        ["cabin"] = {"trojan_usb", "diamond_ring", "goldchain", "weed_purple-haze", "thermite", "advancedlockpick", "weapon_golfclub"},
        ["kitchen"] = {"tosti", "sandwich", "goldchain"},
        ["chest"] = {"trojan_usb", "rolex", "diamond_ring", "goldchain", "weed_purple-haze", "thermite", "cryptostick", "weapon_machete"},
        ["livingroom"] = {"trojan_usb", "rolex", "diamond_ring", "goldchain", "thermite", "cryptostick", "tablet", "pistol_ammo"}
    },
	[4] = {
        ["cabin"] = {"gatecrack", "diamond_ring", "goldchain", "weed_og-kush", "thermite", "cryptostick", "weapon_golfclub"},
        ["kitchen"] = {"tosti", "sandwich", "goldchain"},
        ["chest"] = {"gatecrack", "rolex", "diamond_ring", "goldchain", "weed_og-kush", "thermite", "cryptostick", "weapon_wrench"},
        ["livingroom"] = {"gatecrack", "rolex", "diamond_ring", "goldchain", "thermite", "cryptostick", "tablet", "pistol_ammo"}
    },
	[5] = {
        ["cabin"] = {"electronickit", "diamond_ring", "goldchain", "weed_amnesia", "thermite", "cryptostick", "weapon_knuckle"},
        ["kitchen"] = {"tosti", "sandwich", "goldchain"},
        ["chest"] = {"electronickit", "rolex", "diamond_ring", "goldchain", "weed_amnesia", "thermite", "cryptostick", "weapon_bat"},
        ["livingroom"] = {"electronickit", "rolex", "diamond_ring", "goldchain", "thermite", "cryptostick", "tablet", "pistol_ammo"}
    },
	[6] = {
       ["cabin"] = {"drill", "diamond_ring", "goldchain", "weed_ak47", "thermite", "cryptostick", "weapon_golfclub"},
        ["kitchen"] = {"tosti", "sandwich", "goldchain"},
        ["chest"] = {"drill", "rolex", "diamond_ring", "goldchain", "weed_ak47", "thermite", "cryptostick", "weapon_combatpistol"},
        ["livingroom"] = {"drill", "rolex", "cokebaggy", "goldchain", "thermite", "cryptostick", "tablet", "pistol_ammo"}
    },
	
}

Config.tier1 = {
	[1] = {
		["type"] = "kitchen",
		["coords"] = {["x"] = 2.50, ["y"] = -1.10, ["z"] = 3.0},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search Kitchen Shelves"
	},
	[2] = {
		["type"] = "cabinet",
		["coords"] = {["x"] = -2.90, ["y"] = -1.60, ["z"] = 3.0},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search Cabinet"
	},
	[3] = {
		["type"] = "livingroom",
		["coords"] = {["x"] = -4.50, ["y"] = -1.60, ["z"] = 3.0},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search shelf"
	},
	[4] = {
		["type"] = "chest",
		["coords"] = {["x"] = -5.70, ["y"] = -1.60, ["z"] = 3.0},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search Dresser"
	},
	[5] = {
		["type"] = "chest",
		["coords"] = {["x"] = .90, ["y"] = -1.60, ["z"] = 3.0},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search Sink"
	},
            
}

Config.tier2 = {
	[1] = {
        ["type"] = "livingroom",
        ["coords"] = {["x"] = -0.40, ["y"] = -3.92, ["z"] = 1.0},
        ["searched"] = false,
        ["isBusy"] = false,
        ["text"] = "Search Behind the door"
    },
    [2] = {
        ["type"] = "cabin",
        ["coords"] = {["x"] = -1.20, ["y"] = 2.78, ["z"] = 1.0},
        ["searched"] = false,
        ["isBusy"] = false,
        ["text"] = "Search Desk"
    },
    [3] = {
        ["type"] = "kitchen",
        ["coords"] = {["x"] = 1.15, ["y"] = 5.78, ["z"] = 1.0},
        ["searched"] = false,
        ["isBusy"] = false,
        ["text"] = "Search Behind The Tarp"
    },
    [4] = {
        ["type"] = "chest",
        ["coords"] = {["x"] = 6.904, ["y"] = 3.987, ["z"] = 1.0},
        ["searched"] = false,
        ["isBusy"] = false,
        ["text"] = "Search Chest"
    },
    [5] = {
        ["type"] = "cabin",
        ["coords"] = {["x"] = -1.00, ["y"] = 1.254, ["z"] = 1.0},
        ["searched"] = false,
        ["isBusy"] = false,
        ["text"] = "Search Closet"
    },
    [6] = {
        ["type"] = "cabin",
         ["coords"] = {["x"] = -1.20, ["y"] = -6.10, ["z"] = 1.0},
        ["searched"] = false,
        ["isBusy"] = false,
        ["text"] = "search Behind The Door"
    },
}

Config.tier3 = {

	[1] = {
		["type"] = "cabin",
		["coords"] = {["x"] = 3.40, ["y"] = -3.80, ["z"] = 2.5},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search Bathroom Sink"
	},
	[2] = {
		["type"] = "cabin",
		["coords"] = {["x"] = -1.80, ["y"] = -2.00, ["z"] = 2.5},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search Kitchen Cabinet"
	},
	[3] = {
		["type"] = "chest",
		["coords"] = {["x"] = 4.30, ["y"] = 2.75, ["z"] = 2.5},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search Closet"
	},
	[4] = {
		["type"] = "kitchen",
		["coords"] = {["x"] = -2.50, ["y"] = -3.80, ["z"] = 2.5},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search Sink"
	},
	[5] = {
		["type"] = "kitchen",
		["coords"] = {["x"] = -1.80, ["y"] = -1.00, ["z"] = 2.5},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search Fridge "
	},
	[6] = {
		["type"] = "chest",
		["coords"] = {["x"] = -5.25, ["y"] = -3.80, ["z"] = 2.5},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "search Shelves"
	},
	
	[7] = {
		["type"] = "livingroom",
		["coords"] = {["x"] = 0.30, ["y"] = 2.30, ["z"] = 2.5},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search Closet"
    },
	

}

Config.tier4 = {
	
	[1] = {
		["type"] = "cabin",
		["coords"] = {["x"] = 4.15, ["y"] = 7.82, ["z"] = 1.0},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search Bedside Cabinet"
	},
	[2] = {
		["type"] = "cabin",
		["coords"] = {["x"] = 5.95, ["y"] = 9.34, ["z"] = 1.0},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search Closet"
	},
	[3] = {
		["type"] = "kitchen",
		["coords"] = {["x"] = -1.03, ["y"] = 0.78, ["z"] = 1.0},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search through the kitchen cabinets"
	},
	[4] = {
		["type"] = "chest",
		["coords"] = {["x"] = 6.904, ["y"] = 3.987, ["z"] = 1.0},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search Chest"
	},
	[5] = {
		["type"] = "cabin",
		["coords"] = {["x"] = 0.933, ["y"] = 1.254, ["z"] = 1.0},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search Drawers"
	},
	[6] = {
		["type"] = "cabin",
		["coords"] = {["x"] = 6.19, ["y"] = 3.35, ["z"] = 1.0},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Night Stand Cabinet"
	},
	[7] = {
		["type"] = "kitchen",
		["coords"] = {["x"] = -2.20, ["y"] = -0.30, ["z"] = 1.0},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search through the kitchen cabinets"
	},
	[8] = {
		["type"] = "kitchen",
		["coords"] = {["x"] = -4.35, ["y"] = -0.64, ["z"] = 1.0},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search through shelves"
	},
	[9] = {
		["type"] = "livingroom",
		["coords"] = {["x"] = -6.90, ["y"] = 4.42, ["z"] = 1.0},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search through shelves"
	},
	[10] = {
		["type"] = "livingroom",
		["coords"] = {["x"] = -6.98, ["y"] = 7.91, ["z"] = 1.0},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search through shelves"
	},
}

Config.tier5 = {

	[1] = {
		["type"] = "cabin",
		["coords"] = {["x"] = 1.80, ["y"] = -3.80, ["z"] = 1.00},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search dresser"
	},
	[2] = {
		["type"] = "cabin",
		["coords"] = {["x"] = 4.25, ["y"] = -3.80, ["z"] = 1.0},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search dresser"
	},
	[3] = {
		["type"] = "kitchen",
		["coords"] = {["x"] = 5.70, ["y"] = 0.00, ["z"] = 1.0},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search through the kitchen cabinets"
	},
	[4] = {
		["type"] = "kitchen",
		["coords"] = {["x"] = -4.50, ["y"] = 3.80, ["z"] = 1.0},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search Chest"
	},
	[5] = {
		["type"] = "chest",
		["coords"] = {["x"] = -1.80, ["y"] = -3.80, ["z"] = 1.00},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search dresser"
	},
	[6] = {
		["type"] = "chest",
	["coords"] = {["x"] = -4.25, ["y"] = -3.80, ["z"] = 1.0},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "search dresser"
	},
	[7] = {
		["type"] = "livingroom",
		["coords"] = {["x"] = -6.20, ["y"] = -1.30, ["z"] = 1.0},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search bedside table"
	},
}

Config.tier6 = {

	[1] = {
		["type"] = "cabin",
		["coords"] = {["x"] = -4.25, ["y"] = -2.5, ["z"] = 10.5},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search dresser1"
	},
	[2] = {
		["type"] = "kitchen",
		["coords"] = {["x"] = 11.75, ["y"] = 6.75, ["z"] = 10.5},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search Sink"
	},
	[3] = {
		["type"] = "kitchen",
		["coords"] = {["x"] = 6.70, ["y"] = 8.00, ["z"] = 10.5},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search through the kitchen cabinets"
	},
	[4] = {
		["type"] = "kitchen",
		["coords"] = {["x"] = 4.00, ["y"] = 7.00, ["z"] = 10.5},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search Kitchen Cabinets"
	},
	[5] = {
		["type"] = "cabin",
		["coords"] = {["x"] = -4.25, ["y"] = -6.5, ["z"] = 10.5},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search Shelves"
	},
	[6] = {
		["type"] = "chest",
		["coords"] = {["x"] = -4.25, ["y"] = -4.5, ["z"] = 10.5},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "search Shelves"
	},
	[7] = {
		["type"] = "livingroom",
		["coords"] = {["x"] = -6.20, ["y"] = 2.5, ["z"] = 15.0},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search Closet"
	},
	[8] = {
		["type"] = "livingroom",
		["coords"] = {["x"] = -6.20, ["y"] = 0, ["z"] = 15.0},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "Search Closet"
	},
	[9] = {
		["type"] = "chest",
		["coords"] = {["x"] = -1.75, ["y"] = -5.5, ["z"] = 15.0},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "search Shelves"
	},
	[10] = {
		["type"] = "chest",
		["coords"] = {["x"] = 3.80, ["y"] = -2.0, ["z"] = 15.0},
		["searched"] = false,
		["isBusy"] = false,
		["text"] = "search Closet"
	},
}
Config.Houses = {
    ["stab1"] = {
        ["coords"] = vector4(8.44, 3686.48, 40.18, 19.12),
		["ped"] = vector3(4.39, 3688.21, -1.92),
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = Config.tier1,
    },
    ["stab2"] = {
        ["coords"] = vector4(52.1, 3742.14, 40.29, 1.82),
		["ped"] = vector3(48.06, 3743.87, -1.81),
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = Config.tier1, 
    },
     ["stab3"] = {
        ["coords"] = vector4(97.68, 3682.06, 39.73, 174.4),
		["ped"] = vector3(93.24, 3684.02, -2.37),
         ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = Config.tier1,
	},
    ["algonquin1"] = {
        ["coords"] = vector4(1777.63, 3799.78, 34.53, 297.82),
		["ped"] = vector3(1773.56, 3801.37, -7.57),
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = Config.tier1,
    },
    ["algonquin2"] = {
        ["coords"] = vector4(1813.44, 3853.95, 34.35, 211.63),
		["ped"] = vector3(1809.46, 3855.64, -7.75),
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = Config.tier1,
    },
    ["algonquin3"] = {
        ["coords"] = vector4(1894.26, 3895.98, 33.18, 21.42),
        ["ped"] = vector3(1889.91, 3897.89, -8.92),
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = Config.tier1,
    },
    ["trailer1"] = {
        ["coords"] =  vector4(564.42, 2599.01, 43.87, 286.29),
        ["ped"] = vector3(559.97, 2601.08, 1.77),
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = Config.tier1,
    },
    ["trailer2"] = {
        ["coords"] = vector4(890.95, 2855.04, 57.0, 222.97),
         ["ped"] = vector3(886.74, 2856.77, 14.9),  
        ["opened"] = false,
        ["tier"] = 1,
        ["furniture"] = Config.tier1,
    },
    ["amantillo1"] = {
        ["coords"] = vector4(1354.93, -1690.71, 60.49, 91.76),
         ["ped"] = vector3(1351.24, -1684.91, 16.6),   
        ["opened"] = false,
        ["tier"] = 2,
        ["furniture"] = Config.tier2,
    },
    ["amantillo2"] = {
        ["coords"] = vector4(1314.57, -1733.31, 54.7, 101.74),
        ["ped"] = vector3(1312.06, -1737.74, 10.81),    
        ["opened"] = false,
        ["tier"] = 2,
        ["furniture"] = Config.tier2,
    },
    ["amantillo3"] = {
        ["coords"] = vector4(1259.15, -1761.82, 49.66, 193.3),
        ["ped"] = vector3(1256.76, -1766.21, 5.77),    
        ["opened"] = false,
        ["tier"] = 2,
        ["furniture"] = Config.tier2,
    },
    ["fudge1"] = {
        ["coords"] = vector4(1379.1, -1514.94, 58.44, 20.61),
        ["ped"] = vector3(1376.59, -1519.23, 14.55),
        ["opened"] = false,
        ["tier"] = 2,
        ["furniture"] = Config.tier2,
    },
    ["fudge2"] = {
        ["coords"] = vector4(1261.48, -1616.86, 54.74, 204.76),
        ["ped"] = vector3(1258.62, -1621.7, 10.85),    
        ["opened"] = false,
        ["tier"] = 2,
        ["furniture"] = Config.tier2,
    },
    ["fudge3"] = {
        ["coords"] = vector4(1245.36, -1626.89, 53.28, 205.32),
        ["ped"] = vector3(1242.55, -1630.61, 9.39),   
        ["opened"] = false,
        ["tier"] = 2,
        ["furniture"] = Config.tier2,
    },
    ["fudge4"] = {
        ["coords"] = vector4(1205.44, -1607.35, 50.74, 21.21),
        ["ped"] = vector3(1202.57, -1610.85, 6.85),   
        ["opened"] = false,
        ["tier"] = 2,
        ["furniture"] = Config.tier2,
    },
	 ["fudge5"] = {
        ["coords"] = vector4(-148.23, -1687.41, 33.07, 306.93),
		["ped"] = vector3(-147.63, -1686.85, -10.82),     
        ["opened"] = false,
        ["tier"] = 2,
        ["furniture"] = Config.tier2,
    },
    ["fudge6"] = {
        ["coords"] = vector4(-141.45, -1693.5, 33.07, 214.93),
		["ped"] = vector3(-143.95, -1697.49, -10.82),
        ["opened"] = false,
        ["tier"] = 2,
        ["furniture"] = Config.tier2,
    },
    ["imagination1"] = {
        ["coords"] = vector4(-1182.7, -1064.63, 2.15, 293.6),
        ["ped"] = vector3(-1176.92, -1063.28, -40.42),    
        ["opened"] = false,
        ["tier"] = 3,
        ["furniture"] = Config.tier3,
    },
    ["imagination2"] = {
        ["coords"] = vector4(-1200.49, -1031.97, 2.15, 299.82),
        ["ped"] = vector3(-1203.83, -1034.17, -40.42),    
        ["opened"] = false,
        ["tier"] = 3,
        ["furniture"] = Config.tier3,
    },
    ["imagination3"] = {
        ["coords"] = vector4(-1151.61, -990.49, 2.15, 31.4),
		["ped"] = vector3(-1148.81, -992.68, -40.42),     
        ["opened"] = false,
        ["tier"] = 3,
        ["furniture"] = Config.tier3,
    },
    ["imagination4"] = {
        ["coords"] = vector4(-1103.25, -1014.5, 2.55, 212.19),
        ["ped"] = vector3(-1097.36, -1016.16, -40.02),   
        ["opened"] = false,
        ["tier"] = 3,
        ["furniture"] = Config.tier3,
    },
    ["imagination5"] = {
        ["coords"] = vector4(-1130.23, -1031.52, 2.15, 200.97),
        ["ped"] = vector3(-1131.45, -1028.0, -40.42),    
        ["opened"] = false,
        ["tier"] = 3,
        ["furniture"] = Config.tier3,
    },
    ["imagination6"] = {
        ["coords"] = vector4(-1127.6, -1081.53, 4.22, 289.49),
        ["ped"] = vector3(-1135.17, -1077.85, -38.35),    
        ["opened"] = false,
        ["tier"] = 3,
        ["furniture"] = Config.tier3,
    },
    ["imagination7"] = {
        ["coords"] = vector4(-1034.6, -1147.08, 2.16, 207.91),
        ["ped"] = vector3(-1026.34, -1144.9, -40.41),    
        ["opened"] = false,
        ["tier"] = 3,
        ["furniture"] = Config.tier3,
    },
    ["imagination8"] = {
        ["coords"] = vector4(-1063.64, -1160.25, 2.75, 211.33),
        ["ped"] = vector3(-1061.65, -1158.77, -39.82),    
        ["opened"] = false,
        ["tier"] = 3,
        ["furniture"] = Config.tier3,
    },
    ["muir1"] = {
        ["coords"] = vector4(965.1, -541.96, 59.73, 30.01),
        ["ped"] = vector3(970.64, -547.64, 15.79),    
        ["opened"] = false,
        ["tier"] = 4,
        ["furniture"] = Config.tier4,
    },
    ["muir2"] = {
        ["coords"] = vector4(1009.67, -572.43, 60.59, 81.17),
        ["ped"] = vector3(1012.66, -572.28, 16.65),    
        ["opened"] = false,
        ["tier"] = 4,
        ["furniture"] = Config.tier4,
    },
   
    ["muir3"] = {
        ["coords"] = vector4(1223.11, -697.03, 60.8, 294.09),
		["ped"] = vector3(1221.75, -692.95, 16.86),     
        ["opened"] = false,
        ["tier"] = 4,
        ["furniture"] = Config.tier4,
    },
    ["muir4"] = {
        ["coords"] = vector4(1207.34, -620.32, 66.44, 274.82),
		["ped"] = vector3(1211.96, -611.01, 22.5),     
        ["opened"] = false,
        ["tier"] = 4,
        ["furniture"] = Config.tier4,
    },
    ["grove1"] = {
        ["coords"] = vector4(100.92, -1912.1, 21.41, 336.17),
        ["ped"] = vector3(106.03, -1908.4, -22.53),    
        ["opened"] = false,
        ["tier"] = 4,
        ["furniture"] = Config.tier4,
    },
    ["grove2"] = {
        ["coords"] = vector4(56.51, -1922.67, 21.91, 147.46),
		["ped"] = vector3(55.53, -1914.9, -22.03),
        ["opened"] = false,
        ["tier"] = 4,
        ["furniture"] = Config.tier4,
    },
    ["grove3"] = {
        ["coords"] = vector4(46.01, -1864.21, 23.28, 323.34),
        ["ped"] = vector3(40.6, -1857.8, -20.66),    
        ["opened"] = false,
        ["tier"] = 4,
        ["furniture"] = Config.tier4,
    },
    ["grove4"] = {
        ["coords"] = vector4(-4.83, -1872.21, 24.15, 181.84),
		["ped"] = vector3(-11.48, -1863.11, -19.79),     
        ["opened"] = false,
        ["tier"] = 4,
        ["furniture"] = Config.tier4,
    },
    ["grove5"] = {
        ["coords"] = vector4(-34.44, -1847.35, 26.19, 74.68),
		["ped"] = vector3(-29.56, -1840.56, -17.09),     
        ["opened"] = false,
        ["tier"] = 4,
        ["furniture"] = Config.tier4,
    },
    ["luxeapartment1"] = {
        ["coords"] = vector4(-1307.72, 328.61, 65.49, 320.77),
        ["ped"] = vector3(-1313.39, 328.48, 22.51),    
        ["opened"] = false,
        ["tier"] = 5,
        ["furniture"] = Config.tier5,
    },
    ["luxeapartment2"] = {
        ["coords"] = vector4(-1304.72, 318.79, 65.49, 290.77),
        ["ped"] = vector3(-1310.27, 318.83, 22.49),    
        ["opened"] = false,
        ["tier"] = 5,
        ["furniture"] = Config.tier5,
    },
    ["luxeapartment3"] = {
        ["coords"] = vector4(-1310.29, 316.81, 65.49, 111.17),
        ["ped"] = vector3(-1312.11, 313.98, 21.66),    
        ["opened"] = false,
        ["tier"] = 5,
        ["furniture"] = Config.tier5,
    },
    ["luxeapartment4"] = {
        ["coords"] = vector4(-1313.37, 326.82, 65.49, 65.79),
        ["ped"] = vector3(-1308.06, 325.16, 21.66),    
        ["opened"] = false,
        ["tier"] = 5,
        ["furniture"] = Config.tier5,
    },
    ["luxeapartment5"] = {
        ["coords"] = vector4(-1340.48, 318.73, 65.51, 286.5),
        ["ped"] = vector3(-1342.01, 317.51, 21.68),    
        ["opened"] = false,
        ["tier"] = 5,
        ["furniture"] = Config.tier5,
    },
    ["luxeapartment6"] = {
        ["coords"] = vector4(-1337.58, 309.1, 65.51, 276.18),
        ["ped"] = vector3(-1340.61, 309.03, 21.68),    
        ["opened"] = false,
        ["tier"] = 5,
        ["furniture"] = Config.tier5,
    },
    ["luxeapartment7"] = {
        ["coords"] = vector4(-1343.22, 307.09, 65.51, 113.2),
        ["ped"] = vector3(-1343.51, 306.35, 21.68),    
        ["opened"] = false,
        ["tier"] = 5,
        ["furniture"] = Config.tier5,
    },
    ["luxeapartment8"] = {
        ["coords"] = vector4(-1346.18, 316.93, 65.51, 99.1),
		["ped"] = vector3(-1344.57, 313.33, 21.68),     
        ["opened"] = false,
        ["tier"] = 5,
        ["furniture"] = Config.tier5,
    },
    ["mansion1"] = {
        ["coords"] = vector4(-1277.48, 630.04, 143.26, 308.89),
        ["ped"] = vector3(-1276.63, 637.46, 111.03),    
        ["opened"] = false,
        ["tier"] = 6,
        ["furniture"] = Config.tier6,
    },
    ["mansion2"] = {
        ["coords"] = vector4(-1241.24, 674.48, 142.81, 348.22),
        ["ped"] = vector3(-1235.36, 682.34, 108.18),    
        ["opened"] = false,
        ["tier"] = 6,
        ["furniture"] = Config.tier6,
    },
    ["mansion3"] = {
        ["coords"] = vector4(-1100.6, 797.97, 167.26, 25.19),
        ["ped"] = vector3(-1103.04, 797.52, 132.86),
        ["opened"] = false,
        ["tier"] = 6,
        ["furniture"] = Config.tier6,
    },
    ["mansion4"] = {
        ["coords"] = vector4(-932.18, 809.01, 184.78, 16.57),
        ["ped"] = vector3(-940.55, 810.33, 154.29),    
        ["opened"] = false,
        ["tier"] = 6,
        ["furniture"] = Config.tier6,
    },
    ["mansion5"] = {
        ["coords"] = vector4(-596.6, 851.75, 211.48, 225.95),
        ["ped"] = vector3(-593.73, 845.42, 180.99),    
        ["opened"] = false,
        ["tier"] = 6,
        ["furniture"] = Config.tier6,
    },
    ["mansion6"] = {
        ["coords"] = vector4(-232.91, 588.13, 190.54, 203.67),
		["ped"] = vector3(-222.56, 592.17, 155.91),
        ["opened"] = false,
        ["tier"] = 6,
        ["furniture"] = Config.tier6,
    },
    ["mansion7"] = {
        ["coords"] = vector4(-701.1, 647.03, 155.38, 184.12),
		["ped"] = vector3(-700.89, 641.1, 120.98),
        ["opened"] = false,
        ["tier"] = 6,
        ["furniture"] = Config.tier6,
    },
    ["mansion8"] = {
        ["coords"] = vector4(-459.05, 537.07, 121.46, 181.33),
        ["ped"] = vector3(-459.12, 543.27, 86.38),    
        ["opened"] = false,
        ["tier"] = 6,
        ["furniture"] = Config.tier6,
    },
    ["mansion9"] = {
        ["coords"] = vector4(-355.97, 458.43, 116.65, 156.1),
        ["ped"] = vector3(-355.04, 466.73, 84.42),    
        ["opened"] = false,
        ["tier"] = 6,
        ["furniture"] = Config.tier6,
    },
    ["mansion10"] = {
        ["coords"] = vector4(-66.93, 490.09, 144.88, 114.47),
        ["ped"] = vector3(-65.09, 487.67, 110.48),    
        ["opened"] = false,
        ["tier"] = 6,
        ["furniture"] = Config.tier6,
    },
    ["mansion11"] = {
        ["coords"] = vector4(216.34, 620.47, 187.76, 259.66),
        ["ped"] = vector3(217.57, 621.18, 153.36),    
        ["opened"] = false,
        ["tier"] = 6,
        ["furniture"] = Config.tier6,
    },
    ["mansion12"] = {
        ["coords"] = vector4(232.25, 672.18, 189.98, 222.58),
        ["ped"] = vector3(231.74, 679.08, 157.27),    
        ["opened"] = false,
        ["tier"] = 6,
        ["furniture"] = Config.tier6,
    },
}


Config.MaleNoGloves = {
    [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true, [9] = true, [10] = true, [11] = true, [12] = true, [13] = true, [14] = true, [15] = true, [16] = true, [18] = true, [26] = true, [52] = true, [53] = true, [54] = true, [55] = true, [56] = true, [57] = true, [58] = true, [59] = true, [60] = true, [61] = true, [62] = true, [112] = true, [113] = true, [114] = true, [118] = true, [125] = true, [132] = true
}

Config.FemaleNoGloves = {
    [0] = true, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true, [9] = true, [10] = true, [11] = true, [12] = true, [13] = true, [14] = true, [15] = true, [19] = true, [59] = true, [60] = true, [61] = true, [62] = true, [63] = true, [64] = true, [65] = true, [66] = true, [67] = true, [68] = true, [69] = true, [70] = true, [71] = true, [129] = true, [130] = true, [131] = true, [135] = true, [142] = true, [149] = true, [153] = true, [157] = true, [161] = true, [165] = true
}
