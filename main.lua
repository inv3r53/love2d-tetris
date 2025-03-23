local Board = require('board')
local Tetromino = require('tetromino')
local Audio = require('audio')

-- Game state
local board
local currentPiece
local gameOver = false
local dropTimer = 0
local dropInterval = 0.5 -- Time in seconds between automatic drops
local score = 0

function love.load()
    love.window.setMode(400, 600)
    board = Board.new()
    currentPiece = Tetromino.new()
    Audio.load() -- Initialize audio
end

function love.update(dt)
    if gameOver then return end
    
    dropTimer = dropTimer + dt
    if dropTimer >= dropInterval then
        dropTimer = 0
        if not currentPiece:moveDown(board) then
            board:addPiece(currentPiece)
            -- Check if game is over
            for x = 0, board.width - 1 do
                if board:hasBlock(x, 0) then
                    gameOver = true
                    Audio.stop() -- Stop music when game is over
                    return
                end
            end
            currentPiece = Tetromino.new()
        end
    end
end

function love.draw()
    -- Center the board
    love.graphics.translate(50, 0)
    
    -- Draw the board and current piece
    board:draw()
    currentPiece:draw()
    
    -- Draw score
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. score, 10, 10)
    
    if gameOver then
        love.graphics.setColor(1, 0, 0)
        love.graphics.print("Game Over!", 150, 250)
        love.graphics.print("Press R to restart", 130, 270)
    end
end

function love.keypressed(key)
    if gameOver then
        if key == 'r' then
            -- Reset game
            board:clear()
            currentPiece = Tetromino.new()
            gameOver = false
            score = 0
            Audio.load() -- Restart music
        end
        return
    end
    
    if key == 'left' then
        currentPiece:moveLeft(board)
    elseif key == 'right' then
        currentPiece:moveRight(board)
    elseif key == 'down' then
        if currentPiece:moveDown(board) then
            score = score + 1
        end
    elseif key == 'up' then
        currentPiece:rotate(board)
    elseif key == 'space' then
        -- Hard drop
        while currentPiece:moveDown(board) do
            score = score + 2
        end
        board:addPiece(currentPiece)
        currentPiece = Tetromino.new()
    elseif key == 'm' then
        Audio.toggleMute() -- Add mute toggle
    end
end