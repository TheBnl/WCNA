local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"


-- particle room draw
 
-- http://alienryderflex.com/polygon/
-- http://alienryderflex.com/polygon_fill/
 
 
-- turn off status display bar
display.setStatusBar(display.HiddenStatusBar)
 
-- library loading
require("displayex")
require("mathlib")
 
-- groups
local background, fill, outline, dottop = display.newGroup(), display.newGroup(), display.newGroup(), display.newGroup()
 
-- background
display.newRect(background, 0,0,display.contentWidth,display.contentHeight):setFillColor(255,255,255)
 
-- DISPLAY VALUES - change these values to alter the display
-- widthheight: the size of either a filled row (isperpixel=false) or a filled pixel (isperpixel=true)
-- isclosed: true to fill the surrounding area outside the polygon, false to fill the polygon
-- isperpixel: true to fill each pixel on each row separately, false to fill each row in one color (faster)
local widthheight, isclosed, isperpixel = 1, false, false
 
 

 
local dot = nil
function scene:createScene( event )
        
         
         
                -- werkend voorbeeld!
                -- points tabel nodig
                local points = {10,10,200,10,10,200,10,10}

                local line = display.newLine( points[1],points[2], points[3],points[4] )
                line:append( points[5],points[6], points[1],points[2] )

                local p = polygonFill( table.listToNamed(points,{'x','y'}), isclosed, isperpixel, widthheight, widthheight, {0,0,0} )
                fill:insert(p)

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
        local group = self.view
        
        -- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
        
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
        local group = self.view
        
        -- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
        
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
        local group = self.view

end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene