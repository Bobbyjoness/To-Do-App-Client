local class = require "libs.hump.class"
local lume  = require "libs.lume"
local utils = require 'utils'

local Theme       = class{}

function Theme:init( themeTable )
	self.themeTable = {}
	if type(themeTable) == "table" then
		for k,v in pairs(theme) do
			self.themeTable[k] = v
		end
	end
end

function Theme:setPrimaryColors( light, base, dark ) --light, middle, dark
	self.themeTable.primaryLight = utils.hexToColor( light )
	self.themeTable.primaryBase  = utils.hexToColor( base )
	self.themeTable.primaryDark  = utils.hexToColor( dark )
end

function Theme:getPrimaryLight( )
	return self.themeTable.primaryLight
end

function Theme:getPrimaryBase( )
	return self.themeTable.primaryBase
end

function Theme:getPrimaryDark( )
	return self.themeTable.primaryDark
end

function Theme:setSecondaryColors( fallback, base, dark ) --fallback, base, dark
	self.themeTable.secondaryFallback = utils.hexToColor( fallback )
	self.themeTable.secondaryBase     = utils.hexToColor( base )
	self.themeTable.secondaryDark     = utils.hexToColor( dark )
end

function Theme:getSecondaryFallback()
	return self.themeTable.secondaryFallback
end

function Theme:getSecondaryBase()
	return self.themeTable.secondaryBase
end

function Theme:getSecondaryDark()
	return self.themeTable.secondaryDark
end

function Theme:setTitleFont( regFont, boldFont, iltalicFont, boldIltalicFont )
	self.themeTable.titleFont = {
		regFont         = regFont,
		boldFont        = boldFont,
		iltalicFont     = iltalicFont,
		boldIltalicFont = boldIltalicFont
	}
end

function Theme:getTitleFont()
	return self.themeTable.titleFont
end

function Theme:setMainFont( regFont, boldFont, iltalicFont, boldIltalicFont )
	self.themeTable.mainFont = {
		regFont         = regFont,
		boldFont        = boldFont,
		iltalicFont     = iltalicFont,
		boldIltalicFont = boldIltalicFont
	}
end

function Theme:getMainFont()
	return self.themeTable.mainFont
end

return Theme