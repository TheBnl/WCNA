-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- create a group for the background grid lines
local grid = display.newGroup()

-- create a group for the blocks
local blocksGroup = display.newGroup()

-- grid square width and height variables
local gridWidth = (320/9)
local gridHeight = (568/15)

display.setDefault( "background", 255, 255, 255 )

-- blocks table
local blocks = {
		{ name="tT", posX=3, posY=3,  width=3, height=1, display=false, neighbours= { "tL", "tR" } },
		{ name="tL", posX=2, posY=4,  width=1, height=1, display=false, neighbours= { "tT", "cT" } },
		{ name="tR", posX=6, posY=4,  width=1, height=1, display=false, neighbours= { "tT", "cT" } },
		{ name="cT", posX=3, posY=5,  width=3, height=1, display=false, neighbours= { "tL", "tR", "cL", "cR" } },
		{ name="cL", posX=2, posY=6,  width=1, height=3, display=false, neighbours= { "cT", "cB" } },
		{ name="cR", posX=6, posY=6,  width=1, height=3, display=false, neighbours= { "cT", "cB" } },
		{ name="cB", posX=3, posY=9,  width=3, height=1, display=false, neighbours= { "cL", "cR", "bL", "bR" } },
		{ name="bL", posX=2, posY=10, width=1, height=1, display=false, neighbours= { "cB", "bB" } },
		{ name="bR", posX=6, posY=10, width=1, height=1, display=false, neighbours= { "cB", "bB" } },
		{ name="bB", posX=3, posY=11, width=3, height=1, display=false, neighbours= { "cL", "cR" } },
    }

-- blocks teken functie
local function newBlock( )
	local midRect = display.newRect( 
		-- position
		( gridWidth  * 0 ),
		( gridHeight * 0 ),
		-- size
		( gridWidth  * 3 ),
		( gridHeight * 1 )
		)
end


-- blocks touch event
local function myTouchListener( event )

    if ( event.phase == "began" and event.target.display == false ) then

        print( "object neighbours = ", event.target.neighbours )  --'event.target' is the touched object
        print( "display = ", event.target.display )
        print( "name = ", event.target.name )
       
    	event.target.display = true

        transition.to( event.target, { time=150, alpha=1.0, transition=easing.outQuad } )

        addCorners( event.target )
	
    elseif ( event.phase == "began" and event.target.display == true ) then

		print( "display = ", event.target.display )

		event.target.display = false

		transition.to( event.target, { time=150, alpha=0.0, transition=easing.outQuad } )
    	--event.target.alpha = 0

    end
    return true  --prevents propagation to underlying objects
end


function addCorners( eventTarget )
	print(eventTarget.name)

		if ( eventTarget.name == "centerTop" or eventTarget.name == "centerBottom" ) then

			transition.to(eventTarget, { time=0, x=eventTarget.posX + ( eventTarget.width/2 ) , width=eventTarget.width + ( gridWidth * 2 ) } )

		end
end

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
	
	-- go to level1.lua scene
	storyboard.gotoScene( "level1", "fade", 500 )
	
	return true	-- indicates successful touch
end

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )

	-- vertical grid lines
	for i = 1, 9 do
		if ( i == 1 or i == 4 or i == 5 or i == 8 or i == 9 ) then 
			-- skip it
		else
			local line = display.newLine( gridWidth*i,0, gridWidth*i,568 )
			line:setColor( 0, 0, 0)
			line.width = 1
			grid:insert( line )
		end
	end

	-- horizontal grid lines
	for i = 1, 15 do
		if ( i == 1 or i == 2 or i == 7 or i == 8 or i == 13 or i == 14 or i == 15 ) then 
			-- skip it
		else
			local line = display.newLine( 0,gridHeight*i, 320,gridHeight*i )
			line:setColor( 0, 0, 0)
			line.width = 1
			grid:insert( line )
		end
	end

	-- for loop for placing the blocks
	for i=1,#blocks do


        local rect = display.newRect( 
		-- position
		( gridWidth  * blocks[i].posX ),
		( gridHeight * blocks[i].posY ),
		-- size
		( gridWidth  * blocks[i].width ),
		( gridHeight * blocks[i].height )
		)

        rect.name = blocks[i].name
        rect.display = blocks[i].display
        rect.posX = ( gridWidth * blocks[i].posX )
        rect.posY = ( gridHeight * blocks[i].posY )
        rect.width = ( gridWidth  * blocks[i].width )
        rect.height = ( gridHeight * blocks[i].height )

		rect:addEventListener( "touch", myTouchListener )
		rect.isHitTestable = true

		rect:setFillColor( 0, 0, 0 )
		rect.alpha = 0
		blocksGroup:insert( rect )
    end


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
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
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