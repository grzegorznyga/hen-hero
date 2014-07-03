local SheetHelper = {}
local metatable = { __index = SheetHelper }

function SheetHelper.new(name)	-- constructor
	
	local device = system.getInfo("model"):lower()

	local set = 
	{		 
		name = name,
		options = require("sprites."..name),
		data = graphics.newImageSheet( "sprites/"..name..".png", require("sprites."..name) ),
	}
	
	return setmetatable( set, metatable )	
end

function SheetHelper:newImage(fileName) 
	local index = self.options.frameIndex[fileName]

	return display.newImageRect( self.data, index, self.options.frames[index].width, self.options.frames[index].height)
end	

function SheetHelper:index(fileName) 
	return self.options.frameIndex[fileName]
end	

function SheetHelper:dispose() 
	self.data = nil
	collectgarbage( "collect" )
	--print("sheet dispose")
end



return SheetHelper