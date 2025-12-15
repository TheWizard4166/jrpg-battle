local Object = require "classic.classic"

Entity = Object:extend()

function Entity:new(name,hp,mp,str,dex,con,wis,int,cha)
	self.name = name or "Unknown"
	self.stats = {["hp"] = hp or 10,["mp"] = mp or 10, ["str"] = str or 10, ["dex"] = dex or 10, ["con"] = con or 10, ["wis"] = wis or 10, ["int"] = int or 10, ["cha"] = cha or 10}
end

function Entity:__tostring() 
	return self.name .. ": \nhp: " .. self.hp .. "\nmp: " .. self.mp .. "\nstr: " .. self.str .. "\ndex: " .. self.dex .. "\ncon: " .. self.con .. "\nwis: " .. self.wis .. "\nint: " .. self.int .. "\ncha: " .. self.cha
end

return Entity
