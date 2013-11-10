

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
local gridWidth = math.floor(320/9)
local gridHeight = math.floor(568/15)

display.setDefault( "background", 255, 255, 255 )

-- blocks table
local blocksData = {
	{ posX=3, posY=3,  width=3, height=1, 
		{ tln = 0, trn = 0, bln = 2, brn = 3, tn = 0, bn = 0 }, -- neighbour blocks
		{ lc = 1, rc = 2, tc = 0, bc = 0 } -- neighbour corners
	},
	{ posX=2, posY=4,  width=1, height=1, 
		{ tln = 0, trn = 1, bln = 0, brn = 4, tn = 0, bn = 5 },
		{ lc = 0, rc = 0, tc = 1, bc = 3 } 
	},
	{ posX=6, posY=4,  width=1, height=1, 
		{ tln = 1, trn = 0, bln = 4, brn = 0, tn = 0, bn = 6 },
		{ lc = 0, rc = 0, tc = 2, bc = 4 }
	},
	{ posX=3, posY=5,  width=3, height=1, 
		{ tln = 2, trn = 3, bln = 5, brn = 6, tn = 0, bn = 0 },
		{ lc = 3, rc = 4, tc = 0, bc = 0 } 
	},
	{ posX=2, posY=6,  width=1, height=3, 
		{ tln = 0, trn = 4, bln = 0, brn = 7, tn = 2, bn = 8 },
		{ lc = 0, rc = 0, tc = 3, bc = 5 } 
	},
	{ posX=6, posY=6,  width=1, height=3, 
		{ tln = 4, trn = 0, bln = 7, brn = 0, tn = 3, bn = 9 },
		{ lc = 0, rc = 0, tc = 4, bc = 6 } 
	},
	{ posX=3, posY=9,  width=3, height=1, 
		{ tln = 5, trn = 6, bln = 8, brn = 9, tn = 0, bn = 0 },
		{ lc = 5, rc = 6, tc = 0, bc = 0 } 
	},	
	{ posX=2, posY=10, width=1, height=1, 
		{ tln = 0, trn = 7, bln = 0, brn = 10, tn = 5, bn = 0 },
		{ lc = 0, rc = 0, tc = 5, bc = 7 } 
	},
	{ posX=6, posY=10, width=1, height=1, 
		{ tln = 7, trn = 0, bln = 10, brn = 0, tn = 6, bn = 0 },
		{ lc = 0, rc = 0, tc = 6, bc = 8 } 
	},
	{ posX=3, posY=11, width=3, height=1, 
		{ tln = 8, trn = 9, bln = 0, brn = 0, tn = 0, bn = 0 },
		{ lc = 7, rc = 8, tc = 0, bc = 0 } 
	},
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

	o.tln = 0
	o.trn = 0
	o.bln = 0
	o.brn = 0
	o.tn = 0
	o.bn = 0

	o.lc = 0
	o.rc = 0
	o.tc = 0
	o.bc = 0

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

		event.target.display = true

		addCorners( event.target )

		transition.to( event.target, { time=150, alpha=1, transition=easing.outQuad } )
	
	elseif ( event.phase == "began" and event.target.display == true ) then

		event.target.display = false

		--removeCorners( event.target )
		addCorners( event.target )

		transition.to( event.target, { time=150, alpha=0, transition=easing.outQuad } )

	end
	return true  --prevents propagation to underlying blockObjects
end

function addCorners( eventTarget )

	local tlnID, trnID, blnID, brnID, tnID, bnID = eventTarget.tln, eventTarget.trn, eventTarget.bln, eventTarget.brn, eventTarget.tn, eventTarget.bn
	local lcID, rcID, tcID, bcID = eventTarget.lc, eventTarget.rc, eventTarget.tc, eventTarget.bc

	if tlnID == 0 and trnID == 0 and tnID == 0 and bnID == 0 then
		-- if only bottom neigbours
		local tln, trn, tn, bn = 0, 0, 0, 0
		local bln, brn = blocksGroup[blnID].display, blocksGroup[brnID].display

		if bln == true and brn == true then
			-- both are true
			bottomRightCorner(lcID)
			bottomLeftCorner(rcID)

		elseif bln == false and brn == false then
			-- both are false
			squareCorner(lcID)
			squareCorner(rcID)

		elseif brn == true and bln == false then
			-- only bottom right is true
			bottomLeftCorner(rcID)
			squareCorner(lcID)

		elseif brn == false and bln == true then
			-- only bottom left is true
			bottomRightCorner(lcID)
			squareCorner(rcID)

		else
			print("exeption on only bottom neigbours")
		end

	elseif tlnID == 0 and blnID == 0 and tnID == 0 then
		-- if right and bottom neighbours
		local tln, bln, tn = 0, 0, 0
		local trn, brn, bn = blocksGroup[trnID].display, blocksGroup[brnID].display, blocksGroup[bnID].display

		if trn == true and brn == true and bn == true 
			or trn == true and brn == false and bn == false then
			-- if all are true or only top right is true
			bottomRightCorner(tcID)
			squareCorner(bcID)

		elseif trn == false and brn == false and bn == false 
			or trn == false and brn == true and bn == true then
			-- if all are false
			squareCorner(tcID)
			squareCorner(bcID)

		elseif trn == true and brn == true and bn == false then
			-- if both right is true
			bottomRightCorner(tcID)
			topRightCorner(bcID)

		elseif trn == false and brn == true and bn == false then
			-- if only bottom right is true
			bottomRightCorner(bcID)
			squareCorner(tcID)

		else
			print("exeption on only right and bottom neigbours")
		end

	elseif tlnID == 0 and blnID == 0 and bnID == 0 then
		-- if right and top neighbours
		local tln, bln, bn = 0, 0, 0
		local trn, brn, tn = blocksGroup[trnID].display, blocksGroup[brnID].display, blocksGroup[tnID].display

		if trn == false and brn == false and tn == false
			or trn == false and brn == false and tn == true 
			or trn == true and brn == false and tn == true then
			-- if all are true or only top right is true
			squareCorner(bcID)
			squareCorner(tcID)

		elseif trn == false and brn == true and tn == true 
			or trn == true and brn == true and tn == true 
			or trn == false and brn == true and tn == false then
			-- if all are false
			squareCorner(tcID)
			topRightCorner(bcID)

		elseif trn == true and brn == true and tn == false then
			-- if both right is true
			bottomRightCorner(tcID)
			topRightCorner(bcID)

		elseif trn == true and brn == false and tn == false then
			-- if only top right is true
			bottomRightCorner(tcID)
			squareCorner(bcID)

		else
			print("exeption on only right and top neigbours")
		end

	elseif tlnID == 0 and blnID == 0 then
		-- if right, top and bottom neighbours
		local tln, bln = 0, 0
		local trn, brn, tn, bn = blocksGroup[trnID].display, blocksGroup[brnID].display, blocksGroup[tnID].display, blocksGroup[bnID].display

		if trn == false and brn == false and tn == false and bn == false -- if all are false
			or trn == true and brn == true and tn == true and bn == true -- if all are true
			or trn == false and brn == true and tn == false and bn == true -- if bottom and bottom right is true
			or trn == false and brn == false and tn == false and bn == true -- if only bottom
			or trn == false and brn == false and tn == true and bn == false -- if only top
			or trn == true and brn == false and tn == true and bn == false -- if top and top right is true
			or trn == false and brn == false and tn == true and bn == true -- if top and bottom
			or trn == true and brn == false and tn == true and bn == true -- if top bottom and top right
			or trn == false and brn == true and tn == true and bn == true -- if top bottom and bottom right
			then

			squareCorner(tcID)
			squareCorner(bcID)
		
		elseif trn == true and brn == false and tn == false and bn == false 
			or trn == true and brn == false and tn == false and bn == true
			or trn == true and brn == true and tn == false and bn == true then

			bottomRightCorner(tcID)
			squareCorner(bcID)

		elseif trn == false and brn == true and tn == false and bn == false 
			or trn == false and brn == true and tn == true and bn == false
			or trn == true and brn == true and tn == true and bn == false then
			
			topRightCorner(bcID)
			squareCorner(tcID)

		elseif trn == true and brn == true and tn == false and bn == false then
			-- if both right is true
			bottomRightCorner(tcID)
			topRightCorner(bcID)

		else
			print("exeption on right, top and bottom neigbours")
		end

	elseif blnID == 0 and brnID == 0 and tnID == 0 and bnID == 0 then
		-- if only top neigbours
		local bln, brn, tn, bn = 0, 0, 0, 0
		local tln, trn = blocksGroup[tlnID].display, blocksGroup[trnID].display

		if tln == true and trn == true then
			-- if both are true
			topRightCorner(lcID)
			topLeftCorner(rcID)

		elseif trn == false and tln == false then
			-- if both are false
			squareCorner(rcID)
			squareCorner(lcID)

		elseif tln == true and trn == false then
			-- if only top left is true
			topRightCorner(lcID)
			squareCorner(rcID)

		elseif trn == true and tln == false then
			-- if only top right is true
			topLeftCorner(rcID)
			squareCorner(lcID)

		else
			print("exeption on only top neigbours")
		end

	elseif trnID == 0 and brnID == 0 and tnID == 0 then
		-- if left and bottom neighbours
		local trn, brn, tn = 0, 0, 0
		local tln, bln, bn = blocksGroup[tlnID].display, blocksGroup[blnID].display, blocksGroup[bnID].display

		if tln == true and bln == true and bn == true 
			or tln == true and bln == false and bn == false then
			-- if all are true or only top left is true
			bottomLeftCorner(tcID)
			squareCorner(bcID)

		elseif tln == false and bln == false and bn == false 
			or tln == false and bln == true and bn == true then
			-- if all are false
			squareCorner(tcID)
			squareCorner(bcID)

		elseif tln == true and bln == true and bn == false then
			-- if both left is true
			bottomLeftCorner(tcID)
			topLeftCorner(bcID)

		elseif tln == false and bln == true and bn == false then
			-- if only bottom left is true
			topLeftCorner(bcID)
			squareCorner(tcID)

		else
			print("exeption on only left and bottom neigbours")
		end

	elseif trnID == 0 and brnID == 0 and bnID == 0 then
		-- if left and top neighbours
		local trn, brn, bn = 0, 0, 0
		local tln, bln, tn = blocksGroup[tlnID].display, blocksGroup[blnID].display, blocksGroup[tnID].display

		if tln == false and bln == false and tn == false 
			or tln == false and bln == false and tn == true 
			or tln == true and bln == false and tn == true then
			-- if all are true or only bottom left is true
			squareCorner(bcID)
			squareCorner(tcID)

		elseif tln == false and bln == true and tn == true 
			or tln == true and bln == true and tn == true 
			or tln == false and bln == true and tn == false then
			-- if all are false
			squareCorner(tcID)
			topLeftCorner(bcID)

		elseif tln == true and bln == true and tn == false then
			-- if both left is true
			bottomLeftCorner(tcID)
			topLeftCorner(bcID)

		elseif tln == true and bln == false and tn == false then
			-- if only top left is true
			bottomLeftCorner(tcID)
			squareCorner(bcID)

		else
			print("exeption on only left and top neigbours")
		end

	elseif trnID == 0 and brnID == 0 then
		-- if left, top and bottom neighbours
		local trn, brn = 0, 0
		local tln, bln, tn, bn = blocksGroup[tlnID].display, blocksGroup[blnID].display, blocksGroup[tnID].display, blocksGroup[bnID].display

		if tln == false and bln == false and tn == false and bn == false -- if all are false
			or tln == true and bln == true and tn == true and bn == true -- if all are true
			or tln == false and bln == true and tn == false and bn == true -- if bottom and bottom left is true
			or tln == false and bln == false and tn == false and bn == true -- if only bottom
			or tln == false and bln == false and tn == true and bn == false -- if only top
			or tln == true and bln == false and tn == true and bn == false -- if top and top left is true
			or tln == false and bln == false and tn == true and bn == true -- if top and bottom
			or tln == true and bln == false and tn == true and bn == true -- if top bottom and top left
			or tln == false and bln == true and tn == true and bn == true -- if top bottom and bottom left
			then

			squareCorner(tcID)
			squareCorner(bcID)
		
		elseif tln == true and bln == false and tn == false and bn == false 
			or tln == true and bln == false and tn == false and bn == true
			or tln == true and bln == true and tn == false and bn == true then

			bottomLeftCorner(tcID)
			squareCorner(bcID)

		elseif tln == false and bln == true and tn == false and bn == false 
			or tln == false and bln == true and tn == true and bn == false
			or tln == true and bln == true and tn == true and bn == false then
			
			topLeftCorner(bcID)
			squareCorner(tcID)

		elseif tln == true and bln == true and tn == false and bn == false then
			-- if both left is true
			bottomLeftCorner(tcID)
			topLeftCorner(bcID)

		else
			print("exeption on left, top and bottom neigbours")
		end

	elseif tnID == 0 and bnID == 0 then
		-- if horizontal
		local tn, bn = 0, 0
		local tln, trn, bln, brn = blocksGroup[tlnID].display, blocksGroup[trnID].display, blocksGroup[blnID].display, blocksGroup[brnID].display

		if tln == true and trn == true and bln == true and brn == true then
			-- if all are true
			squareCorner(lcID)
			squareCorner(rcID)

		elseif tln == false and trn == false and bln == false and brn == false then
			-- if all are false
			squareCorner(lcID)
			squareCorner(rcID)

		elseif tln == true and trn == false and bln == true and brn == false then
			-- if both left are true
			squareCorner(lcID)
			squareCorner(rcID)

		elseif tln == false and trn == true and bln == false and brn == true then
			-- if both right are true
			squareCorner(lcID)
			squareCorner(rcID)

		elseif tln == true and trn == true and bln == false and brn == false then
			-- if both top are true
			topRightCorner(lcID)
			topLeftCorner(rcID)

		elseif tln == false and trn == false and bln == true and brn == true then
			-- if both bottoms are true
			bottomRightCorner(lcID)
			bottomLeftCorner(rcID)

		elseif tln == true and trn == false and bln == false and brn == false 
			or tln == true and trn == true and bln == false and brn == true then
			-- if only top left is true
			topRightCorner(lcID)
			squareCorner(rcID)

		elseif tln == false and trn == false and bln == true and brn == false 
			or tln == false and trn == true and bln == true and brn == true then
			-- if only bottom left is true
			bottomRightCorner(lcID)
			squareCorner(rcID)

		elseif tln == false and trn == true and bln == false and brn == false 
			or tln == true and trn == true and bln == true and brn == false then
			-- if only top right is true
			topLeftCorner(rcID)
			squareCorner(lcID)

		elseif tln == false and trn == false and bln == false and brn == true 
			or tln == true and trn == false and bln == true and brn == true then
			-- if only bottom right is true
			bottomLeftCorner(rcID)
			squareCorner(lcID)

		else
			print("exeption on all is posible corner")
		end
	else
		print("exeption on neighbour check")
	end
end

function topLeftCorner(i)
	transition.to( cornerGroup[i], { time=150, alpha=1, transition=easing.outQuad } )
	transition.to( cornerGroup[i].topLeft, { time=150, alpha=1, transition=easing.outQuad } )
	cornerGroup[i].bottomRight.alpha = 0
	cornerGroup[i].bottomLeft.alpha = 0
	cornerGroup[i].topRight.alpha = 0
end
function topRightCorner(i)
	transition.to( cornerGroup[i], { time=150, alpha=1, transition=easing.outQuad } )
	transition.to( cornerGroup[i].topRight, { time=150, alpha=1, transition=easing.outQuad } )
	cornerGroup[i].topLeft.alpha = 0
	cornerGroup[i].bottomLeft.alpha = 0
	cornerGroup[i].bottomRight.alpha = 0
end
function bottomLeftCorner(i)
	transition.to( cornerGroup[i], { time=150, alpha=1, transition=easing.outQuad } )
	transition.to( cornerGroup[i].bottomLeft, { time=150, alpha=1, transition=easing.outQuad } )
	cornerGroup[i].bottomRight.alpha = 0
	cornerGroup[i].topLeft.alpha = 0
	cornerGroup[i].topRight.alpha = 0
end
function bottomRightCorner(i)
	transition.to( cornerGroup[i], { time=150, alpha=1, transition=easing.outQuad } )
	transition.to( cornerGroup[i].bottomRight, { time=150, alpha=1, transition=easing.outQuad } )
	cornerGroup[i].topLeft.alpha = 0
	cornerGroup[i].bottomLeft.alpha = 0
	cornerGroup[i].topRight.alpha = 0
end
function squareCorner(i)
	transition.to( cornerGroup[i], { time=150, alpha=1, transition=easing.outQuad } )
	cornerGroup[i].bottomRight.alpha=1
	cornerGroup[i].topLeft.alpha = 1
	cornerGroup[i].bottomLeft.alpha = 1
	cornerGroup[i].topRight.alpha = 1
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
		rect.tln, rect.trn, rect.bln, rect.brn, rect.tn, rect.bn = self.tln, self.trn, self.bln, self.brn, self.tn, self.bn
		rect.lc, rect.rc, rect.tc, rect.bc = self.lc, self.rc, self.tc, self.bc

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
	corner.topLeft = topLeft

	-- trc
	local topRight = polygonFill( table.listToNamed(trcPoints,{'x','y'}), isclosed, isperpixel, widthheight, widthheight, {0,0,0} )
	corner:insert( topRight )
	corner.topRight = topRight

	-- blc
	local bottomLeft = polygonFill( table.listToNamed(blcPoints,{'x','y'}), isclosed, isperpixel, widthheight, widthheight, {0,0,0} )
	corner:insert( bottomLeft )
	corner.bottomLeft = bottomLeft

	-- brc
	local bottomRight = polygonFill( table.listToNamed(brcPoints,{'x','y'}), isclosed, isperpixel, widthheight, widthheight, {0,0,0} )
	corner:insert( bottomRight )
	corner.bottomRight = bottomRight

	
	--corner:setReferencePoint( display.TopLeftReferencePoint )
	--corner.cornerX, corner.cornerY = corner:localToContent( (gridWidth * self.posX - gridWidth * 5), gridHeight * self.posY )

	corner.x, corner.y = gridWidth * self.posX, gridHeight * self.posY

	topLeft.alpha, topRight.alpha, bottomLeft.alpha, bottomRight.alpha = 1, 1, 1, 1

	corner.name, corner.display, corner.alpha = self.name, self.display, 0

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

	-- corner objects
	for i=1,#cornerData do
		cO.posX, cO.posY = cornerData[i].posX,cornerData[i].posY
		cO:drawCorner()
	end

	-- block objects
	for i=1,#blocksData do
		o.posX, o.posY, o.width, o.height = blocksData[i].posX, blocksData[i].posY, blocksData[i].width, blocksData[i].height
		o.tln, o.trn, o.bln, o.brn, o.tn, o.bn = blocksData[i][1].tln, blocksData[i][1].trn, blocksData[i][1].bln, blocksData[i][1].brn, blocksData[i][1].tn, blocksData[i][1].bn
		o.lc, o.rc, o.tc, o.bc = blocksData[i][2].lc, blocksData[i][2].rc, blocksData[i][2].tc, blocksData[i][2].bc
		o:drawBlock()
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