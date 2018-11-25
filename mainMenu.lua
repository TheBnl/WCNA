-----------------------------------------------------------------------------------------
--
-- mainMenu.lua
--
-----------------------------------------------------------------------------------------

local composer = require("composer")
local scene = composer.newScene()

-- include Corona's "widget" library
-- local widget = require "widget"

-- levelstorage
local levelstorage = require("levelstorage")

local gameNetwork = require "gameNetwork"
local loggedIntoGC = false

-- called after the "init" request has completed
local function initCallback(event)
    if event.data then
        loggedIntoGC = true
        print("Success!", "User has logged into Game Center", { "OK" })
    else
        loggedIntoGC = false
        print("Fail", "User is not logged into Game Center", { "OK" })
    end
end

-- function to listen for system events
local function onSystemEvent(event)
    if (event.type == "applicationStart") and not (system.getInfo("environment") == "simulator") then
        gameNetwork.init("gamecenter", initCallback)
        return true
    end
end

-- change story board options
local options =
{
    effect = "crossFade",
    time = 400
}

-- what level?
levels =
{
    2, 2, 2, 2, 2, 2,
    2, 2, 2, 2, 2, 2,
    2, 2, 2, 2, 2, 2,
    2, 2, 2, 2,
}
levels = loadLevels()

-- create a group for the background grid lines
local grid = display.newGroup()
local play
local achievements

-- grid square width and height variables
local gridWidth = math.floor(320 / 9)
local gridHeight = math.floor(568 / 15)

--local gridWidth = math.floor(display.actualContentWidth / 9)
--local gridHeight = math.floor(display.actualContentHeight / 15)

print('pixelWidth ' .. display.pixelWidth .. ' actualContentWidth ' .. display.actualContentWidth)
print('pixelHeight ' .. display.pixelHeight .. ' actualContentHeight ' .. display.actualContentHeight)

display.setDefault("background", 255, 255, 255)

-- line data
local linesX = { 3, 4, 5, 6, 9, 10, 11, 12 }
local linesY = { 2, 3, 6, 7 }

-- font fix
if system.getInfo("environment") == "simulator" then simulator = true end
local yFixBig = 0 --14
local yFixSmall = 0 --6
if simulator then
    yFixBig = 0
    yFixSmall = 0
end


-- alert
local function alertAchievement()
    local x = math.floor(gridWidth * 3 + 4)
    local y = 55
    local w = math.floor(gridWidth * 3)
    local h = math.floor(gridHeight * 2)

    local alertWrong = display.newText("Nothing unlocked", x, y, w, h, "Gridnik", 16)
    alertWrong.anchorX = 0
    alertWrong:setFillColor(0, 0, 0)

    alertWrong.y = -20
    alertWrong.alpha = 0
    transition.to(alertWrong, { time = 500, alpha = 1, y = 90, transition = easing.inQuad })
    transition.to(alertWrong, { time = 500, delay = 1400, alpha = 0, y = -20, transition = easing.outQuad })
end

-- draw lines
-- draw line X
local function drawLineX(i)
    local line = display.newLine(0, gridHeight * i, 320, gridHeight * i)
    line:setStrokeColor(0, 0, 0)
    line.strokeWidth = 1
    grid:insert(line)
end

-- draw line Y
local function drawLineY(i)
    local line = display.newLine(gridWidth * i, 0, gridWidth * i, 568)
    line:setStrokeColor(0, 0, 0)
    line.strokeWidth = 1
    grid:insert(line)
end

local function onAchievementsBtnRelease(event)
    if event.phase == "began" then

        if levels[1] == 1 then
            print("go to achievements")
            transition.to(play, { time = 500, alpha = 0, transition = easing.outQuad })
            transition.to(achievements, { time = 500, alpha = 0, transition = easing.outQuad })
            composer.gotoScene("achievements", options)
        else
            alertAchievement()
        end
    end
    return true -- indicates successful touch
end

local function onPlayBtnRelease(event)
    if event.phase == "began" then
        print("Start playing")

        transition.to(play, { time = 500, alpha = 0, transition = easing.outQuad })
        transition.to(achievements, { time = 500, alpha = 0, transition = easing.outQuad })
        transition.to(grid, { time = 500, alpha = 1, transition = easing.inQuad })

        --StartLevel()
        composer.gotoScene("level1", options)
    end
    return true -- indicates successful touch
end

-- draw play button
local function drawPlayBtn()

    local x = gridWidth * 2
    local y = (gridHeight * 3 + 22) + yFixBig

    print('position text x', x)

    play = display.newText("play", x, y, "new_alphabet.ttf", 121)
    play.anchorX = 0;
    play.anchorY = 0;
    play:setFillColor(0, 0, 0)
    play:addEventListener("touch", onPlayBtnRelease)

    play.alpha = 1
    --transition.to( play, { time=500, alpha=1, transition=easing.inQuad } )
end

local function drawGrid()

    -- X grid
    for i, linesX in ipairs(linesX) do
        drawLineX(linesX)
    end

    -- Y grid
    for i, linesY in ipairs(linesY) do
        drawLineY(linesY)
    end
    grid.alpha = 0
    transition.to(grid, { time = 100, alpha = 0.2, transition = easing.inQuad })
end

-- draw achievements button
local function drawAchievementsBtn()

    local x = gridWidth * 2
    local y = (gridHeight * 10 + 18) + yFixSmall

    achievements = display.newText("achievements", x, y, "new_alphabet.ttf", 39.5)
    achievements.anchorX = 0;
    achievements.anchorY = 0;
    achievements:setFillColor(0, 0, 0)
    achievements:addEventListener("touch", onAchievementsBtnRelease)

    achievements.alpha = 1
    --transition.to( achievements, { time=500, alpha=1, transition=easing.inQuad } )
end

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
--
-- NOTE: Code outside of listener functions (below) will only be executed once,
-- unless composer.removeScene() is called.
--
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:create( event )
    local group = self.view

    drawPlayBtn()
    drawAchievementsBtn()
    drawGrid()

    group:insert(grid)
    group:insert(play)
    group:insert(achievements)

    print( "mainMenu::create" )
end



-- Called immediately after scene has moved onscreen:
function scene:show(event)
    local group = self.view
    print( "mainMenu::enter" )




    -- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
end

-- Called when scene is about to move offscreen:
function scene:hide(event)
    local group = self.view
    print( "mainMenu::exit" )
    composer.removeHidden()
end

-- If scene's view is removed, scene:destroy() will be called just prior to:
function scene:destroy(event)
    print( "mainMenu::destroy" )
    local group = self.view
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "create" event is dispatched if scene's view does not exist
scene:addEventListener("create", scene)

-- "enter" event is dispatched whenever scene transition has finished
scene:addEventListener("show", scene)

-- "exit" event is dispatched whenever before next scene's transition begins
scene:addEventListener("hide", scene)

-- "destroy" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- composer.purgeScene() or composer.removeScene().
scene:addEventListener("destroy", scene)

Runtime:addEventListener("system", onSystemEvent)
-----------------------------------------------------------------------------------------

return scene