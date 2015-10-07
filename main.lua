local lurker      = require 'libs.lurker.lurker'
local lume        = require 'libs.lume.lume'
local json        = require 'libs.dkjson'
local tserial     = require 'libs.tserial'

local utils       = require 'utils'
local gui         = require 'gui'
local theme       = require 'themes.defualt'
local TodoAPI     = require 'APIs.Todo'


local fontManager = gui.fontManager()

list = gui.list(0,0,400,600)

local todos, todosJson
local updateRate = 1/10
local counter    = 0
local timeStamp  = 0
local newStamp   = 0
local url        = "http://localhost:5000"
local api        = {} -- api namespace
api.todo   = TodoAPI( url, 1)


function love.load( ) 

	testJson = [[{ "task" :  "task ]]..love.math.random()..[["}]]

 	local res = api.todo:addTodo( testJson )

 	todos, newStamp = api.todo:getTodos()
	
	love.graphics.setBackgroundColor( 255,255,255 )


end

function love.update( dt )

	lurker.update()
	if todos == nil then 
		todos, newStamp = api.todo:getTodos()

	end

	counter = counter + dt
	if counter >= updateRate then
		todos, newStamp = api.todo:getTodos()

		counter = 0
	end

	if newStamp > timeStamp then
		for i, task in ipairs( todos ) do
			local _task = gui.task(i,task.task)
			list:addTask(_task)
		end
		timeStamp = newStamp
	end
	list:update()
end



function love.draw( )

	list:draw(0,theme,fontManager)
	love.graphics.setColor({0,0,0})
	love.graphics.setFont(love.graphics.newFont(12))
	love.graphics.print(love.timer.getFPS())

end
