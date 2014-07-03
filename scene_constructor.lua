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
local sheetHelper 	= require("scripts.sheet_helper")
local helpers 		= require("scripts.helpers")
local dataLevels 	= require("scripts.data_levels")
local tnt 			= require("scripts.transitions_manager")
local gameState 	= require("scripts.game")
local textBitmap 	= require("scripts.text_bitmap")
local data 			= require("scripts.data")
local ftp 			= require("scripts.ftp")

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

local device = system.getInfo("model"):lower()

-----WARSTWY---
local board, boardBack, boardGrass, boardFront, boardBoxes, boardShadow, boardFlat, boardAnimation

local boardConstructor
local layerElements

local background
local boardChicken
local egg
local map
local elementID


local clearBoard = function()	
	for j = 1, boardGrass.numChildren do boardGrass[1]:removeSelf(); end
	for j = 1, boardFlat.numChildren do boardFlat[1]:removeSelf(); end
	for j = 1, boardShadow.numChildren do boardShadow[1]:removeSelf(); end
	for j = 1, boardFront.numChildren do boardFront[1]:removeSelf(); end
	for j = 1, boardAnimation.numChildren do boardAnimation[1]:removeSelf(); end
	for j = 1, boardBoxes.numChildren do boardBoxes[1]:removeSelf(); end
	for j = 1, boardConstructor.numChildren do boardConstructor[1]:removeSelf(); end
end

local defaulBoard = function()
	return {
		  width = 10, 
		  height = 9,
		  turns = 10,
		  stars = { 0,201,301 },
		  cells = { 10,13,00,13,00,13,00,13,00,10,
		            00,00,00,00,00,00,00,00,00,00,
		            10,00,00,00,00,00,00,00,00,10,
		            00,00,00,00,00,00,00,00,00,00,
		            20,00,00,00,00,00,00,00,00,98,
		            10,00,00,00,00,00,00,00,00,10,
		            00,00,00,00,00,00,00,00,00,00,
		            10,00,00,00,00,00,00,00,00,10,
		            00,13,00,13,00,13,00,13,00,00, }
		}
end


drawBoard = function() 
	--------------------------------------
	-- Rysowanie mapy
	--------------------------------------
	local p = 0
	blocksList = {}

	for i=0,map.height-1 do		
		for j=0,map.width-1 do
			p = p+1
			local x = gameState.cellSize*j + 130
			local y = gameState.cellSize*i + 44
			local block = nil

			--test
			--if (map.cells[p] == 99) then
			local constructorBlock = display.newRect(0, 0, 166/2, 166/2)
			constructorBlock.strokeWidth = 1
			constructorBlock.x = x
			constructorBlock.y = y
			constructorBlock.alpha = 0
			constructorBlock.isHitTestable = true
			constructorBlock.cellIndex = p

			function constructorBlock:tap( event )
			    print( self.cellIndex )
			    map.cells[self.cellIndex] = elementID
			    clearBoard()
			    drawBoard()
			    return true
			end
			constructorBlock:addEventListener( "tap" )
			constructorBlock:addEventListener("touch", function() return true end)
			boardConstructor:insert(constructorBlock)

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
				boardChicken = Chicken.new(x,y,0, egg)
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
				block = Bumper.new({x=x,y=y})
				block:display()
				boardFlat:insert(block.flat)
				boardShadow:insert(block.displayFront)				
				boardAnimation:insert(block.display)
				
			elseif (map.cells[p] == 31) then
				block = Bumper.new({x=x,y=y,rotation=90})
				block:display()
				boardFlat:insert(block.flat)
				boardShadow:insert(block.displayFront)				
				boardAnimation:insert(block.display)
			elseif (map.cells[p] == 32) then
				block = Bumper.new({x=x,y=y,rotation=180})
				block:display()
				boardFlat:insert(block.flat)
				boardShadow:insert(block.displayFront)				
				boardAnimation:insert(block.display)
			elseif (map.cells[p] == 33) then
				block = Bumper.new({x=x,y=y,rotation=270})
				block:display()
				boardFlat:insert(block.flat)
				boardShadow:insert(block.displayFront)				
				boardAnimation:insert(block.display)
			
			elseif (map.cells[p] == 35) then
				block = Bumper.new({x=x,y=y,type="freez"})
				block:display()
				boardGrass:insert(block.displayGrass)
				boardFlat:insert(block.flat)
				boardShadow:insert(block.displayFront)				
				boardAnimation:insert(block.display)
			elseif (map.cells[p] == 36) then
				block = Bumper.new({x=x,y=y,type="freez",rotation=90})
				block:display()
				boardGrass:insert(block.displayGrass)
				boardFlat:insert(block.flat)
				boardShadow:insert(block.displayFront)				
				boardAnimation:insert(block.display)
			elseif (map.cells[p] == 37) then
				block = Bumper.new({x=x,y=y,type="freez",rotation=180})
				block:display()
				boardGrass:insert(block.displayGrass)
				boardFlat:insert(block.flat)
				boardShadow:insert(block.displayFront)				
				boardAnimation:insert(block.display)
			elseif (map.cells[p] == 38) then
				block = Bumper.new({x=x,y=y,type="freez",rotation=270})
				block:display()
				boardGrass:insert(block.displayGrass)
				boardFlat:insert(block.flat)
				boardShadow:insert(block.displayFront)				
				boardAnimation:insert(block.display)

			elseif (map.cells[p] == 40) then
				block = Bumper.new({x=x,y=y,type="auto"})
				block:display()
				boardFlat:insert(block.flat)
				boardShadow:insert(block.displayFront)				
				boardAnimation:insert(block.display)
			elseif (map.cells[p] == 41) then
				block = Bumper.new({x=x,y=y,type="auto",rotation=90})
				block:display()
				boardFlat:insert(block.flat)
				boardShadow:insert(block.displayFront)				
				boardAnimation:insert(block.display)
			elseif (map.cells[p] == 42) then
				block = Bumper.new({x=x,y=y,type="auto",rotation=180})
				block:display()
				boardFlat:insert(block.flat)
				boardShadow:insert(block.displayFront)				
				boardAnimation:insert(block.display)
			elseif (map.cells[p] == 43) then
				block = Bumper.new({x=x,y=y,type="auto",rotation=270})
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
						
		end
	end

	tnt:pauseAllTimers()
	tnt:pauseAllTransitions()
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-----------------------------------------------------------------------------
		
	--	CREATE display objects and add them to 'group' here.
	--	Example use-case: Restore 'group' from previously saved state.
	
	-----------------------------------------------------------------------------
	boardConstructor = display.newGroup()	

	-----WARSTWY--- ***
	board = display.newGroup()
	boardBack = display.newGroup()
	boardGrass = display.newGroup() -- efekt na trawie
	boardFlat = display.newGroup() -- elementy plaskie pod cieniem
	boardShadow = display.newGroup()	
	boardFront = display.newGroup()
	boardAnimation = display.newGroup() -- elemnty wysokie ruchome
	boardBoxes = display.newGroup() -- elementy wysokie
	
	background = display.newImageRect("images/bg.png",1024, 768)
	background.x = display.contentWidth / 2
	background.y = display.contentHeight / 2
	boardBack:insert(background)

	egg = Egg.new(0,0)
	local startX, startY = 137, 384
	egg.x = startX
	egg.y = startY
	egg.isVisible = false
	

	--------------------------------------
	-- Rysowanie mapy
	--------------------------------------
	map = defaulBoard()
	storyboard.map = map
	if storyboard.map ~= nil then map = storyboard.map end
	
	drawBoard()		

  	-----SKŁADANIE WARSTW
  	group:insert(board)
	board:insert(boardBack)
	board:insert(boardGrass)
	board:insert(boardFlat)
	board:insert(boardShadow)	
	board:insert(egg)
	board:insert(boardFront)
	board:insert(boardAnimation)	
	board:insert(boardBoxes)
    --- ******************

	
	group:insert(boardConstructor)	
	

	layerElements = display.newGroup()

	--- button select element
	local selectButton = display.newRect(10, 10, 70, 70)
	selectButton:setFillColor(46, 139, 87)
	function selectButton:tap(event)
		layerElements.isVisible = true
	end
	selectButton:addEventListener("tap")
	group:insert(selectButton)

	--- button save map
	local saveButton = display.newRect(10, 90, 70, 70)
	saveButton:setFillColor(168, 0, 0)
	function saveButton:tap(event)	

		native.showAlert( "Konstruktor", "Save level", { "OK", "Cancel" }, 
			function(event)
				if 1 == event.index then
					
					------------------------------
					display.save( group, "level.jpg", system.DocumentsDirectory )
					data.save(map,"level.json")
					local idLevel =  os.time( t )

					ftp:newConnection({ 
					        host = "hittdog.kei.pl", 
					        user = "hittdog", 
					        password = "hittdog2012", 
					        port = 21 -- Optional. Will default to 21.
					})

					local onError = function(event)
					        print("Error: " .. event.error) 
					end

					local onUploadTxtSuccess = function(event)        	
			        	ftp:upload({
						        localFile = system.pathForFile("level.jpg", system.DocumentsDirectory),
						        remoteFile = "public_html/kamilhh/"..idLevel..".jpg",
						        onSuccess = function() native.showAlert( "Zapisano", idLevel, { "OK"} ) end,
						        onError = function() native.showAlert( "Error", "Błąd zapisu", { "OK"} ) end
						})
					end	

					ftp:upload({
					        localFile = system.pathForFile("level.json", system.DocumentsDirectory),
					        remoteFile = "public_html/kamilhh/"..idLevel..".txt",
					        onSuccess = onUploadTxtSuccess,
					        onError = onError
					})

				end
			end )	
		
	end
	saveButton:addEventListener("tap")
	group:insert(saveButton)

	--- play button
	local playButton = sheetGame1:newImage("play.png")
	playButton.x = 45
	playButton.y = 723
	function playButton:tap(event)
		storyboard.map = map
		storyboard.levelNumber = 0
		storyboard.gotoScene( "scene_loading_level" )
	end
	playButton:addEventListener("tap")
	group:insert(playButton)

	--- reset button
	local restartButton = sheetGame1:newImage("restart.png")
	restartButton.x = 45
	restartButton.y = 638
	function restartButton:tap(event)
		native.showAlert( "Konstruktor", "Wyczyść mape", { "OK", "Cancel" }, 
			function(event)
				if 1 == event.index then
					map = defaulBoard()
					clearBoard()
					drawBoard()
				end
			end )
	end
	restartButton:addEventListener("tap")
	group:insert(restartButton)

	--- menu button
	local menuButton = sheetGame1:newImage("menu_popup.png")
	menuButton.x = 45
	menuButton.y = 550
	menuButton:scale(.88,.88)
	function menuButton:tap(event)
		storyboard.gotoScene("scene_menu")
	end
	menuButton:addEventListener("tap")
	group:insert(menuButton)

	--- elementy do wyboru
	layerElements = display.newGroup();
	layerElements.isVisible = false	

	local bgElements = display.newRect(0, 0, display.contentWidth, display.contentHeight)
	bgElements:setFillColor(0, 0, 0)
	bgElements.alpha = .9
	bgElements:addEventListener("touch", function() return true end)
	bgElements:addEventListener("tap", function() return true end)
	layerElements:insert(bgElements)

	local grid = 115
	elementID = 0

	local e0 = display.newRect(0, 0, 80, 80)
	e0:setReferencePoint(display.CenterReferencePoint);
	e0.x = grid*4
	e0.y = grid
	e0:setFillColor( black )
	e0:setStrokeColor(255, 255, 255) 
	e0.strokeWidth = 2
	e0:addEventListener("tap",function() elementID = 0 layerElements.isVisible = false end)
	layerElements:insert(e0)

	local e1 = Rock.new({x=grid*5,y=grid})
	e1:display()	
	e1.display:addEventListener("tap",function() elementID = 1 layerElements.isVisible = false end)
	layerElements:insert(e1.shadow)
	layerElements:insert(e1.display)

	local e4 = GoldenEgg.new({x=grid*6,y=grid*4})
	e4:display()	
	e4.display:addEventListener("tap",function() elementID = 4 layerElements.isVisible = false end)
	layerElements:insert(e4.display)

	local e5 = PowerUp.new({x=grid*5,y=grid*4})
	e5:display()	
	e5.display:addEventListener("tap",function() elementID = 5 layerElements.isVisible = false end)
	layerElements:insert(e5.display)

	local e10 = Reverser.new({x=grid,y=grid,rotation=0})
	e10:display()	
	e10.display:addEventListener("tap",function() elementID = 10 layerElements.isVisible = false end)
	layerElements:insert(e10.shadow)
	layerElements:insert(e10.display)

	local e13 = Reverser.new({x=grid*2,y=grid,rotation=270})
	e13:display()
	e13.display:addEventListener("tap",function() elementID = 13 layerElements.isVisible = false end)
	layerElements:insert(e13.shadow)
	layerElements:insert(e13.display)
	
	local e14 = ReverserHalf.new({x=grid*6,y=grid})
	e14:display()
	e14.display:addEventListener("tap",function() elementID = 14 layerElements.isVisible = false end)
	layerElements:insert(e14.shadow)
	layerElements:insert(e14.display)

	local e20 = Chicken.new(grid*5,grid*3,0,nil)
	e20:display()	
	--e20.myRectangle:removeEventListener("touch")
	e20.display:addEventListener("tap",function() elementID = 20 layerElements.isVisible = false return true end)
	layerElements:insert(e20.display)
	layerElements:insert(e20.myRectangle)

	local e25 = Switch.new({x=grid*4,y=grid*4})
	e25:display()	
	e25.display:addEventListener("tap",function() elementID = 25 layerElements.isVisible = false end)
	layerElements:insert(e25.display)

	local e30 = Bumper.new({x=grid,y=grid*3})
	e30:display()
	e30.display:removeEventListener("touch")
	e30.display:addEventListener("tap",function() elementID = 30 layerElements.isVisible = false return true end)
	layerElements:insert(e30.displayFront)
	layerElements:insert(e30.flat)
	layerElements:insert(e30.display)

	local e31 = Bumper.new({x=grid,y=grid*4,rotation=90})
	e31:display()
	e31.display:removeEventListener("touch")
	e31.display:addEventListener("tap",function() elementID = 31 layerElements.isVisible = false return true end)
	layerElements:insert(e31.displayFront)
	layerElements:insert(e31.flat)
	layerElements:insert(e31.display)

	local e32 = Bumper.new({x=grid,y=grid*5,rotation=180})
	e32:display()
	e32.display:removeEventListener("touch")
	e32.display:addEventListener("tap",function() elementID = 32 layerElements.isVisible = false return true end)
	layerElements:insert(e32.displayFront)
	layerElements:insert(e32.flat)
	layerElements:insert(e32.display)

	local e33 = Bumper.new({x=grid,y=grid*6,rotation=270})
	e33:display()
	e33.display:removeEventListener("touch")
	e33.display:addEventListener("tap",function() elementID = 33 layerElements.isVisible = false return true end)
	layerElements:insert(e33.displayFront)
	layerElements:insert(e33.flat)
	layerElements:insert(e33.display)

	local e35 = Bumper.new({x=grid*2,y=grid*3,type="freez"})
	e35:display()
	e35.display:removeEventListener("touch")
	e35.display:addEventListener("tap",function() elementID = 35 layerElements.isVisible = false end)
	layerElements:insert(e35.displayGrass)
	layerElements:insert(e35.displayFront)
	layerElements:insert(e35.flat)
	layerElements:insert(e35.display)

	local e36 = Bumper.new({x=grid*2,y=grid*4,rotation=90,type="freez"})
	e36:display()
	e36.display:removeEventListener("touch")
	e36.display:addEventListener("tap",function() elementID = 36 layerElements.isVisible = false end)
	layerElements:insert(e36.displayGrass)
	layerElements:insert(e36.displayFront)
	layerElements:insert(e36.flat)
	layerElements:insert(e36.display)

	local e37 = Bumper.new({x=grid*2,y=grid*5,rotation=180,type="freez"})
	e37:display()
	e37.display:removeEventListener("touch")
	e37.display:addEventListener("tap",function() elementID = 37 layerElements.isVisible = false end)
	layerElements:insert(e37.displayGrass)
	layerElements:insert(e37.displayFront)
	layerElements:insert(e37.flat)
	layerElements:insert(e37.display)

	local e38 = Bumper.new({x=grid*2,y=grid*6,rotation=270,type="freez"})
	e38:display()
	e38.display:removeEventListener("touch")
	e38.display:addEventListener("tap",function() elementID = 38 layerElements.isVisible = false end)
	layerElements:insert(e38.displayGrass)
	layerElements:insert(e38.displayFront)
	layerElements:insert(e38.flat)
	layerElements:insert(e38.display)

	local e40 = Bumper.new({x=grid*3,y=grid*3,type="auto"})
	e40:display()
	e40.display:removeEventListener("touch")
	e40.display:addEventListener("tap",function() elementID = 40 layerElements.isVisible = false end)
	layerElements:insert(e40.displayFront)
	layerElements:insert(e40.flat)
	layerElements:insert(e40.display)

	local e41 = Bumper.new({x=grid*3,y=grid*4,rotation=90,type="auto"})
	e41:display()
	e41.display:removeEventListener("touch")
	e41.display:addEventListener("tap",function() elementID = 41 layerElements.isVisible = false end)
	layerElements:insert(e41.displayFront)
	layerElements:insert(e41.flat)
	layerElements:insert(e41.display)

	local e42 = Bumper.new({x=grid*3,y=grid*5,rotation=180,type="auto"})
	e42:display()
	e42.display:removeEventListener("touch")
	e42.display:addEventListener("tap",function() elementID = 42 layerElements.isVisible = false end)
	layerElements:insert(e42.displayFront)
	layerElements:insert(e42.flat)
	layerElements:insert(e42.display)

	local e43 = Bumper.new({x=grid*3,y=grid*6,rotation=270,type="auto"})
	e43:display()
	e43.display:removeEventListener("touch")
	e43.display:addEventListener("tap",function() elementID = 43 layerElements.isVisible = false end)
	layerElements:insert(e43.displayFront)
	layerElements:insert(e43.flat)
	layerElements:insert(e43.display)

	local e98 = Pipe.new({x=grid*2,y=grid*2})
	e98:display()
	e98.display:addEventListener("tap",function() elementID = 98 layerElements.isVisible = false end)
	layerElements:insert(e98.display)

	local e99 = Pipe.new({x=grid*5,y=grid*2,withLock = true})
	e99:display()
	e99.display:addEventListener("tap",function() elementID = 99 layerElements.isVisible = false end)
	layerElements:insert(e99.display)
	layerElements:insert(e99.displayBarrier1)
	layerElements:insert(e99.displayBarrier2)
	layerElements:insert(e99.displayDiode)

	group:insert(layerElements)

	tnt:cancelAllTimers()
	tnt:cancelAllTransitions() 
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
		
	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
	-----------------------------------------------------------------------------
	storyboard.removeScene( "scene_menu" )
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	
	-----------------------------------------------------------------------------
	
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