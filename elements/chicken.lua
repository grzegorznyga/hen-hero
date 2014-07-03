local helpers = require("scripts.helpers")
local game = require("scripts.game")
local sheetHelper = require("scripts.sheet_helper")

local sheetGame1 = sheetHelper.new("interface")

local Chicken = {}
local Chicken_mt = { __index = Chicken }

function Chicken.new(x,y,rotation, egg)	-- constructor
	
	local chicken = {
		x=x or 0,
		y=y or 0,
		rotation = rotation or 0,
		display = nil,
		displayHead = nil,
		displayBody = nil,
		egg = egg,
		myRectangle = nil
	}
	return setmetatable( chicken, Chicken_mt )
end

function Chicken:pause()
	if self.display.isPlaying then
		self.display.isPause = true
		self.display:pause()
		if self.display.timer ~= nil then
			timer.pause( self.display.timer )
		end
	end
end

function Chicken:continue()
	if self.display.isPause then
		self.display.isPause = false
		self.display:play()
		if self.display.timer ~= nil then
			timer.resume( self.display.timer )
		end
	end
end



function Chicken:isCollision(egg)
	if(egg) then
		if (egg.y <= self.display.y+70 and egg.x == self.display.x and egg.ydirection == -1) then			
			audio.play(game.audio.s11)
			game.eggOnMove = false			
			

			-- wjechanie jajka
			transition.to(egg,{time=799,y=egg.y-70, transition=easing.outExpo,onComplete=function()
				egg:prepereEgg()
				self.myRectangle.isEggInside = true
				game.status = "restart" 
			end })

			-- aniamcja korousu
			local chickenBody = self.displayBody
			chickenBody:setReferencePoint( display.CenterLeftReferencePoint )			
			transition.to(chickenBody,{time=99,xScale=.88,yScale=1.10,onComplete=function()
				transition.to(chickenBody,{time=99,xScale=1.02,yScale=0.98,onComplete=function()
					transition.to(chickenBody,{time=99,xScale=1,yScale=1,onComplete=function()
						
					end})
				end})
			end})

			-- animacja glowy
			local chickenHead = self.displayHead
			local xHead = chickenHead.x
			transition.to(chickenHead,{time=99,x=xHead-8,onComplete=function()
				transition.to(chickenHead,{time=99,x=xHead+2,onComplete=function()
					transition.to(chickenHead,{time=99,x=xHead,onComplete=function()
						--print("ss")
					end})
				end})
			end})

			
		end
	end
end



function Chicken:display()	-- constructor

	-- local sheetChicken = sheetHelper.new("game2")
	-- local sequenceData = { 
	-- 	{ name="chickenStart", start=sheetChicken.options.frameIndex["chicken01.png"], count=16,  time=400, loopCount = 1 },
	-- 	{ name="chickenEnd", start=sheetChicken.options.frameIndex["chicken18.png"], count=7,  time=290, loopCount = 1 },
	--  }
	-- local chicken = display.newSprite( sheetChicken.data, sequenceData )

	local chicken = display.newImageGroup( sheetGame1.data )
	local chickenHead = sheetGame1:newImage("chicken_head.png")
	local chickenBody = sheetGame1:newImage("chicken_body.png")



	chicken:insert( chickenHead )
	chicken:insert( chickenBody )

	chickenHead.x = -79
	chickenHead.y = -3
	

	chicken.xReference = -10
	chicken.yReference = -13

	chicken.x = self.x
	chicken.y = self.y
	chicken.rotation = self.rotation
	
	--metody
	--chicken.touch = touch
	--chicken.test = test
	--chicken.isCollision = isCollision
	chicken.isPause = false
	
	
	self.display = chicken
	self.displayHead = chickenHead
	self.displayBody = chickenBody

	--obszar klikalny
	local myRectangle = display.newRect(0, 0, 140, 82)
	myRectangle.xReference = 20
	myRectangle.x=self.x
	myRectangle.y=self.y
	myRectangle.isVisible = false
	myRectangle.isHitTestable = true
	myRectangle.isEggInside = true
	

	--start
	local function startEgg()
		if myRectangle.isEggInside then
			myRectangle.isEggInside = false
			audio.play(game.audio.s9)

			-- wjechanie jajka
			transition.to(self.egg,{time=100,y=self.egg.y+78,onComplete=function()				
					--transition.to(self.egg,{time=50,x=self.egg.x+39,onComplete=function()
					game.status = "play"
				 	game.eggOnMove = true
				 	--end })			 	
			end })			

			chickenBody:setReferencePoint( display.CenterLeftReferencePoint )			
			transition.to(chickenBody,{time=66,xScale=.9,yScale=1.1,onComplete=function()
				transition.to(chickenBody,{time=66,xScale=1.12,yScale=0.94,onComplete=function()
					transition.to(chickenBody,{time=33,xScale=1.22,yScale=.88,onComplete=function()
						transition.to(chickenBody,{time=33,xScale=1.12,yScale=.94,onComplete=function()
							transition.to(chickenBody,{time=66,xScale=.93,yScale=1.07,onComplete=function()
								transition.to(chickenBody,{time=66,xScale=1.03,yScale=.97,onComplete=function()
									transition.to(chickenBody,{time=66,xScale=1,yScale=1,onComplete=function()
										--print("ss")
									end})
								end})
							end})
						end})
					end})
				end})
			end})

			local xHead = chickenHead.x
			transition.to(chickenHead,{time=66,x=xHead+1,onComplete=function()
				transition.to(chickenHead,{time=66,x=xHead-3,onComplete=function()
					transition.to(chickenHead,{time=33,x=xHead-5,onComplete=function()
						transition.to(chickenHead,{time=33,x=xHead-3,onComplete=function()
							transition.to(chickenHead,{time=66,x=xHead+0,onComplete=function()
								transition.to(chickenHead,{time=66,x=xHead+1,onComplete=function()
									transition.to(chickenHead,{time=66,x=xHead,onComplete=function()
										--print("ss")
									end})
								end})
							end})
						end})
					end})
				end})
			end})

		else
		---dwiek tutaj
		audio.play(game.audio.s10)

		end
	end
	self.startEgg = function() return startEgg() end

	--eventy
	local function onTouch(event)
		if(event.phase == "began") then
			game.start()
			startEgg()
		end
	end
	myRectangle:addEventListener("touch", onTouch)

	self.myRectangle = myRectangle
	


end

return Chicken