----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

----------------------------------------------------------------------------------
-- 
--	NOTE:
--	
--	Code outside of listener functions (below) will only be executed once,
--	unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
--local helpers = require("scripts.helpers")
local sheetHelper = require("scripts.sheet_helper")

local sheetGame
local star1
local star2

local test160
local test162


local x1
local x2
local x3


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-----------------------------------------------------------------------------
		
	--	CREATE display objects and add them to 'group' here.
	--	Example use-case: Restore 'group' from previously saved state.
	
	-----------------------------------------------------------------------------
	sheetGame = sheetHelper.new("interface")


	star1 = sheetGame:newImage("star.png")
	star1.x = 737
	star1.y = 282
	star1.alpha = .5

	local animStar = function(star, scaleFactor)
		star:scale(.0,.0)		
		transition.to(star,{time=100,xScale=.45*scaleFactor,yScale=.75*scaleFactor,alpha=1,transition=easing.inQuad,onComplete=function()
			transition.to(star,{time=100,xScale=1.25*scaleFactor,yScale=.70*scaleFactor,transition=easing.inQuad,onComplete=function()
				transition.to(star,{time=100,xScale=.80*scaleFactor,yScale=1.20*scaleFactor,transition=easing.inQuad,onComplete=function()
					transition.to(star,{time=100,xScale=1*scaleFactor,yScale=1*scaleFactor,transition=easing.inQuad,onComplete=function()
						
					end})
				end})
			end})
		end})
	end


	function star1:tap(event)

		animStar(star1,1)
		animStar(star2,.5)
		
		-- print("test")			

		-- star1:scale(.0,.0)		
		-- transition.to(star1,{time=100,xScale=.45,yScale=.75,alpha=1,transition=easing.inQuad,onComplete=function()
		-- 	transition.to(star1,{time=100,xScale=1.25,yScale=.70,transition=easing.inQuad,onComplete=function()
		-- 		transition.to(star1,{time=100,xScale=.80,yScale=1.20,transition=easing.inQuad,onComplete=function()
		-- 			transition.to(star1,{time=100,xScale=1,yScale=1,transition=easing.inQuad,onComplete=function()
		-- 				print("ss")
		-- 			end})
		-- 		end})
		-- 	end})
		-- end})

		storyboard.printMemUsage()
	end
	star1:addEventListener("tap")

	star2 = sheetGame:newImage("star.png")
	star2.x = 637
	star2.y = 282
	star2.alpha = .5




	function star2:tap(event)
		
			print("test")			

		star2:scale(.0,.0)		
		transition.to(star2,{time=100,xScale=.45,yScale=.75, alpha=1,transition=easing.linear,onComplete=function()
			transition.to(star2,{time=100,xScale=1.25,yScale=.70,transition=easing.linear,onComplete=function()
				transition.to(star2,{time=100,xScale=.80,yScale=1.20,transition=easing.linear,onComplete=function()
					transition.to(star2,{time=100,xScale=1,yScale=1,transition=easing.linear,onComplete=function()
						print("ss")
					end})
				end})
			end})
		end})

		storyboard.printMemUsage()
	end
	star2:addEventListener("tap")




	x1 = sheetGame:newImage("x1.png")
	x1.x = 137
	x1.y = 182

	local animX = function(object)
		object:scale(1.05,.65)		
		transition.to(object,{time=100,xScale=.65,yScale=1.05,transition=easing.inOutQuad,onComplete=function()
			transition.to(object,{time=100,xScale=1.05,yScale=.80, y = x1.y - 10,transition=easing.inQuad,onComplete=function()
				transition.to(object,{time=100,xScale=1,yScale=1, y = x1.y - 10,transition=easing.linear,onComplete=function()
					transition.to(object,{time=700, alpha=0, y = x1.y - 70, transition=easing.outQuad,onComplete=function()
						object.alpha = 1
						object.y = 182
					end})
				end})
			end})
		end})
	end

	function x1:tap(event)
		
			print("test")		

			animX(x1)	

		-- x1:scale(1.05,.65)		
		-- transition.to(x1,{time=100,xScale=.65,yScale=1.05,transition=easing.inOutQuad,onComplete=function()
		-- 	transition.to(x1,{time=100,xScale=1.05,yScale=.80, y = x1.y - 10,transition=easing.inQuad,onComplete=function()
		-- 		transition.to(x1,{time=100,xScale=1,yScale=1, y = x1.y - 10,transition=easing.linear,onComplete=function()
		-- 			transition.to(x1,{time=700, alpha=0, y = x1.y - 70, transition=easing.outQuad,onComplete=function()
		-- 				print("ss")
		-- 			end})
		-- 		end})
		-- 	end})
		-- end})

		storyboard.printMemUsage()
	end
	x1:addEventListener("tap")



	---- test
	test160 = sheetGame:newImage("160.png")
	test160.x = 200
	test160.y = 500

	test162 = sheetGame:newImage("162.png")
	test162.x = 500
	test162.y = 500

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
		
	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
	-----------------------------------------------------------------------------
	storyboard.removeScene( "scene_menu" )
	storyboard.printMemUsage()

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	
	-----------------------------------------------------------------------------
	spriteSheet:dispose()
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)
	
	-----------------------------------------------------------------------------
	
end


---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene