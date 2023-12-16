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

- [qb-lockpick](https://github.com/qbcore-framework/qb-lockpick)

- [qb-skillbar]( https://github.com/qbcore-framework/qb-skillbar)

- [k4mb1 free shells](https://forum.cfx.re/t/free-props-starter-shells-for-housing-scripts/4826922)

## How to install like a boss
**step 1**

- replace qb-houserobbery

**step 2**

- Add the following Items to `qb-core/shared/items.lua`

```lua
["houselaptop"] 	= {["name"] = "houselaptop",        ["label"] = "House Hacking Laptop",	 		["weight"] = 1200, 		["type"] = "item", 		["image"] = "houselaptop.png", 			["unique"] = false, 		["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = ""},
["mansionlaptop"] 	= {["name"] = "mansionlaptop",      ["label"] = "Mansion Hacking Laptop",	 	["weight"] = 1100, 		["type"] = "item", 		["image"] = "mansionlaptop.png", 		["unique"] = false, 		["useable"] = true, 	["shouldClose"] = true,   	["combinable"] = nil,   ["description"] = ""},
```
**step 3**

- Add items images to `qb-inventory/html/images`


**step 4**

- Modify `md-houserobberies/config.lua` to your liking

**step 5**

- edit the following function

	- head to `md-houserobberies/client/main.lua` **line 152** and change to what you use for police alert

![](https://cdn.discordapp.com/attachments/1164709522691076120/1185704378083069983/image.png?ex=65909441&is=657e1f41&hm=5a74fe8c6cf4534e46c22b287b215223af000747e4ba3d60e7714ab7d2bb9baa&)
