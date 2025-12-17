local push = require "modules.push.push"
local sti = require "modules.sti.sti"
local Entity = require "modules.Entity.Entity"

local gameWidth, gameHeight = 480, 320 --fixed game resolution
local windowWidth, windowHeight = love.window.getDesktopDimensions()

push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = true})

function love.load()
	love.physics.setMeter(16)
	
	map = sti("maps/battle.lua", { "box2d" })
	
	world = love.physics.newWorld(0, 0)

	map:box2d_init(world)
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

	-- Draw Collision Map (useful for debugging)
	love.graphics.setColor(1, 0, 0)
	map:box2d_draw()
   
	push:finish()
end
