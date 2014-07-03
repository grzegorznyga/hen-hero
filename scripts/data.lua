local json = require("json")
 
local function saveTable(t, filename)
    local path = system.pathForFile( filename, system.DocumentsDirectory)
    local file = io.open(path, "w")
    if file then
        local contents = json.encode(t)
        file:write( contents )
        io.close( file )
        return true
    else
        return false
    end
end
 
local function loadTable(filename)
    local path = system.pathForFile( filename, system.DocumentsDirectory)
    local contents = ""
    local myTable = {}
    local file = io.open( path, "r" )
    if file then
        -- read all contents of file into a string
        local contents = file:read( "*a" )
        myTable = json.decode(contents);
        io.close( file )
        return myTable
    end
    return nil
end

local M = {}

M.levelsListFileName = "_scores.json"
M.settingsFileName = "settings.json"

M.save = function(t, filename)
    return saveTable(t, filename)
end

M.load = function(filename)
    return loadTable(filename)
end

--## USTAWIENIA
M.saveSettings = function(t)   
    return saveTable(t,M.settingsFileName)
end
M.loadSettings = function()    
    return loadTable(M.settingsFileName)
end

--## LISTA WYNIKOW

-- zapisz liste wynikow
M.saveScoresList = function(t, world)   
    return saveTable(t, world..M.levelsListFileName)
end

-- wgraj liste wynikow
M.loadScores = function(world)    
    return loadTable(world..M.levelsListFileName) or {}
end

-- wgraj wynik
M.loadScore = function(world, level)
    local t = loadTable(world..M.levelsListFileName) or {}
    return t[level]
end

-- zapisz wynik
M.saveScore = function(t, world, level, stars, highscore)

    if t == nil then
        t = M.loadScores(world)       
    end

    t[level] = {
        stars = stars,
        highscore = highscore
    }    

    return M.saveScoresList(t, world)
end

-- liczba wszystkich gwiazd
M.totalStars = function(world)    
    
    local stars = 0
    local t = M.loadScores(world) 

    for i=1,#t do
        if t[i].stars ~= nil then
            stars = stars + t[i].stars
        end
    end

    return stars
end

return M
