--3rd-party libs
local class = require 'libs.hump.class'
local json  = require 'libs.dkjson'
local async = require 'libs.async' 

--my code
local utils = require 'utils'

local Todo = class{}

function Todo:init( url, timeout )
	self.url = url
	self.timeout = timeout or 0
	self.async = async -- gets handle to global async instance
	self.async.ensure.atLeast(2).atMost(3)
	self._getTodos = async.define( "_getTodos", function ( url, timeout )
		local utils = require 'utils'
		local b, c = utils.request( url.."/todos", "GET", timeout )
		return b, c
	end )

	self._addTodo = async.define( "_addTodo", function ( url, timeout,todo )
		local utils = require 'utils'
		local b, c = utils.request( url.."/todos", "POST", timeout, todo )
		return b, c
	end )

	self._getTodo = async.define( "_getTodo", function ( url, timeout, id )
		local utils = require 'utils'
		local b, c = utils.request( url.."/todos/todo"..id, "GET", timeout )
		return b, c
	end )

	self._deleteTodo = async.define( "_deleteTodo", function ( url, timeout, id )
		local utils = require 'utils'
		local b, c = utils.request(self.url.."/todos/todo"..id, "DELETE", self.timeout )
		return b, c
	end )

 	self._updateTodo = async.define( "_updateTodo", function ( url,timeout,todo )
		local utils = require 'utils'
		local b, c = utils.request(self.url.."/todos/todo"..id, "PUT", self.timeout, todo)
		return b, c
	end )

end

function Todo:getTodos( callback )      -- GET method on /todos
	self._getTodos({
		success = function (todosJson, c)
			if todosJson then
				local todos, pos, err = json.decode( todosJson )
				if err then
					print( "Error:", err )
					callback(false,0)
				else
					local timeStamp = utils.makeTimeStamp(todos[#todos].lastUpdated)
					todos[#todos] = nil
					callback(todos, timeStamp)
				end
			else
				print( "Error:", todosJson, c )
				callback(false,0) 
			end
		end,
		error = function ( ... )
			error( ... )
		end
	},self.url, self.timeout )
	
end

function Todo:addTodo( todo, callback )       -- POST method on /todos
	self._addTodo({
		success = function (b,c)
			if b then
				callback( b,c )
			else
				print( "Error:", b, c )
				callback( false )
			end
		end,
		error = function ( ... )
			error( ... )
		end
	},self.url, self.timeout, todo )
end

function Todo:getTodo( id, callback )    -- GET method on /todos/<id>
	self._getTodo({
		success = function (todosJson, c)
			if todosJson then
				local todos, pos, err = json.decode( todosJson )
				if err then
					print( "Error:", err )
					callback(false,0)
				else
					local timeStamp = utils.makeTimeStamp(todos[#todos].lastUpdated)
					todos[#todos] = nil
					callback(todos[1], timeStamp)
				end
			else
				print( "Error:", todosJson, c )
				callback(false,0) 
			end
		end,
		error = function ( ... )
			error( ... )
		end
	},self.url, self.timeout, id )
end

function Todo:deleteTodo( id, callback ) -- DELETE method on /todos/<id>
	self._deleteTodo({
		success = function (b,c)
			if b then
				callback( b,c )
			else
				print( "Error:", b, c )
				callback( false )
			end
		end,
		error = function ( ... )
			error( ... )
		end
	},self.url, self.timeout, id )
	
end

function Todo:updateTodo( id, todo, callback ) -- PUT method on /todos/<id>
	self._updateTodo({
		success = function (b,c)
			if b then
				callback( b,c )
			else
				print( "Error:", b, c)
				callback( false )
			end
		end,
		error = function ( ... )
			error( ... )
		end
	},self.url, self.timeout, todo )
end

return Todo
