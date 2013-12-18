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

-- include GGTwitter => activate for a later release
-- local GGTwitter = require( "GGTwitter" )

-- levelstorage
local levelstorage = require("levelstorage")

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

-- twitter autorisation
--[[
local twitter

local listener = function( event )
    if event.phase == "authorised" then

    end
end

twitter = GGTwitter:new( "BH2z1M2WZ126GoDepqCA", "jWNYyZIazqfeLYf4UhkAXgcU4Yc09ij40LVZl9ve4", listener, "http://www.bram-de-leeuw.nl/" )
]]
------------------

-- what level?
levels =
{
2, 2, 2, 2, 2, 2,
2, 2, 2, 2, 2, 2,
2, 2, 2, 2, 2, 2,
2, 2, 2, 2,
}
levels = loadLevels()

local unlocks = #levels

for i=1, #levels do 
	if levels[i] == 1 then
		unlocks = unlocks - 1
	end
end

-- change story board options
local options =
{
    effect = "crossFade",
    time = 400
}

-- font fix
if system.getInfo("environment") == "simulator" then simulator = true end
yFixSmall = 6
if simulator then
    yFixSmall = 0
end

-- create a group for the background grid lines
local grid, sliderBox, slide, prevButton = display.newGroup(), display.newGroup(), display.newGroup(), display.newGroup()

-- polygon fill options
local widthheight, isclosed, isperpixel = 0.25, false, false

-- grid square width and height variables
local gridWidth = math.floor(320/9)
local gridHeight = math.floor(568/15)

-- slidewidth
local slideWidth = gridWidth * 6
local scrollListener
local scrollView

display.setDefault( "background", 255, 255, 255 )

-- line data
local linesX = {3,4,5,6,9,10,11,12}
local linesY = {2,3,6,7}

-- quotes
local quotes = {
	{"Right from the beginning my work was highly influenced by architecture, not directly but via the statements that architects delivered.", "Wim Crouwel"},
	{"The graphic grid was a valued tool through which order in typography could be created.", "Wim Crouwel"},
	{"The modern sans serif typeface was, as an ultimate expression of its time, preferable above classic fonts.", "Wim Crouwel"},
	{"I became so intrigued by the first computerized typesetting in the sixties, that I thought it wise to create a specific typeface for it.", "Wim Crouwel"},
	{"I decided that my typeface had to be constructed from straight lines and 45 degrees corners.", "Wim Crouwel"},
	{"All letters should have an even width, whereby spacing between words should always be related to the width of an individual character.", "Wim Crouwel"},
	{"Sometimes, while working on this project, I even thought: ‘through the computer, design finally has become democratic’.", "Wim Crouwel"},
	{"I was intrigued by the structural experiments of De Stijl and the purifying direction of the Dessau Bauhaus.", "Wim Crouwel"},
	{"All in all I became very interested in all sorts of modular techniques to reproduce typefaces, such as through bricklaying and through tiles.", "Wim Crouwel"},
	{"I for myself cannot stop to believe that graphic design is first of all a means of making things clear.", "Wim Crouwel"},
	{"Lower-case typography has two sources: one is idealistic and the other functional-rational.", "Wim Crouwel"},
	{"For quite a while Bauhaus stationery read: ‘wir schreiben alles klein, denn wir sparen damit zeit’.", "Wim Crouwel"},
	{"Both Jan Tschichold and Herbert Bayer made designs for a universal alphabet.", "Wim Crouwel"},
	{"Piet Zwart developed an emphasis on a clear, open en rhythmic order of typographic elements.", "PWim Crouwel"},
	{"I proposed a single-alphabet typeface as an answer to new functional needs.", "Wim Crouwel"},
	{"NA was a rather theoretical proposal, since some of the characters did not have any resemblance with existing ones.", "Wim Crouwel"},
	{"The basic principles in typography and graphic design, which were highly decisive in my career; are still valid.", "Wim Crouwel"},
	{"Masters of Modernism: Tschichold, Bayer,Renner, Zwart, Moholy Nagy showed us how lucid the result could be.", "Wim Crouwel"},
	{"What is it that designers in the country have, which does not effect most of the designers in other countries?", "Wim Crouwel"},
	{"Is that missionary force a result of a general need of the Dutch to win souls?", "Wim Crouwel"},
	{"Or is it that designers pre-eminently are the guardian angels of our consciences?", "Wim Crouwel"},
	{"I believe the disappearance of utopias is a great loss for the current intellectual and artistically minded debate.", "Wim Crouwel"}
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
		storyboard.gotoScene( "mainMenu", options )
	end 
	return true	-- indicates successful touch
end

--[[
local function onTweetBtnRelease( event )
	if event.phase == "began" then
		print("Tweet: "..event.target.message)
		twitter:post( event.target.message )
	end 
	return true	-- indicates successful touch
end
]]

local function scrollListener( event )
    local phase = event.phase
    local direction = event.direction
    local target = event.target

    print(event.name)

    --print(direction)
    --print(target)

    if "began" == phase then
        print( "Began" )
    elseif "moved" == phase then
        print( "Moved" )
    elseif phase == "ended" then
        print( "Ended" )
    end

    -- resume transition so back button will appear
    transition.resume()

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
scrollView = widget.newScrollView
{
    top = gridHeight * 1.5,
    left = 0,
    width = display.contentWidth,
    height = display.contentHeight - ( gridHeight * 3 ),
    scrollWidth = sliderBox.width + display.contentWidth,
    scrollHeight = slide.height,
    listener = scrollListener,
    verticalScrollDisabled = true,
    hideBackground = true,
    hideScrollBar = true,
    --friction = 0,
    rightPadding = -( gridWidth * 2.45 ) - ( slideWidth * ( unlocks ) ),
}

local function drawSlide( nr )
	local contentGroup = display.newGroup()

	local quote = quotes[nr]
	local w, h = gridWidth * 5, gridHeight * 5
	local cX, cY = ( gridWidth * 2 ) + (( w + gridWidth ) * ( nr - 1 )), gridHeight * 4
	local fX, fY = ( gridWidth * 2 ) + (( w + gridWidth ) * ( nr - 1 )), ( gridHeight * 9 ) + 16 + yFixSmall
	local tX, tY = ( gridWidth * 2 ) + (( w + gridWidth ) * ( nr - 1 )), gridHeight * 11

	content = display.newText( quote[1], cX, cY, w, h, "Gridnik", 18 )
	content:setFillColor( 0, 0, 0 )
	contentGroup:insert(content)

	from = display.newText( quote[2], fX, fY, "Gridnik", 18 )
	from:setFillColor( 0, 0, 0 )
	contentGroup:insert(from)

	--[[
	-- twitter integration for a later version
	tweet = display.newRect( tX, tY, gridWidth, gridHeight )
	tweet:setFillColor(0,172,237)
	contentGroup:insert(tweet)

	tweetIMG = display.newImageRect( "twit.png", gridWidth, gridHeight )
	tweetIMG:translate( tX + (gridWidth/2), tY + (gridHeight/2))
	contentGroup:insert(tweetIMG)

	tweetIMG.message = quote[1].." -"..quote[2].." #WCNA www.bram-de-leeuw.nl"

	print(message)

	tweetIMG:addEventListener( "touch", onTweetBtnRelease )
	]]
	slide:insert( contentGroup )
	sliderBox:insert(slide)
end

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
	
	local group = self.view

	--twitter:authorise()

	-- draw the grid
	drawGrid()	

	-- place the quotes
	for i=1, #levels do
		drawSlide(i)
	end

	scrollView:insert( sliderBox )
	drawPrevButton()
	
	--print("twitter?")
	--print( twitter:isAuthorised() )
	
	group:insert( grid )
	group:insert( scrollView )
	group:insert( prevButton )
end



-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

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

Runtime:addEventListener( "system", onSystemEvent )

-----------------------------------------------------------------------------------------

return scene