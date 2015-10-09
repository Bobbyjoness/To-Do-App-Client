local class = require "libs.hump.class"
local lume  = require "libs.lume"
local utils = require 'utils'

local path = (...):gsub('%.init$','') .. '.'

local fontManager = require( path.."fontmanager" )
local list        = require( path.."list"        )
local task        = require( path.."task"        )
local theme       = require( path.."theme"       )


return {
	fontManager = fontManager,
	list        = list,
	task        = task,
	theme       = theme	
}