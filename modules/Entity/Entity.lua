Object = require "modules.classic.classic"
Entity = Object:extend()

function Entity:new(name,spritename,folderpath,hp,mp,str,dex,con,wis,int,cha)
	self.name = name or "Unknown"
	self.spritename = spritename or "knight_m"
	self.folder = folderpath or "../assets/0x72_DungeonTilesetII_v1.7/frames/knight_m"
	self.stats = {["hp"] = hp or 10,["mp"] = mp or 10, ["str"] = str or 10, ["dex"] = dex or 10, ["con"] = con or 10, ["wis"] = wis or 10, ["int"] = int or 10, ["cha"] = cha or 10}
end

function Entity:__tostring() 
	retval = "name: " .. self.name
	for i, k in pairs(self.stats) do
		retval = retval .. "\n" .. i .. ": " .. k
	end
	return retval
end

return Entity
