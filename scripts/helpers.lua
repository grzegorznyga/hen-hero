local M = {}

--zaasoby
M.newImageDevice = function (fileName)
	local device = system.getInfo("model")
	local assets =
	{
		--["images/bg.png"] = { iPad = {1024, 768}, iPhone = {480, 320} },
		--["Default-Landscape.png"] = { iPad = {1024, 768}, iPhone = {480, 320} },
		
		
		["images/bg_fail.png"] = { iPad = {1024, 768}, iPhone = {480, 320} },
		["images/bg_win.png"] = { iPad = {1024, 768}, iPhone = {480, 320} },
		["images/bg_popup.png"] = { iPad = {822, 492}, iPhone = {480, 320} },
		
	}

	return display.newImageRect( fileName, assets[fileName][device][1],assets[fileName][device][2] )
end

M.indexFromSheet = function(sheet,fileName) 
	return sheet.options.frameIndex[fileName]
end	

M.imageFromSheet = function(sheet,fileName) 
	local index = sheet.options.frameIndex[fileName]

	return display.newImageRect( sheet.data, index, sheet.options.frames[index].width, sheet.options.frames[index].height)
end	

M.sizeForDevice = function(iphone,ipad)
	return system.getInfo("model") == "iPhone" and iphone or ipad
end

return M

-- package.loaded["myModule"] = nil
-- collectgarbage("collect")
-- http://developer.coronalabs.com/forum/2011/04/20/everything-you-need-know-about-lua-modules
-- http://www.coronalabs.com/blog/2011/09/05/a-better-approach-to-external-modules/