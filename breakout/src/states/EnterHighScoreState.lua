EnterHighScoreState = Class{__includes = BaseState}

local highlightedChar = 1

local chars = {
    [1] = 65,
    [2] = 65,
    [3] = 65
}

function EnterHighScoreState:enter(para)
    self.score = para.score
    self.highScores = para.highScores
    self.scoreIndex = para.scoreIndex
end

function EnterHighScoreState:update(dt)
    if love.keyboard.keysPressed['left'] and highlightedChar > 1 then
        gSounds['select']:play()
        highlightedChar = highlightedChar - 1
    elseif love.keyboard.keysPressed['right'] and highlightedChar < 3 then
        gSounds['select']:play()
        highlightedChar = highlightedChar + 1
    end

    if love.keyboard.keysPressed['up'] then
        chars[highlightedChar] = chars[highlightedChar] + 1
        if chars[highlightedChar] > 90 then
            chars[highlightedChar] = 65
        end
    elseif love.keyboard.keysPressed['down'] then
        chars[highlightedChar] = chars[highlightedChar] - 1
        if chars[highlightedChar] < 65 then
            chars[highlightedChar] = 90
        end
    end

    if love.keyboard.keysPressed['enter'] or love.keyboard.keysPressed['return'] then
        local name = string.char(chars[1]) .. string.char(chars[2]) .. string.char(chars[3])

        for i = 10,self.scoreIndex,-1 do 
            self.highScores[i + 1] = {
                name = self.highScores[i].name,
                score = self.highScores[i].score
            }
        end 
        self.highScores[self.scoreIndex].name = name
        self.highScores[self.scoreIndex].score = self.score

        local updatedHS = ''

        for i = 1,10 do 
            updatedHS = updatedHS .. self.highScores[i].name .. '\n'
            updatedHS = updatedHS .. tostring(self.highScores[i].score) .. '\n'
        end
        love.filesystem.write('Breakout2_0.lst',updatedHS)

        gStateMachine:change('high-score',{
            highScores = self.highScores
        })
    end
end

function EnterHighScoreState:render()
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Your Score: ' .. tostring(self.score),0,30,VIRTUAL_WIDTH,'center')

    if highlightedChar == 1 then
        love.graphics.setColor(103 / 255,1,1,1)
    end

    love.graphics.print(string.char(chars[1]),VIRTUAL_WIDTH / 2 - 28,VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1,1,1,1)

    if highlightedChar == 2 then
        love.graphics.setColor(103 / 255,1,1,1)
    end

    love.graphics.print(string.char(chars[2]),VIRTUAL_WIDTH / 2 - 6,VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1,1,1,1)

    if highlightedChar == 3 then
        love.graphics.setColor(103 / 255,1,1,1)
    end

    love.graphics.print(string.char(chars[3]),VIRTUAL_WIDTH / 2 + 20,VIRTUAL_HEIGHT / 2)
    love.graphics.setColor(1,1,1,1)

    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press ENTER to confirm!',0,VIRTUAL_HEIGHT - 18,VIRTUAL_WIDTH,'center')
end