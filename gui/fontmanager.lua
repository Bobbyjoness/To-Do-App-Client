local class = require "libs.hump.class"
local lume  = require "libs.lume"
local utils = require 'utils'

local FontManager = class{}

function FontManager:init()
	self.fonts = {}
end

function FontManager:getFont( pathFont, size )
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

return FontManager