local game = require("scripts.game")
local helpers = require("scripts.helpers")
local sheetHelper = require("scripts.sheet_helper")
local sheetGame1 = sheetHelper.new("interface")

local Reverser = {}
local Reverser_mt = { __index = Reverser }

function Reverser.new(params)	-- constructor
	 
	return setmetatable({
			x=params.x or 0,
			y=params.y or 0,			
			display = nil,
			shadow = nil,
			egg = params.egg
		},
		Reverser_mt)
end

function Reverser:display()
	
	local straw = sheetGame1:newImage("straw_small.png")
	
	straw.yReference = 0
	straw.xReference = 0
	
	straw.x = self.x
	straw.y = self.y

	local shadow = sheetGame1:newImage("straw_small_s.png")
	shadow.yReference = -28
	shadow.xReference = -28
	shadow.x = self.x
	shadow.y = self.y

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
	--print(x .. "=" .. self.display.x .. " x " .. y .. "=" .. self.display.y)
	if (x == self.display.x and y == self.display.y) then		
		audio.play(game.audio.s13)
		egg:bump()
	end	
end

return Reverser