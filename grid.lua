--
-- Created by IntelliJ IDEA.
-- User: bramdeleeuw
-- Date: 03/11/2018
-- Time: 13:09
-- To change this template use File | Settings | File Templates.
--
Grid = {}

local grid = display.newGroup()

-- line data
local linesX = { 3, 4, 5, 6, 9, 10, 11, 12 }
local linesY = { 2, 3, 6, 7 }

-- grid square width and height variables
print(display.pixelWidth / display.actualContentWidth)
local gridWidth = math.floor(320 / 9)
local gridHeight = math.floor(568 / 15)

function Grid:create()
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