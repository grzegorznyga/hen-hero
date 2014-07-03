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
local dataScore = require("scripts.data")

local sheetMenu
local sheetText
-- gfx
-- local background
-- local grass
local onFrame

local dim



local bg_sky, bg_top
local bg_cloud1
local bg_cloud2
local bg_cloud3
local bg_cloud4
-- local bg_mount1
-- local bg_mount2
local bg_grass


local header
local slideView
local goldenEggsText


-- buttons
local buttonBack


local transitionSlideView
local transitionShadowGroup
local panelIndx
local currentX 
local touchStartX



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
	bg_sky:setReferencePoint(display.BottomCenterReferencePoint)
	bg_sky.x = display.contentWidth / 2
	bg_sky.y = (display.contentHeight - display.screenOriginY) -20
	bgGroup:insert( bg_sky )

	bg_top = sheetMenu:newImage("bck_top.png")
	bg_top:setReferencePoint(display.TopCenterReferencePoint)
	bg_top.x = display.contentWidth / 2
	bg_top.y = display.screenOriginY
	bgGroup:insert( bg_top )

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

	-- bg_mount2 = sheetMenu:newImage("bck_gory_02.png")
	-- bg_mount2.x = display.contentWidth / 2 -20
	-- bg_mount2.y = 680
	-- bgGroup:insert( bg_mount2 )

	-- bg_mount1 = sheetMenu:newImage("bck_gory_01.png")
	-- bg_mount1.x = display.contentWidth / 2 +30
	-- bg_mount1.y = 680
	-- bgGroup:insert( bg_mount1 )

	-- bg_grass = sheetMenu:newImage("bck_trawa.png")
	-- bg_grass.x = display.contentWidth / 2
	-- bg_grass.y = 719
	-- bgGroup:insert( bg_grass )

	bg_grass = sheetMenu:newImage("credits_bck.png")
	bg_grass.x = display.contentWidth / 2
	bg_grass.y = (display.contentHeight - display.screenOriginY) + 90
	bgGroup:insert( bg_grass )

	group:insert(bgGroup)






	header = sheetMenu:newImage("label_selectbox.png")
	header.x = display.contentWidth / 2
	header.y = (display.screenOriginY/2) + 210
	group:insert( header )

	--- cienie -----------
	local shadowGroup = display.newGroup()
	group:insert(shadowGroup)

	local mask = graphics.newMask( "images/mask_world_shadow.png" )
	shadowGroup:setMask( mask )
	shadowGroup.maskX = (display.contentWidth / 2 ) 
	shadowGroup.maskY = (display.contentHeight - display.screenOriginY) - 223

	----- slider
	slideView = display.newGroup()
	local pages = 1
	if event.params ~= nil and event.params.page == 2 then
		pages = 2
	end

	local touchArea = display.newRect(0, 0, display.contentWidth*pages, 550)
	touchArea:setReferencePoint(display.CenterLeftReferencePoint);
	touchArea.x = 0
	touchArea.y = 400	
	--touchArea:setFillColor( 185, 231, 40, 200 ) --debug
	touchArea.isVisible = false
	touchArea.isHitTestable = true
	slideView:insert(touchArea)

	-- dodać swiaty
	local offset = 0
	for i=1,pages do

		local world = display.newGroup()
		world.number = i

		local box = sheetMenu:newImage("world_"..i..".png")
		box.x = ((display.contentWidth / 2) +5) + offset
		box.y = display.contentHeight /2	
		world:insert(box)

		if i == 2 then
			box.y = box.y - 15

			local buttonOK = sheetMenu:newImage("button_ok.png")
			buttonOK.x = ((display.contentWidth / 2) +5) + offset
			buttonOK.y = display.contentHeight /2 + 58				

			function buttonOK:touch(event)
				if event.phase == "began" then
					self.alpha = .5
					self:scale( .9, .9 )
					audio.play( storyboard.audio.s2 )
					slideView:removeEventListener("touch")
					display.getCurrentStage():setFocus(event.target)
				elseif event.phase == "ended" then
					self.alpha = 1
					self.xScale = 1
					self.yScale = 1			

					panelIndx = 0	
					currentX = 0 
					touchStartX = 0	
					transitionSlideView = transition.to( slideView, {time=1000, x=0, transition=easing.outExpo } )
					transitionShadowGroup = transition.to( shadowGroup, {time=1000, x=0, maskX=(display.contentWidth / 2) -0, transition=easing.outExpo, onComplete = function() slideView:addEventListener("touch") end } )		

					display.getCurrentStage():setFocus(nil)
					--self:removeEventListener("touch")
				end

				return true
			end
			buttonOK:addEventListener("touch")

			world:insert(buttonOK)

		end

		if i == 1 then
			function world:tap( event )		 
				audio.play( storyboard.audio.s2 )  
				storyboard.worldNumber = self.number
				dim.isHitTestable = true

				--transition.to(self,{time=200,xScale = 6, yScale = 6, alpha = 0})

				transition.to( dim, { time=200, alpha=1, onComplete = 
					function() storyboard.gotoScene( "scene_levels" ) end
					 } )

			end
			world:addEventListener( "tap" )
		
			-- liczba jaj
			goldenEggsText = textBitmap.newText(sheetText, "white_")
			goldenEggsText.x = 370  + offset
		    goldenEggsText.y = 580
		    goldenEggsText.xScale = .75
		    goldenEggsText.yScale = .75
		    goldenEggsText:print(dataScore.totalStars(i).."#90")
		    world:insert(goldenEggsText)
		end

	    local shadow = sheetMenu:newImage("world_shadow.png")
		shadow.x = box.x
		shadow.y = (display.contentHeight - display.screenOriginY) - 235
		shadowGroup:insert(shadow)
	    

		offset = i * 550
		slideView:insert(world)
	end

	
	local dragDistance = 0
	local endResistance = -100
	panelIndx = 0	
	currentX = 0 
	touchStartX = 0	

	-- pudelko nr 2
	if event.params ~= nil and event.params.page == 2 then
		endResistance = -650
		panelIndx = 1
		currentX = -550*panelIndx
		slideView.x = currentX
		shadowGroup.x = currentX
		shadowGroup.maskX = (display.contentWidth / 2) - slideView.x
	end

	local function touchListener (self, touch) 
			if touch.phase == "began" then				
				display.getCurrentStage():setFocus( self )
            	self.isFocus = true

				touchStartX = touch.x
				currentX = slideView.x

				if transitionSlideView ~= nil then transition.cancel( transitionSlideView ) end
				if transitionShadowGroup ~= nil then transition.cancel( transitionShadowGroup ) end
			
			elseif self.isFocus then        
				if touch.phase == "moved" then
					
					if slideView.x > 0 or slideView.x < -100 then
						local factor = 0
						if (touch.x - touchStartX) > 0 then 
							factor = (1-(touch.x - touchStartX)*0.0012)
						else
							factor = (1+(touch.x - touchStartX)*0.0012)
						end


						if factor > 0.51 then
						 	dragDistance = (touch.x - touchStartX)*factor
						else
							if (touch.x - touchStartX) > 0 then 
								dragDistance = dragDistance + 1
							else
								dragDistance = dragDistance - 1
							end
						end
					else
						dragDistance = touch.x - touchStartX
					end	

					--print(dragDistance)
					--local dragDistance = touch.x - touchStartX					
					slideView.x = currentX + dragDistance 	
					shadowGroup.x = slideView.x
					shadowGroup.maskX = (display.contentWidth / 2) - slideView.x
					
					--print(slideView.x )
								
				elseif touch.phase == "ended" or touch.phase == "cancelled" then

					local dragDistance = touch.x - touchStartX

					if dragDistance < -30 then
						if panelIndx < pages-1 then						
							panelIndx = panelIndx +1
							
						end						
					elseif dragDistance > 30 then
						if panelIndx > 0 then 
							panelIndx = panelIndx -1
							
						end																	
					end

					dragDistance = 0
					currentX = -550*panelIndx
					transitionSlideView = transition.to( slideView, {time=1000, x=currentX, transition=easing.outExpo } )
					transitionShadowGroup = transition.to( shadowGroup, {time=1000, x=currentX, maskX=(display.contentWidth / 2) -currentX, transition=easing.outExpo } )
					display.getCurrentStage():setFocus(nil)
					self.isFocus = false
				end
			end
			
	end
	slideView.touch = touchListener
	slideView:addEventListener("touch")
	group:insert( slideView )



	------ back button
	buttonBack = sheetMenu:newImage("button_back.png")
	buttonBack.x = display.contentWidth / 100  * 8	
	buttonBack.y = (display.contentHeight - display.screenOriginY) - 155	
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

	slideView:toFront()

	----- Stan Jajek na trawie
	-- local currentStatus = display.newGroup()

	-- local labelEggsEarned = sheetMenu:newImage("txt_earn.png")
	-- labelEggsEarned.x = 340
 --    labelEggsEarned.y = display.contentHeight / 100  * 94 
 --    currentStatus:insert(labelEggsEarned)

	-- local goldenEggsText = textBitmap.newText(sheetText, "blue_")
	-- goldenEggsText.x = 495
 --    goldenEggsText.y = 720   
 --    goldenEggsText:print("175")
 --    goldenEggsText:scale(.9,.9)
 --    currentStatus:insert(goldenEggsText)

 --    local labelX = sheetMenu:newImage("x.png")
	-- labelX.x = display.contentWidth / 100  * 57	
	-- labelX.y = display.contentHeight / 100  * 94
	-- currentStatus:insert(labelX)

 --    local star = sheetMenu:newImage("level_star1.png")
	-- star.x = display.contentWidth / 100  * 60	
	-- star.y = display.contentHeight / 100  * 94
	-- currentStatus:insert(star)

 --    local buttonGetMore = sheetMenu:newImage("button_get_more.png")
	-- buttonGetMore.x = display.contentWidth / 100  * 69	
	-- buttonGetMore.y = display.contentHeight / 100  * 94
	-- function buttonGetMore:tap( event )		 
	-- 	native.showAlert( "Test", "akcja.", { "OK" } )
	-- end
	-- buttonGetMore:addEventListener( "tap" )
	-- currentStatus:insert(buttonGetMore)

 --    group:insert(currentStatus)

	--warstwa przykrywajaca i robi przejscia
	dim = display.newRect(0, display.screenOriginY, 768, display.contentHeight - display.screenOriginY*2)
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
	if event.params ~= nil and event.params.page == 2 then		
		storyboard.analytics.logEvent( "EnterScene_Worlds_End" )
	else
		storyboard.analytics.logEvent( "EnterScene_Worlds" )
	end
	
	storyboard.removeScene( "scene_menu" )
	storyboard.removeScene( "scene_levels" )
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
	goldenEggsText:removeSelf()
	goldenEggsText = nil
	sheetText:dispose()
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