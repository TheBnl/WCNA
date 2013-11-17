-----------------------------------------------------------------------------------------
--
-- mainMenu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"

-- create a group for the background grid lines
local grid = display.newGroup()
local play
local achievements

-- grid square width and height variables
local gridWidth = math.floor(320/9)
local gridHeight = math.floor(568/15)

display.setDefault( "background", 255, 255, 255 )

-- line data
local linesX = {3,4,5,6,9,10,11,12}
local linesY = {2,3,6,7}

-- draw lines 
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

local function onAchievementsBtnRelease( event )
	if event.phase == "began" then
		print("go to achievements")

		transition.to( play, { time=500, alpha=0, transition=easing.outQuad } )
		transition.to( achievements, { time=500, alpha=0, transition=easing.outQuad } )
		--transition.to( grid, { time=500, alpha=1, transition=easing.inQuad } )

		--StartLevel()
		storyboard.gotoScene( "achievements" )
	end 
	return true	-- indicates successful touch
end

local function onPlayBtnRelease( event )
	if event.phase == "began" then
		print("Start playing")

		transition.to( play, { time=500, alpha=0, transition=easing.outQuad } )
		transition.to( achievements, { time=500, alpha=0, transition=easing.outQuad } )
		transition.to( grid, { time=500, alpha=1, transition=easing.inQuad } )

		--StartLevel()
		storyboard.gotoScene( "level1" )
	end 
	return true	-- indicates successful touch
end

-- draw play button
local function drawPlayBtn()

	local x = gridWidth * 2
	local y = gridHeight * 5 -30

	play = display.newText( "play", x, y, "New-Alphabet", 121 )
	play:setFillColor( 0, 0, 0 )
	play:addEventListener( "touch", onPlayBtnRelease )

	play.alpha = 0
	transition.to( play, { time=500, alpha=1, transition=easing.inQuad } )

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

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	
end



-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

	drawPlayBtn()
	drawAchievementsBtn()
	drawGrid()

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