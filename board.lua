local Block = require('block')

local Board = {}
Board.__index = Board

function Board.new()
    local self = setmetatable({}, Board)
    self.width = 10
    self.height = 20
    self.grid = {}
    self:clear()
    return self
end

function Board:clear()
    -- Initialize empty grid
    for y = 0, self.height - 1 do
        self.grid[y] = {}
        for x = 0, self.width - 1 do
            self.grid[y][x] = nil
        end
    end
end

function Board:hasBlock(x, y)
    if y < 0 then return false end
    return self.grid[y] and self.grid[y][x]
end

function Board:addPiece(piece)
    for _, block in ipairs(piece.blocks) do
        self.grid[block.y][block.x] = block
    end
    self:checkLines()
end

function Board:checkLines()
    local y = self.height - 1
    while y >= 0 do
        if self:isLineFull(y) then
            self:removeLine(y)
        else
            y = y - 1
        end
    end
end

function Board:isLineFull(y)
    for x = 0, self.width - 1 do
        if not self.grid[y][x] then
            return false
        end
    end
    return true
end

function Board:removeLine(y)
    -- Remove the line
    for x = 0, self.width - 1 do
        self.grid[y][x] = nil
    end
    
    -- Move all lines above down
    for moveY = y - 1, 0, -1 do
        for x = 0, self.width - 1 do
            if self.grid[moveY][x] then
                local block = self.grid[moveY][x]
                block.y = block.y + 1
                self.grid[moveY + 1][x] = block
                self.grid[moveY][x] = nil
            end
        end
    end
end

function Board:draw()
    -- Draw blocks
    for y = 0, self.height - 1 do
        for x = 0, self.width - 1 do
            if self.grid[y][x] then
                self.grid[y][x]:draw()
            end
        end
    end
    
    -- Draw grid lines
    love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
    for x = 0, self.width do
        love.graphics.line(x * 30, 0, x * 30, self.height * 30)
    end
    for y = 0, self.height do
        love.graphics.line(0, y * 30, self.width * 30, y * 30)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

return Board