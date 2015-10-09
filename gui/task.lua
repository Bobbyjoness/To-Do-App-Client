local class = require "libs.hump.class"
local lume  = require "libs.lume"
local utils = require 'utils'

local Task  = class{}

function Task:init( id, task )
	self.id     = id
	self.task   = task
	self.hover  = false
	self.x      = 0
	self.y      = 0
	self.width  = 0
	self.height = 0
end

function Task:setTask( task )
	self.task = task
end

function Task:update( dt )
	local mousex,mousey = love.mouse.getPosition()
	self.hover = false
	if mousex > self.x and mousex < self.x + self.width and  mousey>self.y and mousey < self.y + self.height then
		self.hover = true
	end
end

function Task:setPos( x,y )
	self.x = x
	self.y = y
end

function Task:setSize( width, height )
	self.width  = width
	self.height = height
end

function Task:draw( theme, fontManager )
	love.graphics.setColor(theme:getPrimaryLight())
	love.graphics.setLineWidth( 3 )

	local drawMode = 'line'
	if self.hover then
		drawMode = 'fill'
	end
		love.graphics.rectangle( drawMode, math.floor(self.x),math.floor(self.y),self.width,self.height, 0, 0, 30 )

	if self.hover then
		love.graphics.setColor(0,0,0,255)
	else
		love.graphics.setColor(0,0,0,200)
	end

	local fonts = theme:getMainFont()
	local font = fontManager:getFont(fonts.regFont,12)
	love.graphics.setFont(font)
	love.graphics.printf( utils.limitString(self.task,font,self.width - 20/780*self.width,true ), self.x + 20/780*self.width,
	 self.y + self.height/2 - font:getHeight()/2, self.width - 2*self.width/10, "left" )
	self.hover = false
end

function Task:getID()
	return self.id
end

return Task