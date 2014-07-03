local Rock = {}
local Rock_mt = { __index = Rock }

local gameState = require("scripts.game")
local helpers = require("scripts.helpers")
local sheetHelper = require("scripts.sheet_helper")
local sheetGame1 = sheetHelper.new("interface")

function Rock.new(params)	-- constructor
	 
	local new_rock = {
			x=params.x or 0,
			y=params.y or 0,
			display = nil,
			id = params.id or 0
		}
	return setmetatable( new_rock, Rock_mt)
end

function Rock:display()	
	local constructorBlock = display.newRect(0, 0, 166/2, 166/2)
	constructorBlock.strokeWidth = 1
	constructorBlock.x = self.x
	constructorBlock.y = self.y
	constructorBlock.alpha = .5
	constructorBlock.id = self.id

	rock.x = self.x
	rock.y = self.y

	self.display = rock
end

return Rock