local Block = require('block')

local Tetromino = {}
Tetromino.__index = Tetromino

-- Define all tetromino shapes and their colors
local SHAPES = {
    -- I piece
    {
        shape = {{1,1,1,1}},
        color = {0, 1, 1} -- cyan
    },
    -- O piece
    {
        shape = {{1,1}, {1,1}},
        color = {1, 1, 0} -- yellow
    },
    -- T piece
    {
        shape = {{0,1,0}, {1,1,1}},
        color = {0.5, 0, 0.5} -- purple
    },
    -- L piece
    {
        shape = {{1,0}, {1,0}, {1,1}},
        color = {1, 0.5, 0} -- orange
    },
    -- J piece
    {
        shape = {{0,1}, {0,1}, {1,1}},
        color = {0, 0, 1} -- blue
    },
    -- S piece
    {
        shape = {{0,1,1}, {1,1,0}},
        color = {0, 1, 0} -- green
    },
    -- Z piece
    {
        shape = {{1,1,0}, {0,1,1}},
        color = {1, 0, 0} -- red
    }
}

function Tetromino.new()
    local self = setmetatable({}, Tetromino)
    self:spawn()
    return self
end

function Tetromino:spawn()
    -- Select random shape
    local shapeData = SHAPES[love.math.random(#SHAPES)]
    self.blocks = {}
    self.shape = shapeData.shape
    self.color = shapeData.color
    
    -- Starting position (centered at top)
    self.x = 4
    self.y = 0
    
    -- Create blocks
    for y = 1, #self.shape do
        for x = 1, #self.shape[y] do
            if self.shape[y][x] == 1 then
                table.insert(self.blocks, Block.new(self.x + x - 1, self.y + y - 1, self.color))
            end
        end
    end
end

function Tetromino:moveLeft(board)
    self:move(-1, 0, board)
end

function Tetromino:moveRight(board)
    self:move(1, 0, board)
end

function Tetromino:moveDown(board)
    return self:move(0, 1, board)
end

function Tetromino:move(dx, dy, board)
    -- Try to move
    for _, block in ipairs(self.blocks) do
        local newX = block.x + dx
        local newY = block.y + dy
        
        -- Check boundaries and collision
        if newX < 0 or newX >= board.width or
           newY >= board.height or
           board:hasBlock(newX, newY) then
            return false
        end
    end
    
    -- Apply movement
    for _, block in ipairs(self.blocks) do
        block.x = block.x + dx
        block.y = block.y + dy
    end
    return true
end

function Tetromino:rotate(board)
    -- Store original positions in case rotation fails
    local originalPositions = {}
    for i, block in ipairs(self.blocks) do
        originalPositions[i] = {x = block.x, y = block.y}
    end
    
    -- Calculate center of rotation
    local centerX = self.blocks[1].x
    local centerY = self.blocks[1].y
    
    -- Rotate each block
    for _, block in ipairs(self.blocks) do
        local relX = block.x - centerX
        local relY = block.y - centerY
        local newX = centerX - relY
        local newY = centerY + relX
        
        -- Check if new position is valid
        if newX < 0 or newX >= board.width or
           newY >= board.height or
           board:hasBlock(newX, newY) then
            -- Restore original positions
            for i, block in ipairs(self.blocks) do
                block.x = originalPositions[i].x
                block.y = originalPositions[i].y
            end
            return false
        end
        
        block.x = newX
        block.y = newY
    end
    return true
end

function Tetromino:draw()
    for _, block in ipairs(self.blocks) do
        block:draw()
    end
end

return Tetromino