local Block = {}
Block.__index = Block

function Block.new(x, y, color)
    local self = setmetatable({}, Block)
    self.x = x
    self.y = y
    self.color = color
    self.size = 30 -- Size of each block in pixels
    return self
end

function Block:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x * self.size, self.y * self.size, self.size - 1, self.size - 1)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", self.x * self.size, self.y * self.size, self.size - 1, self.size - 1)
end

return Block