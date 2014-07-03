local game = require("scripts.game")
local helpers = require("scripts.helpers")
local tnt = require("scripts.transitions_manager")
local sheetHelper = require("scripts.sheet_helper")
local sheetGame1 = sheetHelper.new("interface")

local Switch = {}
local Switch_mt = { __index = Switch }

--- constructor
function Switch.new(params)
	 
	return setmetatable({
			collected 	= params.collected or false,
			x 			= params.x or 0,
			y 			= params.y or 0,
			display 	= nil
		},
		Switch_mt)
end

function Switch:display()
	
	local switch = display.newSprite( sheetGame1.data, {
		{ name="red", start=sheetGame1.options.frameIndex["lock_01.png"], count=1},
		{ name="green", start=sheetGame1.options.frameIndex["unlock_01.png"], count=1}
	} )
	
	switch.x = self.x
	switch.y = self.y
	switch:setSequence("red")

	self.display = switch
end

--- zderzenie ze zlotym jajkiem
function Switch:isCollision (egg)
	if self.collected ~= true then
		if egg.x == self.display.x and egg.y == self.display.y then
				
			audio.play(game.audio.s22)
			self.display:setSequence("green")
			self.collected = true
			game:unlockExit()				
			
		end
	end
end

return Switch