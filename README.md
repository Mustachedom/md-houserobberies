## md-houserobberies

<div align="center">
  <a href="https://discord.gg/sAMzrB4DDx">
    <img align="center" src="https://cdn.discordapp.com/attachments/1164709522691076120/1185676859363557457/Discord_logo.svg.png?ex=65907aa0&is=657e05a0&hm=dd2a8924c3a3d84507747ab2bac036e5fc219c697e084c9aa13ba468ff725bde&" width="100">
  </a><br>
  <a href="https://discord.gg/sAMzrB4DDx">Mustache Scripts Discord</a><br>
</div>


## Dependencies :

- [qb-core](https://github.com/qbcore-framework/qb-core)

- [ps-ui](https://github.com/Project-Sloth/ps-ui)

- [k4mb1 free shells](https://forum.cfx.re/t/free-props-starter-shells-for-housing-scripts/4826922)

- [ability to read a readme](https://www.hookedonphonics.com/)

## How to install like a boss
**step 1**

- delete qb-houserobbery

**step 2**

- Add the following Items to `qb-core/shared/items.lua`

```lua
["houselaptop"] 	= {["name"] = "houselaptop",        ["label"] = "House Hacking Laptop",	 	["weight"] = 1200, 		["type"] = "item", 		["image"] = "houselaptop.png", 		["unique"] = false, 		["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = ""},
["mansionlaptop"] 	= {["name"] = "mansionlaptop",      ["label"] = "Mansion Hacking Laptop",	["weight"] = 1100, 		["type"] = "item", 		["image"] = "mansionlaptop.png", 	["unique"] = false, 		["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = ""},
["art1"] 		 	= {["name"] = "art1",        		["label"] = "Kitty Sleeping Art",	 	["weight"] = 2500, 		["type"] = "item", 		["image"] = "art1.png", 			["unique"] = false, 		["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = ""},
["art2"] 		 	= {["name"] = "art2",        		["label"] = "Wide Eye Kitty Art",	 	["weight"] = 2500, 		["type"] = "item", 		["image"] = "art2.png", 			["unique"] = false, 		["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = ""},
["art3"] 		 	= {["name"] = "art3",        		["label"] = "Fancy Kitty Art",	 		["weight"] = 2500, 		["type"] = "item", 		["image"] = "art3.png", 			["unique"] = false, 		["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = ""},
["art4"] 		 	= {["name"] = "art4",        		["label"] = "Presidential Kitty Art",	["weight"] = 2500, 		["type"] = "item", 		["image"] = "art4.png", 			["unique"] = false, 		["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = ""},
["art5"] 		 	= {["name"] = "art5",        		["label"] = "Obi Jesus Painting",	 	["weight"] = 2500, 		["type"] = "item", 		["image"] = "art5.png", 			["unique"] = false, 		["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = ""},
["art6"] 		 	= {["name"] = "art6",        		["label"] = "Merp Kitty Art",	 		["weight"] = 2500, 		["type"] = "item", 		["image"] = "art6.png", 			["unique"] = false, 		["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = ""},
["art7"] 		 	= {["name"] = "art7",        		["label"] = "Family Portait",	 		["weight"] = 2500, 		["type"] = "item", 		["image"] = "art7.png", 			["unique"] = false, 		["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = ""},
["boombox"] 	   = {["name"] = "boombox",        		["label"] = "Boom Box",	 				["weight"] = 2500, 		["type"] = "item", 		["image"] = "boombox.png", 			["unique"] = false, 		["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = ""},
["checkbook"] 	   = {["name"] = "checkbook",        	["label"] = "Check Book",	 			["weight"] = 2500, 		["type"] = "item", 		["image"] = "checkbook.png", 		["unique"] = false, 		["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = ""},
["mdlaptop"] 	   = {["name"] = "mdlaptop",        	["label"] = "Slow Laptop",	 			["weight"] = 2500, 		["type"] = "item", 		["image"] = "laptop.png", 			["unique"] = false, 		["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = ""},
["mddesktop"] 	   = {["name"] = "mddesktop",        	["label"] = "Desktop",	 				["weight"] = 2500, 		["type"] = "item", 		["image"] = "mddesktop.png", 		["unique"] = false, 		["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = ""},
["mdmonitor"] 	   = {["name"] = "mdmonitor",        	["label"] = "Monitor",	 				["weight"] = 2500, 		["type"] = "item", 		["image"] = "mansionlaptop.png", 	["unique"] = false, 		["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = ""},
["mdtablet"] 	   = {["name"] = "mdtablet",        	["label"] = "Tablet",	 				["weight"] = 2500, 		["type"] = "item", 		["image"] = "mdtablet.png", 		["unique"] = false, 		["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = ""},
["mdspeakers"] 	   = {["name"] = "mdspeakers",        	["label"] = "Speakers",	 				["weight"] = 2500, 		["type"] = "item", 		["image"] = "speaker.png", 			["unique"] = false, 		["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = ""},


```
**step 3**

- Add items images to your inventory script 



**step 4**

- Modify `md-houserobberies/config.lua` to your liking

**step 5**

- edit the following function

	- head to `md-houserobberies/client/main.lua` **27** and change to what you use for police alert
	- if you dont, your people will be annoyed
	


