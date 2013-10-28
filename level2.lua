

-----------------------------------------------------------------------------------------
--
-- level2.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"

-- include Corona's "display extention" library
require("displayex")

-- include Corona's "math" library
require("mathlib")

--------------------------------------------

-- create a group for the background grid lines
local grid, blocksGroup, cornerGroup = display.newGroup(), display.newGroup(), display.newGroup()

-- polygon fill options
local widthheight, isclosed, isperpixel = 1, false, false

-- grid square width and height variables
local gridWidth = (320/9)
local gridHeight = (568/15)

display.setDefault( "background", 255, 255, 255 )

-- blocks table
local blocksData = {
	{ posX=3, posY=3,  width=3, height=1 },
	{ posX=2, posY=4,  width=1, height=1 },
	{ posX=6, posY=4,  width=1, height=1 },
	{ posX=3, posY=5,  width=3, height=1 },
	{ posX=2, posY=6,  width=1, height=3 },
	{ posX=6, posY=6,  width=1, height=3 },
	{ posX=3, posY=9,  width=3, height=1 },
	{ posX=2, posY=10, width=1, height=1 },
	{ posX=6, posY=10, width=1, height=1 },
	{ posX=3, posY=11, width=3, height=1 },
}
local cornerData = {
	{ posX=2, posY=3 },
	{ posX=6, posY=3 },
	{ posX=2, posY=5 },
	{ posX=6, posY=5 },
	{ posX=2, posY=9 },
	{ posX=6, posY=9 },
	{ posX=2, posY=11 },
	{ posX=6, posY=11 },
}

local linesX = {3,4,5,6,9,10,11,12}
local linesY = {2,3,6,7}

local blockObject = {}

local cornerObject = {}

local mt = {}
local cmt = {}

function blockObject:new()
	local o = {}
	o._ID = 0
	o.name = "block"
	o.display = false
	o.width = 1
	o.height = 1
	o.posX = 0
	o.posY = 0

	local m = setmetatable(o,mt)
	return o
end

function blockObject:increaseId()
	self._ID = self.id + 1
end

function cornerObject:new()
	local cO = {}
	cO._ID = 0
	cO.name = "corner"
	cO.display = false
	cO.posX = 0
	cO.posY = 0

	local m = setmetatable(cO,cmt)
	return cO
end

local o = blockObject:new()

local cO = cornerObject:new()

function cornerObject:increaseId()
	self._ID = self.id + 1
end

-- blocks touch event
local function myTouchListener( event )

	if ( event.phase == "began" and event.target.display == false ) then
--[[
		print("id: "..event.target.id)
		print("width: "..event.target.width)
		print("height: "..event.target.height)

		print("left x: "..event.target.x - (event.target.width/2))
		print("right x: "..event.target.x - (event.target.width/2) + event.target.width)

		print("top y: "..event.target.y - (event.target.height/2))
		print("bottom y: "..event.target.y - (event.target.height/2) + event.target.height)


		print("x + 1: "..event.target.x - (event.target.width/2) + (gridHeight))
		print("y: "..event.target.y)
		print("gridWidth * 6: "..gridWidth *6)
		print("gridHeight * 5: "..gridHeight *5)
]]
		event.target.display = true

		transition.to( event.target, { time=150, alpha=1, transition=easing.outQuad } )

		addCorners( event.target )

		for i=1,#cornerData do
			cX = cornerData[i].posX
			cY = cornerData[i].posY

			--print("corner object x: "..( cX*gridWidth ))
			--print("corner object y: "..( cY*gridHeight ))


			blockRightX = event.target.x - (event.target.width/2) + event.target.width
			blockLeftX = event.target.x - (event.target.width/2) - gridWidth
			cornerX = cX*gridWidth

			blockTopY = event.target.y - (event.target.height/2)
			blockBottomY = event.target.y + (event.target.height/2)
			cornerY = cY*gridHeight

			verticalCornerX = cornerX + gridWidth
			verticalBlockTopY = blockTopY - gridHeight
			verticalBlockBottomY = blockTopY + event.target.height

			--print("block height "..event.target.height)
			--print("block y "..math.round(blockY))
			--print("corner y "..math.round(cornerY))

			
			if ( math.round(blockTopY) == math.round(cornerY) and math.round(blockRightX) == math.round(cornerX) or math.round(blockTopY) == math.round(cornerY) and math.round(blockLeftX) == math.round(cornerX) ) then 
				
				-- fill corner
				--transition.to( fill, { time=150, alpha=1, transition=easing.outQuad } )
				print("horizontal susses!")
			
			end

			if ( math.round(blockRightX) == math.round(verticalCornerX) and math.round(verticalBlockTopY) == math.round( cornerY ) or math.round(blockRightX) == math.round(verticalCornerX) and math.round(verticalBlockBottomY) == math.round( cornerY ) ) then 
				
				-- fill corner
				--transition.to( fill, { time=150, alpha=1, transition=easing.outQuad } )
				print("vertical susses!")
			
			end

			--[[if ( math.round(blockY) == math.round(cornerY) ) then 
				fill.alpha = 1
				print("susses Y")
				print("block y: "..blockY)
				print("corner y: "..cornerY)
			end]]
		end
	
	elseif ( event.phase == "began" and event.target.display == true ) then

		event.target.display = false

		transition.to( event.target, { time=150, alpha=0, transition=easing.outQuad } )
		--transition.to( fill, { time=150, alpha=0, transition=easing.outQuad } )

	end
	return true  --prevents propagation to underlying blockObjects
end

function addCorners( eventTarget )
	--print(eventTarget.id)

		--[[if ( eventTarget.name == "centerTop" or eventTarget.name == "centerBottom" ) then

			transition.to(eventTarget, { time=0, x=eventTarget.posX + ( eventTarget.width/2 ) , width=eventTarget.width + ( gridWidth * 2 ) } )

		end]]
end

function blockObject:drawBlock() 
	 local rect = display.newRect( 
		-- position
		( gridWidth  * self.posX ),
		( gridHeight * self.posY ),
		-- size
		( gridWidth  * self.width ),
		( gridHeight * self.height )
		)

		rect:setFillColor( 0, 0, 0 )
		rect.alpha = 0
		self:increaseId()

		rect.name, rect.id, rect.display = self.name, self.id, self.display

		rect:addEventListener( "touch", myTouchListener )
		rect.isHitTestable = true

		blocksGroup:insert( rect )
end

function cornerObject:drawCorner()
	corner = display.newGroup()

	--corner:setReferencePoint( display.TopLeftReferencePoint )
	--corner.x, corner.y = corner:localToContent( gridWidth * self.posX, gridHeight * self.posY )

	self:increaseId()

	local x, y = 0,0--gridWidth * self.posX, gridHeight * self.posY
	addX, addY = gridWidth, gridHeight
	
	local tlcPoints = { x,y, x+addX,y, x,y+addY, x,y }
	local trcPoints = { x,y, x+addX,y+addY, x+addX,y, x,y }
	local blcPoints = { x,y, x+addX,y+addY, x,y+addY, x,y }
	local brcPoints	= { x+addX,y+addY, x,y+addY, x+addX,y, x+addX,y+addY }

	-- tlc
	local topLeft = polygonFill( table.listToNamed(tlcPoints,{'x','y'}), isclosed, isperpixel, widthheight, widthheight, {0,0,0} )
	corner:insert( topLeft )

	-- trc
	local topRight = polygonFill( table.listToNamed(trcPoints,{'x','y'}), isclosed, isperpixel, widthheight, widthheight, {0,0,0} )
	corner:insert( topRight )

	-- blc
	local bottomLeft = polygonFill( table.listToNamed(blcPoints,{'x','y'}), isclosed, isperpixel, widthheight, widthheight, {0,0,0} )
	corner:insert( bottomLeft )

	-- brc
	local bottomRight = polygonFill( table.listToNamed(brcPoints,{'x','y'}), isclosed, isperpixel, widthheight, widthheight, {0,0,0} )
	corner:insert( bottomRight )


	
	--corner:setReferencePoint( display.TopLeftReferencePoint )
	--corner.cornerX, corner.cornerY = corner:localToContent( (gridWidth * self.posX - gridWidth * 5), gridHeight * self.posY )

	corner.x, corner.y = gridWidth * self.posX, gridHeight * self.posY

	topLeft.alpha, topRight.alpha, bottomLeft.alpha, bottomRight.alpha = 1, 0, 0, 0

	corner.name, corner.display, corner.alpha = self.name, self.display, 0

	corner.topLeft = topLeftCorner
	corner.topRight = topRightCorner
	corner.bottomLeft = bottomLeftCorner
	corner.bottomRight = bottomRightCorner

	cornerGroup:insert( corner )

end

mt.__newindex = function(tab,key,value)
	if key == "id" then
		error("'id' is read only.")
	else
		error(tab.name.." has no member '"..key.."'")
	end
end

mt.__index = function(tab,key)
	if key == "id" then
		return tab._ID
	else
		return blockObject[key]
	end
end

cmt.__newindex = function(tab,key,value)
	if key == "id" then
		error("'id' is read only.")
	else
		error(tab.name.." has no member '"..key.."'")
	end
end

cmt.__index = function(tab,key)
	if key == "id" then
		return tab._ID
	else
		return cornerObject[key]
	end
end

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
	
	-- go to level1.lua scene
	storyboard.gotoScene( "level1", "fade", 500 )
	
	return true	-- indicates successful touch
end

-- draw line X
local function drawLineX( i )
	local line = display.newLine( 0,gridHeight*i, 320,gridHeight*i )
	line:setColor( 0, 0, 0)
	line.width = 1
	grid:insert( line )
end

-- draw line Y
local function drawLineY( i )
	local line = display.newLine( gridWidth*i,0, gridWidth*i,568 )
	line:setColor( 0, 0, 0 )
	line.width = 1
	grid:insert( line )
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

	-- X grid
	for i, linesX in ipairs(linesX) do
		drawLineX( linesX )
	end

	-- Y grid
	for i, linesY in ipairs(linesY) do
		drawLineY( linesY )
	end

	-- block objects
	for i=1,#blocksData do
		o.posX, o.posY, o.width, o.height = blocksData[i].posX, blocksData[i].posY, blocksData[i].width, blocksData[i].height
		o:drawBlock()
	end

	-- corner objects
	for i=1,#cornerData do
		cO.posX, cO.posY = cornerData[i].posX,cornerData[i].posY
		cO:drawCorner()
	end

	print("blocksGroup children: "..blocksGroup.numChildren)
	print("cornerGroup children: "..cornerGroup.numChildren)
	print("corner 4 children: "..cornerGroup[4].numChildren)


	cornerGroup[2].alpha = 1
	cornerGroup[4].alpha = 1

	cornerGroup[4].alpha = 1
	--cornerGroup[4].bottomLeftCorner.alpha = 1
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