local game = require("scripts.game")
local helpers = require("scripts.helpers")
local sheetHelper = require("scripts.sheet_helper")
local sheetGame1 = sheetHelper.new("interface")
local tnt = require("scripts.transitions_manager")

local Reverser = {}
local Reverser_mt = { __index = Reverser }

function Reverser.new(params)	-- constructor
	 
	return setmetatable({
			x=params.x or 0,
			y=params.y or 0,
			rotation = params.rotation or 0,
			display = nil,
			shadow = nil,
			egg = params.egg
		},
		Reverser_mt)
end

function Reverser:display()
	
	local shadow = nil
	local straw = nil
	if self.rotation == 90 or self.rotation == 270 then
		
		straw = sheetGame1:newImage("straw_.png")
		straw.yReference = 0
		straw.xReference = -42			

		shadow = sheetGame1:newImage("straw__s.png")
		shadow.yReference = -24
		shadow.xReference = -67
		shadow.x = self.x
		shadow.y = self.y

	else
		straw = sheetGame1:newImage("straw.png")
		straw.yReference = -42
		straw.xReference = 0

		shadow = sheetGame1:newImage("straw_s.png")
		shadow.yReference = -60
		shadow.xReference = -26
		shadow.x = self.x
		shadow.y = self.y
	end
	
	straw.x = self.x
	straw.y = self.y

	--local egg = self.egg

	self.display = straw
	self.shadow = shadow
end


function Reverser:isCollision (egg)

	--policz czoło jajka
	local x,y = egg.x,egg.y
	if egg.orientation == 1 then 
		x = egg.x+70 * egg.xdirection
	else
		y = egg.y+70 * egg.ydirection
	end

	if (x == self.display.x and y == self.display.y) then		
		audio.play(game.audio.s13)
		egg:bump()
	elseif self.rotation == 0 and x == self.display.x and y == self.display.y+game.cellSize then
		audio.play(game.audio.s13)
		egg:bump()
	elseif self.rotation == 90 and x == self.display.x-game.cellSize and y == self.display.y then
		audio.play(game.audio.s13)
		egg:bump()
	elseif self.rotation == 180 and x == self.display.x and y == self.display.y-game.cellSize then
		audio.play(game.audio.s13)
		egg:bump()
	elseif self.rotation == 270 and x == self.display.x+game.cellSize and y == self.display.y then
		audio.play(game.audio.s13)
		egg:bump()
	end	
end

return Reverser