local game = require("scripts.game")
local helpers = require("scripts.helpers")
local sheetHelper = require("scripts.sheet_helper")
local sheetGame1 = sheetHelper.new("interface")
local tnt = require("scripts.transitions_manager")

local GoldenEgg = {}
local GoldenEgg_mt = { __index = GoldenEgg }

--- constructor
function GoldenEgg.new(params)
	 
	return setmetatable({
			collected 	= params.collected or false,
			x 			= params.x or 0,
			y 			= params.y or 0,
			display 	= nil,
			displayBonus1 = nil,
			displayBonus2 = nil,
			displayBonus3 = nil
		},
		GoldenEgg_mt)
end

function GoldenEgg:display()
	local goldenEgg = sheetGame1:newImage("golden_egg.png")
	goldenEgg.x = self.x
	goldenEgg.y = self.y

	self.display = goldenEgg

	--game.bonusCounter = game.bonusCounter + 1

	self.displayBonus1 = sheetGame1:newImage("x1.png")
	self.displayBonus1.x = self.x
	self.displayBonus1.y = self.y
	self.displayBonus1.alpha = 0

	self.displayBonus2 = sheetGame1:newImage("x2.png")
	self.displayBonus2.x = self.x
	self.displayBonus2.y = self.y
	self.displayBonus2.alpha = 0

	self.displayBonus3 = sheetGame1:newImage("x3.png")
	self.displayBonus3.x = self.x
	self.displayBonus3.y = self.y
	self.displayBonus3.alpha = 0
end

-- animacja x po zebraniu jajka
local animX = function(object)
	object.alpha = 1
	object:scale(1.05,.65)		
	tnt:newTransition(object,{time=100,xScale=.65,yScale=1.05,transition=easing.inOutQuad,onComplete=function()
		tnt:newTransition(object,{time=100,xScale=1.05,yScale=.80, y = object.y - 10,transition=easing.inQuad,onComplete=function()
			tnt:newTransition(object,{time=100,xScale=1,yScale=1, y = object.y - 10,transition=easing.linear,onComplete=function()
				tnt:newTransition(object,{time=700, alpha=0, y = object.y - 70, transition=easing.outQuad,onComplete=function()
					object:removeSelf()
					object = nil
				end})
			end})
		end})
	end})
end

--- zderzenie ze zlotym jajkiem
function GoldenEgg:isCollision (egg)
	if egg and self.collected ~= true then
		if (egg.x == self.display.x and egg.y == self.display.y) then
			--self.display.parent:remove(self.display)	
			audio.play(game.audio.s14)

			game.bonus = game.bonus + 1
			-- local xBonus = sheetGame1:newImage("x"..game.bonus..".png")
			-- xBonus.x = self.display.x
			-- xBonus.y = self.display.y
			if game.bonus == 1 then
				animX(self.displayBonus1)
			elseif game.bonus == 2 then
				animX(self.displayBonus2)
			elseif game.bonus == 3 then
				animX(self.displayBonus3)	
			end		

			self.collected = true			
			transition.to( self.display, { time=500, alpha = 0, transition=easing.outExpo} )		
			
		end
	end
end

return GoldenEgg