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
local params

local sheetHelper 	= require("scripts.sheet_helper")
--local helpers 		= require("scripts.helpers")
local dataLevels 	= require("scripts.data_levels")
local tnt 			= require("scripts.transitions_manager")
local game 			= require("scripts.game")
local textBitmap 	= require("scripts.text_bitmap")
local data 			= require("scripts.data")

--- sprity
local sheetGame1 = sheetHelper.new("interface")
--local sheetGame2 = sheetHelper.new("game2")

--- elementy gry
local Rock 			= require("elements.rock")
local Pipe 			= require("elements.pipe")
local Reverser 		= require("elements.reverser")
local ReverserHalf 	= require("elements.reverser_half")
local Bumper 		= require("elements.bumper")
local Egg 			= require("elements.egg")
local GoldenEgg 	= require("elements.golden_egg")
local Chicken 		= require("elements.chicken")
local PowerUp 		= require("elements.powerup")
local Switch 		= require("elements.switch")

local boardChicken



local device = system.getInfo("model"):lower()


-----WARSTWY---
local board, boardBack, boardGrass, boardFront, boardBoxes, boardShadow, boardFlat, boardAnimation, boardInfo

local background
local egg
local blocksList

-- interface
local labelTurns
local textTurns
local labelLevel
local levelText
local dim
local groupTurns
local groupLevel

--tutorial elelemnts
local tutorialBumper1
local tutorialBumper2
local isTutorialStep2 = true
local tutorialStart
local tutorialArrow2

-- pausa
local pausePanel
local loadingLayer

--buttony
local pause, play, restart, start

--funkcje
local onEnterFrame


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-----------------------------------------------------------------------------
		
	--	CREATE display objects and add them to 'group' here.
	--	Example use-case: Restore 'group' from previously saved state.
	
	-----------------------------------------------------------------------------
	params = event.params

	game:new()

	function game:increaseTurns()
		self.turns = self.turns + 1
		textTurns:print(self.turns)

		if self.turns == 10 or self.turns == 100 or self.turns == 1000 then
			transition.to( groupTurns, { time=100, x = groupTurns.x - 25 } )
		end
	end

	

	

	-----WARSTWY---
	board = display.newGroup()
	boardBack = display.newGroup()
	boardGrass = display.newGroup() -- efekt na trawie
	boardFlat = display.newGroup() -- elementy plaskie pod cieniem
	boardShadow = display.newGroup()	
	boardFront = display.newGroup()
	boardAnimation = display.newGroup() -- elemnty wysokie ruchome
	boardBoxes = display.newGroup() -- elementy wysokie	
	boardInfo = display.newGroup() -- np bounusy x1 inne teksty	
	

	background = display.newImageRect("images/bg.png",768 , 1363)   --1152
	background.x = display.contentWidth / 2
	background.y = display.contentHeight / 2
	boardBack:insert(background)

	egg = Egg.new(0,0)
	local startX, startY = 384, 137
	egg.x = startX
	egg.y = startY
	

	--------------------------------------
	-- Rysowanie mapy
	--------------------------------------
	local map
	if storyboard.levelNumber == 0 then 
		map = storyboard.map
	else
		storyboard.map = dataLevels.loadMap(storyboard.worldNumber,storyboard.levelNumber)
		map = storyboard.map
	end
	local p = 0
	blocksList = {}

	for i=0,map.height-1 do		
		for j=0,map.width-1 do
			p = p+1
			local x = game.cellSize*j + 44
			local y = game.cellSize*i + 130
			local block = nil

			--test
			--if (map.cells[p] == 99) then
				-- local myRectangle = display.newRect(0, 0, 166/2, 166/2)
				-- myRectangle.strokeWidth = 1
				-- myRectangle.x = x
				-- myRectangle.y = y
				-- myRectangle.alpha = 0

			--- skala
			if (map.cells[p] == 1) then
				block = Rock.new({x=x,y=y})
				block:display()
				boardBoxes:insert(block.display)
				boardShadow:insert(block.shadow)

			--- zlote jajko
			elseif (map.cells[p] == 4) then
				block = GoldenEgg.new({x=x,y=y})
				block:display()
				boardFront:insert(block.display)
				boardInfo:insert(block.displayBonus1)
				boardInfo:insert(block.displayBonus2)
				boardInfo:insert(block.displayBonus3)

			--- powerup strong
			elseif (map.cells[p] == 5) then
				block = PowerUp.new({x=x,y=y})
				block:display()
				boardFront:insert(block.display)

			

			--- siano 
			elseif (map.cells[p] == 10) then
				block = Reverser.new({x=x,y=y,rotation=0, egg=egg})
				block:display()
				boardBoxes:insert(block.display)
				boardShadow:insert(block.shadow)				
			elseif (map.cells[p] == 11) then
				block = Reverser.new({x=x,y=y,rotation=90, egg=egg})	
				block:display()
				boardBoxes:insert(block.display)
				boardShadow:insert(block.shadow)			
			elseif (map.cells[p] == 12) then
				block = Reverser.new({x=x,y=y,rotation=180, egg=egg})
				block:display()
				boardBoxes:insert(block.display)
				boardShadow:insert(block.shadow)				
			elseif (map.cells[p] == 13) then
				block = Reverser.new({x=x,y=y,rotation=270, egg=egg})
				block:display()
				boardBoxes:insert(block.display)
				boardShadow:insert(block.shadow)
			elseif (map.cells[p] == 14) then
				block = ReverserHalf.new({x=x,y=y, egg=egg})	
				block:display()
				boardBoxes:insert(block.display)
				boardShadow:insert(block.shadow)
			
			--- kura	
			elseif (map.cells[p] == 20) then
				boardChicken = Chicken.new(x,y,90, egg)
				block = boardChicken
				block:display()
				boardFront:insert(block.display)
				boardFront:insert(block.myRectangle)	

			--- powerup strong
			elseif (map.cells[p] == 25) then
				block = Switch.new({x=x,y=y})
				block:display()
				boardFlat:insert(block.display)						

			--- zwrotnica
			elseif (map.cells[p] == 30) then
				block = Bumper.new({x=x,y=y,rotation=90})
				block:display()
				boardFlat:insert(block.flat)
				boardShadow:insert(block.displayFront)				
				boardAnimation:insert(block.display)
				
			elseif (map.cells[p] == 31) then
				block = Bumper.new({x=x,y=y,rotation=180})
				block:display()
				boardFlat:insert(block.flat)
				boardShadow:insert(block.displayFront)				
				boardAnimation:insert(block.display)
				-- if tylko 1 level
				--tutorialBumper1 = block
			elseif (map.cells[p] == 32) then
				block = Bumper.new({x=x,y=y,rotation=270})
				block:display()
				boardFlat:insert(block.flat)
				boardShadow:insert(block.displayFront)				
				boardAnimation:insert(block.display)
			elseif (map.cells[p] == 33) then
				block = Bumper.new({x=x,y=y,rotation=0})
				block:display()
				boardFlat:insert(block.flat)
				boardShadow:insert(block.displayFront)				
				boardAnimation:insert(block.display)
			
			elseif (map.cells[p] == 35) then
				block = Bumper.new({x=x,y=y,type="freez",rotation=90})
				block:display()
				boardGrass:insert(block.displayGrass)
				boardFlat:insert(block.flat)
				boardShadow:insert(block.displayFront)				
				boardAnimation:insert(block.display)
			elseif (map.cells[p] == 36) then
				block = Bumper.new({x=x,y=y,type="freez",rotation=180})
				block:display()
				boardGrass:insert(block.displayGrass)
				boardFlat:insert(block.flat)
				boardShadow:insert(block.displayFront)				
				boardAnimation:insert(block.display)
			elseif (map.cells[p] == 37) then
				block = Bumper.new({x=x,y=y,type="freez",rotation=270})
				block:display()
				boardGrass:insert(block.displayGrass)
				boardFlat:insert(block.flat)
				boardShadow:insert(block.displayFront)				
				boardAnimation:insert(block.display)
			elseif (map.cells[p] == 38) then
				block = Bumper.new({x=x,y=y,type="freez",rotation=0})
				block:display()
				boardGrass:insert(block.displayGrass)
				boardFlat:insert(block.flat)
				boardShadow:insert(block.displayFront)				
				boardAnimation:insert(block.display)

			elseif (map.cells[p] == 40) then
				block = Bumper.new({x=x,y=y,type="auto",rotation=90})
				block:display()
				boardFlat:insert(block.flat)
				boardShadow:insert(block.displayFront)				
				boardAnimation:insert(block.display)
			elseif (map.cells[p] == 41) then
				block = Bumper.new({x=x,y=y,type="auto",rotation=180})
				block:display()
				boardFlat:insert(block.flat)
				boardShadow:insert(block.displayFront)				
				boardAnimation:insert(block.display)
			elseif (map.cells[p] == 42) then
				block = Bumper.new({x=x,y=y,type="auto",rotation=270})
				block:display()
				boardFlat:insert(block.flat)
				boardShadow:insert(block.displayFront)				
				boardAnimation:insert(block.display)
			elseif (map.cells[p] == 43) then
				block = Bumper.new({x=x,y=y,type="auto",rotation=0})
				block:display()
				boardFlat:insert(block.flat)
				boardShadow:insert(block.displayFront)				
				boardAnimation:insert(block.display)

			--- rura
			elseif (map.cells[p] == 98) then
				block = Pipe.new({x=x,y=y})	
				block:display()			
				boardFront:insert(block.display)
			elseif (map.cells[p] == 99) then
				block = Pipe.new({x=x,y=y,withLock = true})	
				block:display()			
				boardFront:insert(block.display)
				boardAnimation:insert(block.displayBarrier1)
				boardAnimation:insert(block.displayBarrier2)
				boardBoxes:insert(block.displayDiode)

			end

			-- TUTORIAL
			if storyboard.worldNumber == 1 and storyboard.levelNumber == 1 then
				--print(p .. "-" .. map.cells[p])
				if p == 50 then tutorialBumper1 = block end
				if p == 79 then tutorialBumper2 = block end

			end

			--- dodaj do listy puktow kolizyjnych
			if block ~= nil then				
				if block["isCollision"] then --dodaj do tablicy elemento na planszy
					table.insert(blocksList,block)
				end
			end
			
		end
	end

  	--TODO animacje dodac do grup
  	
  	--boardFront[26]:toFront()

  	-----SKŁADANIE WARSTW
	board:insert(boardBack)
	board:insert(boardGrass)
	board:insert(boardFlat)
	board:insert(boardShadow)	
	board:insert(egg)
	board:insert(boardFront)
	board:insert(boardAnimation)	
	board:insert(boardBoxes)
	board:insert(boardInfo)

	--- test
	-- local animX = function(object)
	-- 	object:scale(1.05,.65)		
	-- 	transition.to(object,{time=100,xScale=.65,yScale=1.05,transition=easing.inOutQuad,onComplete=function()
	-- 		transition.to(object,{time=100,xScale=1.05,yScale=.80, y = object.y - 10,transition=easing.inQuad,onComplete=function()
	-- 			transition.to(object,{time=100,xScale=1,yScale=1, y = object.y - 10,transition=easing.linear,onComplete=function()
	-- 				transition.to(object,{time=700, alpha=0, y = object.y - 70, transition=easing.outQuad,onComplete=function()
	-- 					object:removeSelf()
	-- 					object = nil
	-- 				end})
	-- 			end})
	-- 		end})
	-- 	end})
	-- end

	-- local xBonus = sheetGame1:newImage("x1.png")
	-- xBonus.x = 100
	-- xBonus.y = 100
	-- animX(xBonus)
	-- board:insert(xBonus)
	-- koniec testu

	group:insert(board)

	board.y = -20 + (display.screenOriginY )
	if display.screenOriginY < -60 then
		board:scale(1.12,1.12)
		--board:setReferencePoint(display.CenterTopReferencePoint);
		board.x = -45
		--board.y = 0 + (display.screenOriginY )
	end

	if display.screenOriginY < -100 then
		board:scale(1.04,1.04)
		--board:setReferencePoint(display.CenterTopReferencePoint);
		board.x = -64
		board.y = display.screenOriginY + 0
	end

	

	-------------------------------
	-- liczba odbic
	-------------------------------
	groupTurns = display.newGroup()
	labelTurns = sheetGame1:newImage("turns.png")
	labelTurns.x = 660
	labelTurns.y = display.screenOriginY + 34
	groupTurns:insert(labelTurns)

	textTurns = textBitmap.newText(sheetGame1,"");
	textTurns.x = 740
 	textTurns.y = display.screenOriginY + 36
    textTurns.letterMargin = -5
    textTurns:print("0")
    groupTurns:insert(textTurns)

    group:insert(groupTurns)
    if system.getInfo( "model" ) == "iPhone" then
    	groupTurns:scale(1.25,1.25)
    	groupTurns:setReferencePoint(display.TopLeftReferencePoint);
    	groupTurns.x =  550
    	groupTurns.y =  display.screenOriginY + 6
    	--print('ggg'.. groupTurns.y)
    end

    -------------------------------
	-- level napis
	-------------------------------
	groupLevel = display.newGroup()
    labelLevel = sheetGame1:newImage("level.png")
	labelLevel.x = 70
	labelLevel.y = display.screenOriginY + 34
	--labelLevel:scale(1.3, 1.3)
	groupLevel:insert(labelLevel)


	levelText = textBitmap.newText(sheetGame1, "");
	levelText.x = 145
    levelText.y = display.screenOriginY + 36
    levelText.letterMargin = -5
    levelText:print(storyboard.levelNumber)
    groupLevel:insert(levelText)

    group:insert(groupLevel)
    if system.getInfo( "model" ) == "iPhone" then
    	groupLevel:scale(1.25,1.25)
    	groupLevel:setReferencePoint(display.TopLeftReferencePoint);
    	groupLevel.x = 10
    	groupLevel.y = display.screenOriginY + 2
    end

    --------------------------------
    --- wyciemnienie
    ---------------------------------
	dim = display.newRect(0, 0, display.contentWidth, display.contentHeight)
	dim:setFillColor(0, 0, 0)
	dim.alpha = 0
	function dim:touch(event)
		return true
	end
	dim:addEventListener("touch")
	board:insert(dim)

	-------------------------------------
	--- ############ kura HIGH Score ##########
	-------------------------------------
	-- chickenScore = sheetGame1:newImage("chicken_corner.png")
	-- chickenScore.x = 835
	-- chickenScore.y = 580
	-- group:insert(chickenScore)
	--storyboard.groupHighScore = display.newGroup()
	--group:insert(storyboard.groupHighScore)

	-------------------------------------
	--- ############ MENU ON PAUSE ##########
	-------------------------------------
	pausePanel = display.newGroup()
	pausePanel.startY = - display.screenOriginY -20
	pausePanel.endY = pausePanel.startY - 334
	pausePanel.y = pausePanel.startY
	storyboard.pausePanel = pausePanel -- trawa na topiw w popupach

	if display.screenOriginY < -100 then
		pausePanel.startY = - display.screenOriginY -130
		pausePanel.endY = pausePanel.startY - 227
		pausePanel.y = pausePanel.startY
	end

	-- zienia ---------------------
	local grass = sheetGame1:newImage("grass.png")	
	grass.x = display.contentWidth /2
	grass.y = display.contentHeight  + 130	
	pausePanel:insert(grass)

	
	--print("board panel".. board.y)
	--print("pause panel".. grass.y)

	-- dzwieki
	local soundOff = sheetGame1:newImage("sound_off.png")
	local soundOn = sheetGame1:newImage("sound_on.png")

	soundOff.x = display.contentWidth / 100 * 28
	soundOff.y = display.contentHeight / 100 * 123	

	soundOn.x = display.contentWidth / 100 * 28
	soundOn.y = display.contentHeight / 100 * 123
	

	function soundOff:touch(event)
		if event.phase == "began" then
			audio.play(game.audio.s2)
			self.alpha = .5
			self:scale( .9, .9 )
			display.getCurrentStage():setFocus(event.target)
		elseif event.phase == "ended" then
			self.isVisible = false
			self.alpha = 1
			self.xScale = 1
			self.yScale = 1			

			audio.setVolume( 1, { channel=2 } )		    
		    audio.play(game.audio.s5, { channel=2, loops=-1, fadein=100 } )

			storyboard.settings.music = 1
			data.saveSettings(storyboard.settings)
			
			soundOn.isVisible = true
			display.getCurrentStage():setFocus(nil)
		end
	end
	soundOff:addEventListener("touch")	

	
	function soundOn:touch(event)
		if event.phase == "began" then
			audio.play(game.audio.s2)
			self.alpha = .5
			self:scale( .9, .9 )
			display.getCurrentStage():setFocus(event.target)
		elseif event.phase == "ended" then
			self.isVisible = false
			self.alpha = 1
			self.xScale = 1
			self.yScale = 1

			audio.fadeOut({ channel=2, time=100 } )
			
			storyboard.settings.music = 0
			data.saveSettings(storyboard.settings)
					
			soundOff.isVisible = true
			display.getCurrentStage():setFocus(nil)
		end
	end
	soundOn:addEventListener("touch")

	pausePanel:insert(soundOff)
	pausePanel:insert(soundOn)

	if storyboard.settings.music == 0 then
		soundOn.isVisible = false
	else
		soundOff.isVisible = false
	end


	--menu
	local menu = sheetGame1:newImage("menu.png")
	menu.x = display.contentWidth / 100 * 50
	menu.y = display.contentHeight / 100 * 123

	function menu:touch(event)
		if event.phase == "began" then
			audio.play(game.audio.s2)
			self.alpha = .5
			self:scale( .95, .95 )
			display.getCurrentStage():setFocus(event.target)
		elseif event.phase == "ended" then
			self.alpha = 1
			self:scale( 1, 1 )

			-- przejscie do menu
			transition.to( loadingLayer, { time=200, alpha=1, onComplete=function( obj )
				timer.performWithDelay( 10, function() 
					storyboard.gotoScene( "scene_menu" )		
				end)
			end } )

			display.getCurrentStage():setFocus(nil)
			self:removeEventListener("touch")
		end
	end
	menu:addEventListener("touch")

	pausePanel:insert(menu)

	--repeat
	local repeatMap = sheetGame1:newImage("repeat.png")
	repeatMap.x = display.contentWidth / 100 * 72
	repeatMap.y = display.contentHeight / 100 * 123

	function repeatMap:touch(event)
		if event.phase == "began" then
			audio.play(game.audio.s2)
			self.alpha = .5
			self:scale( .9, .9 )
			display.getCurrentStage():setFocus(event.target)
		elseif(event.phase == "ended") then
			
			self.alpha = 1
			self.xScale = 1
			self.yScale = 1

			audio.stop()
			tnt:cancelAllTransitions()
			tnt:cancelAllTimers()

			game.eggOnMove = false			
			transition.to( loadingLayer, { time=200, alpha=1, onComplete=function( obj )
				storyboard.gotoScene( "scene_loading_level" )
			end } )

			display.getCurrentStage():setFocus(nil)
			self:removeEventListener("touch")
		end
	end
	repeatMap:addEventListener("touch")
	pausePanel:insert(repeatMap)


    group:insert(pausePanel)

    -------################# START  ###############################ee
	start = sheetGame1:newImage("start.png")
	start.x = display.contentWidth/2
	start.y = 990 --55

	if display.screenOriginY < -100 then
		start.y = 1008
	end

	start.yStart = start.y

	function game:start()
		start:removeEventListener("touch")
		start.y = start.yStart
		transition.to( start, { time=100, alpha = 0, y = start.yStart+30} )		
	end

	function start:touch(event)
		if event.phase == "began" then

			audio.play(game.audio.s2)
			--self.alpha = .5
			self:scale( 1.2, 1.2 )
			display.getCurrentStage():setFocus(event.target)
		elseif(event.phase == "ended") then
			self.isHitTestable = false
			transition.to( self, { time=100, alpha = 0, xScale = 1, yScale = 1 } )		

			if dim.isHitTestable == true then
				dim.alpha = 0
				dim.isHitTestable = false
				display.remove(tutorialArrow2)
				display.remove(tutorialStart)						
			end

			boardChicken.startEgg()

			display.getCurrentStage():setFocus(nil)
			self:removeEventListener("touch")
		end
	end
	start:addEventListener("touch")

	pausePanel:insert(start)


    -------################# RESTART  ###############################ee
	restart = sheetGame1:newImage("restart.png")
	restart.x = (display.contentWidth - 55)
	restart.y = 990

	if display.screenOriginY < -60 then
    	restart:scale(1.25,1.25)   	
    end

    if display.screenOriginY < -100 then
		restart.y = 1008
	end

	function restart:touch(event)
		if event.phase == "began" then
			audio.play(game.audio.s2)
			self.alpha = .5
			--self:scale( .9, .9 )
			display.getCurrentStage():setFocus(event.target)
		elseif(event.phase == "ended") then
			
			self.alpha = 1
			--self.xScale = 1
			--self.yScale = 1

			audio.stop()
			tnt:cancelAllTransitions()
			tnt:cancelAllTimers()

			game.eggOnMove = false
			transition.to( loadingLayer, { time=200, alpha=1, onComplete=function( obj )				
				storyboard.gotoScene( "scene_loading_level" )
			end } )

			display.getCurrentStage():setFocus(nil)
			self:removeEventListener("touch")
		end
	end
	restart:addEventListener("touch")

	pausePanel:insert(restart)


	------- ############# PAUSA /PLAY ############################
	pause = sheetGame1:newImage("pause.png")
	pause.x = 55
	pause.y = 990	

	play = sheetGame1:newImage("play.png")
	play.x = 55
	play.y = 990	
	play.isVisible = false

	if display.screenOriginY < -60 then
    	pause:scale(1.25,1.25)    	
    	play:scale(1.25,1.25)    	
    end

     if display.screenOriginY < -100 then
		pause.y = 1008
		play.y = 1008
	end

	pause.starY = pause.y
	play.starY = play.y

	function pause:touch(event)
		if event.phase == "began" then
			audio.play(game.audio.s2)
			self.alpha = .5
			--self:scale( .9, .9 )
			display.getCurrentStage():setFocus(event.target)
		elseif event.phase == "ended" then
			
			self.isVisible = false
			--self.xScale = 1
			--self.yScale = 1

			play.alpha = 1			
			play.isVisible = true

			dim:addEventListener("touch")

			boardChicken:pause()			
			tnt:pauseAllTransitions()
			tnt:pauseAllTimers()

			
			game.status = "pause"

			transition.to( pause, { time=250, y = 1030 } )
			transition.to( play, { time=250, y = 1030 } )

			--if game.status == "ready" then
				transition.to( start, { time=250, alpha=0 } )
			--end

			transition.to( dim, { time=250, alpha=0.7 } )
			transition.to( board, { time=250, y = board.y - 120 } ) 
			transition.to( pausePanel, { time=250, y = pausePanel.endY} )
			transition.to( restart, { time=250, alpha = 0 } )
			display.getCurrentStage():setFocus(nil)
		end

		return true
	end

	function play:touch(event)
		if event.phase == "began" then
			audio.play(game.audio.s2)
			self.alpha = .5
			--self:scale( .9, .9 )
			display.getCurrentStage():setFocus(event.target)
		elseif event.phase == "ended" then
			
			self.isVisible = false
			--self.xScale = 1
			--self.yScale = 1

			pause.alpha = 1			
			pause.isVisible = true

			boardChicken:continue()
			tnt:resumeAllTransitions()
			tnt:resumeAllTimers()

			game.status = "play"

			transition.to( pause, { time=250, y = pause.starY } )
			transition.to( play, { time=250, y = play.starY } )

			if game.eggOnMove == false then
				transition.to( start, { time=250, alpha=1 } )
			end

			transition.to( dim, { time=250, alpha=0 } )
			transition.to( board, { time=250, y = board.y + 120 } ) 
			--transition.to( pausePanel, { time=250, y = 0, onComplete=function() game.status = "play" end } )
			transition.to( pausePanel, { time=250, y = pausePanel.startY  } )
			transition.to( restart, { time=250, alpha = 1 } )
			display.getCurrentStage():setFocus(nil)
		end

		return true
	end

	pause:addEventListener("touch")
	play:addEventListener("touch")

	pausePanel:insert(pause)
	pausePanel:insert(play)

	--########### zablokuj i schowaj kontrolki
	function game:disableButtons()
		display.getCurrentStage():setFocus(nil)
		restart:removeEventListener("touch")
		pause:removeEventListener("touch")
		play:removeEventListener("touch")
	end

	--##############  konstruktor
	if storyboard.levelNumber == 0 then
		local constructor = sheetGame1:newImage("constructor.png")
		constructor.x = 45
		constructor.y = 640
		function constructor:tap(event)		
			storyboard.gotoScene( "scene_constructor" )
		end
		constructor:addEventListener("tap")	
		group:insert(constructor)
	end

	--############### warstwa loading
	loadingLayer = display.newRect(0, 0, display.contentWidth, 1363)
	loadingLayer.y = display.contentHeight / 2
	loadingLayer:setFillColor(0, 0, 0)
	loadingLayer.alpha = 1
	group:insert(loadingLayer)
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
		
	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
	-----------------------------------------------------------------------------
	storyboard.analytics.logEvent( "EnterScene_Game_W"..storyboard.worldNumber.."_L"..storyboard.levelNumber )

	--storyboard.removeScene( "scene_levels" )
	storyboard.removeScene( "scene_loading_level" )
	--storyboard.removeScene( "scene_constructor" )
	storyboard.printMemUsage()

	--print(#game.bumperTimers)
	-- timer.performWithDelay( 2090, function()
	-- 	game.status = "play"
	-- 	game.eggOnMove = true
	-- end, 1)

	-- rozjasnienie ekranu
	transition.to( loadingLayer, { time=200, alpha=0 } )

	-- test
	--################ load music
	if storyboard.settings.music == 1 then	
		audio.setVolume( 1, { channel=2 } )		

		local function playBackgroundSound(event)		    
		    if event.completed then		        
		        if game ~= nil then	    
				    audio.play(game.audio.s5, { channel=2, loops=-1 } )
			   	end		   
		    end
		end 
		audio.play(game.audio.s4, { channel=2, loops=0, fadein=200, onComplete=playBackgroundSound } )
	end
	
	--############### Dla każdej klatki
	onEnterFrame = function(event)

		if game.status == "play" then		
			if game.eggOnMove then
				
				egg:calculatePosition()		

				--TUTORIAL 2
				if storyboard.worldNumber == 1 and storyboard.levelNumber == 1 then
					if egg.x == 484 and egg.y ==555 and isTutorialStep2 == true then
						isTutorialStep2 = false
						game.status = "pause"						
						pause.alpha = 0
						restart.alpha = 0
						dim.isHitTestable = true

						--zwrotnica nad dima
						tutorialBumper2.display:removeEventListener("touch") 
						board:insert(tutorialBumper2.flat)
						board:insert(tutorialBumper2.displayFront)				
						board:insert(tutorialBumper2.display)

						--wyciemnienie
						transition.to( dim, { time=250, delay=0, alpha=0.75, onComplete = function() 

							local tutorialRotate = sheetGame1:newImage("tutorial_tap_to_rotate.png")
							tutorialRotate.x = 540
							tutorialRotate.y = 470	
							board:insert(tutorialRotate)

							local tutorialArrow = sheetGame1:newImage("tutorial_arrow.png")
							tutorialArrow.x = 540
							tutorialArrow.y = 600	
							board:insert(tutorialArrow)

							local tutorialRing = sheetGame1:newImage("tutorial_ring.png")
							tutorialRing.x = tutorialBumper2.x
							tutorialRing.y = tutorialBumper2.y	
							board:insert(tutorialRing)

							local tapArea = display.newRect(0, 0, 85, 85)
							tapArea.alpha = 0	
							tapArea.isHitTestable = true 		
							tapArea.x=tutorialBumper2.x
							tapArea.y=tutorialBumper2.y				
							tapArea:addEventListener("touch", function() 
								--schowaj zwrotnice
								timer.performWithDelay( 100, function() 
									boardFlat:insert(tutorialBumper2.flat)
									boardShadow:insert(tutorialBumper2.displayFront)				
									boardAnimation:insert(tutorialBumper2.display) 
									display.remove(tapArea)
									--pokaz start									
									pause.alpha = 1
									restart.alpha = 1

									display.remove(tutorialRotate)
									display.remove(tutorialArrow)
									display.remove(tutorialRing)

									--schwaj dima
									dim.isHitTestable = false
									dim.alpha = 0
									--rusz jajko
									game.status = "play"

								end )
							end )
							board:insert(tapArea)
							tutorialBumper2.display:addEventListener("touch")
						end } )

					end	
				end

				--sprawdz czy jest kolizja
				for k, block in pairs (blocksList) do					
						block:isCollision(egg)					
				end
					
			end
		elseif game.status == "restart" then
			game.status = "ready"
			
			start.y = start.yStart + 30
			transition.to( start, { time=100, alpha = 1, y = start.yStart } )		
			start:addEventListener("touch")

		elseif game.status == "win" then
			game.status = "ready"
			
			tnt:cancelAllTransitions()
			tnt:cancelAllTimers()

			transition.to( start, { time=150,alpha=0  } )
			transition.to( pause, { time=150,alpha=0  } )
			transition.to( restart, { time=150,alpha=0  } )
			transition.to( dim, { time=250, delay=400, alpha=0.75 } )
			
			local sceneName = "scene_game_win"
			if storyboard.worldNumber == 1 and storyboard.levelNumber == 1 then
				sceneName = "scene_game_tutorial"
			end
			
			timer.performWithDelay( 300, 
				function ()
				    storyboard.showOverlay( sceneName, 
					    {
					        effect = "fade",
					        time = 250			        
					    } 
					)
			    end 
			)

		elseif game.status == "lost" then		
			game.status = "ready"
			
			tnt:cancelAllTransitions()
			tnt:cancelAllTimers()

		    local function loadScene( event )
			    local options =
			    {
			        effect = "fade",
			        time = 250
			    }
			    storyboard.showOverlay( "scene_game_lost", options )
			end
			timer.performWithDelay( 300, loadScene )
			

			transition.to( start, { time=150,alpha=0  } )
			transition.to( pause, { time=150,alpha=0  } )
			transition.to( restart, { time=150,alpha=0  } )
			transition.to( dim, { time=250, delay=400, alpha=0.75 } )			
		end
		
	end
	Runtime:addEventListener( "enterFrame", onEnterFrame );

	--TUTORIAL
	if storyboard.worldNumber == 1 then
		if storyboard.levelNumber == 1 then
			start.alpha = 0
			pause.alpha = 0
			restart.alpha = 0
			dim.isHitTestable = true 

			--zwrotnica nad dima
			tutorialBumper1.display:removeEventListener("touch") 
			board:insert(tutorialBumper1.flat)
			board:insert(tutorialBumper1.displayFront)				
			board:insert(tutorialBumper1.display)

			--wyciemnienie
			transition.to( dim, { time=250, delay=800, alpha=0.75, onComplete = function() 
				
				local tutorialRotate = sheetGame1:newImage("tutorial_tap_to_rotate.png")
				tutorialRotate.x = 510
				tutorialRotate.y = 260	
				board:insert(tutorialRotate)

				local tutorialArrow = sheetGame1:newImage("tutorial_arrow.png")
				tutorialArrow.x = 374
				tutorialArrow.y = 340	
				board:insert(tutorialArrow)

				local tutorialRing = sheetGame1:newImage("tutorial_ring.png")
				tutorialRing.x = tutorialBumper1.x
				tutorialRing.y = tutorialBumper1.y	
				board:insert(tutorialRing)

				tutorialStart = sheetGame1:newImage("tutorial_tap_to_start.png")
				tutorialStart.x = 525
				tutorialStart.y = 740	
				tutorialStart.alpha = 0
				board:insert(tutorialStart)

				tutorialArrow2 = sheetGame1:newImage("tutorial_arrow.png")
				tutorialArrow2.x = 388
				tutorialArrow2.y = 840	
				tutorialArrow2.alpha = 0
				board:insert(tutorialArrow2)

				local tapArea = display.newRect(0, 0, 85, 85)
				tapArea.alpha = 0	
				tapArea.isHitTestable = true 		
				tapArea.x=tutorialBumper1.x
				tapArea.y=tutorialBumper1.y				
				tapArea:addEventListener("touch", function() 
					--schowaj zwrotnice
					timer.performWithDelay( 100, function() 
						boardFlat:insert(tutorialBumper1.flat)
						boardShadow:insert(tutorialBumper1.displayFront)				
						boardAnimation:insert(tutorialBumper1.display) 
						
						--pokaz start
						start.alpha = 1
						pause.alpha = 1
						restart.alpha = 1

						display.remove(tutorialRotate)
						display.remove(tutorialArrow)
						display.remove(tutorialRing)						

						display.remove(tapArea)

						tutorialStart.alpha = 1
						tutorialArrow2.alpha = 1
					end )
				end )
				board:insert(tapArea)
				tutorialBumper1.display:addEventListener("touch")
			end } )

		end
	end


	--- Ekran z pomocą pokaż POPUP
	if storyboard.worldNumber == 1 then
		--if storyboard.levelNumber == 1 
			if storyboard.levelNumber == 16
			or storyboard.levelNumber == 35
			then
			dim.isHitTestable = true    
			timer.performWithDelay( 300, function( event )
			    local options =
			    {
			        effect = "fade",
			        time = 250
			    }
			    storyboard.showOverlay( "scene_game_howto", options )
			end )
			start.alpha = 0
			pause.alpha = 0
			restart.alpha = 0
			
			-- transition.to( start, { time=150,alpha=0  } )
			-- transition.to( pause, { time=150,alpha=0  } )
			-- transition.to( restart, { time=150,alpha=0  } )
			transition.to( dim, { time=250, delay=400, alpha=0.75 } )
		end
	end

	 -- timer.performWithDelay( 1500, function( event )
	 -- 	game.status = "win"
	 -- end )
	

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	
	-----------------------------------------------------------------------------
	Runtime:removeEventListener( "enterFrame", onEnterFrame );

	audio.fadeOut({ channel=2, time=50 } )
	audio.stop()
	tnt:cancelAllTransitions()
	tnt:cancelAllTimers()
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)
	
	-----------------------------------------------------------------------------
	--audio.dispose( storyboard.audio.s18 )
	--storyboard.audio.s18 = nil
	background:removeSelf()
	background = nil
	game:freeMemory()
	game = nil
	sheetGame1:dispose()
end

-- the following event is dispatched once the overlay is in place
function scene:overlayBegan( event )
    --print( "Showing overlay: " .. event.sceneName )
end

-- the following event is dispatched once overlay is removed
function scene:overlayEnded( event )
    --print( "Overlay removed: " .. event.sceneName )

    transition.to( dim, { time=150, alpha=0 } )
    transition.to( start, { time=150,alpha=1  } )
    transition.to( pause, { time=150,alpha=1  } )
	transition.to( restart, { time=150,alpha=1  } )
	dim.isHitTestable = false
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

scene:addEventListener( "overlayBegan" )
scene:addEventListener( "overlayEnded" )

---------------------------------------------------------------------------------

return scene