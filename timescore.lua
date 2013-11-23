local json = require("json")
 
function loadScore()
	local baseFile = system.pathForFile( "timeScore.json", system.DocumentsDirectory)
 	local scorecontents = ""
 	local scoreArray = {}
 	local scoreFile = io.open( baseFile, "r" )
	if scoreFile then
		local scorecontents = scoreFile:read( "*a" )
		scoreArray = json.decode(scorecontents);
		io.close( scoreFile )
        return scoreArray
	end

	return timeScore
 end
 
function saveScore()
    local baseFile = system.pathForFile( "timeScore.json", system.DocumentsDirectory)
    local scoreFile = io.open(baseFile, "w")
    local scorecontents = json.encode(timeScore)
    scoreFile:write( scorecontents )
	io.close( scoreFile )
end