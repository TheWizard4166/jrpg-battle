local Object = require "modules.classic.classic"
local push = require "modules.push.push"
local sti = require "modules.sti.sti"
-- local Entity = require "modules.Entity.Entity"

Entity = Object:extend()

function attrdir (path)
    assert(path ~= nil, "Path is nil!")
    assert(love.filesystem.getInfo(path) ~= nil, "Not a valid path!")  
    frameTable = {}
    for i, k in pairs(love.filesystem.getDirectoryItems(path)) do
	    assert(love.filesystem.getInfo(path .. "/" .. k), "Invalid path: " .. path .. "/" .. k)
	    if(love.filesystem.getInfo(path .. "/" .. k, "directory")) then
		frameTable[k] = attrdir(path .. "/" .. k) else frameTable[i] = love.graphics.newImage(path .. "/" .. k)
	end
    end
    return frameTable
end

function Entity:new(x, y, name,spritename,folderpath,hp,mp,str,dex,con,wis,int,cha)
	self.x = x or 4
	self.y = y or 4
	self.name = name or "Unknown"
	self.spritename = spritename or "knight_m"
	self.folder = folderpath or "assets/0x72_DungeonTilesetII_v1.7/frames/knight_m"
	self.stats = {["hp"] = hp or 10,["mp"] = mp or 10, ["str"] = str or 10, ["dex"] = dex or 10, ["con"] = con or 10, ["wis"] = wis or 10, ["int"] = int or 10, ["cha"] = cha or 10}
	self.frameTable = attrdir (self.folder)
	self.currentFrame = 1
    self.currentType = nil
    if(self.frameTable[1] == nil) then
        self.currentType = "idle"
    end
	self.currentTime = 0
end

function Entity:animate(type)
	if self.currentType ~= type and type ~= nil then
		self.currentType = type
		self.currentFrame = 0
	end
	if type(self.frameTable[self.currentType]) == "table" then
		if self.frameTable[self.currentType][self.currentFrame + 1] == nil then
			self.currentFrame = 0
		end
	elseif self.frameTable[self.currentFrame + 1] == nil then
		self.currentFrame = 0
	end
	self.currentFrame = self.currentFrame + 1
end

function Entity:getFrame()
	if self.currentType == nil and self.currentFrame >= 1 then
		return self.frameTable[self.currentFrame] 
	elseif self.currentType ~= nil and self.currentFrame >= 1 then
		return self.frameTable[self.currentType][self.currentFrame]
	end
	return nil
end

function Entity:getx()
    return self.x
end

function Entity:gety()
    return self.y
end
function Entity:__tostring() 
	retval = "name: " .. self.name
	for i, k in pairs(self.stats) do
		retval = retval .. "\n" .. i .. ": " .. k
	end
	return retval
end

local gameWidth, gameHeight = 480, 320 --fixed game resolution
local windowWidth, windowHeight = love.window.getDesktopDimensions()

push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = true})

function love.load()
	love.physics.setMeter(16)
	map = sti("maps/dungeon_battle_map/battle.lua", { "box2d" })
	
	world = love.physics.newWorld(0, 0)

	map:box2d_init(world)

	map:addCustomLayer("Sprite Layer", 3)

	local spriteLayer = map.layers["Sprite Layer"]
	spriteLayer.sprites = {
        player = Entity()
		--[[player = {
            image = entities["player"]:getFrame(),
            x = entities["player"]:getx(),
            y = entities["player"]:gety(),
            currentTime = 0,
            entityName = "player",
        }]]
	}
    assert(spriteLayer.sprites.player, "Player is nil")
    assert(spriteLayer.sprites.player:is(Entity), "Player is not Entity Type!" .. type(spriteLayer.sprites.player))

	function spriteLayer:update(dt) 
		for sprite in pairs(self.sprites) do
			sprite.currentTime = sprite.currentTime + dt
			if sprite.entity.currentTime >= 0.125 then
				sprite.entity:animate("idle")
                sprite.entity.currentTime = 0
			end
		end
	end
	
	function spriteLayer:draw()
		for sprite in pairs(self.sprites) do	
            assert(sprite ~= nil, "Sprite is nil!")
            assert(sprite:is(Entity), "Sprite is not an Entity!")
			local x =  sprite:getx()
			local y =  sprite:gety()
            assert(x ~= nil, "x coordinate is nil!\n " .. sprite)
            assert(y ~= nil, "y coordinate is nil!\n " .. sprite)
			x, y = map:convertTileToPixel(x, y)
			-- assert(love.filesystem.getInfo(sprite:getFrame(), "file") ~= nil, "Not a file!")
			-- assert(string.find(sprite.entity:getFrame(),".png") or string.find(sprite.entity:getFrame(),".jpg", "Invalid File type!"))
			love.graphics.draw(sprite.entity:getFrame(), x, y, 0)

		end
	end
end


function love.resize(w, h)
	push:resize(w, h)
end

function love.update(dt)
	map:update(dt)
end

function love.draw()
	push:start()
	-- Draw the map and all objects within
	love.graphics.setColor(1, 1, 1)
	map:draw()
    map.layers["Sprite Layer"]:draw()

	-- Draw Collision Map (useful for debugging)
	love.graphics.setColor(1, 0, 0)
	map:box2d_draw()
   
	push:finish()
end
