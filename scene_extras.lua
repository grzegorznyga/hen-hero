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

-- modules
--local helpers = require("scripts.helpers")
local sheetHelper = require("scripts.sheet_helper")
local textBitmap = require("scripts.text_bitmap")

local sheetMenu
local sheetText

local dim
local onFrame

local bg_sky
local bg_cloud1
local bg_cloud2
local bg_cloud3
local bg_cloud4
local bg_mount1
local bg_mount2
local bg_grass

local header
local listView

-- buttons
local buttonBack




-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-----------------------------------------------------------------------------
		
	--	CREATE display objects and add them to 'group' here.
	--	Example use-case: Restore 'group' from previously saved state.
	
	-----------------------------------------------------------------------------

	sheetMenu = sheetHelper.new("menu")
	sheetText = sheetHelper.new("interface")

	local bgGroup = display.newImageGroup( sheetMenu.data )
	--------
	bg_sky = sheetMenu:newImage("bck.png")
	bg_sky.x = display.contentWidth / 2
	bg_sky.y = display.contentHeight / 2
	bgGroup:insert( bg_sky )

	bg_cloud1 = sheetMenu:newImage("bck_chmura_01.png")
	bg_cloud1.x = 50
	bg_cloud1.y = 230
	bgGroup:insert( bg_cloud1 )	

	bg_cloud2 = sheetMenu:newImage("bck_chmura_02.png")
	bg_cloud2.x = 350
	bg_cloud2.y = 90
	bgGroup:insert( bg_cloud2 )

	bg_cloud3 = sheetMenu:newImage("bck_chmura_03.png")
	bg_cloud3.x = 620
	bg_cloud3.y = 280
	bgGroup:insert( bg_cloud3 )

	bg_cloud4 = sheetMenu:newImage("bck_chmura_04.png")
	bg_cloud4.x = 910
	bg_cloud4.y = 150
	bgGroup:insert( bg_cloud4 )

	bg_mount2 = sheetMenu:newImage("bck_gory_02.png")
	bg_mount2.x = display.contentWidth / 2 -20
	bg_mount2.y = 680
	bgGroup:insert( bg_mount2 )

	bg_mount1 = sheetMenu:newImage("bck_gory_01.png")
	bg_mount1.x = display.contentWidth / 2 +30
	bg_mount1.y = 680
	bgGroup:insert( bg_mount1 )

	bg_grass = sheetMenu:newImage("bck_trawa.png")
	bg_grass.x = display.contentWidth / 2
	bg_grass.y = 719
	bgGroup:insert( bg_grass )

	group:insert(bgGroup)

	------ naglowek

	header = sheetMenu:newImage("label_extras.png")
	header.x = display.contentWidth / 2
	header.y = 100
	group:insert( header )

	--setup the table
	local data = {}

	--setup each row as a new table, then add title, subtitle, and image
	data[1] = {}
	data[1].title = "Hot Coffee"
	data[1].subtitle = "Grounds brewed in hot water"
	data[1].image = "coffee1.png"

	data[2] = {}
	data[2].title = "Iced Coffee"
	data[2].subtitle = "Chilled coffee with ice"
	data[2].image = "coffee2.png"

	data[3] = {}
	data[3].title = "Espresso"
	data[3].subtitle = "Concentrated by forcing hot water"
	data[3].image = "coffee3.png"

	data[4] = {}
	data[4].title = "Cappuccino"
	data[4].subtitle = "Espresso with frothy milk"
	data[4].image = "coffee4.png"

	data[5] = {}
	data[5].title = "Latte"
	data[5].subtitle = "More milk and less froth"
	data[5].image = "coffee5.png"

	data[6] = {}
	data[6].title = "Americano"
	data[6].subtitle = "Espresso with hot water"
	data[6].image = "coffee6.png"


	------ Lista
	listView = display.newGroup()
	
	--local mask = graphics.newMask("images/mask_list.png")
	--listView:setMask(mask)
	listView:setReferencePoint( display.CenterReferencePoint )
	listView.maskX = display.contentWidth / 2
	listView.maskY = display.contentHeight / 2


	local offset = 180
	for i=1,5 do
		
		local myRoundedRect = display.newRoundedRect(0, 0, 790, 80, 15)
		myRoundedRect:setReferencePoint(display.TopCenterReferencePoint)
		myRoundedRect.x=display.contentWidth / 2
		myRoundedRect.y= offset
		myRoundedRect:setFillColor(0, 0, 0)
		myRoundedRect.alpha = .5
		listView:insert(myRoundedRect)

		local extrasText = sheetMenu:newImage("extras_1.png")
		extrasText:setReferencePoint(display.TopCenterReferencePoint)
		extrasText.x= 275
		extrasText.y= offset + 10
		listView:insert(extrasText)

		local yolkList = sheetMenu:newImage("yolk.png")
		yolkList:setReferencePoint(display.TopCenterReferencePoint)
		yolkList.x= 720
		yolkList.y= offset + 20
		listView:insert(yolkList)

		local labelXList = sheetMenu:newImage("x.png")
		labelXList:setReferencePoint(display.TopCenterReferencePoint)
		labelXList.x= 690
		labelXList.y= offset + 35
		listView:insert(labelXList)

		local cashText = textBitmap.newText(sheetText, "white_")
		cashText.x = 610
	    cashText.y = offset + 40 
	    cashText.xScale = .8
    	cashText.yScale = .8
	    cashText:print("680")
	    listView:insert(cashText)

		local separator1 = sheetMenu:newImage("separator_dots.png")
		separator1:setReferencePoint(display.TopCenterReferencePoint)
		separator1.x=570
		separator1.y= offset + 10
		listView:insert(separator1)

		local separator2 = sheetMenu:newImage("separator_dots.png")
		separator2:setReferencePoint(display.TopCenterReferencePoint)
		separator2.x=750
		separator2.y= offset + 10
		listView:insert(separator2)

		local buttonGetIt = sheetMenu:newImage("button_get_it.png")
		buttonGetIt:setReferencePoint(display.TopCenterReferencePoint)
		buttonGetIt.x = 835
		buttonGetIt.y = offset + 10
		function buttonGetIt:tap( event )		 
			native.showAlert( "Test", "extras:"..i, { "OK" } )
		end
		buttonGetIt:addEventListener( "tap" )
		listView:insert(buttonGetIt)

		offset = (i * 90) + 180
	end

	-- function listView:touch(event) 
	-- 		if event.phase == "began" then				
	-- 			display.getCurrentStage():setFocus( self )
 --            	self.isFocus = true

 --            	 self.markY = self.y
				
	-- 		elseif self.isFocus then        
	-- 			if event.phase == "moved" then
					
	-- 				local y = (event.y - event.yStart) + self.markY
	-- 				self.y = y
	-- 				--print(y)
	-- 				self.maskY = (display.contentHeight / 2) -self.y
								
	-- 			elseif event.phase == "ended" or event.phase == "cancelled" then

					
	-- 				display.getCurrentStage():setFocus(nil)
	-- 				self.isFocus = false
	-- 			end
	-- 		end
			
	-- end	
	-- listView:addEventListener("touch")
	group:insert( listView )
	
	
	

	----- Stan Jajek na trawie
	local currentStatus = display.newGroup()

	local labelEggsEarned = sheetMenu:newImage("txt_earn.png")
	labelEggsEarned.x = 340
    labelEggsEarned.y = display.contentHeight / 100  * 94 
    currentStatus:insert(labelEggsEarned)

	local goldenEggsText = textBitmap.newText(sheetText, "blue_")
	goldenEggsText.x = 495
    goldenEggsText.y = 720   
    goldenEggsText:print("175")
    goldenEggsText:scale(.9,.9)
    currentStatus:insert(goldenEggsText)

    local labelX = sheetMenu:newImage("x.png")
	labelX.x = display.contentWidth / 100  * 57	
	labelX.y = display.contentHeight / 100  * 94
	currentStatus:insert(labelX)

    local yolk = sheetMenu:newImage("yolk.png")
	yolk.x = display.contentWidth / 100  * 60	
	yolk.y = display.contentHeight / 100  * 94
	currentStatus:insert(yolk)

    local buttonGetMore = sheetMenu:newImage("button_get_more.png")
	buttonGetMore.x = display.contentWidth / 100  * 69	
	buttonGetMore.y = display.contentHeight / 100  * 94
	function buttonGetMore:tap( event )		 
		native.showAlert( "Test", "akcja.", { "OK" } )
	end
	buttonGetMore:addEventListener( "tap" )
	currentStatus:insert(buttonGetMore)

    group:insert(currentStatus)

	------ back button
	buttonBack = sheetMenu:newImage("button_back.png")
	buttonBack.x = display.contentWidth / 100  * 5	
	buttonBack.y = display.contentHeight / 100  * 94
	function buttonBack:touch(event)
		if event.phase == "began" then
			self.alpha = .5
			self:scale( .9, .9 )
			audio.play( storyboard.audio.s2 )
			display.getCurrentStage():setFocus(event.target)
		elseif event.phase == "ended" then
			self.alpha = 1
			self.xScale = 1
			self.yScale = 1

			dim.isHitTestable = true
			transition.to( dim, { time=200, alpha=1, onComplete = 
				function() storyboard.gotoScene( "scene_menu" ) end
				 } )

			display.getCurrentStage():setFocus(nil)
		end

		return true
	end
	buttonBack:addEventListener("touch")
	group:insert( buttonBack )

	--warstwa przykrywajaca i robi przejscia
	dim = display.newRect(0, 0, display.contentWidth, display.contentHeight)
	dim:setFillColor(0, 0, 0)
	dim.alpha = 1
	function dim:touch(event)
		return true
	end
	dim:addEventListener("touch")
	group:insert(dim)

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
		
	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
	-----------------------------------------------------------------------------
	storyboard.removeScene( "scene_menu" )
	storyboard.printMemUsage()

	-- rozjasnienie ekranu
	transition.to( dim, { time=200, alpha=0 } )

	local endX = -130
	local startX = 1155
	local speed = 0.6
	onFrame = function( event )
	    
	    bg_cloud1.x = bg_cloud1.x - speed
	    if bg_cloud1.x < endX then bg_cloud1.x = startX  end

	    bg_cloud2.x = bg_cloud2.x - speed
	    if bg_cloud2.x < endX then bg_cloud2.x = startX end

	    bg_cloud3.x = bg_cloud3.x - speed
	    if bg_cloud3.x < endX then bg_cloud3.x = startX end

	    bg_cloud4.x = bg_cloud4.x - speed
	    if bg_cloud4.x < endX then bg_cloud4.x = startX end
	    
	end
	Runtime:addEventListener( "enterFrame", onFrame )

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	
	-----------------------------------------------------------------------------
	Runtime:removeEventListener( "enterFrame", onFrame )
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