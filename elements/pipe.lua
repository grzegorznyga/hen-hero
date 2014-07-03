local game = require("scripts.game")
local helpers = require("scripts.helpers")
local tnt = require("scripts.transitions_manager")
local sheetHelper = require("scripts.sheet_helper")
local sheetGame1 = sheetHelper.new("interface")

local Pipe = {}
local Pipe_mt = { __index = Pipe }

function Pipe.new(params)	-- constructor
	local pipe = {
			x=params.x or 0,
			y=params.y or 0,
			withLock = params.withLock or false,
			display = nil,
			displayDiode = nil,
			displayBarrier1 = nil,
			displayBarrier2 = nil
		}
		
	return setmetatable( pipe, Pipe_mt )	
end

function Pipe:display()
	local pipe = sheetGame1:newImage("pipe.png")
	pipe.rotation = 90
	pipe.xReference = -20
	pipe.yReference = -19
	pipe.x = self.x
	pipe.y = self.y
	pipe.isLocked = false
	self.display = pipe


	if self.withLock then 
		pipe.isLocked = true		
		local diode = display.newSprite( sheetGame1.data, {
			{ name="red", start=sheetGame1.options.frameIndex["pipe_r.png"], count=1},
			{ name="green", start=sheetGame1.options.frameIndex["pipe_g.png"], count=1}
		} )
		diode.rotation = 90
		diode.xReference = -39
		diode.yReference = 0
		diode.x = self.x
		diode.y = self.y		
		self.displayDiode = diode


		-- szlaban 1
		local barrier1Group = display.newImageGroup( sheetGame1.data )
		barrier1Group.xReference = 30
		barrier1Group.yReference = 0
		barrier1Group.x = self.x
		barrier1Group.y = self.y
		self.displayBarrier1 = barrier1Group
		--barrier1Group.isVisible = false

		local barrier1ShadowBottom = sheetGame1:newImage("barrier_03.png")
		barrier1ShadowBottom.x = 8	
		barrier1ShadowBottom.y = -4	
		barrier1Group:insert( barrier1ShadowBottom )

		local barrier1 = sheetGame1:newImage("barrier_01.png")
		barrier1.y = -4
		barrier1Group:insert( barrier1 )

		local barrier1ShadowTop = sheetGame1:newImage("barrier_02.png")
		barrier1ShadowTop:rotate(180)
		barrier1Group:insert( barrier1ShadowTop )
		barrier1Group.rotation = 90


		-- szlaban 2
		local barrier2Group = display.newImageGroup( sheetGame1.data )
		barrier2Group.xReference = 15
		barrier2Group.yReference = 0
		barrier2Group.x = self.x
		barrier2Group.y = self.y
		self.displayBarrier2 = barrier2Group

		local barrier2ShadowBottom = sheetGame1:newImage("barrier_03.png")
		barrier2ShadowBottom.x = 8	
		barrier2ShadowBottom.y = 6	
		barrier2Group:insert( barrier2ShadowBottom )

		local barrier2 = sheetGame1:newImage("barrier_01.png")
		barrier2.y = 6
		barrier2Group:insert( barrier2 )

		local barrier2ShadowTop = sheetGame1:newImage("barrier_02.png")		
		barrier2Group:insert( barrier2ShadowTop )	
		barrier2Group.rotation = 90	

		function game:unlockExit()
			pipe.isLocked = false
			diode:setSequence("green")

			tnt:newTransition( barrier1ShadowBottom, { time=500, y=-76, transition=easing.outQuad } )
			tnt:newTransition( barrier1, { time=500, y=-76, transition=easing.outQuad } )

			tnt:newTransition( barrier2ShadowBottom, { time=500, y=74, transition=easing.outQuad } )
			tnt:newTransition( barrier2, { time=500, y=74, transition=easing.outQuad } )
		end
	else
		function game:unlockExit()
		end
	end

end

function Pipe:isCollision (egg)	
	if egg.orientation == -1 and egg.ydirection == 1 and self.display.x == egg.x then
		
		--------------------------------optymalizacja
		local objectX, objectY = self.display.x, self.display.y
		local eggX, eggY, eggOrientation = egg.x, egg.y, egg.orientation
		local eggDirectionX, eggDirectionY = egg.xdirection, egg.ydirection

		---------------------------- czujnik zagdaj melodie
		if self.display.isLocked == false and self.display.y - 100 == egg.y then
			audio.play(game.audio.s18)	

			game:disableButtons()
			game.eggOnMove = false
			tnt:newTransition( egg, { time=200, y=egg.y+60, onComplete=function()
				tnt:newTransition( egg, { time=220, y=egg.y+40, xScale=1.1, yScale=1, onComplete=function()
					 tnt:newTransition( egg, { time=80, y=egg.y+30, xScale=.8, yScale=1.2, onComplete=function()
					 	game.eggOnMove = true
					 end } )
				end } )
			end } )	

			return true	
		end

		if self.display.isLocked then
			-------------------------------czyjnik na  sciane rozbicie
			if  egg.sequence == "normal" and self.display.y - 70 == egg.y then
				egg:crash()
				return true	
			end	

			-------------------------------czyjnik na  sciane rozbicie
			if egg.sequence == "strong" and self.display.y - 60 == egg.y then
				egg:bump(true)
				return true	
			end
		end

		--------------------------- wygrana
		
		if self.display.y + 50 == egg.y then
			game.status = "win"		
		end
	end
	
end

return Pipe