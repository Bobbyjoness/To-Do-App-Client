local class = require "libs.hump.class"
local lume  = require "libs.lume"

local utils = require 'utils'

local List  = class{}

function List:init( x,y,w,h ) --h is height of view window
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	self.tasks = {}
	self.buttonHover = false
end

function List:setNewTaskFunction( newTaskFunction ) --very awkward way of doing things :( Need to fix eventually  
	self.newTaskFunction = newTaskFunction
end

function List:addTask( task )
	self.tasks[task:getID()] = task
end

function List:update( dt )
	local mousex,mousey = love.mouse.getPosition()
	self.buttonHover = false
	if lume.distance( self.w/8*7, self.y + self.h/8, mousex, mousey) < (self.w/20) then
		self.buttonHover = true
	else
		for i,task in ipairs( self.tasks ) do
			task:update(dt)
		end
	end
end

function List:draw(  position, theme, fontManager )--postion = 0 to 1 --10 percent padding all around
	love.graphics.setScissor(self.x,self.y,self.w,self.h)
	love.graphics.setColor(theme:getSecondaryFallback())
	love.graphics.rectangle('fill',self.x,self.y,self.w,self.h)
	local numTasks = #self.tasks
	local listHeight = numTasks*75
	if listHeight <= self.h then
		postion = 0
	end
	for i,task in ipairs( self.tasks ) do
		local x = self.x
		local y =(self.y + 65*(i-1))+(-position*listHeight) + self.h/8
		if  (y < self.y + self.h) and not(y + 45 < self.y) then
			task:setPos(x,y)
			task:setSize(self.w,65)
			task:draw(theme,fontManager )
		end
	end
	love.graphics.setScissor()

	love.graphics.setColor( theme:getPrimaryBase() )
	love.graphics.rectangle("fill",self.x,self.y,self.w,self.h/8)

	love.graphics.setColor( theme:getSecondaryFallback() )

	local fonts = theme:getMainFont()
	local font = fontManager:getFont(fonts.regFont,30)
	love.graphics.setFont(font)
	love.graphics.print("Todos  |"..#self.tasks.. " Todos left",self.w/40,self.h/16 - font:getHeight()/2)

	local r,g,b = unpack(theme:getSecondaryDark())
	love.graphics.setColor( r, g, b, (self.buttonHover and 255) or 230 )
	love.graphics.circle( "fill", self.w/8*7 ,self.y + self.h/8, self.w/20 )

	local fonts = theme:getMainFont()
	local font = fontManager:getFont(fonts.regFont,60)
	love.graphics.setFont(font)
	love.graphics.setColor( theme:getSecondaryFallback())
	love.graphics.print("+", self.w/8*7 - font:getWidth("+")/2 + 1, self.y + self.h/8 - font:getHeight()/2 - 3)
end

function List:click( x, y, button )
	if self.buttonHover then
		self.newTaskFunction( self )
	else
		for i, task in ipairs(self.tasks) do
			task:click( x, y, button )
		end
	end
end

return List
