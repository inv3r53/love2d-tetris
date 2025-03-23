local Audio = {}

function Audio.load()
    -- Load background music
    Audio.bgm = love.audio.newSource("assets/audio/8_bit_adventure.mp3", "stream")
    Audio.bgm:setLooping(true)
    Audio.bgm:setVolume(0.7)
    Audio.bgm:play()
end

function Audio.stop()
    Audio.bgm:stop()
end

function Audio.toggleMute()
    if Audio.bgm:getVolume() > 0 then
        Audio.bgm:setVolume(0)
    else
        Audio.bgm:setVolume(0.7)
    end
end

return Audio