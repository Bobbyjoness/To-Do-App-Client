local gui         = require 'gui'
local theme       = require 'themes.defualt'
local TodoAPI     = require 'APIs.Todo'
local State       = require 'libs.hump.gamestate'
local tserial     = require 'libs.tserial'

local todo
local updateRate = 1/3
local counter    = 0
local timeStamp  = 0
local newStamp   = 0
local url        = "http://localhost:5000"
local fontManager = gui.fontManager()
local api        = {} -- api namespace
api.todo   = TodoAPI( url, 60)

local TaskState = {}
local taskID
function TaskState:init()

end

function TaskState:enter( previous, xtaskID, ... )
	taskID = xtaskID
	api.todo:getTodo( xtaskID, function (xtodo, timeStamp)
	 		todo = xtodo
	 		newStamp = timeStamp
 		end)
end

function TaskState:update()

end

function TaskState:draw( )
	local w,h = love.graphics.getDimensions() 
	love.graphics.setColor( theme:getPrimaryBase() )
	love.graphics.rectangle("fill",0,0,w,h/8)

	love.graphics.setColor( theme:getSecondaryFallback() )

	local fonts = theme:getMainFont()
	local font = fontManager:getFont(fonts.regFont,30)
	love.graphics.setFont(font)
	love.graphics.print("Todo "..taskID,w/40,h/16 - font:getHeight()/2)
end
return TaskState