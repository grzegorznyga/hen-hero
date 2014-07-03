--stan gry
local helpers = require("scripts.helpers")

local _M = {}

_M.turns = 0
_M.status = "ready"
_M.cellSize = 85
_M.eggSpeed = 5
_M.eggOnMove = false
_M.bonus = 0  -- ile jajek zebrano
_M.bonusCounter = 0  -- liczy ile jajek jest na planszy
_M.size = "normal" -- normal/long(-64)/longer (-169.5)

_M.bumperTimers = {}

function _M:new()
	self.turns = 0
	self.status = "ready"
	self.cellSize = 85
	self.eggSpeed = 5
	self.eggOnMove = false
	self.bonus = 0
	self.bonusCounter = 0

	-- tablica z zwrotnicami
	self.bumperTimers = {}

	-- rizmiar ekranu
	self.size = "normal"
	if display.screenOriginY < -60 then  self.size = "long" end
	if display.screenOriginY < -100 then  self.size = "longer" end

	--- dzwieki
	self.audio = {}	
	self.audio.s2 = audio.loadSound("audio/02.wav")
	self.audio.s4 = audio.loadStream("audio/04.mp3")
	self.audio.s5 = audio.loadStream("audio/05.mp3")
	self.audio.s6 = audio.loadSound("audio/06.mp3")
	self.audio.s7 = audio.loadSound("audio/07.mp3")
	self.audio.s8 = audio.loadSound("audio/08.mp3")
	self.audio.s9 = audio.loadSound("audio/09.mp3")
	self.audio.s10 = audio.loadSound("audio/10a.wav")
	self.audio.s11 = audio.loadSound("audio/11.mp3")
	self.audio.s12 = audio.loadSound("audio/12.wav")
	self.audio.s13 = audio.loadSound("audio/13.wav")
	self.audio.s14 = audio.loadSound("audio/14.wav")
	self.audio.s17 = audio.loadSound("audio/17.wav")
	self.audio.s18 = audio.loadSound("audio/18.mp3")
	self.audio.s19 = audio.loadSound("audio/19.mp3")
	self.audio.s20 = audio.loadSound("audio/20.mp3")
	self.audio.s21 = audio.loadSound("audio/21.mp3")
	self.audio.s22 = audio.loadSound("audio/22.wav")
	self.audio.s23 = audio.loadSound("audio/14.wav")
end

function _M:addBumperTimer(myTimer)
	table.insert(self.bumperTimers, myTimer)	
end

function _M:pauseBumperTimers()
	for i=1,#self.bumperTimers do
        self.bumperTimers[i]:pause()
    end
end

function _M:reasumeBumperTimers()
	for i=1,#self.bumperTimers do
        self.bumperTimers[i]:resume()
    end
end

function _M:freeMemory()	
	audio.dispose(self.audio.s2)
	self.audio.s2 = nil
	audio.dispose(self.audio.s4)
	self.audio.s4 = nil
	audio.dispose(self.audio.s5)
	self.audio.s5 = nil
	audio.dispose(self.audio.s6)
	self.audio.s6 = nil
	audio.dispose(self.audio.s7)
	self.audio.s7 = nil
	audio.dispose(self.audio.s8)
	self.audio.s8 = nil
	audio.dispose(self.audio.s9)
	self.audio.s9 = nil
	audio.dispose(self.audio.s10)
	self.audio.s10 = nil
	audio.dispose(self.audio.s11)
	self.audio.s11 = nil
	audio.dispose(self.audio.s12)
	self.audio.s12 = nil
	audio.dispose(self.audio.s13)
	self.audio.s13 = nil
	audio.dispose(self.audio.s14)
	self.audio.s14 = nil
	audio.dispose(self.audio.s17)
	self.audio.s17 = nil
	audio.dispose(self.audio.s18)
	self.audio.s18 = nil
	audio.dispose(self.audio.s19)
	self.audio.s19 = nil
	audio.dispose(self.audio.s20)
	self.audio.s20 = nil
	audio.dispose(self.audio.s21)
	self.audio.s21 = nil
	audio.dispose(self.audio.s22)
	self.audio.s22 = nil
	audio.dispose(self.audio.s23)
	self.audio.s23 = nil

	self.audio = nil
end
	
return _M