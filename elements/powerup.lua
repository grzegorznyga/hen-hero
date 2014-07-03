local game = require("scripts.game")
local helpers = require("scripts.helpers")
local sheetHelper = require("scripts.sheet_helper")
local sheetGame1 = sheetHelper.new("interface")
local tnt = require("scripts.transitions_manager")

local PowerUp = {}
local PowerUp_mt = { __index = PowerUp }

--- constructor
function PowerUp.new(params)
	 
	return setmetatable({
			collected 	= params.collected or false,
			x 			= params.x or 0,
			y 			= params.y or 0,
			display 	= nil
		},
		PowerUp_mt)
end

function PowerUp:display()
	local powerup = sheetGame1:newImage("powerup_strong.png")
	powerup.x = self.x
	powerup.y = self.y

	self.display = powerup
end

--- zderzenie ze zlotym jajkiem
function PowerUp:isCollision (egg)
	if egg and self.collected ~= true then
		if egg.x == self.display.x and egg.y == self.display.y then
				
			audio.play(game.audio.s14)
			game.eggOnMove = false			

			egg:powerUp()

			local speed = 120
			tnt:newTransition( egg, { time=speed, yScale=1.5, onComplete=function()
				tnt:newTransition( egg, { time=speed, xScale=.8, onComplete=function()
					tnt:newTransition( egg, { time=speed, xScale=1, yScale=1, onComplete=function()
						game.eggOnMove = true
					end } )
				end } )
			end } )			

			
			self.collected = true			
			transition.to( self.display, { time=500, alpha = 0,xScale=5,yScale=5, transition=easing.outExpo} )		
			
		end
	end
end

return PowerUp