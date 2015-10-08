local gui         = require 'gui'
local theme       = require 'themes.defualt'
local TodoAPI     = require 'APIs.Todo'

local todos
local todosJson
local updateRate = 1/10
local counter    = 0
local timeStamp  = 0
local newStamp   = 0
local url        = "http://localhost:5000"
local fontManager = gui.fontManager()
local api        = {} -- api namespace
api.todo   = TodoAPI( url, 1)

local list = gui.list(0,0,400,600)
local List = {}

function List:init() -- run only once

end

function List:enter(previous) -- run every time the state is entered
	local testJson = [[{ "task" :  "task ]]..love.math.random()..[["}]]

 	local res = api.todo:addTodo( testJson )

 	todos, newStamp = api.todo:getTodos()
end

function List:update(dt)
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

function List:draw()
	list:draw(0,theme,fontManager)

   -- DEBUG INFO
	love.graphics.setColor(255, 0, 255)
	love.graphics.setFont(love.graphics.newFont(12))
	love.graphics.print(love.timer.getFPS())
end

function List:keyreleased(key)

end

function List:mousereleased(x,y, mouse_btn)

end

return List
