local game = require("scripts.game")
local helpers = require("scripts.helpers")
local tnt = require("scripts.transitions_manager")
local sheetHelper = require("scripts.sheet_helper")
local sheetGame1 = sheetHelper.new("interface")

local Bumper = {}
local Bumper_mt = { __index = Bumper }

function Bumper.new(params)	-- constructor
	 
	return setmetatable({
			x=params.x or 0,
			y=params.y or 0,
			rotation = params.rotation or 0,
			flat = nil,
			display = nil,
			displayFront = nil,
			displayGrass = nil,
			isMove = true,
			type = params.type or "tap",
			autoTimer = nil
		},
		Bumper_mt)
end

function Bumper:isCollision(egg)
	--------------------------------optymalizacja
	local objectX, objectY = self.display.x, self.display.y
	local objectDirectionX, objectDirectionY = self.display.xdirection, self.display.ydirection
	local eggX, eggY, eggOrientation = egg.x, egg.y, egg.orientation
	local eggDirectionX, eggDirectionY = egg.xdirection, egg.ydirection

	----------------------------------- czujniki
	local x,y = eggX,eggY
	local range = 0
	--print(objectX .. "x" .. objectY)
	-------------------------------czujnik blokowania obrotu
	if self.type == "tap" or self.type == "auto" then -- wylaczam czujnik dla zamarznietych
		range = 80
		local pointDirection = (self.display.isMove) and 1 or -1
		if eggOrientation == 1 then 
			x = eggX + range * eggDirectionX * pointDirection
		else 
			y = eggY + range * eggDirectionY * pointDirection
		end 

		if x == objectX and y == objectY then -- zablokuj
			if self.display.isMove  then				
				self.display.isMove = false
				if self.type == "auto" then game:pauseBumperTimers() end
				--print("BLOK")
			else				
				self.display.isMove = true
				if self.type == "auto" then game:reasumeBumperTimers() end
				--print("NIE BLOK")
			end
		end
	end

	-------------------------------czyjnik na  sciane zwrotnicy
	range = 80
	if eggOrientation == 1 then 
		x = eggX + range * eggDirectionX
	else 
		y = eggY + range * eggDirectionY
	end 

	if egg.sequence == "normal" and x == objectX and y == objectY then -- odbij

		if eggOrientation == 1 and eggDirectionX == self.display.xdirection then
			egg:crash()

			return true
		elseif eggOrientation == -1 and eggDirectionY == self.display.ydirection then
			egg:crash()
			
			return true
		end
	end

	-------------------------------czyjnik na osbicie dla specjalnego jajka
	range = 75
	if eggOrientation == 1 then 
		x = eggX + range * eggDirectionX
	else 
		y = eggY + range * eggDirectionY
	end 

	if egg.sequence == "strong" and x == objectX and y == objectY then -- odbij

		if eggOrientation == 1 and eggDirectionX == self.display.xdirection then
			egg:bump(true)
			return true
		elseif eggOrientation == -1 and eggDirectionY == self.display.ydirection then
			egg:bump(true)
			return true
		end
		
	end

	---------------------czujnik na obracanie jaja na zakrecie
	local r = egg.rotation
	range = 30
	if eggOrientation == 1 then 
		x = eggX + range * eggDirectionX
	else
		y = eggY + range * eggDirectionY
	end

	if x == objectX and y == objectY then -- zakret
		audio.play(game.audio.s17)
		--print("###### zakret")
		egg.isNormalRotate = true --falga czy jajko sie obrucilo
		if eggOrientation == 1  then --lewo prawo
			tnt:newTransition( egg, { time=110, rotation=r-(90*objectDirectionY*objectDirectionX) } )
			return true
		else --góra dol
			tnt:newTransition( egg, { time=110, rotation=r+(90*objectDirectionY*objectDirectionX) } )
			return true
		end
	end

	---------------------czujnik na obracanie jaja na zakrecie SZYBSZE np jesli obok jest siano
	--- tylko gdy nie wykryto normalnego zawracania
	if(egg.isNormalRotate == nil) then
		local r = egg.rotation
		range = 5
		if eggOrientation == 1 then 
			x = eggX + range * eggDirectionX
		else
			y = eggY + range * eggDirectionY
		end

		if x == objectX and y == objectY then -- zakret
			audio.play(game.audio.s17)
			--print("###### zakret SZYBSZE")			
			if eggOrientation == 1  then --lewo prawo
				tnt:newTransition( egg, { time=80, rotation=r-(90*objectDirectionY*objectDirectionX) } )
				return true
			else --góra dol
				tnt:newTransition( egg, { time=80, rotation=r+(90*objectDirectionY*objectDirectionX) } )
				return true
			end
		end
	end

	----------------------------- czujnik na zmiane kierunku
	
	x,y = eggX,eggY

	if x == objectX and y == objectY then -- zmiana kierunku
		egg.isNormalRotate = nil
		if eggOrientation == 1  then --lewo prawo
			egg.yspeed = game.eggSpeed
			egg.xspeed = 0
			egg.orientation = -1
			egg.xdirection = self.display.xdirection
			egg.ydirection = self.display.ydirection
			game:increaseTurns()
			return true			
		else --góra dol
			egg.yspeed = 0
			egg.xspeed = game.eggSpeed
			egg.orientation = 1
			egg.xdirection = self.display.xdirection
			egg.ydirection = self.display.ydirection
			game:increaseTurns()
			return true			
		end
	end
end

local function setDirection(self)
	if(self.rotation == 0) then
		self.xdirection = -1		
		self.ydirection = 1
	elseif(self.rotation == 90) then	
		self.xdirection = -1	
		self.ydirection = -1	
	elseif(self.rotation == 180) then
		self.xdirection = 1	
		self.ydirection = -1	
	elseif(self.rotation == 270) then
		self.xdirection = 1
		self.ydirection = 1			
	elseif(self.rotation == 360) then
		self.xdirection = -1
		self.ydirection = 1
		self.rotation = 0	
	end
end

local function setDirectionNext(bumper)

	local rotation = bumper.rotation+90	

	if(rotation == 0) then
		bumper.xdirection = -1		
		bumper.ydirection = 1
	elseif(rotation == 90) then	
		bumper.xdirection = -1	
		bumper.ydirection = -1	
	elseif(rotation == 180) then
		bumper.xdirection = 1	
		bumper.ydirection = -1	
	elseif(rotation == 270) then
		bumper.xdirection = 1
		bumper.ydirection = 1			
	elseif(rotation == 360) then		
		bumper.xdirection = -1
		bumper.ydirection = 1			
	end
end

function Bumper:display()

	local bumper = nil
	local flat = nil
	local grass = nil

	if self.type == "freez" then
		bumper = sheetGame1:newImage("switch_freez_top.png")		
		bumper.xReference = 0
		bumper.yReference = 0
		bumper.rotation = self.rotation
		bumper.x = self.x
		bumper.y = self.y

		flat = sheetGame1:newImage("switch_freez.png")		
		flat.xReference = 0
		flat.yReference = 0
		flat.rotation = self.rotation
		flat.x = self.x
		flat.y = self.y

		grass = sheetGame1:newImage("switch_freez_grass.png")		
		grass.xReference = 0
		grass.yReference = 0
		grass.rotation = self.rotation
		grass.x = self.x
		grass.y = self.y

	elseif self.type == "auto" then
		bumper = sheetGame1:newImage("switch_auto_top.png")		
		bumper.xReference = 0
		bumper.yReference = 0
		bumper.rotation = self.rotation
		bumper.x = self.x
		bumper.y = self.y

		flat = sheetGame1:newImage("switch_auto.png")		
		flat.xReference = 0
		flat.yReference = 0
		flat.rotation = self.rotation
		flat.x = self.x
		flat.y = self.y
	else
		bumper = sheetGame1:newImage("switch_top.png")		
		bumper.xReference = 1
		bumper.yReference = -1
		bumper.rotation = self.rotation
		bumper.x = self.x
		bumper.y = self.y

		flat = sheetGame1:newImage("switch.png")		
		flat.xReference = 0
		flat.yReference = 0
		flat.rotation = self.rotation
		flat.x = self.x
		flat.y = self.y
	end 
	
	bumper.onRotation = false
	bumper.isMove = self.isMove --blokuje zwrotnice
	setDirection(bumper)

	local bumper_shadow = sheetGame1:newImage("switch_s.png")
	bumper_shadow.xReference = -19
	bumper_shadow.yReference = 17
	bumper_shadow.x = self.x 
	bumper_shadow.y = self.y 
	bumper_shadow.rotation = self.rotation
	--bumper_shadow.isVisible = false


	self.displayGrass = grass
	self.display = bumper
	self.flat = flat
	self.displayFront = bumper_shadow



	--- obracanie po tapnieciu
	if self.type == "tap" then
		function bumper:touch(event)
			--if event.phase == "began" and self.isMove then
				--audio.play(game.audio.s6)
			if event.phase == "began" and self.onRotation == false and self.isMove then	
				audio.play(game.audio.s6)
				self.onRotation = true
				--obracanie
				local onCompleteAnimation = function( bumper )			   
					self.onRotation = false
					if bumper.rotation == 360 then bumper.rotation = 0 end
				end			
				--self:removeEventListener("touch", self)
				setDirectionNext(bumper)

				transition.to(self, { time=80, rotation=self.rotation+90, onComplete=onCompleteAnimation})
				transition.to( flat, { time=80, rotation=flat.rotation+90} )
				transition.to( bumper_shadow, { time=80, rotation=bumper_shadow.rotation+90} )

			end	
			return true
		end

		bumper:addEventListener("touch")
	end

	-- obracanie automatyczne
	if self.type == "auto" then

		function bumper:touch(event)
			if event.phase == "began" then
				audio.play(game.audio.s8)
			end	
			return true
		end
		bumper:addEventListener("touch")

		local function autoRotate( event )
		    if bumper.onRotation == false or bumper.isMove then	
				bumper.onRotation = true
				--obracanie
				local onCompleteAnimation = function( bumper )			   
					bumper.onRotation = false
					if bumper.rotation == 360 then bumper.rotation = 0 end
				end			
				--self:removeEventListener("touch", self)
				setDirectionNext(bumper)
				--print("--- oo ---")

				transition.to( bumper, { time=80, rotation=bumper.rotation+90, onComplete=onCompleteAnimation})
				transition.to( flat, { time=80, rotation=flat.rotation+90} )
				transition.to( bumper_shadow, { time=80, rotation=bumper_shadow.rotation+90} )

			end	
		end
		--self.autoTimer = tnt:newTimer(1000, autoRotate, 0)
		game:addBumperTimer(tnt:newTimer(1500, autoRotate, 0))
	end

	if self.type == "freez" then
		function bumper:touch(event)
			if event.phase == "began" then
				audio.play(game.audio.s7)
			end	
			return true
		end
		bumper:addEventListener("touch")
	end


	
end

return Bumper