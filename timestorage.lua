local json = require("json")
 
function loadTime()
	local base = system.pathForFile( "time.json", system.DocumentsDirectory)
 	local jsoncontents = ""
 	local timeArray = {}
 	local file = io.open( base, "r" )
	if file then
		local jsoncontents = file:read( "*a" )
		timeArray = json.decode(jsoncontents);
		io.close( file )
        return timeArray
	end

	return timeLimit
 end
 
function saveTime()
    local base = system.pathForFile( "time.json", system.DocumentsDirectory)
    local file = io.open(base, "w")
    local jsoncontents = json.encode(timeLimit)
    file:write( jsoncontents )
	io.close( file )
end