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
local helpers = require("scripts.helpers")
local data = require("scripts.data")
local tnt = require("scripts.transitions_manager")
local game = require("scripts.game")
local sheetHelper = require("scripts.sheet_helper")
local sheetGame1 = sheetHelper.new("interface")

local window, groupHighScore
local groupEgg
local textBitmap

local chickenScore
local eggStars
local plateHighScore
local endSceneWin
local playEnd
local menuEnd2
local restartEnd2
--local loadingLayer
local jingelChanel

local textTurns, levelText, totalText, turnsCountText, eggPointsText, turnsPointsText, eggCountText,turnsMaxText
local highScoreText
local star1, star2, star3

local scoreEggs 
local scoreTurns
local totalScore
local highScore 
local isRecord

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-----------------------------------------------------------------------------
		
	--	CREATE display objects and add them to 'group' here.
	--	Example use-case: Restore 'group' from previously saved state.
	
	-----------------------------------------------------------------------------
	textBitmap = require("scripts.text_bitmap")
	window = display.newGroup()	
	window.y = 20
	groupHighScore = display.newGroup()

	-- rekord
	jingelChanel = audio.play(game.audio.s21)	

	----
	endSceneWin = display.newImageRect("images/bg_tutorial.png",768,696)
	endSceneWin.x = display.contentWidth / 2
	endSceneWin.y = (display.contentHeight / 2) -154
	
	playEnd = sheetGame1:newImage("play_popup.png")
	playEnd.x = display.contentWidth / 2
	playEnd.y = 2.13 * 224
	function playEnd:touch(event)
		if event.phase == "began" then
			audio.play(game.audio.s2)
			self.alpha = .5
			self:scale( .95, .95 )
			display.getCurrentStage():setFocus(event.target)
		elseif event.phase == "ended" then
			audio.stop()
			self.alpha = 1
			self:scale( 1, 1 )

			
			
			--local restart = function( obj )
				storyboard.levelNumber = storyboard.levelNumber + 1				
				storyboard.gotoScene( "scene_loading_level" )
			--end
			--transition.to( loadingLayer, { time=100, alpha=1, onComplete=restart } )

			display.getCurrentStage():setFocus(nil)
			self:removeEventListener("touch")
		end
	end
	playEnd:addEventListener("touch")
	
	
	menuEnd2 = sheetGame1:newImage("menu_popup.png")
	menuEnd2.x = (display.contentWidth / 2) - (2.13 * 67)
	menuEnd2.y = 2.13 * 227
	function menuEnd2:touch(event)
		if event.phase == "began" then
			audio.play(game.audio.s2)
			self.alpha = .5
			self:scale( .95, .95 )
			display.getCurrentStage():setFocus(event.target)
		elseif event.phase == "ended" then
			audio.stop()
			self.alpha = 1
			self:scale( 1, 1 )

			tnt:cancelAllTransitions()
			tnt:cancelAllTimers()

			storyboard.gotoScene( "scene_menu" )
			display.getCurrentStage():setFocus(nil)
			self:removeEventListener("touch")
		end
	end
	menuEnd2:addEventListener("touch")

	restartEnd2 = sheetGame1:newImage("restart_popup_small.png")
	restartEnd2.x = (display.contentWidth / 2) + (2.13 * 67)
	restartEnd2.y = 2.13 * 227
	function restartEnd2:touch(event)
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

			tnt:cancelAllTransitions()
			tnt:cancelAllTimers()

			--local restart = function( obj )
				--storyboard.levelNumber = storyboard.levelNumber	
				storyboard.gotoScene( "scene_loading_level" )
			--end
			--transition.to( loadingLayer, { time=400, alpha=1, onComplete=restart } )

			display.getCurrentStage():setFocus(nil)
		end
	end
	restartEnd2:addEventListener("touch")


	--- dodawanie warstw
	window:insert(endSceneWin)
	window:insert(menuEnd2)
	window:insert(restartEnd2)
	window:insert(playEnd)



	

	window:setReferencePoint( display.CenterReferencePoint )
	window:scale(.4,.9)		
	tnt:newTransition(window,{time=100,xScale=1.05,yScale=.7,transition=easing.inQuad,onComplete=function()
		tnt:newTransition(window,{time=110,xScale=.95,yScale=1.06,transition=easing.inQuad,onComplete=function()
			tnt:newTransition(window,{time=120,xScale=1.02,yScale=.98,transition=easing.inQuad,onComplete=function()
				tnt:newTransition(window,{time=130,xScale=1,yScale=1,transition=easing.inQuad,onComplete=function()
					
				end})
			end})
		end})
	end})

	---- kura HIGH Score
	chickenScore = sheetGame1:newImage("chicken_corner.png")
	chickenScore.x = 870
	chickenScore.y = 760
	chickenScore.alpha = 0

	if display.screenOriginY < -60 then
		chickenScore.y = 820
	end



	group:insert(window)
	group:insert(chickenScore)

	

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
		
	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
	-----------------------------------------------------------------------------
	local params = event.params

	group:insert(storyboard.pausePanel)

	tnt:newTransition(chickenScore,{time=350,x = 576, alpha = 1, transition=easing.inOutQuad,onComplete=function() 
		
	end})

	
	-- zapisz wynik	
	data.saveScore(nil,1,1,3,100)
	

	storyboard.printMemUsage()
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	
	-----------------------------------------------------------------------------
	tnt:cancelAllTransitions()
	tnt:cancelAllTimers()
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