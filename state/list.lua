local gui         = require 'gui'
local theme       = require 'themes.defualt'
local TodoAPI     = require 'APIs.Todo'
local State       = require 'libs.hump.gamestate'

local todos, todosJson
local updateRate = 1/3
local counter    = 0
local timeStamp  = 0
local newStamp   = 0
local url        = "http://localhost:5000"
local fontManager = gui.fontManager()
local api        = {} -- api namespace
local nextTodo   = false
api.todo   = TodoAPI( url, 60)

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
	 		nextTodo = true

 		end)

end

function List:update(dt)
	if todos == nil and nextTodo then 
		nextTodo = false
		api.todo:getTodos(function (xtodos, xtimeStamp)
	 		todos = xtodos
	 		newStamp = xtimeStamp
	 		nextTodo = true
 		end)

	end

	counter = counter + dt
	if counter >= updateRate and nextTodo then
		nextTodo = false
		api.todo:getTodos(function (xtodos, xtimeStamp)
	 		todos = xtodos
	 		newStamp = xtimeStamp
	 		nextTodo = true
 		end)
		counter = 0
	end

	if newStamp > timeStamp then
		for i, task in ipairs( todos ) do
			local _task = gui.task(i,task.task)
			_task:setClickFunction(function(self) print(self.id) end)
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
    list:click()
end

return List