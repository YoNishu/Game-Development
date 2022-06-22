StartState = Class{__includes = BaseState}

local highlighted = 1

function StartState:enter(para)
    self.highScores = para.highScores
end

function StartState:update(dt)
    if love.keyboard.keysPressed['up'] or love.keyboard.keysPressed['down'] then
        highlighted = highlighted == 1 and 2 or 1
        gSounds['paddle-hit']:play()
    end

    if love.keyboard.keysPressed['enter'] or love.keyboard.keysPressed['return'] then
        gSounds['confirm']:play()
        if highlighted == 1 then
            gStateMachine:change('paddle-select',{
                highScores = self.highScores
            })
        else
            gStateMachine:change('high-score',{
                highScores = self.highScores
            })
        end
    end

    if love.keyboard.keysPressed['escape'] then
        love.event.quit()
    end
end

function StartState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Breakout',0,VIRTUAL_HEIGHT / 3,VIRTUAL_WIDTH,'center')

    love.graphics.setFont(gFonts['medium'])

    if highlighted == 1 then
        love.graphics.setColor(103/255, 255/255, 255/255, 255/255)
    end
    love.graphics.printf('START',0,VIRTUAL_HEIGHT / 2 + 70,VIRTUAL_WIDTH,'center')
    
    love.graphics.setColor(1,1,1,1)
    
    if highlighted == 2 then
        love.graphics.setColor(103/255, 255/255, 255/255, 255/255)
    end
    love.graphics.printf('HIGH SCORES',0,VIRTUAL_HEIGHT / 2 + 90,VIRTUAL_WIDTH,'center')
    
    love.graphics.setColor(1,1,1,1)

end