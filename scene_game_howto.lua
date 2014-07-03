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
local sheetGame1 = sheetHelper.new("interface")

local window


local endSceneFail
local help
local help2
local restartEnd
local buttonNext
local loadingLayer

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-----------------------------------------------------------------------------
		
	--	CREATE display objects and add them to 'group' here.
	--	Example use-case: Restore 'group' from previously saved state.
	
	-----------------------------------------------------------------------------


	window = display.newGroup()	

	endSceneFail = display.newImageRect("images/bg_popup.png", 822, 492)	
	endSceneFail.x = display.contentWidth / 2
	endSceneFail.y = display.contentHeight / 2

	restartEnd = sheetGame1:newImage("play_txt.png")
	restartEnd.x =display.contentWidth / 2
	restartEnd.y = 545

	if storyboard.levelNumber == 1 then
		help = sheetGame1:newImage("help1.png")
		help.x = display.contentWidth / 2
		help.y = 410

		help2 = sheetGame1:newImage("help2.png")
		help2.x = display.contentWidth / 2
		help2.y = 410
		help2.alpha = 0

		restartEnd.isVisible = false
		
		buttonNext = sheetGame1:newImage("next_txt.png")
		buttonNext.x = display.contentWidth / 2
		buttonNext.y = 545
		function buttonNext:touch(event)
			if event.phase == "began" then
				audio.play(storyboard.audio.s2)
				self.alpha = .5
				self:scale( .9, .9 )
				display.getCurrentStage():setFocus(event.target)
			elseif(event.phase == "ended") then
				self.alpha = 0
				restartEnd.isVisible = true

				transition.to( help, { time=200, alpha=0,xScale =.2, yScale =.2, onComplete=function() 
					transition.to( help2, { time=200, alpha=1, onComplete=function() 
					
					end } )
				end } )
				
				
				display.getCurrentStage():setFocus(nil)
			end
		end
		buttonNext:addEventListener("touch")

	elseif storyboard.levelNumber == 16 then
		help = sheetGame1:newImage("help4.png")
		help.x = (display.contentWidth / 2) + 44
		help.y = 400
	elseif storyboard.levelNumber == 35 then
		help = sheetGame1:newImage("help3.png")
		help.x = display.contentWidth / 2
		help.y = 400
	end
	

	function restartEnd:touch(event)
		if event.phase == "began" then
			audio.play(storyboard.audio.s2)
			self.alpha = .5
			self:scale( .9, .9 )
			display.getCurrentStage():setFocus(event.target)
		elseif(event.phase == "ended") then
			self.alpha = 1
			self.xScale = 1
			self.yScale = 1

			storyboard.hideOverlay(  )
			
			display.getCurrentStage():setFocus(nil)
		end
	end
	restartEnd:addEventListener("touch")

	loadingLayer = display.newRect(0, 0, display.contentWidth, display.contentHeight)
	loadingLayer:setFillColor(0, 0, 0)
	loadingLayer.alpha = 0	

	window:insert(endSceneFail)
	window:insert(help)
	if help2 ~= nil then window:insert(help2) end
	if buttonNext ~= nil then window:insert(buttonNext) end
	window:insert(restartEnd)
	window:setReferencePoint( display.CenterReferencePoint )

	window:scale(.4,.9)		
	transition.to(window,{time=100,xScale=1.05,yScale=.7,transition=easing.inQuad,onComplete=function()
		transition.to(window,{time=110,xScale=.95,yScale=1.06,transition=easing.inQuad,onComplete=function()
			transition.to(window,{time=120,xScale=1.02,yScale=.98,transition=easing.inQuad,onComplete=function()
				transition.to(window,{time=130,xScale=1,yScale=1,transition=easing.inQuad,onComplete=function()
					
				end})
			end})
		end})
	end})	
	

	group:insert(window)
	group:insert(loadingLayer)

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
		
	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
	-----------------------------------------------------------------------------
	--print("enterScene")

	storyboard.printMemUsage()
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