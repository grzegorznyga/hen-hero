local gameState = require("scripts.game")
local helpers = require("scripts.helpers")
local sheetHelper = require("scripts.sheet_helper")
local sheetGame1 = sheetHelper.new("interface")

local Rock = {}
local Rock_mt = { __index = Rock }

function Rock.new(params)	-- constructor
	 
	local new_rock = {
			x=params.x or 0,
			y=params.y or 0,
			display = nil,
			shadow = nil
		}
	return setmetatable( new_rock, Rock_mt)
end

function Rock:display()	
	local rock = sheetGame1:newImage("rock.png")
	rock.yReference = 0
	rock.xReference = 1
	rock.x = self.x
	rock.y = self.y

	local shadow = sheetGame1:newImage("rock_s.png")
	shadow.yReference = -15
	shadow.xReference = 0
	shadow.x = self.x
	shadow.y = self.y	

	self.display = rock
	self.shadow = shadow
end

function Rock:isCollision (egg)
	--------------------------------optymalizacja
	local objectX, objectY = self.display.x, self.display.y
	local eggX, eggY, eggOrientation = egg.x, egg.y, egg.orientation
	local eggDirectionX, eggDirectionY = egg.xdirection, egg.ydirection

	----------------------------------- czujniki
	local x,y = eggX,eggY
	local range = 0

	-------------------------------czyjnik na  sciane
	range = 80
	if eggOrientation == 1 then 
		x = eggX + range * eggDirectionX
	else 
		y = eggY + range * eggDirectionY
	end 

	if egg.sequence == "normal" and x == objectX and y == objectY then 		
		egg:crash()	
	end

	-------------------------------czyjnik na odbicie
	range = 70
	if eggOrientation == 1 then 
		x = eggX + range * eggDirectionX
	else 
		y = eggY + range * eggDirectionY
	end 

	if egg.sequence == "strong" and x == objectX and y == objectY then 
		egg:bump(true)
	end

end

return Rock