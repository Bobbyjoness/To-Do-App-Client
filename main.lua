local lurker      = require 'libs.lurker'
local lume        = require 'libs.lume'
local json        = require 'libs.dkjson'
local tserial     = require 'libs.tserial'
local State       = require 'libs.hump.gamestate'
local utils       = require 'utils'
local listState   = require 'state.list'

function love.load( )
	love.graphics.setBackgroundColor( 255,255,255 )
	State.switch(listState)
	State.registerEvents()
end

function love.update( dt )
	lurker.update()
end

function love.draw( )

end
