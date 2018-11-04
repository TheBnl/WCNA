-----------------------------------------------------------------------------------------
--
-- level1.lua
-- solve A
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

-- include Corona's "display extention" library
require("displayex")

-- include Corona's "math" library
require("mathlib")

-- levelstorage
local levelstorage = require("levelstorage")

-- timeScore
local ScoreStorage = require("timescore")

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

--------------------------------------------
-- grid square width and height variables
local gridWidth = math.floor(320/9)
local gridHeight = math.floor(568/15)

-- levels
currentLevel = 4
currentChar = "l"
totalLevels = 22
nextLevel = "level5"

-- timer options
local time = 1000
local totalTime = 1000
local timerWidth = gridWidth * 3

local trueBlocks = {2,5,7}
local falseBlocks = {1,3,4,6,8,9,10}

-- change story board options
local options =
{
    effect = "crossFade",
    time = 400
}

levels =
{
2, 2, 2, 2, 2, 2,
2, 2, 2, 2, 2, 2,
2, 2, 2, 2, 2, 2,
2, 2, 2, 2,
}
levels = loadLevels()

-- time
timeScore = { 0, }
timeScore = loadScore()

-- font fix
if system.getInfo("environment") == "simulator" then simulator = true end
yFixSmall = 6
if simulator then
    yFixSmall = 0
end

-- create a group for the background grid lines
local grid, blocksGroup, dotGroup, cornerGroup, correctGroup, wrongGroup, levelIndicator, prevButton, nextButton = display.newGroup(), display.newGroup(), display.newGroup(), display.newGroup(), display.newGroup(), display.newGroup(), display.newGroup(), display.newGroup(), display.newGroup()

-- polygon fill options
local widthheight, isclosed, isperpixel = 0.25, false, false

-- wrong or right animation
local trans
local transitions = 0

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

local correct = 0
local wrong = 0

local linesX = {3,4,5,6,9,10,11,12}
local linesY = {2,3,6,7}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--  CREATION OF BLOCK AND CORNER OBJECTS  --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local blockObject = {}

local cornerObject = {}

local mt = {}
local cmt = {}

function blockObject:new()
	local o = {}
	o._ID = 0
	o.name = "block"
	o.display = false
	o.width, o.height = 1, 1
	o.posX, o.posY, o.tln, o.trn, o.bln, o.brn = 0, 0, 0, 0, 0, 0
	o.tn, o.bn, o.lc, o.rc, o.tc, o.bc = 0, 0, 0, 0, 0, 0

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
	cO.posX, cO.posY = 0, 0

	local m = setmetatable(cO,cmt)
	return cO
end

function cornerObject:increaseId()
	self._ID = self.id + 1
end

local o = blockObject:new()

local cO = cornerObject:new()

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--          BLOCK TOUCH LISTNER           --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function myTouchListener( event )

	if ( event.phase == "began" and event.target.display == false ) then

		event.target.display = true

		addCorners( event.target, true )

		transition.to( event.target, { time=150, alpha=1, transition=easing.outQuad } )
	
	elseif ( event.phase == "began" and event.target.display == true ) then

		event.target.display = false

		addCorners( event.target, false )

		transition.to( event.target, { time=150, alpha=0, transition=easing.outQuad } )

	end
	return true  --prevents propagation to underlying blockObjects
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--         HUGE CORNER FUNCTION           --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function addCorners( eventTarget, a )

	local tlnID, trnID, blnID, brnID, tnID, bnID = eventTarget.tln, eventTarget.trn, eventTarget.bln, eventTarget.brn, eventTarget.tn, eventTarget.bn
	local lcID, rcID, tcID, bcID = eventTarget.lc, eventTarget.rc, eventTarget.tc, eventTarget.bc

	if tlnID == 0 and trnID == 0 and tnID == 0 and bnID == 0 then
		-- if only bottom neigbours
		local tln, trn, tn, bn = 0, 0, 0, 0
		local bln, brn = blocksGroup[blnID].display, blocksGroup[brnID].display

		if bln == true and brn == true then
			-- both are true
			if a == true then
				bottomRightCorner(lcID, true)
				bottomLeftCorner(rcID, true)
			elseif a == false then
				squareCorner(lcID, true)
				squareCorner(rcID, true)
			end

		elseif bln == false and brn == false then
			-- both are false
			if a == true then
				squareCorner(lcID, true)
				squareCorner(rcID, true)
			elseif a == false then
				squareCorner(lcID, false)
				squareCorner(rcID, false)
			end

		elseif brn == true and bln == false then
			-- only bottom right is true
			if a == true then
				bottomLeftCorner(rcID, true)
				squareCorner(lcID, true)
			elseif a == false then
				squareCorner(rcID, true)
				squareCorner(lcID, false)
			end

		elseif brn == false and bln == true then
			-- only bottom left is true
			if a == true then
				bottomRightCorner(lcID, true)
				squareCorner(rcID, true)
			elseif a == false then
				squareCorner(lcID, true)
				squareCorner(rcID, false)
			end

		else
			print("exeption on only bottom neigbours")
		end

	elseif tlnID == 0 and blnID == 0 and tnID == 0 then
		-- if right and bottom neighbours
		local tln, bln, tn = 0, 0, 0
		local trn, brn, bn = blocksGroup[trnID].display, blocksGroup[brnID].display, blocksGroup[bnID].display

		if trn == true and brn == true and bn == true then
			if a == true then
				bottomRightCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				bottomRightCorner(bcID, true)
			end
		elseif trn == false and brn == false and bn == true then
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, false)
				squareCorner(bcID, true)
			end
		elseif trn == true and brn == false and bn == false then
			if a == true then
				bottomRightCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				bottomRightCorner(bcID, false)
			end
		elseif trn == true and brn == false and bn == true then

			if a == true then
				bottomRightCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			end

		elseif trn == false and brn == false and bn == false then
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, false)
				squareCorner(bcID, false)
			end
		elseif trn == false and brn == true and bn == true then
			-- if all are false
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, false)
				bottomRightCorner(bcID, true)
			end

		elseif trn == true and brn == true and bn == false then
			-- if both right is true
			if a == true then
				bottomRightCorner(tcID, true)
				topRightCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			end

		elseif trn == false and brn == true and bn == false then
			-- if only bottom right is true
			if a == true then
				topRightCorner(bcID, true)
				squareCorner(tcID, true)
			elseif a == false then
				squareCorner(bcID, true)
				squareCorner(tcID, false)
			end

		else
			print("exeption on only right and bottom neigbours")
		end

	elseif tlnID == 0 and blnID == 0 and bnID == 0 then
		-- if right and top neighbours
		local tln, bln, bn = 0, 0, 0
		local trn, brn, tn = blocksGroup[trnID].display, blocksGroup[brnID].display, blocksGroup[tnID].display

		if trn == false and brn == false and tn == false then

			if a == true then
				squareCorner(bcID, true)
				squareCorner(tcID, true)
			elseif a == false then
				squareCorner(bcID, false)
				squareCorner(tcID, false)
			end

		elseif trn == false and brn == false and tn == true then
			
			if a == true then
				squareCorner(bcID, true)
				squareCorner(tcID, true)
			elseif a == false then
				squareCorner(bcID, false)
				squareCorner(tcID, true)
			end

		elseif trn == true and brn == false and tn == true then
			-- if all are false or top right and top neighbour or only top neighbour is true
			if a == true then
				squareCorner(bcID, true)
				squareCorner(tcID, true)
			elseif a == false then
				squareCorner(bcID, false)
				topRightCorner(tcID, true)
			end

		elseif trn == false and brn == true and tn == true then
			if a == true then
				squareCorner(tcID, true)
				topRightCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			end
		elseif trn == true and brn == true and tn == true then
			if a == true then
				squareCorner(tcID, true)
				topRightCorner(bcID, true)
			elseif a == false then
				topRightCorner(tcID, true)
				squareCorner(bcID, true)
			end
		elseif trn == false and brn == true and tn == false then
			if a == true then
				squareCorner(tcID, true)
				topRightCorner(bcID, true)
			elseif a == false then
				topRightCorner(tcID, false)
				squareCorner(bcID, true)
			end

		elseif trn == true and brn == true and tn == false then
			-- if both right is true
			if a == true then
				bottomRightCorner(tcID, true)
				topRightCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			end

		elseif trn == true and brn == false and tn == false then
			-- if only top right is true
			if a == true then
				bottomRightCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				squareCorner(bcID, false)
			end

		else
			print("exeption on only right and top neigbours")
		end

	elseif tlnID == 0 and blnID == 0 then
		-- if right, top and bottom neighbours
		local tln, bln = 0, 0
		local trn, brn, tn, bn = blocksGroup[trnID].display, blocksGroup[brnID].display, blocksGroup[tnID].display, blocksGroup[bnID].display

		if trn == false and brn == false and tn == false and bn == false then-- if all are false
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, false)
				squareCorner(bcID, false)
			end
		elseif trn == true and brn == true and tn == true and bn == true then-- if all are true
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				topRightCorner(tcID, true)
				bottomRightCorner(bcID, true)
			end
		elseif trn == false and brn == true and tn == false and bn == true then-- if bottom and bottom right is true
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, false)
				bottomRightCorner(bcID, true)
			end
		elseif trn == false and brn == false and tn == false and bn == true then-- if only bottom
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, false)
				squareCorner(bcID, true)
			end
		elseif trn == false and brn == false and tn == true and bn == false then-- if only top
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				squareCorner(bcID, false)
			end
		elseif trn == true and brn == false and tn == true and bn == false then-- if top and top right is true
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				topRightCorner(tcID, true)
				squareCorner(bcID, false)
			end
		elseif trn == false and brn == false and tn == true and bn == true then-- if top and bottom
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			end
		elseif trn == true and brn == false and tn == true and bn == true then-- if top bottom and top right
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				topRightCorner(tcID, true)
				squareCorner(bcID, true)
			end
		elseif trn == false and brn == true and tn == true and bn == true then-- if top bottom and bottom right

			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				bottomRightCorner(bcID, true)
			end
		
		elseif trn == true and brn == false and tn == false and bn == false then
			if a == true then
				bottomRightCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				squareCorner(bcID, false)
			end
		elseif trn == true and brn == false and tn == false and bn == true then
			if a == true then
				bottomRightCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			end
		elseif trn == true and brn == true and tn == false and bn == true then
			if a == true then
				bottomRightCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				bottomRightCorner(bcID, true)
			end

		elseif trn == false and brn == true and tn == false and bn == false then
			if a == true then
				topRightCorner(bcID, true)
				squareCorner(tcID, true)
			elseif a == false then
				topRightCorner(tcID, false)
				squareCorner(bcID, true)
			end
		elseif trn == false and brn == true and tn == true and bn == false then
			if a == true then
				topRightCorner(bcID, true)
				squareCorner(tcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			end
		elseif trn == true and brn == true and tn == true and bn == false then
			
			if a == true then
				topRightCorner(bcID, true)
				squareCorner(tcID, true)
			elseif a == false then
				topRightCorner(tcID, true)
				squareCorner(bcID, true)
			end

		elseif trn == true and brn == true and tn == false and bn == false then
			-- if both right is true
			if a == true then
				bottomRightCorner(tcID, true)
				topRightCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			end

		else
			print("exeption on right, top and bottom neigbours")
		end

	elseif blnID == 0 and brnID == 0 and tnID == 0 and bnID == 0 then
		-- if only top neigbours
		local bln, brn, tn, bn = 0, 0, 0, 0
		local tln, trn = blocksGroup[tlnID].display, blocksGroup[trnID].display

		if tln == true and trn == true then
			-- if both are true 													<------------<<		HIERO!
			if a == true then
				topRightCorner(lcID, true)
				topLeftCorner(rcID, true)
			elseif a == false then
				squareCorner(lcID, true)
				squareCorner(rcID, true)
			end

		elseif trn == false and tln == false then
			-- if both are false
			if a == true then
				squareCorner(rcID, true)
				squareCorner(lcID, true)
			elseif a == false then
				squareCorner(rcID, false)
				squareCorner(lcID, false)
			end

		elseif tln == true and trn == false then
			-- if only top left is true
			if a == true then
				topRightCorner(lcID, true)
				squareCorner(rcID, true)
			elseif a == false then
				squareCorner(lcID, true)
				squareCorner(rcID, false)
			end

		elseif trn == true and tln == false then
			-- if only top right is true
			if a == true then
				topLeftCorner(rcID, true)
				squareCorner(lcID, true)
			elseif a == false then
				squareCorner(rcID, true)
				squareCorner(lcID, false)
			end

		else
			print("exeption on only top neigbours")
		end

	elseif trnID == 0 and brnID == 0 and tnID == 0 then
		-- if left and bottom neighbours
		local trn, brn, tn = 0, 0, 0
		local tln, bln, bn = blocksGroup[tlnID].display, blocksGroup[blnID].display, blocksGroup[bnID].display

		if tln == true and bln == true and bn == true then
			if a == true then
				bottomLeftCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				bottomLeftCorner(bcID, true)
			end
		elseif tln == false and bln == false and bn == true then
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, false)
				squareCorner(bcID, true)
			end
		elseif tln == true and bln == false and bn == false then
			if a == true then
				bottomLeftCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				squareCorner(bcID, false)
			end

		elseif tln == false and bln == false and bn == false then
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, false)
				squareCorner(bcID, false)
			end
		elseif tln == false and bln == true and bn == true then
			-- if all are false
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, false)
				bottomLeftCorner(bcID, true)
			end

		elseif tln == true and bln == true and bn == false then
			-- if both left is true
			if a == true then
				bottomLeftCorner(tcID, true)
				topLeftCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			end
		elseif tln == true and bln == false and bn == true then
			if a == true then
				squareCorner(bcID, true)
				bottomLeftCorner(tcID, true)
			elseif a == false then
				squareCorner(bcID, true)
				squareCorner(tcID, true)
			end
		elseif tln == false and bln == true and bn == false then
			-- if only bottom left is true
			if a == true then
				topLeftCorner(bcID, true)
				squareCorner(tcID, true)
			elseif a == false then
				squareCorner(bcID, true)
				squareCorner(tcID, false)
			end

		else
			print("exeption on only left and bottom neigbours")
		end

	elseif trnID == 0 and brnID == 0 and bnID == 0 then
		-- if left and top neighbours
		local trn, brn, bn = 0, 0, 0
		local tln, bln, tn = blocksGroup[tlnID].display, blocksGroup[blnID].display, blocksGroup[tnID].display

		if tln == false and bln == false and tn == false then
			if a == true then
				squareCorner(bcID, true)
				squareCorner(tcID, true)
			elseif a == false then
				squareCorner(bcID, false)
				squareCorner(tcID, false)
			end
		elseif tln == false and bln == false and tn == true then
			if a == true then
				squareCorner(bcID, true)
				squareCorner(tcID, true)
			elseif a == false then
				squareCorner(bcID, false)
				squareCorner(tcID, true)
			end
		elseif tln == true and bln == false and tn == true then
			if a == true then
				squareCorner(bcID, true)
				squareCorner(tcID, true)
			elseif a == false then
				topLeftCorner(bcID, false)
				topLeftCorner(tcID, true)
			end

		elseif tln == false and bln == true and tn == true then
			if a == true then
				squareCorner(tcID, true)
				topLeftCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			end
		elseif tln == true and bln == true and tn == true then
			if a == true then
				squareCorner(tcID, true)
				topLeftCorner(bcID, true)
			elseif a == false then
				topLeftCorner(tcID, true)
				squareCorner(bcID, true)
			end
		elseif tln == false and bln == true and tn == false then
			-- if all are false
			if a == true then
				squareCorner(tcID, true)
				topLeftCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, false)
				squareCorner(bcID, true)
			end

		elseif tln == true and bln == true and tn == false then
			-- if both left is true
			if a == true then
				bottomLeftCorner(tcID, true)
				topLeftCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			end

		elseif tln == true and bln == false and tn == false then
			-- if only top left is true
			if a == true then
				bottomLeftCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				squareCorner(bcID, false)
			end

		else
			print("exeption on only left and top neigbours")
		end

	elseif trnID == 0 and brnID == 0 then
		-- if left, top and bottom neighbours
		local trn, brn = 0, 0
		local tln, bln, tn, bn = blocksGroup[tlnID].display, blocksGroup[blnID].display, blocksGroup[tnID].display, blocksGroup[bnID].display

		if tln == false and bln == false and tn == false and bn == false then -- if all are false
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, false)
				squareCorner(bcID, false)
			end
		elseif tln == true and bln == true and tn == true and bn == true then -- if all are true
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				topLeftCorner(tcID, true)
				bottomLeftCorner(bcID, true)
			end
		elseif tln == false and bln == true and tn == false and bn == true then -- if bottom and bottom left is true
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, false)
				bottomLeftCorner(bcID, true)
			end
		elseif tln == false and bln == false and tn == false and bn == true then -- if only bottom
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, false)
				squareCorner(bcID, true)
			end
		elseif tln == false and bln == false and tn == true and bn == false then -- if only top
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				squareCorner(bcID, false)
			end
		elseif tln == true and bln == false and tn == true and bn == false then -- if top and top left is true
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				topLeftCorner(tcID, true)
				squareCorner(bcID, false)
			end
		elseif tln == false and bln == false and tn == true and bn == true then -- if top and bottom
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			end
		elseif tln == true and bln == false and tn == true and bn == true then -- if top bottom and top left
			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				topLeftCorner(tcID, true)
				squareCorner(bcID, true)
			end
		elseif tln == false and bln == true and tn == true and bn == true then -- if top bottom and bottom left

			if a == true then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				bottomLeftCorner(bcID, true)
			end
		
		elseif tln == true and bln == false and tn == false and bn == false then
			if a == true then
				bottomLeftCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				squareCorner(bcID, false)
			end
		elseif tln == true and bln == false and tn == false and bn == true then
			if a == true then
				bottomLeftCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			end
		elseif tln == true and bln == true and tn == false and bn == true then
			if a == true then
				bottomLeftCorner(tcID, true)
				squareCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				bottomLeftCorner(bcID, true)
			end

		elseif tln == false and bln == true and tn == false and bn == false then
			if a == true then
				topLeftCorner(bcID, true)
				squareCorner(tcID, true)
			elseif a == false then
				squareCorner(bcID, true)
				squareCorner(tcID, false)
			end
		elseif tln == false and bln == true and tn == true and bn == false then
			if a == true then
				topLeftCorner(bcID, true)
				squareCorner(tcID, true)
			elseif a == false then
				squareCorner(bcID, true)
				squareCorner(tcID, true)
			end
		elseif tln == true and bln == true and tn == true and bn == false then
			
			if a == true then
				topLeftCorner(bcID, true)
				squareCorner(tcID, true)
			elseif a == false then
				topLeftCorner(tcID, true)
				squareCorner(bcID, true)
			end

		elseif tln == true and bln == true and tn == false and bn == false then
			-- if both left is true
			if a == true then
				bottomLeftCorner(tcID, true)
				topLeftCorner(bcID, true)
			elseif a == false then
				squareCorner(tcID, true)
				squareCorner(bcID, true)
			end

		else
			print("exeption on left, top and bottom neigbours")
		end

	elseif tnID == 0 and bnID == 0 then
		-- if horizontal
		local tn, bn = 0, 0
		local tln, trn, bln, brn = blocksGroup[tlnID].display, blocksGroup[trnID].display, blocksGroup[blnID].display, blocksGroup[brnID].display

		if tln == true and trn == true and bln == true and brn == true then
			-- if all are true
			if a == true then
				squareCorner(lcID, true)
				squareCorner(rcID, true)
			elseif a == false then
				squareCorner(lcID, true)
				squareCorner(rcID, true)
			end

		elseif tln == false and trn == false and bln == false and brn == false then
			-- if all are false
			if a == true then
				squareCorner(lcID, true)
				squareCorner(rcID, true)
			elseif a == false then
				squareCorner(lcID, false)
				squareCorner(rcID, false)
			end

		elseif tln == true and trn == false and bln == true and brn == false then
			-- if both left are true
			if a == true then
				squareCorner(lcID, true)
				squareCorner(rcID, true)
			elseif a == false then
				squareCorner(lcID, true)
				squareCorner(rcID, false)
			end

		elseif tln == false and trn == true and bln == false and brn == true then
			-- if both right are true
			if a == true then
				squareCorner(lcID, true)
				squareCorner(rcID, true)
			elseif a == false then
				squareCorner(lcID, false)
				squareCorner(rcID, true)
			end

		elseif tln == true and trn == true and bln == false and brn == false then
			-- if both top are true
			if a == true then
				topRightCorner(lcID, true)
				topLeftCorner(rcID, true)
			elseif a == false then
				squareCorner(lcID, true)
				squareCorner(rcID, true)
			end

		elseif tln == false and trn == false and bln == true and brn == true then
			-- if both bottoms are true
			if a == true then
				bottomRightCorner(lcID, true)
				bottomLeftCorner(rcID, true)
			elseif a == false then
				squareCorner(lcID, true)
				squareCorner(rcID, true)
			end

		elseif tln == true and trn == false and bln == false and brn == false then
			if a == true then
				topRightCorner(lcID, true)
				squareCorner(rcID, true)
			elseif a == false then
				squareCorner(lcID, true)
				squareCorner(rcID, false)
			end
		elseif tln == true and trn == true and bln == false and brn == true then
			-- if only top left is true
			if a == true then
				topRightCorner(lcID, true)
				squareCorner(rcID, true)
			elseif a == false then
				squareCorner(lcID, true)
				squareCorner(rcID, true)
			end

		elseif tln == false and trn == false and bln == true and brn == false then
			if a == true then
				bottomRightCorner(lcID, true)
				squareCorner(rcID, true)
			elseif a == false then
				squareCorner(lcID, true)
				squareCorner(rcID, false)
			end
		elseif tln == false and trn == true and bln == true and brn == true then
			-- if only bottom left is true
			if a == true then
				bottomRightCorner(lcID, true)
				squareCorner(rcID, true)
			elseif a == false then
				squareCorner(lcID, true)
				squareCorner(rcID, true)
			end

		elseif tln == false and trn == true and bln == false and brn == false then
			if a == true then
				topLeftCorner(rcID, true)
				squareCorner(lcID, true)
			elseif a == false then
				squareCorner(rcID, true)
				squareCorner(lcID, false)
			end
		elseif tln == true and trn == true and bln == true and brn == false then
			-- if only top right is true
			if a == true then
				topLeftCorner(rcID, true)
				squareCorner(lcID, true)
			elseif a == false then
				squareCorner(rcID, true)
				squareCorner(lcID, true)
			end

		elseif tln == false and trn == false and bln == false and brn == true then
			if a == true then
				bottomLeftCorner(rcID, true)
				squareCorner(lcID, true)
			elseif a == false then
				squareCorner(rcID, true)
				squareCorner(lcID, false)
			end
		elseif tln == true and trn == false and bln == true and brn == true then
			-- if only bottom right is true
			if a == true then
				bottomLeftCorner(rcID, true)
				squareCorner(lcID, true)
			elseif a == false then
				squareCorner(rcID, true)
				squareCorner(lcID, true)
			end
		elseif tln == true and trn == false and bln == false and brn == true then
			-- if only bottom right is true
			if a == true then
				bottomLeftCorner(rcID, true)
				topRightCorner(lcID, true)
			elseif a == false then
				squareCorner(rcID, true)
				squareCorner(lcID, true)
			end
		elseif tln == false and trn == true and bln == true and brn == false then
			-- if only bottom right is true
			if a == true then
				topLeftCorner(rcID, true)
				bottomRightCorner(lcID, true)
			elseif a == false then
				squareCorner(rcID, true)
				squareCorner(lcID, true)
			end
		else
			print("exeption on all is posible corner")
		end
	else
		print("exeption on neighbour check")
	end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--           TOGGLE TL CORNER             --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function topLeftCorner(i, on)
	cornerGroup[i].bottomRight.alpha = 0
	cornerGroup[i].bottomLeft.alpha = 0
	cornerGroup[i].topRight.alpha = 0

	if on == true then 
		transition.to( cornerGroup[i], { time=150, alpha=1, transition=easing.inQuad } )
		transition.to( cornerGroup[i].topLeft, { time=150, alpha=1, transition=easing.inQuad } )
	elseif on == false then
		transition.to( cornerGroup[i], { time=150, alpha=0, transition=easing.outQuad } )
		transition.to( cornerGroup[i].topLeft, { time=150, alpha=0, transition=easing.outQuad } )
	end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--           TOGGLE TR CORNER             --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function topRightCorner(i, on)
	cornerGroup[i].topLeft.alpha = 0
	cornerGroup[i].bottomLeft.alpha = 0
	cornerGroup[i].bottomRight.alpha = 0

	if on == true then 
		transition.to( cornerGroup[i], { time=150, alpha=1, transition=easing.inQuad } )
		transition.to( cornerGroup[i].topRight, { time=150, alpha=1, transition=easing.inQuad } )
	elseif on == false then
		transition.to( cornerGroup[i], { time=150, alpha=0, transition=easing.outQuad } )
		transition.to( cornerGroup[i].topRight, { time=150, alpha=0, transition=easing.outQuad } )
	end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--           TOGGLE BL CORNER             --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function bottomLeftCorner(i, on)
	cornerGroup[i].bottomRight.alpha = 0
	cornerGroup[i].topLeft.alpha = 0
	cornerGroup[i].topRight.alpha = 0

	if on == true then 
		transition.to( cornerGroup[i], { time=150, alpha=1, transition=easing.inQuad } )
		transition.to( cornerGroup[i].bottomLeft, { time=150, alpha=1, transition=easing.inQuad } )
	elseif on == false then
		transition.to( cornerGroup[i], { time=150, alpha=0, transition=easing.outQuad } )
		transition.to( cornerGroup[i].bottomLeft, { time=150, alpha=0, transition=easing.outQuad } )
	end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--           TOGGLE BR CORNER             --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function bottomRightCorner(i, on)
	cornerGroup[i].topLeft.alpha = 0
	cornerGroup[i].bottomLeft.alpha = 0
	cornerGroup[i].topRight.alpha = 0

	if on == true then 
		transition.to( cornerGroup[i], { time=150, alpha=1, transition=easing.inQuad } )
		transition.to( cornerGroup[i].bottomRight, { time=150, alpha=1, transition=easing.inQuad } )
	elseif on == false then
		transition.to( cornerGroup[i], { time=150, alpha=0, transition=easing.outQuad } )
		transition.to( cornerGroup[i].bottomRight, { time=150, alpha=0, transition=easing.outQuad } )
	end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--           TOGGLE SQ CORNER             --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function squareCorner(i, on)
	if on == true then 
		transition.to( cornerGroup[i], { time=150, alpha=1, transition=easing.inQuad } )
		cornerGroup[i].bottomRight.alpha = 1
		cornerGroup[i].topLeft.alpha = 1
		cornerGroup[i].bottomLeft.alpha = 1
		cornerGroup[i].topRight.alpha = 1
	elseif on == false then
		transition.to( cornerGroup[i], { time=150, alpha=0, transition=easing.outQuad } )
		cornerGroup[i].bottomRight.alpha= 0
		cornerGroup[i].topLeft.alpha = 0
		cornerGroup[i].bottomLeft.alpha = 0
		cornerGroup[i].topRight.alpha = 0
	end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--            DRAW THE BLOCKS             --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function blockObject:drawBlock(i) 
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

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--           DRAW THE CORNERS             --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

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

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--               ANIMATIONS               --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--            WRONG BLOCK FADE            --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function fadeInOut( target )

	print("fade animation")
	blocksGroup[target]:removeEventListener( "touch", myTouchListener )

	transition.to( blocksGroup[target], { time=300, delay=0, alpha=0.5, transition=easing.outQuad } )
	transition.to( blocksGroup[target], { time=300, delay=300, alpha=1, transition=easing.inQuad } )
	transition.to( blocksGroup[target], { time=300, delay=600, alpha=0.5, transition=easing.outQuad } )
	transition.to( blocksGroup[target], { time=300, delay=900, alpha=1, transition=easing.inQuad, onComplete=function() blocksGroup[target]:addEventListener( "touch", myTouchListener ) end } )
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--            WRONG BLOCK FADE            --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function endAnimation()
	--transition.to( grid, { time=300, alpha=0.2, transition=easing.outQuad } )
	transition.to( blocksGroup, { time=300, alpha=0, transition=easing.outQuad } )
	transition.to( cornerGroup, { time=250, alpha=0, transition=easing.outQuad } )
	transition.to( nextButton, { time=800, alpha=0, y=-90, transition=easing.outQuad } )
	transition.to( prevButton, { time=800, alpha=0, y=-90, transition=easing.outQuad } )
	transition.to( levelIndicator, { time=800, alpha=0, y=588, transition=easing.outQuad } )
	transition.to( timeLeft, { time=100, alpha=0, transition=easing.outQuad } )
end

local function newLevelAnimation()
	--transition.to( grid, { time=300, alpha=0, transition=easing.outQuad } )
	transition.to( blocksGroup, { time=300, alpha=0, transition=easing.outQuad } )
	transition.to( cornerGroup, { time=250, alpha=0, transition=easing.outQuad } )
	transition.to( nextButton, { time=0, alpha=0, y=-90, transition=easing.outQuad } )
	transition.to( prevButton, { time=0, alpha=0, y=-90, transition=easing.outQuad } )
	transition.to( levelIndicator, { time=800, alpha=0, y=588, transition=easing.outQuad } )
	transition.to( timeLeft, { time=0, alpha=0, transition=easing.outQuad } )
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--          MISSING BLOCK MESSAGE         --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function alertMissing()
	x = math.floor(gridWidth * 3 + 4)
	y = 55
	w = math.floor(gridWidth * 3)
	h = math.floor(gridHeight * 2)
	tY = 90 + yFixSmall

	local alertMissing = display.newText( "Something is missing", x, y, w, h, "Gridnik", 16 )
	alertMissing:setFillColor( 0, 0, 0 )

	alertMissing.y = -20
	alertMissing.alpha = 0
	transition.to( alertMissing, { time=500, alpha=1, y=tY, transition=easing.inQuad } )
	transition.to( alertMissing, { time=500, delay=1400, alpha=0, y=-20, transition=easing.outQuad } )
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--           WRONG BLOCK MESSAGE          --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function alertWrong()
	x = math.floor(gridWidth * 3 + 4)
	y = 55
	w = math.floor(gridWidth * 3)
	h = math.floor(gridHeight * 2)
	tY = 90 + yFixSmall

	local alertWrong = display.newText( "Something is wrong", x, y, w, h, "Gridnik", 16 )
	alertWrong:setFillColor( 0, 0, 0 )

	alertWrong.y = -20
	alertWrong.alpha = 0
	transition.to( alertWrong, { time=500, alpha=1, y=tY, transition=easing.inQuad } )
	transition.to( alertWrong, { time=500, delay=1400, alpha=0, y=-20, transition=easing.outQuad } )
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--          FACT UNLOCKED MESSAGE         --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function alertFact( i )
	x = math.floor(gridWidth * 3 + 4)
	y = 55
	w = math.floor(gridWidth * 3)
	h = math.floor(gridHeight * 2)
	tY = 90 + yFixSmall

	string = "Fact "..i.." unlocked!"
	print(string)

	local alertFact = display.newText( string, x, y, w, h, "Gridnik", 16 )
	alertFact:setFillColor( 0, 0, 0 )

	alertFact.y = -20
	alertFact.alpha = 0
	transition.to( alertFact, { time=500, alpha=1, y=tY, transition=easing.inQuad } )
	transition.to( alertFact, { time=500, delay=1600, alpha=0, y=-20, transition=easing.outQuad } )
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--            TIMER FUNCTIONS             --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
local function resetScore()
	print("score reset")
	print(timeScore[1])
	timer.cancel( scoreTimer )
	timeScore[1] = 0
	timeLeft.width = gridWidth * 3
	time = 1000
end

local function exitScore()
	print("score reset")
	timeScore[1] = 0
	saveScore()

	timer.cancel( scoreTimer )
	timeLeft.width = gridWidth * 3
	time = 1000
end

local function saveCurrScore()
	print("save score")
	timer.cancel( scoreTimer )
	timeScore[1] = timeScore[1] + time
	saveScore()

	print("currnet score: "..timeScore[1])

	timer.cancel( scoreTimer )
	timeScore[1] = 0
	timeLeft.width = gridWidth * 3
	time = 1000
end

local function drawTimer()

	print(gridWidth * 3)

	local x = gridWidth * 3
	local y = ( display.viewableContentHeight - 5 ) + display.screenOriginY
	local w = gridWidth * 3
	local h = 10 

	timeLeft = display.newRect( x, y, w, h )
	timeLeft:setFillColor(0,0,0)
	timeLeft.alpha = 0
	--timeLeft.y = -10

	transition.to( timeLeft, { time=300, alpha=1, transition=easing.inQuad } )
end

local function timerDown()

	local t = totalTime -- total time

	timeLeft:setReferencePoint( display.CenterLeftReferencePoint )
	time = time - 1

	timeLeft.width = ( timerWidth / t ) * time

	timeLeft.x = 105 - (timerWidth / ( t * 2 )) 

	if( time == 0 )then
		print("Time Out") -- or do your code for time out
		print(timeScore[1])
		--timeScore[1] = timeScore[1] + 0
		saveScore()
	end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--          FACT UNLOCKED MESSAGE         --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function drawLevelIndicator( level, char )

	charX = math.floor(gridWidth * 4.5)
	levelX = math.floor(gridWidth * 4.5)

	levelString = level.."/"..totalLevels

	local char = display.newText( char, 0, 0, "Gridnik", 16 )
	char:setFillColor( 0, 0, 0 )
	char:setReferencePoint( display.CenterReferencePoint )
	char.x = charX

	local level = display.newText( levelString, 0, 18, "Gridnik", 14 )
	level:setFillColor( 0, 0, 0 )
	level:setReferencePoint( display.CenterReferencePoint )
	level.x = levelX

	levelIndicator:insert(char)
	levelIndicator:insert(level)
	levelIndicator.y = 588

	transition.to( levelIndicator, { time=1000, alpha=1, y=460, transition=easing.inQuad } )
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--           PRESS NEXT BUTTON            --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function onNextBtnRelease( event )
	if event.phase == "began" then

		for b=1, #blocksData do
			for c=1, #trueBlocks do
				local tb = trueBlocks[c]
				if b == tb then
					if blocksGroup[tb].display == true then
						correct = correct + 1
					end
				end
			end
			for f=1, #falseBlocks do
				local fb = falseBlocks[f]
				if b == fb then
					if blocksGroup[fb].display == false then
						wrong = wrong + 1
					end
				end
			end
		end

		print("correct: "..correct)
		print("wrong: "..wrong)

		if correct == #trueBlocks and wrong == #falseBlocks then
			print("next level!")
			print(levels[currentLevel])

			if levels[currentLevel] == 2 and time > 0 and levels[currentLevel - 1] == 1 then
				alertFact(currentLevel)
				levels[currentLevel] = 1

				gameNetwork.request( "unlockAchievement",
				{
				    achievement =
				    {
				        identifier="nl.bram-de-leeuw.wcna.fact4",
				        percentComplete=100,
				        showsCompletionBanner=false,
				    }
				})
			end

			-- save levels
			saveLevels()
			
			-- save score
			saveCurrScore()
			
			composer.gotoScene( nextLevel, options )
			--newLevelAnimation()
			--endAnimation()

		elseif correct > 0 and wrong == #falseBlocks then
			print("something is missing")
			alertMissing()

		elseif wrong <= #falseBlocks then
			print("something is wrong")
			alertWrong()

			for f=1, #falseBlocks do
				local fb = falseBlocks[f]
				if blocksGroup[fb].display == true then
					fadeInOut( fb )
				end
			end

		else 
			print("exeption")
		end

		-- reset
		correct = 0
		wrong = 0

	end 
	return true	-- indicates successful touch
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--           PRESS PREV BUTTON            --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function onPrevBtnRelease( event )
	if event.phase == "began" then
		print("Go to main menu")
		exitScore()
		endAnimation()
		composer.gotoScene( "mainMenu", options )
	end 
	return true	-- indicates successful touch
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--              RESET SCORE               --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function resetLevel()
	correct = 0
	wrong = 0
	for i=1, #blocksData do
		blocksGroup[i].display = false
	end
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--            DRAW NEXT BUTTON            --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function drawNextButton()
	x = 270
	y = 65
	addX, addY = 25, 25

	local triangle = { x,y, x+addX,y+(addY/2), x,y+addY, x,y }

	local bg = display.newRect( x-12, y-12, 50, 50 )
	bg:setFillColor( 255,255,255 )
	nextButton:insert( bg )

	local arrow = polygonFill( table.listToNamed(triangle,{'x','y'}), isclosed, isperpixel, widthheight, widthheight, {0,0,0} )
	nextButton:insert( arrow )

	nextButton:addEventListener( "touch", onNextBtnRelease )

	nextButton.alpha = 0
	nextButton.y = -90

	transition.to( nextButton, { time=1000, alpha=1, y=0, transition=easing.inQuad } )
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--            DRAW PREV BUTTON            --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function drawPrevButton()
	x = 20
	y = 65
	addX, addY = 25, 25

	local triangle = { x,y+(addY/2), x+addX,y, x+addX,y+addY, x,y+(addY/2) }


	local bg = display.newRect( x-12, y-12, 50, 50 )
	bg:setFillColor( 255,255,255 )
	prevButton:insert( bg )

	arrow = polygonFill( table.listToNamed(triangle,{'x','y'}), isclosed, isperpixel, widthheight, widthheight, {0,0,0} )
	prevButton:insert( arrow )

	prevButton:addEventListener( "touch", onPrevBtnRelease )

	prevButton.alpha = 0
	prevButton.y = -90

	transition.to( prevButton, { time=1000, alpha=1, y=0, transition=easing.inQuad } )

end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--              DRAW LINE X               --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function drawLineX( i )
	local line = display.newLine( 0,gridHeight*i, 320,gridHeight*i )
	line:setStrokeColor( 0, 0, 0)
	line.strokeWidth = 1
	grid:insert( line )
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--              DRAW LINE Y               --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function drawLineY( i )
	local line = display.newLine( gridWidth*i,0, gridWidth*i,568 )
	line:setStrokeColor( 0, 0, 0 )
	line.strokeWidth = 1
	grid:insert( line )
end


-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--             DRAW THE GRID              --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local function drawGrid()

	-- X grid
	for i, linesX in ipairs(linesX) do
		drawLineX( linesX )
	end

	-- Y grid
	for i, linesY in ipairs(linesY) do
		drawLineY( linesY )
	end
	grid.alpha = 1
	--transition.to( grid, { time=100, alpha=0.2, transition=easing.inQuad } )
end

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless composer.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:create( event )
	local group = self.view
	-- corner objects
	for i=1,#cornerData do
		cO.posX, cO.posY = cornerData[i].posX,cornerData[i].posY
		cO:drawCorner()
	end

	-- block objects
	for i=1,#blocksData do
		local bd = blocksData[i]
		o.posX, o.posY, o.width, o.height = bd.posX, bd.posY, bd.width, bd.height
		o.tln, o.trn, o.bln, o.brn, o.tn, o.bn = bd[1].tln, bd[1].trn, bd[1].bln, bd[1].brn, bd[1].tn, bd[1].bn
		o.lc, o.rc, o.tc, o.bc = bd[2].lc, bd[2].rc, bd[2].tc, bd[2].bc
		o:drawBlock(i)
	end

	drawNextButton()
	drawPrevButton()
	drawGrid()
	drawLevelIndicator( currentLevel, currentChar )
	drawTimer()

	group:insert( grid )
	group:insert( blocksGroup )
	group:insert( cornerGroup )
	group:insert( nextButton )
	group:insert( prevButton )
	group:insert( levelIndicator )
	group:insert( timeLeft )
end



-- Called immediately after scene has moved onscreen:
function scene:show( event )
	local group = self.view

	scoreTimer = timer.performWithDelay(1,timerDown,time)

	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
end

-- Called when scene is about to move offscreen:
function scene:hide( event )
	local group = self.view
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)

	resetLevel()
	composer.removeHidden()
end

-- If scene's view is removed, scene:destroy() will be called just prior to:
function scene:destroy( event )
	local group = self.view

end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "create" event is dispatched if scene's view does not exist
scene:addEventListener( "create", scene )

-- "enter" event is dispatched whenever scene transition has finished
scene:addEventListener( "show", scene )

-- "exit" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "hide", scene )

-- "destroy" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- composer.purgeScene() or composer.removeScene().
scene:addEventListener( "destroy", scene )

Runtime:addEventListener( "system", onSystemEvent )
-----------------------------------------------------------------------------------------

return scene