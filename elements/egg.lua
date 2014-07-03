local game = require("scripts.game")
local sheetHelper = require("scripts.sheet_helper")
local sheetGame1 = sheetHelper.new("interface")
local tnt = require("scripts.transitions_manager")

local Egg = {}

local function calculatePosition(self)
	self.x = self.x + ( self.xspeed * self.xdirection );
	self.y = self.y + ( self.yspeed * self.ydirection );
	--print("x:"..self.x.." y:"..self.y)
end

local function moveEgg(self)	
	self:translate( 0, 0)
end

local function powerUp(self) 
	self:setSequence( "strong" )
end

local function prepereEgg(self)

	self.x = 384
	self.y = 137

	self.rotation = 180
	
	self.radius = 20
	self.move = false

	self.xdirection = 1
	self.ydirection = 1

	self.xspeed = 0
	self.yspeed = game.eggSpeed

	self:setSequence( "normal" )

	--self:setSequence( "crash" )
	
	self.orientation = -1 -- 1- lewa/prawa -1 gora/dol
end

local function crash(self)	
	game.status = "lost"
	--game.eggOnMove = false	
	audio.play(game.audio.s12)
	self:setSequence( "crash" )
	if self.orientation == 1 then
		self.x = self.x - 5 * self.xdirection
		self.y = self.y + 5 * self.xdirection
	else
		self.x = self.x - 5 * self.ydirection
		self.y = self.y - 5 * self.ydirection
	end		
	self:play()
end

--- 
local function bump(self,removePower)

	local egg = self
			
	game.eggOnMove = false	
	
	local xMove,yMove = 0,0
	if egg.orientation == 1 then xMove = 15*egg.xdirection end
	if egg.orientation == -1 then yMove = 15*egg.ydirection end

	local speed = 120
	tnt:newTransition( egg, { time=speed, yScale=.5 } )
	tnt:newTransition( egg, { time=speed, xScale=1.15 } )
	tnt:newTransition( egg, { time=speed, y=egg.y+yMove, x=egg.x+xMove, 
	onComplete=function()
		egg:rotate(180)
		if removePower == true then egg:setSequence( "normal" )	end		
		game:increaseTurns()
		tnt:newTransition( egg, { time=speed, yScale=1 } )
		tnt:newTransition( egg, { time=speed, xScale=1 } )
		tnt:newTransition( egg, { time=speed, y=egg.y-yMove, x=egg.x-xMove,
		onComplete=function()
			game.eggOnMove = true			
		end } )
	end } )		

	-- ustaw animacje obicia
	if egg.orientation == 1 then 				-- lewa/praw banda	
		egg.xdirection = egg.xdirection * -1
	else			
		egg.ydirection = egg.ydirection * -1
	end	
end

function Egg.new(x, y)

	local eggOptions = {
		{ name="normal", start=sheetGame1.options.frameIndex["egg.png"], count=1},
		{ name="strong", start=sheetGame1.options.frameIndex["egg_strong.png"], count=1},
		{ name="crash", start=sheetGame1.options.frameIndex["crash00.png"], count=6, time=170, loopCount = 1}
	}
	local egg = display.newSprite( sheetGame1.data, eggOptions )
	

	egg.x = x or 0
	egg.y = y or 0
	

	-- metody
	egg.prepereEgg = prepereEgg
	egg.calculatePosition = calculatePosition
	egg.moveEgg = moveEgg
	egg.powerUp = powerUp
	egg.crash = crash
	egg.bump = bump

	--egg.game = game

	egg:prepereEgg()

	return egg
end

-- function Egg:powerUp()
-- 	print("power")
-- end



return Egg