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
local dataLevels = require("scripts.data_levels")

-- local
local sheetMenu
local pager
local currentPageDot
local slideView
local dim
local onFrame

-- local background
-- local backgroundLayerTop
local myImages
local header
local slide

local buttonBack



local bg_sky, bg_top
local bg_cloud1
local bg_cloud2
local bg_cloud3
local bg_cloud4
-- local bg_mount1
-- local bg_mount2
local bg_grass

-- local bg_egg
-- local bg_chicken
-- local chickenEys

-- local blinkTimer

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-----------------------------------------------------------------------------
		
	--	CREATE display objects and add them to 'group' here.
	--	Example use-case: Restore 'group' from previously saved state.
	
	-----------------------------------------------------------------------------

	sheetMenu = sheetHelper.new("menu")

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

	group:insert(bgGroup)

	header = sheetMenu:newImage("world_1_txt.png")
	header.x = display.contentWidth / 2
	header.y = 100
	group:insert( header )


	-- wgraj liste wynikow
	local world = storyboard.worldNumber
	local levelsList = dataLevels.loadLevels(world)
	local userLevelScores = data.loadScores(world)
	--doaj puste jajo dla odblokowania nastepnego levelu
	userLevelScores[#userLevelScores + 1] = {}


	local pages = math.ceil(#levelsList / 12)

	------- pager
	pager = display.newGroup()
	
	for i=1,pages do
		local dot = sheetMenu:newImage("dot_page.png")
		dot.x = 25 * (i-1)
		pager:insert(dot)
	end

	pager:setReferencePoint(display.CenterReferencePoint)
	pager.x = display.contentWidth/2
	pager.y = 740
	group:insert( pager )

	-- aktualna strona kropka
	currentPageDot = sheetMenu:newImage("dot_page_current.png")
	currentPageDot.x = pager[1].x
	currentPageDot.y = pager[1].y
	pager:insert( currentPageDot )

	----- slider
	slideView = display.newGroup()

	local view1 = display.newRect(0, 0, display.contentWidth*pages, 650)
	view1:setReferencePoint(display.CenterLeftReferencePoint);
	view1.x = 0
	view1.y = 470	
	--view1:setFillColor( 185, 231, 40, 200 ) --debug
	view1.isVisible = false
	view1.isHitTestable = true
	slideView:insert(view1)	

	-- #################################################
	-- dodac jajka
	--print("ile:"..#userLevelScores)
	--print(math.floor((#userLevelScores-1)/12)) 
	local levelX = 130
	local levelY = 257
	for i=1,#levelsList do

		local level = display.newGroup()
		local border = sheetMenu:newImage("level_border.png")		
		
		local egg 		
		if userLevelScores[i] ~= nil then
			egg = display.newGroup()

			local eggBg = sheetMenu:newImage("level_egg_full.png")

			local star1 = sheetMenu:newImage("level_star1.png")
			star1.x = -1
			star1.y = -23
			star1.alpha = .3

			local star2 = sheetMenu:newImage("level_star1.png")
			star2.x = -20
			star2.y = 12
			star2.xScale, star2.yScale = .85, .85
			star2.rotation = -15
			star2.alpha = .3

			local star3 = sheetMenu:newImage("level_star1.png")
			star3.x = 15
			star3.y = 20
			star3.xScale, star3.yScale = .65, .65
			star3.rotation = 22
			star3.alpha = .3

			-- bonusowe gwiazdki
			if userLevelScores[i].stars ~= nil then
				if userLevelScores[i].stars >= 1 then star1.alpha = 1 end
				if userLevelScores[i].stars >= 2 then star2.alpha = 1 end
				if userLevelScores[i].stars >= 3 then star3.alpha = 1 end
			end

			egg:insert(eggBg)
			egg:insert(star1)
			egg:insert(star2)
			egg:insert(star3)
		else
			egg = sheetMenu:newImage("level_egg_empty.png")
		end

		local number = sheetMenu:newImage("level"..i..".png")
		number.x = 41
		number.y = 44
		
		level:insert( border )
		level:insert( egg )
		level:insert( number )

		level.number = i
		level.x = levelX - 10
		level.y = levelY

		levelX = levelX + 175
		--print(levelY)
		-- co 4 zmiana rzedu
		if i % 4 == 0 then
			if levelY == 257 then
				levelY = 430
				levelX = levelX - 175 * 4
			elseif levelY == 430 then
				levelY = 603
				levelX = levelX - 175 * 4
			else 
				levelY = 257
				levelX = levelX + 69
			end
		end

		function level:tap( event )		 
			audio.play( storyboard.audio.s2 )  

			dim.isHitTestable = false
			transition.to( dim, { time=200, alpha=1, onComplete = 				
				function() 
					storyboard.levelNumber = self.number
					storyboard.gotoScene( "scene_loading_level" )
				end } )

			transition.to(self,{time=200,xScale = 6, yScale = 6, alpha = 0})

			-- local options =
			-- {
			-- 	effect = "fade",
	  --   		time = 200,				    
			--     params = { levelNumber = self.number }
			-- }
			-- storyboard.gotoScene( "scene_loading_level", options )
		    --storyboard.gotoScene( "scene_game", { params={ levelNumber = self.number } } )

		    audio.fadeOut({ channel=1, time=300 } )
		    self:removeEventListener( "tap" )
		end

		if userLevelScores[i] ~= nil then
			level:addEventListener( "tap" )
		end

		slideView:insert(level) 
	end
	-- ####################################################
	local transitionSlideView

	local panelIndx = 0	
	local currentX = 0 
	local touchStartX = 0
	local function touchListener (self, touch) 
			if touch.phase == "began" then				
				display.getCurrentStage():setFocus( self )
            	self.isFocus = true

				touchStartX = touch.x
				currentX = slideView.x

				if transitionSlideView ~= nil then transition.cancel( transitionSlideView ) end

			elseif self.isFocus then        
				if touch.phase == "moved" then

					local dragDistance = touch.x - touchStartX					
					slideView.x = currentX + dragDistance 	
								
				elseif touch.phase == "ended" or touch.phase == "cancelled" then

					local dragDistance = touch.x - touchStartX

					if dragDistance < -30 then
						if panelIndx < pages-1 then						
							panelIndx = panelIndx +1
							currentPageDot.x = pager[panelIndx+1].x
							currentPageDot.y = pager[panelIndx+1].y
						end						
					elseif dragDistance > 30 then
						if panelIndx > 0 then 
							panelIndx = panelIndx -1
							currentPageDot.x = pager[panelIndx+1].x
							currentPageDot.y = pager[panelIndx+1].y
						end																	
					end
					currentX = -display.contentWidth*panelIndx
					transitionSlideView = transition.to( slideView, {time=1500, x=currentX, transition=easing.outExpo } )
					display.getCurrentStage():setFocus(nil)
					self.isFocus = false
				end
			end
			
	end
	slideView.touch = touchListener
	slideView:addEventListener("touch")

	group:insert( slideView )

	--ustaw strone
	panelIndx = math.floor((#userLevelScores-1)/12)
	currentPageDot.x = pager[panelIndx+1].x
	currentPageDot.y = pager[panelIndx+1].y
	currentX = -display.contentWidth*panelIndx
	slideView.x = currentX



	-- bg_chicken = sheetMenu:newImage("bck_kura.png")
	-- bg_chicken.x = 608 --308
	-- bg_chicken.y = 850 --499
	-- group:insert( bg_chicken )

	-- local sequenceData = {
	--     name="blink",
	--     start=sheetMenu.options.frameIndex["kura_oczy_00.png"],
	--     count=3,
	--     time=140,        -- Optional. In ms.  If not supplied, then sprite is frame-based.
	--     loopCount = 1,   -- Optional. Default is 0 (loop indefinitely)
	--     loopDirection = "bounce"    -- Optional. Values include: "forward","bounce"
	-- }
	-- chickenEys = display.newSprite( sheetMenu.data, sequenceData )
	-- chickenEys.x = 872
	-- chickenEys.y = 519
	-- group:insert( chickenEys )
	-- chickenEys:play()

	-- bg_egg = sheetMenu:newImage("bck_jajo.png")
	-- bg_egg.x = 590
	-- bg_egg.y = 710
	-- group:insert( bg_egg )

	bg_grass = sheetMenu:newImage("credits_bck.png")
	bg_grass.x = display.contentWidth / 2
	bg_grass.y = (display.contentHeight - display.screenOriginY) + 90
	group:insert( bg_grass )



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
				function() storyboard.gotoScene( "scene_worlds" ) end --scene_menu
				 } )			

			display.getCurrentStage():setFocus(nil)
		end

		return true
	end
	buttonBack:addEventListener("touch")
	group:insert( buttonBack )

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
	storyboard.analytics.logEvent( "EnterScene_Levels_W"..storyboard.worldNumber )

	--storyboard.removeScene( "scene_menu" )
	storyboard.removeScene( "scene_worlds" )
	

	-- rozjasnienie ekranu
	transition.to( dim, { time=200, alpha=0 } )

	-- chmury
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
	-- local blink = function()
	-- 	chickenEys:play()		
	-- 	blinkTimer._delay = math.random(800, 3500)
	-- end
	-- blinkTimer = timer.performWithDelay(1000, blink, -1)

	storyboard.printMemUsage()
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	
	-----------------------------------------------------------------------------	
	

	--if blinkTimer then timer.cancel( blinkTimer ); end

	Runtime:removeEventListener( "enterFrame", onFrame )
	--storyboard.removeAll()
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)
	
	-----------------------------------------------------------------------------
	--sheetMenu:dispose()
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