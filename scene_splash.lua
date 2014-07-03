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
local data = require("scripts.data")
local myTimer
local loadingImage

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-----------------------------------------------------------------------------
		
	--	CREATE display objects and add them to 'group' here.
	--	Example use-case: Restore 'group' from previously saved state.
	
	-----------------------------------------------------------------------------
	loadingImage = display.newImageRect("images/splash.png",768 , 1363)	
	loadingImage.x = display.contentWidth / 2
	loadingImage.y = display.contentHeight / 2
	group:insert( loadingImage )

	
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
		
	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
	-----------------------------------------------------------------------------
	storyboard.analytics.logEvent( "EnterScene_Splash" )
	storyboard.printMemUsage()
	


	--- zaladuj dzwieki	
	storyboard.audio.s1 = audio.loadStream("audio/01.mp3")
	storyboard.audio.s2 = audio.loadSound("audio/02.wav")

	-- zaladuj ustawienia gry
	local settings = data.loadSettings()
	if settings ~= nil then
		storyboard.settings  = settings
	end


	local goToMenu = function()	

		transition.to( loadingImage, { time=400, alpha=0, onComplete = 
				function() storyboard.gotoScene( "scene_menu" ) end
				 } )		

	end
	myTimer = timer.performWithDelay( 2000, goToMenu, 1 )
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	--transition.to( loadingImage, { time=500,  alpha=.2 } )
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	
	-----------------------------------------------------------------------------
	if myTimer then timer.cancel( myTimer ); end
	loadingImage:removeSelf()
	loadingImage = nil

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