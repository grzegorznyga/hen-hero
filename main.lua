-- function declare (name, initval)
--       rawset(_G, name, initval or false)
--    end        

--    setmetatable(_G, {
--    __newindex = function(_ENV, var, val)
--      if var ~= "tableDict" then
--        error(("attempt to set undeclared global\"%s\""):format(tostring(var)), 2)
--      else
--        rawset(_ENV, var, val)
--      end
--    end,      

--    __index = function(_ENV, var, val)
--      if var ~= "tableDict" then
--        error(("attempt to read undeclared global\"%s\""):format(tostring(var)), 2)        else
--        rawset(_ENV, var, val)
--      end     
--    end,
--    })

-- local filePath = "some/sound.wav"
-- local sound = audio.loadSound(soundName)
-- if audio.play(sound, {onComplete = function ( event )
--         audio.dispose(event.handle)
--         event.handle = nil
-- end}) == 0 then print("didn't play sound:" .. filePath) end

display.setStatusBar( display.HiddenStatusBar )

-- constants
-- STAGE_WIDTH = display.contentWidth + display.screenOriginX * -2
-- STAGE_HEIGHT = display.contentHeight + display.screenOriginY * -2
-- HALF_WIDTH = display.contentWidth / 2
-- HALF_HEIGHT = display.contentHeight / 2

-- print(display.contentWidth)
-- print(display.screenOriginX)
-- print(display.viewableContentWidth)
-- print(display.viewableContentHeight)
-- print(display.pixelWidth)
-- print(display.pixelHeight)
-- print(display.screenOriginY)


--- FLURRY
--Your unique application key is: TFCSFK9DV26QJDGHV8MZ

-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
audio.reserveChannels(2)

local analytics = require "analytics" 
analytics.init("TFCSFK9DV26QJDGHV8MZ")

local storyboard = require "storyboard"
storyboard.analytics = analytics
storyboard.isDebug = false
storyboard.version = "1.0.9"
storyboard.settings = {}
storyboard.settings.music = 1
storyboard.audio = {}
storyboard.worldNumber = 1
storyboard.levelNumber = 1
storyboard.map = {}

local options =
{
    effect = "zoomInOutFade",
    time = 800
}
-- load scenetemplate.lua
--storyboard.gotoScene( "scene_game" )
storyboard.gotoScene( "scene_splash", options )
--storyboard.gotoScene( "scene_levels" )
--storyboard.gotoScene( "scene_test" )
--storyboard.gotoScene( "scene_constructor" )

-- Add any objects that should appear on all scenes below (e.g. tab bar, hud, etc.):