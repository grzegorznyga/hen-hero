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
local game = require("scripts.game")
local sheetGame1 = sheetHelper.new("interface")

local window

local chickenScore
local endSceneFail
local restartEnd
local menuEnd
--local loadingLayer
local jingelChanel

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-----------------------------------------------------------------------------
		
	--	CREATE display objects and add them to 'group' here.
	--	Example use-case: Restore 'group' from previously saved state.
	
	-----------------------------------------------------------------------------
	window = display.newGroup()	

	jingelChanel = audio.play(game.audio.s20)

	endSceneFail = display.newImageRect("images/bg_fail.png",768,656)	
	endSceneFail.x = display.contentWidth / 2
	endSceneFail.y = (display.contentHeight / 2) -180

	restartEnd = sheetGame1:newImage("restart_popup.png")
	restartEnd.x = display.contentWidth / 2
	restartEnd.y = 2.13 * 221
	
	menuEnd = sheetGame1:newImage("menu_popup.png")
	menuEnd.x = (display.contentWidth / 2) - (2.13 * 67)
	menuEnd.y = 2.13 * 224

	function menuEnd:touch(event)
		if event.phase == "began" then
			audio.play(game.audio.s2)
			self.alpha = .5
			self:scale( .95, .95 )
			display.getCurrentStage():setFocus(event.target)
		elseif event.phase == "ended" then
			audio.stop()
			self.alpha = 1
			self:scale( 1, 1 )
			storyboard.gotoScene( "scene_menu" )
			display.getCurrentStage():setFocus(nil)
			self:removeEventListener("touch")
		end
	end
	menuEnd:addEventListener("touch")

	function restartEnd:touch(event)
		if event.phase == "began" then
			audio.play(game.audio.s2)
			self.alpha = .5
			self:scale( .9, .9 )
			display.getCurrentStage():setFocus(event.target)
		elseif(event.phase == "ended") then
			audio.stop()
			self.alpha = 1
			self.xScale = 1
			self.yScale = 1

			--local restart = function( obj )				
				storyboard.gotoScene( "scene_loading_level" )
			--end
			--transition.to( loadingLayer, { time=200, alpha=1, onComplete=restart } )

			display.getCurrentStage():setFocus(nil)
		end
	end
	restartEnd:addEventListener("touch")

	-- loadingLayer = display.newRect(0, 0, display.contentWidth, display.contentHeight)
	-- loadingLayer:setFillColor(0, 0, 0)
	-- loadingLayer.alpha = 0

	--test animacji
	-- function window:touch(event)
	-- 	if event.phase == "ended" then
	-- 		print("test")

	-- 		-- window:scale(1,1)

	-- 		-- transition.to(window,{time=200,xScale=.4,yScale=.9,transition=easing.inQuad,onComplete=function() 
	-- 		-- 	transition.to(window,{time=120,xScale=1.05,yScale=.7,transition=easing.inQuad,onComplete=function()
	-- 		-- 		transition.to(window,{time=180,xScale=.95,yScale=1.06,transition=easing.inQuad,onComplete=function()
	-- 		-- 			transition.to(window,{time=200,xScale=1.02,yScale=.98,transition=easing.inQuad,onComplete=function()
	-- 		-- 				transition.to(window,{time=200,xScale=1,yScale=1,transition=easing.inQuad,onComplete=function()
	-- 		-- 					print("ss")
	-- 		-- 				end})
	-- 		-- 			end})
	-- 		-- 		end})
	-- 		-- 	end})	
	-- 		-- end})

	-- 	end
	-- end
	-- window:addEventListener("touch")

	window:insert(endSceneFail)
	window:insert(restartEnd)
	window:insert(menuEnd)	
	window:setReferencePoint( display.CenterReferencePoint )

	window:scale(.4,.9)		
	transition.to(window,{time=100,xScale=1.05,yScale=.7,transition=easing.inQuad,onComplete=function()
		transition.to(window,{time=110,xScale=.95,yScale=1.06,transition=easing.inQuad,onComplete=function()
			transition.to(window,{time=120,xScale=1.02,yScale=.98,transition=easing.inQuad,onComplete=function()
				transition.to(window,{time=130,xScale=1,yScale=1,transition=easing.inQuad,onComplete=function()
					--print("ss")
				end})
			end})
		end})
	end})	

	---- kura HIGH Score
	-- chickenScore = sheetGame1:newImage("chicken_corner.png")
	-- chickenScore.x = 620
	-- chickenScore.y = 880
	

	group:insert(window)
	--group:insert(chickenScore)
	--group:insert(loadingLayer)

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
		
	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
	-----------------------------------------------------------------------------
	

	storyboard.printMemUsage()

	--transition.to(chickenScore,{time=150,x = 535,transition=easing.inOutQuad}) 
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	
	-----------------------------------------------------------------------------
	--print("exitScene")
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)
	
	-----------------------------------------------------------------------------
	--print("destroyScene")
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