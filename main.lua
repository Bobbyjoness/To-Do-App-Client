local lurker      = require 'libs.lurker.lurker'
local lume        = require 'libs.lume.lume'
local json        = require 'libs.dkjson'
local tserial     = require 'libs.tserial'
local lurker      = require 'libs.lurker.lurker'

local http        = require 'socket.http'
local socket      = require 'socket'
local ltn12       = require 'ltn12'
local mime        = require 'mime' 

local utils       = require 'utils'
local gui         = require 'gui'
local theme       = require('themes.defualt')

local fontManager = gui.fontManager()

list = gui.list(0,0,400,600)

local todos, todosJson
local updateRate = 1/10
local counter    = 0
local position   = 0
local mult       = 1
local timeStamp  = 0
local newStamp = 0
local url = "http://localhost:5000"


function love.load( ) 

	testJson = [[{ "task" :  "task ]]..love.math.random()..[["}]]
 	local b,c,h = utils.request(url.."/todos", 1, "post", testJson)
	todosJson = utils.request(url.."/todos", .1)
	if todosJson then
		todos = json.decode(todosJson)
		timeStamp = utils.makeTimeStamp(todos[#todos].lastUpdated)
		todos[#todos] = nil
		for i, task in ipairs( todos ) do
			local _task = gui.task(i,task.task)
			list:addTask(_task)
		end
	end
	love.graphics.setBackgroundColor( 255,255,255 )


end

function love.update( dt )

	lurker.update()
	if todos == nil then 
		todosJson = utils.request(url.."/todos", .1)
		if todosJson then
			todos = json.decode(todosJson)
			todosJson = nil
			newStamp = utils.makeTimeStamp(todos[#todos].lastUpdated)
			todos[#todos] = nil
		end
	end

	counter = counter + dt
	if counter >= updateRate then
		todosJson = utils.request(url.."/todos", .1)
		if todosJson then
			todos = json.decode(todosJson)
			todosJson = nil
			newStamp = utils.makeTimeStamp(todos[#todos].lastUpdated)
			todos[#todos] = nil
		end
		counter = 0
	end

	if newStamp > timeStamp then
		for i, task in ipairs( todos ) do
			local _task = gui.task(i,task.task)
			list:addTask(_task)
		end
		timeStamp = newStamp
	end
end



function love.draw( )

	list:draw(0,theme,fontManager)
	love.graphics.setColor({0,0,0})
	love.graphics.setFont(love.graphics.newFont(12))
	love.graphics.print(love.timer.getFPS())

end
