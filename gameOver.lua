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

-- levelstorage
local levelstorage = require("levelstorage")

-- timeScore
local ScoreStorage = require("timescore")

--------------------------------------------
-- grid square width and height variables
local gridWidth = math.floor(320/9)
local gridHeight = math.floor(568/15)

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

-- time
timeScore = { 0, }
timeScore = loadScore()

-- change story board options
local options =
{
    effect = "crossFade",
    time = 400
}

-- create a group for the background grid lines
local grid, sliderBox, slide, gameOver, highScore = display.newGroup(), display.newGroup(), display.newGroup(), display.newGroup(), display.newGroup()

-- polygon fill options
local widthheight, isclosed, isperpixel = 0.25, false, false

-- slidewidth
local slideWidth = gridWidth * 6
local scrollListener
local scrollView

display.setDefault( "background", 255, 255, 255 )

-- line data
local linesX = {3,4,5,6,9,10,11,12}
local linesY = {2,3,6,7}


local function endAnimation()
	--transition.to( grid, { time=300, alpha=0.2, transition=easing.outQuad } )
	transition.to( prevButton, { time=800, alpha=0, y=-90, transition=easing.outQuad } )
	transition.to( slide, { time=300, alpha=0, transition=easing.outQuad } )
end

local function onAchievementsBtnRelease( event )
	if event.phase == "began" then

		if levels[1] == 1 then
			print("go to achievements")
			transition.to( play, { time=500, alpha=0, transition=easing.outQuad } )
			transition.to( achievements, { time=500, alpha=0, transition=easing.outQuad } )
			storyboard.gotoScene( "achievements", options )
		else
			alertAchievement()
		end
		
	end 
	return true	-- indicates successful touch
end

local function onPrevBtnRelease( event )
	if event.phase == "began" then
		print("Go to main menu")
		endAnimation()
		storyboard.gotoScene( "mainMenu", options )
	end 
	return true	-- indicates successful touch
end

-- draw achievements button
local function drawAchievementsBtn()

	local x = gridWidth * 2
	local y = gridHeight * 10 + 14

	achievements = display.newText( "achievements", x, y, "New-Alphabet", 39.5 )
	achievements:setFillColor( 0, 0, 0 )
	achievements:addEventListener( "touch", onAchievementsBtnRelease )

	achievements.alpha = 0
	transition.to( achievements, { time=500, alpha=1, transition=easing.inQuad } )
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

-- draw Game ending
local function drawGameOver()

	local x = gridWidth * 2
	local gY = gridHeight * 3 - 30
	local oY = gridHeight * 5 - 30

	game = display.newText( "game", x, gY, "New-Alphabet", 121 )
	game:setFillColor( 0, 0, 0 )
	gameOver:insert( game )

	over = display.newText( "over", x, oY, "New-Alphabet", 121 )
	over:setFillColor( 0, 0, 0 )
	gameOver:insert( over )
end

-- draw Score
local function drawScore()

	local totalScore = timeScore[1]
	
	local sX = gridWidth * 2
	local iX = gridWidth * 4 + 18.5
	local y = gridHeight * 9 + 14

	score = display.newText( "score", sX, y, "New-Alphabet", 39.5 )
	score:setFillColor( 0, 0, 0 )
	highScore:insert( score )

	scoreInt = display.newText( totalScore, iX, y, "New-Alphabet", 39.5 )
	scoreInt:setFillColor( 0, 0, 0 )
	highScore:insert( scoreInt )

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
	-- draw the grid
	drawGrid()	

	drawPrevButton()
	drawAchievementsBtn()
	drawGameOver()
	drawScore()

	group:insert( grid )
	group:insert( score )
	group:insert( gameOver )
	group:insert( highScore )
	group:insert( prevButton )
	group:insert( achievements )

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

-----------------------------------------------------------------------------------------

return scene