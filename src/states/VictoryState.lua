VictoryState = Class{__includes = BaseState}

function VictoryState:enter(para)
    self.paddle = para.paddle
    self.health = para.health
    self.score = para.score
    self.ball = para.ball
    self.level = para.level
    self.highScores = para.highScores
    self.recoverPoints = para.recoverPoints
    self.paddlePoints = para.paddlePoints
end

function VictoryState:update(dt)
    self.paddle:update(dt)
    self.ball.x = self.paddle.x + self.paddle.width / 2 - self.ball.width / 2
    self.ball.y = self.paddle.y - self.ball.height 

    if love.keyboard.keysPressed['enter'] or love.keyboard.keysPressed['return'] then
        gStateMachine:change('serve',{
            level = self.level + 1,
            bricks = createMap(self.level + 1),
            paddle = self.paddle,
            health = self.health,
            score = self.score,
            highScores = self.highScores,
            recoverPoints = self.recoverPoints,
            paddlePoints = self.paddlePoints
        })
    end
end

function VictoryState:render()
    self.paddle:render()
    self.ball:render()

    renderHealth(self.health)
    renderScore(self.score)

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Level '..tostring(self.level)..' complete!',
                        0,VIRTUAL_HEIGHT / 4,
                        VIRTUAL_WIDTH,'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press ENTER to advance to the next level',
                        0,VIRTUAL_HEIGHT / 2,
                        VIRTUAL_WIDTH,'center')
end