GameOverState = Class{__includes = BaseState}

function GameOverState:enter(para)
    self.score = para.score
    self.highScores = para.highScores
end

function GameOverState:update(dt)
    if love.keyboard.keysPressed['enter'] or love.keyboard.keysPressed['return'] then
        local highscore = false
        local highScoreIndex = 11

        for i = 10,1,-1 do 
            local score = self.highScores[i].score or 0
            if tonumber(self.score) > tonumber(score) then
                highScoreIndex = i
                highscore = true
            end
        end
        
        if highscore then
            gSounds['high-score']:play()
            gStateMachine:change('enter-high-score',{
                score = self.score,
                highScores = self.highScores,
                scoreIndex = highScoreIndex
            })
        else
            gStateMachine:change('start',{
            highScores = self.highScores
            })
        end
        
    end

    if love.keyboard.keysPressed['escape'] then
        love.event.quit()
    end
end

function GameOverState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Final Score: ' .. tostring(self.score), 0, VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter!', 0, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 4,
        VIRTUAL_WIDTH, 'center')
end