PaddleSelectState = Class{__includes = BaseState}

function PaddleSelectState:enter(para)
    self.highScores = para.highScores
end

function PaddleSelectState:init()
    self.currentPaddle = 1
end

function PaddleSelectState:update(dt)
    if love.keyboard.keysPressed['left'] then
        if self.currentPaddle == 1 then
            gSounds['no-select']:play()
        else
            gSounds['select']:play()
            self.currentPaddle = self.currentPaddle - 1
        end
    elseif love.keyboard.keysPressed['right'] then
        if self.currentPaddle == 4 then
            gSounds['no-select']:play()
        else
            gSounds['select']:play()
            self.currentPaddle = self.currentPaddle + 1
        end
    end

    if love.keyboard.keysPressed['enter'] or love.keyboard.keysPressed['return'] then
        gSounds['confirm']:play()

        gStateMachine:change('serve',{
            paddle = Paddle(self.currentPaddle),
            level = 1,
            bricks = createMap(1),
            health = 3,
            score = 0,
            highScores = self.highScores,
            recoverPoints = 5000,
            paddlePoints = 5000
        })
    end

    if love.keyboard.keysPressed['escape'] then
        love.event.quit()
    end
end

function PaddleSelectState:render()
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Select the paddle with left or right!',0,VIRTUAL_HEIGHT / 4,VIRTUAL_WIDTH,'center')
    
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('(Press ENTER to proceed)',0,VIRTUAL_HEIGHT / 3,VIRTUAL_WIDTH,'center')

    if self.currentPaddle == 1 then
        love.graphics.setColor(40 / 255, 40 / 255, 40 / 255, 128 / 255)
    end
    love.graphics.draw(gTextures['arrows'],gFrames['arrows'][1],VIRTUAL_WIDTH / 4 - 24,
    VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)
    
    love.graphics.setColor(1,1,1,1)
    
    if self.currentPaddle == 4 then
        love.graphics.setColor(40 / 255, 40 / 255, 40 / 255, 128 / 255)
    end
    love.graphics.draw(gTextures['arrows'],gFrames['arrows'][2],VIRTUAL_WIDTH - VIRTUAL_WIDTH / 4,
    VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)
    
    love.graphics.setColor(1,1,1,1)

    love.graphics.draw(gTextures['main']
                        ,gFrames['paddles'][2 + 4 * (self.currentPaddle - 1)]
                        ,VIRTUAL_WIDTH / 2 - 32, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)
end