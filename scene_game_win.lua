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
	

	-- obliczanie wyniku
	scoreEggs = game.bonus*100
	scoreTurns = (storyboard.map.turns * 2) - game.turns
	if scoreTurns < 0 then scoreTurns = 0 end
	totalScore = scoreEggs + scoreTurns

	-- rekord
	isRecord = false
	highScore = 0 
	local levelScore = data.loadScore(storyboard.worldNumber,storyboard.levelNumber)
	if levelScore == nil or levelScore.highscore == nil then 
		highScore = totalScore
		jingelChanel = audio.play(game.audio.s21)
	elseif levelScore.highscore < totalScore then
		highScore = totalScore
		isRecord = true
		jingelChanel = audio.play(game.audio.s21)
	else
		highScore = levelScore.highscore
		jingelChanel = audio.play(game.audio.s19)
	end
	-- koniec oblliczania wyniku

	--audio.play(game.audio.s21)
	

	----
	endSceneWin = display.newImageRect("images/bg_win.png",768,696)
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

	--bitmapy
	turnsPointsText = textBitmap.newText(sheetGame1, "white_")
	turnsPointsText.x = 574
    turnsPointsText.y = 212
    turnsPointsText.xScale = .75
    turnsPointsText.yScale = .75
    turnsPointsText:printRight(scoreTurns)    

    eggPointsText = textBitmap.newText(sheetGame1, "white_")
	eggPointsText.x = 574
    eggPointsText.y = 269
    eggPointsText.xScale = .75
    eggPointsText.yScale = .75
    eggPointsText:printRight(scoreEggs)

    eggCountText = textBitmap.newText(sheetGame1, "yellow_")
	eggCountText.x = 183
    eggCountText.y = 268
    eggCountText.xScale = .75
    eggCountText.yScale = .75
    eggCountText:print(game.bonus)

	totalText = textBitmap.newText(sheetGame1, "yellow_")
	totalText.x = 582
    totalText.y = 350
    totalText:printRight("0")

    turnsCountText = textBitmap.newText(sheetGame1, "yellow_")
	turnsCountText.x = 290
    turnsCountText.y = 212
    turnsCountText.xScale = .66
    turnsCountText.yScale = .66
    turnsCountText:print(game.turns)

    turnsMaxText = textBitmap.newText(sheetGame1, "white_")
	turnsMaxText.x = turnsCountText.x + turnsCountText.widthFix / 1.45
    turnsMaxText.y = 212
    turnsMaxText.xScale = .66
    turnsMaxText.yScale = .66
    turnsMaxText:print("#"..storyboard.map.turns)
    
	--- jakjo z gwiazdami
	groupEgg = display.newGroup()
	groupEgg.alpha = 0	
	groupEgg.y = -38

	if display.screenOriginY < -60 then
		groupEgg.y = 15
	end

	-- jajko
	eggStars = sheetGame1:newImage("egg_stars.png")
	eggStars.x = 410
	eggStars.y = 890
	eggStars:scale(0.9,0.9)
	groupEgg:insert(eggStars)

	------ gwiazdy
	star1 = helpers.imageFromSheet(sheetGame1,"star.png")
	star1.x = 403
	star1.y = 830
	star1.rotation = 12
	star1.alpha = .5
	star1.isBonus = false
	groupEgg:insert(star1)

	star2 = helpers.imageFromSheet(sheetGame1,"star.png")
	star2.xScale, star2.yScale = .85, .85
	star2.rotation = 0
	star2.x = 352
	star2.y = 880
	star2.alpha = .5
	star2.isBonus = false
	groupEgg:insert(star2)

	star3 = helpers.imageFromSheet(sheetGame1,"star.png")
	star3.xScale, star3.yScale = .65, .65
	star3.rotation = 22
	star3.x = 404
	star3.y = 905
	star3.alpha = .5
	star3.isBonus = false
	groupEgg:insert(star3)

	-- loadingLayer = display.newRect(0, 0, display.contentWidth, display.contentHeight)
	-- loadingLayer:setFillColor(0, 0, 0)
	-- loadingLayer.alpha = 0

	--- dodawanie warstw
	window:insert(endSceneWin)
	window:insert(menuEnd2)
	window:insert(restartEnd2)
	window:insert(playEnd)

	window:insert(totalText)
	window:insert(turnsCountText)
	window:insert(turnsPointsText)
	window:insert(eggPointsText)
	window:insert(eggCountText)
	window:insert(turnsMaxText)

	

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

	

	------ rekord
	plateHighScore = sheetGame1:newImage("plate_hs.png")
	plateHighScore.x = 130
	plateHighScore.y = 657		
	groupHighScore:insert(plateHighScore)

    highScoreText = textBitmap.newText(sheetGame1, "yellow_")
	highScoreText.x = 135
    highScoreText.y = 630
    highScoreText.xScale = .85
    highScoreText.yScale = .85
    highScoreText:printCenter(highScore)    
    highScoreText:rotate( 10 )
    groupHighScore:insert(highScoreText)
    groupHighScore.y = 400
    groupHighScore.alpha = 0

    if display.screenOriginY < -60 then
		groupHighScore.y = 470
	end

	group:insert(window)
	group:insert(chickenScore)
	group:insert(groupEgg)
	group:insert(groupHighScore)
	
	--group:insert(loadingLayer)

	

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
		audio.play(game.audio.s13)
		tnt:newTransition(groupHighScore,{time=250,y = groupHighScore.y -200,alpha=1,transition=easing.inOutQuad,onComplete=function() 
			
			if isRecord then 
				tnt:newTransition(highScoreText,{time=250,xScale=2.5,yScale=2.5,rotation=0,transition=easing.inOutQuad,onComplete=function() 
					tnt:newTransition(highScoreText,{time=250,xScale=.85,yScale=.85,rotation=10,transition=easing.inOutQuad,onComplete=function() 
						
					end})	
				end})
			end

		end})
	end})

	local animStar = function(star, scaleFactor)
		star:scale(.0,.0)		
		tnt:newTransition(star,{time=100,xScale=.45*scaleFactor,yScale=.75*scaleFactor,alpha=1,transition=easing.inQuad,onComplete=function()
			tnt:newTransition(star,{time=100,xScale=1.25*scaleFactor,yScale=.70*scaleFactor,transition=easing.inQuad,onComplete=function()
				tnt:newTransition(star,{time=100,xScale=.80*scaleFactor,yScale=1.20*scaleFactor,transition=easing.inQuad,onComplete=function()
					tnt:newTransition(star,{time=100,xScale=1*scaleFactor,yScale=1*scaleFactor,transition=easing.inQuad,onComplete=function()
						
					end})
				end})
			end})
		end})
	end


	--test
	--game.bonus =0
	--totalScore = 301

	--ustaw predkosc zliczania punktów
	local speedFactor = math.ceil(totalScore/36)

	local score = 0	

	local totalCycles = math.floor(totalScore/speedFactor) 
	local curentCycle = 0

	local function listener( event )
		curentCycle = curentCycle + 1

		if curentCycle == totalCycles then
			score = totalScore
		end

		totalText:printRight(score)

	    --animacja gwiazd
	    if score >= storyboard.map.stars[1] and star1.isBonus ~= true then
	    	star1.isBonus = true
	    	star1.alpha = 1
	    	animStar(star1,1)
	    	audio.play(game.audio.s23)
	    elseif score >= storyboard.map.stars[2] and star2.isBonus ~= true then
	    	star2.isBonus = true
	    	star2.alpha = 1
	    	animStar(star2,.85)
	    	audio.play(game.audio.s23)
	    elseif score >= storyboard.map.stars[3] and star3.isBonus ~= true then
	    	star3.isBonus = true
	    	star3.alpha = 1
	    	animStar(star3,.65)
	    	audio.play(game.audio.s23)
	    end

	    if math.fmod(curentCycle, 2) == 0 then
		    audio.play(game.audio.s22)
		end		

		score = score + 1*speedFactor
	end

	transition.to(groupEgg, {time=200,alpha = 1,onComplete=function()
		tnt:newTimer( 30, listener, totalCycles)
	end })
	

	-- zapisz wynik	
	if storyboard.levelNumber > 0 then
		local stars = 0
		if highScore >= storyboard.map.stars[1] then stars = 1 end
	    if highScore >= storyboard.map.stars[2] then stars = 2 end
	    if highScore >= storyboard.map.stars[3] then stars = 3 end

		data.saveScore(nil,storyboard.worldNumber,storyboard.levelNumber,stars,highScore)
	end

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