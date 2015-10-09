local gui         = require 'gui'
local theme       = require 'themes.defualt'
local TodoAPI     = require 'APIs.Todo'

local todos, todosJson
local updateRate = 1/10
local counter    = 0
local timeStamp  = 0
local newStamp   = 0
local url        = "http://localhost:5000"
local fontManager = gui.fontManager()
local api        = {} -- api namespace
api.todo   = TodoAPI( url, 1)

list = gui.list(0,0,400,600)
List = {}

function List:init() -- run only once
    
end

function List:enter(previous) -- run every time the state is entered
	testJson = [[{ "task" :  "task ]]..love.math.random()..[["}]]

 	api.todo:addTodo( testJson,function() end )

 	api.todo:getTodos(function (xtodos, xtimeStamp)
	 		todos = xtodos
	 		newStamp = xtimeStamp
 		end)

end

function List:update(dt)
	if todos == nil then 
		api.todo:getTodos(function (xtodos, xtimeStamp)
	 		todos = xtodos
	 		newStamp = xtimeStamp
 		end)

	end

	counter = counter + dt
	if counter >= updateRate then
		api.todo:getTodos(function (xtodos, xtimeStamp)
	 		todos = xtodos
	 		newStamp = xtimeStamp
 		end)
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
	love.graphics.setColor({0,0,0})
	love.graphics.setFont(love.graphics.newFont(12))
	love.graphics.print(love.timer.getFPS())
end

function List:keyreleased(key)

end

function List:mousereleased(x,y, mouse_btn)
    
end

return List