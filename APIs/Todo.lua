--3rd-party libs
local class = require 'libs.hump.class'
local json  = require 'libs.dkjson'

--my code
local utils = require 'utils'

local Todo = class{}

function Todo:init( url, timeout )
	self.url = url
	print(self.url)
	self.timeout = timeout or 0
end

function Todo:getTodos( )      -- GET method on /todos
	local todosJson, c, h = utils.request(self.url.."/todos", "GET", self.timeout)
	if todosJson then
		local todos, pos, err = json.decode( todosJson )
		if err then
			print( "Error:", err )
			return false, 0
		else
			local timeStamp = utils.makeTimeStamp(todos[#todos].lastUpdated)
			todos[#todos] = nil
			return todos, timeStamp
		end
	else
		print( "Error:", todosJson, c, h )
		return false, 0 
	end
end

function Todo:addTodo( todo )       -- POST method on /todos
	local r,c,h = utils.request( self.url.."/todos", "POST", self.timeout, todo )

	if r then
		return r, c, h
	else
		print( "Error:", r, c, h )
		return false
	end
end

function Todo:getTodo( id )    -- GET method on /todos/<id>
	local todosJson, c, h = utils.request( self.url.."/todos/"..id, "GET", self.timeout )
	if todosJson then
		local todos, pos, err = json.decode( todosJson )
		if err then
			print( "Error:", err, "Response:", todosJson,c,h )
			return false, 0
		else
			local timeStamp = utils.makeTimeStamp( todos[#todos].lastUpdated )
			todos[#todos] = nil
			return todos, timeStamp
		end
	else
		print( "Error:", todosJson, c, h )
		return false, 0 
	end
end

function Todo:deleteTodo( id ) -- DELETE method on /todos/<id>
	local response, c, h = utils.request(self.url.."/todos/"..id, "DELETE", self.timeout )
	if c == 204 then
		return response, c, h
	else
		print( "Error:", response, c, h )
		return false
	end
end

function Todo:updateTodo( id, todo ) -- PUT method on /todos/<id>
	local r,c,h = utils.request(self.url.."/todos/"..id, "PUT", self.timeout, todo)

	if r and code == 201 then
		return r, c, h
	else
		print("Error:", r, c, h )
		return false
	end
end

return Todo
