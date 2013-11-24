-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "storyboard" module
local storyboard = require "storyboard"

local gameNetwork = require "gameNetwork"
local loggedIntoGC = false

-- called after the "init" request has completed
local function initCallback( event )
    if event.data then
        loggedIntoGC = true
        print( "Success!", "User has logged into Game Center", { "OK" } )
    else
        loggedIntoGC = false
        print( "Fail", "User is not logged into Game Center", { "OK" } )
    end
end

-- function to listen for system events
local function onSystemEvent( event ) 
    if event.type == "applicationStart" then
        gameNetwork.init( "gamecenter", initCallback )
        return true
    end
end

Runtime:addEventListener( "system", onSystemEvent )

-- load menu screen
storyboard.gotoScene( "mainMenu")