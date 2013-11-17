-----------------------------------------------------------------------------------------
--
-- mainMenu.lua
-- solve A
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

-- create a group for the background grid lines
local grid, sliderBox, slide = display.newGroup(), display.newGroup(), display.newGroup()

-- polygon fill options
local widthheight, isclosed, isperpixel = 1, false, false

-- grid square width and height variables
local gridWidth = math.floor(320/9)
local gridHeight = math.floor(568/15)

-- slidewidth
local slideWidth = gridWidth * 6

display.setDefault( "background", 255, 255, 255 )

-- line data
local linesX = {3,4,5,6,9,10,11,12}
local linesY = {2,3,6,7}

-- quotes
local quotes = {
	{"I look to Wim Crouwel continually to inspire me to be spare, concise and to do it in perfect scale.", "Paula Scher"},
	{"I look to Wim Crouwel continually to inspire me to be spare, concise and to do it in perfect scale.", "Paula Scher"},
	{"I look to Wim Crouwel continually to inspire me to be spare, concise and to do it in perfect scale.", "Paula Scher"},
	{"I look to Wim Crouwel continually to inspire me to be spare, concise and to do it in perfect scale.", "Paula Scher"},
	{"I look to Wim Crouwel continually to inspire me to be spare, concise and to do it in perfect scale.", "Paula Scher"},
	{"I look to Wim Crouwel continually to inspire me to be spare, concise and to do it in perfect scale.", "Paula Scher"},
	{"I look to Wim Crouwel continually to inspire me to be spare, concise and to do it in perfect scale.", "Paula Scher"},
	{"I look to Wim Crouwel continually to inspire me to be spare, concise and to do it in perfect scale.", "Paula Scher"}
}

local function endAnimation()
	--transition.to( grid, { time=300, alpha=0.2, transition=easing.outQuad } )
	transition.to( prevButton, { time=800, alpha=0, y=-90, transition=easing.outQuad } )
	transition.to( slide, { time=300, alpha=0, transition=easing.outQuad } )
end

local function onPrevBtnRelease( event )
	if event.phase == "began" then
		print("Go to main menu")
		endAnimation()
		storyboard.gotoScene( "mainMenu" )
	end 
	return true	-- indicates successful touch
end

-- touch listener function
--[[
function slide:touch( event )
    if event.phase == "began" then
	
        self.markX = self.x    -- store x location of object
	
    elseif event.phase == "moved" then
	
        local x = (event.x - event.xStart) + self.markX
        
        self.x = x -- move object based on calculations above
    end
    
    return true
end
]]

local function scrollListener( event )
    local phase = event.phase
    local direction = event.direction

    print(phase)
    print(direction)

    if "began" == phase then
        print( "Began" )
    elseif "moved" == phase then
        print( "Moved" )
    elseif "ended" == phase then
        print( "Ended" )
    end

    -- If we have reached one of the scrollViews limits
    if event.limitReached then
		if "left" == direction then
            print( "Reached Left Limit" )
        elseif "right" == direction then
            print( "Reached Right Limit" )
        end
    end

    return true
end

-- Create a ScrollView
local scrollView = widget.newScrollView
{
    top = gridHeight * 1.5,
    left = 0,
    width = display.contentWidth,
    height = display.contentHeight - ( gridHeight * 3 ),
    scrollWidth = sliderBox.width,
    scrollHeight = slide.height,
    listener = scrollListener,
    verticalScrollDisabled = true,
    hideBackground = true,
    hideScrollBar = true,
    rightPadding = -( gridWidth * 2.45 ) - ( slideWidth * 0 ) --( #quotes -1 )),
}

local function drawSlide( nr )
	local contentGroup = display.newGroup()

	local quote = quotes[nr]
	local w, h = gridWidth * 5, gridHeight * 4
	local cX, cY = ( gridWidth * 2 ) + (( w + gridWidth ) * ( nr - 1 )), gridHeight * 5
	local fX, fY = ( gridWidth * 2 ) + (( w + gridWidth ) * ( nr - 1 )), ( gridHeight * 9 ) + 16
	local tX, tY = ( gridWidth * 2 ) + (( w + gridWidth ) * ( nr - 1 )), gridHeight * 11

	content = display.newText( quote[1], cX, cY, w, h, "Gridnik", 18 )
	content:setFillColor( 0, 0, 0 )
	contentGroup:insert(content)

	from = display.newText( quote[2], fX, fY, "Gridnik", 18 )
	from:setFillColor( 0, 0, 0 )
	contentGroup:insert(from)

	tweet = display.newRect( tX, tY, gridWidth, gridHeight )
	tweet:setFillColor(0,172,237)
	contentGroup:insert(tweet)

	tweetIMG = display.newImage( "twit.png" )
	tweetIMG:translate( tX, tY )
	contentGroup:insert(tweetIMG)
	
	slide:insert( contentGroup )
	sliderBox:insert(slide)
end

local function drawPrevButton()
	x = 20
	y = 65
	addX, addY = 25, 25

	local triangle = { x,y+(addY/2), x+addX,y, x+addX,y+addY, x,y+(addY/2) }

	prevButton = polygonFill( table.listToNamed(triangle,{'x','y'}), isclosed, isperpixel, widthheight, widthheight, {0,0,0} )
	prevButton:addEventListener( "touch", onPrevBtnRelease )

	prevButton.alpha = 0
	prevButton.y = -90

	transition.to( prevButton, { time=1000, alpha=1, y=0, transition=easing.inQuad } )

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

local function drawGrid()

	-- X grid
	for i, linesX in ipairs(linesX) do
		drawLineX( linesX )
	end

	-- Y grid
	for i, linesY in ipairs(linesY) do
		drawLineY( linesY )
	end
	grid.alpha = 0
	transition.to( grid, { time=100, alpha=0.2, transition=easing.inQuad } )
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
	-- draw the grid
	drawGrid()	

	-- place the quotes
	for i=1, #quotes do
		drawSlide(i)
	end

	--sliderBox:addEventListener( "touch", slide )
	scrollView:insert( sliderBox )

end



-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

	drawPrevButton()

	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	storyboard.removeAll()
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