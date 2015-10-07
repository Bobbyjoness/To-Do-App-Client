local class = require "libs.hump.class"
local lume  = require "libs.lume.lume"
local utils = require 'utils'

local task        = class{}
local textBox     = class{}
local list        = class{}
local theme       = class{}
local gui         = class{}
local fontManager = class{}

function task:init( id, task )
	self.id     = id
	self.task   = task
	self.hover  = false 
	self.x      = 0
	self.y      = 0
	self.width  = 0
	self.height = 0
end

function task:setTask( task )
	self.task = task
end

function task:update( dt )
	local mousex,mousey = love.mouse.getPosition()
	self.hover = false
	if mousex > self.x and mousex < self.x + self.width and  mousey>self.y and mousey < self.y + self.height then
		self.hover = true
	end
end

function task:setPos( x,y )
	self.x = x
	self.y = y
end

function task:setSize( width, height )
	self.width  = width
	self.height = height
end

function task:draw( theme, fontManager )
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

function task:getID()
	return self.id
end

function list:init(x,y,w,h) --h is height of view window
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	self.tasks = {}
	self.buttonHover = false

end

function list:addTask(  task )
	self.tasks[task:getID()] = task

end

function list:update( dt )
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

function list:draw(  position, theme, fontManager )--postion = 0 to 1 --10 percent padding all around
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

function theme:init( themeTable ) 
	self.themeTable = {}
	if type(themeTable) == "table" then
		for k,v in pairs(theme) do
			self.themeTable[k] = v
		end
	end
end

function theme:setPrimaryColors( light, base, dark ) --light, middle, dark
	self.themeTable.primaryLight = utils.hexToColor( light )
	self.themeTable.primaryBase  = utils.hexToColor( base )
	self.themeTable.primaryDark  = utils.hexToColor( dark )

end

function theme:getPrimaryLight( )
	return self.themeTable.primaryLight

end

function theme:getPrimaryBase( )
	return self.themeTable.primaryBase

end

function theme:getPrimaryDark( )
	return self.themeTable.primaryDark

end

function theme:setSecondaryColors( fallback, base, dark ) --fallback, base, dark
	self.themeTable.secondaryFallback = utils.hexToColor( fallback )
	self.themeTable.secondaryBase  = utils.hexToColor( base )
	self.themeTable.secondaryDark  = utils.hexToColor( dark )

end

function theme:getSecondaryFallback(  )
	return self.themeTable.secondaryFallback

end

function theme:getSecondaryBase( )
	return self.themeTable.secondaryBase

end

function theme:getSecondaryDark( )
	return self.themeTable.secondaryDark

end

function theme:setTitleFont( regFont, boldFont, iltalicFont, boldIltalicFont )
	self.themeTable.titleFont = {
	regFont = regFont,
	boldFont = boldFont,
	iltalicFont = iltalicFont,
	boldIltalicFont = boldIltalicFont
}

end

function theme:getTitleFont()
	return self.themeTable.titleFont
end

function theme:setMainFont( regFont, boldFont, iltalicFont, boldIltalicFont )
	self.themeTable.mainFont = {
	regFont = regFont,
	boldFont = boldFont,
	iltalicFont = iltalicFont,
	boldIltalicFont = boldIltalicFont
}

end	

function theme:getMainFont()
	return self.themeTable.mainFont
end

function fontManager:init()
	self.fonts = {}
end

function fontManager:getFont( pathFont, size )
	if self.fonts[pathFont] then
		if self.fonts[pathFont][size] then
			return self.fonts[pathFont][size]
		else
			self.fonts[pathFont][size] = love.graphics.newFont( pathFont, size )
			return self.fonts[pathFont][size]

		end
	else
		self.fonts[pathFont] = {}
		self.fonts[pathFont][size] = love.graphics.newFont( pathFont, size )
		return self.fonts[pathFont][size]

	end

end

return { task = task,list = list, theme = theme, fontManager = fontManager }


