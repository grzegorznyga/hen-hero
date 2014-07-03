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
local data = require("scripts.data")

-- local
local sheetMenu
local background

local dim
local onFrame

--back
local bg_sky, bg_top

local bg_cloud1
local bg_cloud2
local bg_cloud3
local bg_cloud4

local bg_mount1
local bg_mount2

local bg_barn
local bg_bumper
local bg_rocks
local bg_egg
local bg_chicken
local chickenEys
local bg_grass
local bg_title

local blinkTimer

local buttonPlay
--local buttonExtras
local buttonSoundOff
local buttonSoundOn
-- local buttonClose
local buttonInfo

local transGrass
local transBg

local isCreditsOpen = false


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-----------------------------------------------------------------------------
		
	--	CREATE display objects and add them to 'group' here.
	--	Example use-case: Restore 'group' from previously saved state.
	
	-----------------------------------------------------------------------------	


	sheetMenu = sheetHelper.new("menu")	

	--------------
	
	
		
	local bgGroup = display.newImageGroup( sheetMenu.data )
	local grassGroup = display.newGroup()

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
	-- bg_mount2.y = (display.contentHeight - display.screenOriginY) - 270
	-- bgGroup:insert( bg_mount2 )

	-- bg_mount1 = sheetMenu:newImage("bck_gory_01.png")
	-- bg_mount1.x = display.contentWidth / 2 +30
	-- bg_mount1.y = (display.contentHeight - display.screenOriginY) - 270
	-- bgGroup:insert( bg_mount1 )

	------------------------------------------------------------------
	

	bg_title = sheetMenu:newImage("bck_logo.png")
	--bg_title:setReferencePoint(display.TopCenterReferencePoint)
	bg_title.x = display.contentWidth / 2 +15
	bg_title.y = 190
	bgGroup:insert( bg_title )

	bg_barn = sheetMenu:newImage("bck_stodola.png")
	bg_barn.x = 560
	bg_barn.y = (display.contentHeight - display.screenOriginY) - 330 --564
	bgGroup:insert( bg_barn )




	bg_bumper = sheetMenu:newImage("bck_zwrotnica.png")
	bg_bumper.x = 450
	bg_bumper.y = (display.contentHeight - display.screenOriginY) - 270 --631
	bgGroup:insert( bg_bumper )

	


	-- kura

	bg_chicken = sheetMenu:newImage("bck_kura.png")
	bg_chicken.x = 308
	bg_chicken.y = (display.contentHeight - display.screenOriginY) - 470
	bgGroup:insert( bg_chicken )

	local sequenceData = {
	    name="blink",
	    start=sheetMenu.options.frameIndex["kura_oczy_00.png"],
	    count=3,
	    time=140,        -- Optional. In ms.  If not supplied, then sprite is frame-based.
	    loopCount = 1,   -- Optional. Default is 0 (loop indefinitely)
	    loopDirection = "bounce"    -- Optional. Values include: "forward","bounce"
	}
	chickenEys = display.newSprite( sheetMenu.data, sequenceData )
	chickenEys.x = 130
	chickenEys.y = (display.contentHeight - display.screenOriginY) - 541
	bgGroup:insert( chickenEys )
	chickenEys:play()

	bg_egg = sheetMenu:newImage("bck_jajo.png")
	bg_egg.x = 650
	bg_egg.y = (display.contentHeight - display.screenOriginY) - 280 --635
	bgGroup:insert( bg_egg )

	bg_rocks = sheetMenu:newImage("bck_kamienie.png")
	bg_rocks.x = 640
	bg_rocks.y = (display.contentHeight - display.screenOriginY) - 220 --690
	bgGroup:insert( bg_rocks )

	bg_grass = sheetMenu:newImage("credits_bck.png")
	bg_grass.x = display.contentWidth / 2
	bg_grass.y = (display.contentHeight - display.screenOriginY) + 90
	grassGroup:insert( bg_grass )

	group:insert(bgGroup)
	group:insert( grassGroup )
	-----------
	buttonPlay = sheetMenu:newImage("button_play.png")
	buttonPlay.x = display.contentWidth / 100  * 50	
	buttonPlay.y = (display.contentHeight - display.screenOriginY) - 165
	function buttonPlay:touch(event)
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
				function() storyboard.gotoScene( "scene_worlds" ) end -- scene_levels
				 } )			
			
			

			display.getCurrentStage():setFocus(nil)
		end

		return true
	end
	buttonPlay:addEventListener("touch")
	grassGroup:insert( buttonPlay )
	
	------
	-- buttonExtras = sheetMenu:newImage("button_extras.png")
	-- buttonExtras.x = display.contentWidth / 100  * 75	
	-- buttonExtras.y = display.contentHeight / 100  * 90
	-- function buttonExtras:touch(event)
	-- 	if event.phase == "began" then
	-- 		self.alpha = .5
	-- 		self:scale( .9, .9 )
	-- 		audio.play( storyboard.audio.s2 )
	-- 		display.getCurrentStage():setFocus(event.target)
	-- 	elseif event.phase == "ended" then
	-- 		self.alpha = 1
	-- 		self.xScale = 1
	-- 		self.yScale = 1

	-- 		dim.isHitTestable = true
	-- 		transition.to( dim, { time=200, alpha=1, onComplete = 
	-- 			function() storyboard.gotoScene( "scene_extras" ) end
	-- 			 } )

	-- 		-- transition.to( buttonSoundOff, {time=200, alpha=0, transition=easing.outExpo } )
	-- 		-- transition.to( buttonSoundOn, {time=200, alpha=0, transition=easing.outExpo } )
	-- 		-- transition.to( buttonInfo, {time=200, alpha=0, transition=easing.outExpo } )
	-- 		-- transition.to( buttonPlay, {time=200, alpha=0, transition=easing.outExpo } )
	-- 		--transition.to( bgGroup, {time=800, x=0, y=-300, transition=easing.outExpo } )
			

	-- 		display.getCurrentStage():setFocus(nil)
	-- 	end

	-- 	return true
	-- end
	-- buttonExtras:addEventListener("touch")
	-- grassGroup:insert( buttonExtras )

	-- ----
	-- buttonClose = sheetMenu:newImage("button_i.png")
	-- buttonClose.isVisible = false
	-- buttonClose.isHitTestable = true
	-- buttonClose.x = display.contentWidth / 100  * 92	
	-- buttonClose.y = display.contentHeight / 100  * 129
	-- function buttonClose:touch(event)
	-- 	if event.phase == "began" then
	-- 		self.alpha = .5
	-- 		self:scale( .9, .9 )
	-- 		audio.play( tapSound )
	-- 		display.getCurrentStage():setFocus(event.target)
	-- 	elseif event.phase == "ended" then
	-- 		self.alpha = 1
	-- 		self.xScale = 1
	-- 		self.yScale = 1

	-- 		-- transition.to( buttonSoundOff, {time=200, delay=400, alpha=1, transition=easing.outExpo } )
	-- 		-- transition.to( buttonSoundOn, {time=200, delay=400, alpha=1, transition=easing.outExpo } )
	-- 		-- transition.to( buttonInfo, {time=200, delay=400, alpha=1, transition=easing.outExpo } )
	-- 		-- transition.to( buttonPlay, {time=200, delay=400, alpha=1, transition=easing.outExpo } )
	-- 		transition.to( bgGroup, {time=800, x=0, y=0, transition=easing.outExpo } )
			

	-- 		display.getCurrentStage():setFocus(nil)
	-- 	end

	-- 	return true
	-- end
	-- buttonClose:addEventListener("touch")
	-- bgGroup:insert( buttonClose )

	-- info
	buttonInfo = sheetMenu:newImage("button_i.png")
	buttonInfo.x = display.contentWidth / 100  * 90	
	buttonInfo.y = (display.contentHeight - display.screenOriginY) - 165
	--print(isCreditsOpen)
	function buttonInfo:touch(event)
		if event.phase == "began" then
			self.alpha = .5
			self:scale( .9, .9 )
			audio.play(storyboard.audio.s2)
			display.getCurrentStage():setFocus(event.target)
		elseif event.phase == "ended" then
			self.alpha = 1
			self.xScale = 1
			self.yScale = 1

			if isCreditsOpen == false then
				audio.play(storyboard.audio.s3,{ channel=2})
				if transGrass ~= nil then transition.cancel( transGrass ) end
			    if transBg ~= nil then transition.cancel( transBg ) end
				isCreditsOpen = true
				transGrass = transition.to( grassGroup, {time=800, y=-420, transition=easing.outExpo } )
			    transBg = transition.to( bgGroup, {time=800, y=-300, transition=easing.outExpo } )
			else
				if transGrass ~= nil then transition.cancel( transGrass ) end
			    if transBg ~= nil then transition.cancel( transBg ) end
			    
				isCreditsOpen = false
				transGrass = transition.to( grassGroup, {time=800, y=0, transition=easing.outExpo } )
			    transBg = transition.to( bgGroup, {time=800, y=0, transition=easing.outExpo } )
		end

			display.getCurrentStage():setFocus(nil)
		end

		return true
	end
	buttonInfo:addEventListener("touch")	
	grassGroup:insert( buttonInfo )

	-----
	buttonSoundOff = sheetMenu:newImage("button_sound_off.png")
	buttonSoundOff.x = display.contentWidth / 100  * 8	
	buttonSoundOff.y = (display.contentHeight - display.screenOriginY) - 165	
	grassGroup:insert( buttonSoundOff )

	-----
	buttonSoundOn = sheetMenu:newImage("button_sound_on.png")
	buttonSoundOn.x = display.contentWidth / 100  * 8	
	buttonSoundOn.y = (display.contentHeight - display.screenOriginY) - 165		
	grassGroup:insert( buttonSoundOn )

	function buttonSoundOff:touch(event)
		if event.phase == "began" then
			audio.play(storyboard.audio.s2)
			self.alpha = .5
			self:scale( .9, .9 )
			display.getCurrentStage():setFocus(event.target)
		elseif event.phase == "ended" then
			self.isVisible = false
			self.alpha = 1
			self.xScale = 1
			self.yScale = 1

			storyboard.settings.music = 1
			data.saveSettings(storyboard.settings)

			audio.setVolume( 1, { channel=1 } )
			audio.play(storyboard.audio.s1, { channel=1, loops=-1, fadein=500 } )

			
			buttonSoundOn.isVisible = true
			display.getCurrentStage():setFocus(nil)
		end
		return true
	end
	buttonSoundOff:addEventListener("touch")	

	
	function buttonSoundOn:touch(event)
		if event.phase == "began" then
			audio.play(storyboard.audio.s2)
			self.alpha = .5
			self:scale( .9, .9 )
			display.getCurrentStage():setFocus(event.target)
		elseif event.phase == "ended" then
			self.isVisible = false
			self.alpha = 1
			self.xScale = 1
			self.yScale = 1

			storyboard.settings.music = 0
			data.saveSettings(storyboard.settings)
			
			audio.fadeOut({ channel=1, time=500 } )
					
			buttonSoundOff.isVisible = true
			display.getCurrentStage():setFocus(nil)
		end
		return true
	end
	buttonSoundOn:addEventListener("touch")

	--- ustawienie
	if storyboard.settings.music == 1 then
		buttonSoundOff.isVisible = false
	else
		buttonSoundOn.isVisible = false
	end

	----- przesuwanie warstw	
	local dragDistance = 0

	local touchStartX = 0
	local currentChickenX = bg_chicken.x  
	local currentChickenEysX = chickenEys.x	
	local currentBarnX = bg_barn.x 
	local currentBumperX = bg_bumper.x
	local currentRocksX = bg_rocks.x
	local currentEggX = bg_egg.x
	local currentGrassX = grassGroup.x
	local currentTtileX = bg_title.x
	-- local currentMount2X = bg_mount2.x
	-- local currentMount1X = bg_mount1.x

	local tchicken
	local tchickenEys
	local tbarn
	local tbumper
	local trocks
	local tegg
	local tgrass
	local ttitle
	local tmount2
	local tmount1



	function bgGroup:touch(touch) 
			if touch.phase == "began" then				
				display.getCurrentStage():setFocus( self )
            	self.isFocus = true

				touchStartX = touch.x

				if tchicken ~= nil then transition.cancel( tchicken ) end
				if tchickenEys ~= nil then transition.cancel( tchickenEys ) end
				if tbarn ~= nil then transition.cancel( tbarn ) end
				if tbumper ~= nil then transition.cancel( tbumper ) end
				if trocks ~= nil then transition.cancel( trocks ) end
				if tegg ~= nil then transition.cancel( tegg ) end
				if tgrass ~= nil then transition.cancel( tgrass ) end
				if ttitle ~= nil then transition.cancel( ttitle ) end
				if tmount2 ~= nil then transition.cancel( tmount2 ) end
				if tmount1 ~= nil then transition.cancel( tmount1 ) end

				----------------- os Y				        
		        self.touchStartY = touch.y		      
		        -- if transGrass ~= nil then transition.cancel( transGrass ) end
		        -- if transBg ~= nil then transition.cancel( transBg ) end
		        --------------------------

			elseif self.isFocus then   


				if touch.phase == "moved" then

					--dragDistance = touch.x - touchStartX	
					
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
					--print(factor)
					--dragDistance = dragDistance*factor

					--print(dragDistance)
					if dragDistance < 244 and dragDistance > -243 then
						bg_barn.x = currentBarnX + dragDistance / 4.8
						bg_bumper.x = currentBumperX + dragDistance / 3.8
						bg_rocks.x = currentRocksX + dragDistance / 3.3
						bg_egg.x = currentEggX + dragDistance / 3.3
						bg_chicken.x = currentChickenX + dragDistance / 2.9
						chickenEys.x = currentChickenEysX + dragDistance / 2.9
						--grassGroup.x = currentGrassX + dragDistance / 2 
						bg_title.x = currentTtileX + dragDistance / 7
						-- bg_mount2.x = currentMount2X + dragDistance / 6
						-- bg_mount1.x = currentMount1X + dragDistance / 8		
					end			

								
				elseif touch.phase == "ended" or touch.phase == "cancelled" then					

					tchicken = transition.to( bg_chicken, {time=800, x=308, transition=easing.outExpo } )
					tchickenEys = transition.to( chickenEys, {time=800, x=130, transition=easing.outExpo } )
					tbarn = transition.to( bg_barn, {time=800, x=560, transition=easing.outExpo } )
					tbumper = transition.to( bg_bumper, {time=800, x=650, transition=easing.outExpo } )
					trocks = transition.to( bg_rocks, {time=800, x=810, transition=easing.outExpo } )
					tegg = transition.to( bg_egg, {time=800, x=825, transition=easing.outExpo } )
					--tgrass = transition.to( grassGroup, {time=800, x=0, transition=easing.outExpo } )
					ttitle = transition.to( bg_title, {time=800, x=display.contentWidth / 2+15, transition=easing.outExpo } )
					-- tmount2 = transition.to( bg_mount2, {time=800, x=display.contentWidth / 2-20, transition=easing.outExpo } )
					-- tmount1 = transition.to( bg_mount1, {time=800, x=display.contentWidth / 2+30, transition=easing.outExpo } )
					
			
					----------------------- os Y
					if math.abs(dragDistance) < 50 then
						local dragDistanceY = touch.y - self.touchStartY						
				    	if dragDistanceY < -30 then
				    		audio.play(storyboard.audio.s3,{ channel=2})
				    		transGrass = transition.to( grassGroup, {time=500, y=-300, transition=easing.outExpo } )
				    		transBg = transition.to( bgGroup, {time=500, y=-300/2, transition=easing.outExpo } )
				    	elseif dragDistanceY > 30 then
				    		
				    		transGrass = transition.to( grassGroup, {time=500, y=0, transition=easing.outExpo } )
				    		transBg = transition.to( bgGroup, {time=500, y=0, transition=easing.outExpo } )				    	
				    	end
				    end
			    	------------------

			    	dragDistance = 0
					display.getCurrentStage():setFocus(nil)
					self.isFocus = false
				end
			end
			
	end	
	--bgGroup:addEventListener("touch")


	

	-- klik w logo wysuwa creditsy	 
	function bg_title:tap( event )		 
		if isCreditsOpen == false then
			audio.play(storyboard.audio.s3,{ channel=2})
			if transGrass ~= nil then transition.cancel( transGrass ) end
		    if transBg ~= nil then transition.cancel( transBg ) end
			isCreditsOpen = true
		    transGrass = transition.to( grassGroup, {time=800, y=-420, transition=easing.outExpo } )
			transBg = transition.to( bgGroup, {time=800, y=-300, transition=easing.outExpo } )
		else
			if transGrass ~= nil then transition.cancel( transGrass ) end
		    if transBg ~= nil then transition.cancel( transBg ) end
		    
			isCreditsOpen = false
			transGrass = transition.to( grassGroup, {time=800, y=0, transition=easing.outExpo } )
		    transBg = transition.to( bgGroup, {time=800, y=0, transition=easing.outExpo } )
		end
	end
	bg_title:addEventListener( "tap" )

	

	---konstruktor
	local constructorButton = sheetMenu:newImage("constructor.png")
	constructorButton.x = 950
	constructorButton.y = 990
	function constructorButton:tap(event)
		audio.play(storyboard.audio.s2)		
	    storyboard.gotoScene( "scene_constructor" )
	end
	constructorButton:addEventListener("tap")
	grassGroup:insert(constructorButton)

	-- ########## numer wersji
	local myText = display.newText("v."..storyboard.version, 185, (display.contentHeight - display.screenOriginY) + 6, native.systemFont, 23)
	myText:setTextColor(255, 255, 255)
	grassGroup:insert(myText)

	--############## link do strony www
	local mrLink = display.newRect(40, (display.contentHeight - display.screenOriginY) + 340, 240, 40)
	mrLink:setStrokeColor(140, 140, 140) 
	mrLink.strokeWidth = 1	
	mrLink.isVisible = false
	mrLink.isHitTestable = true
	function mrLink:tap(event)
		audio.play(storyboard.audio.s2)		
	    system.openURL( "http://moonrock.pl" )
	end
	mrLink:addEventListener("tap")
	grassGroup:insert(mrLink)

	--################  warstwa przykrywajaca i robi przejscia
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
	storyboard.analytics.logEvent( "EnterScene_Menu" )
	storyboard.removeScene( "scene_game" )
	--storyboard.removeScene( "scene_levels" )
	--storyboard.removeScene( "scene_splash" )
	storyboard.removeScene( "scene_worlds" )
	--storyboard.removeScene( "scene_extras" )
	storyboard.printMemUsage()

	-- rozjasnienie ekranu
	transition.to( dim, { time=200, alpha=0 } )
	

	if storyboard.settings.music == 1 then	
		audio.setVolume( 1, { channel=1 } )
		audio.play(storyboard.audio.s1, { channel=1, loops=-1, fadein=500 } )	
	end
	

	-- dzwieki
	storyboard.audio.s3 = audio.loadSound("audio/03.mp3")

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


	--- mruganie	
	local blink = function()
		chickenEys:play()		
		blinkTimer._delay = math.random(800, 3500)
	end
	blinkTimer = timer.performWithDelay(1000, blink, -1)

	---jajo
	-- local eggLight = function()		
	-- 	transition.to( bg_egg, { time=1500, delay=0, alpha=0.7, xScale = 1, yScale = 1 } )
	-- 	transition.to( bg_egg, { time=1500, delay=1800, alpha=1, xScale = 1.05, yScale = 1.05 } )
	-- end
	-- eggLight()
	-- timer.performWithDelay(3400, eggLight, -1)


end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	
	-----------------------------------------------------------------------------
	if blinkTimer then timer.cancel( blinkTimer ); end
	Runtime:removeEventListener( "enterFrame", onFrame )

	audio.stop( 2 )
	audio.dispose( storyboard.audio.s3 )
	storyboard.audio.s3 = nil
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)
	
	-----------------------------------------------------------------------------
	

	sheetMenu:dispose()
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