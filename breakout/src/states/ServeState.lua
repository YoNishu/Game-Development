ServeState = Class{__includes = BaseState}

function ServeState:enter(para)
    self.paddle = para.paddle
    self.bricks = para.bricks
    self.health = para.health
    self.score = para.score
    self.level = para.level
    self.highScores = para.highScores
    self.recoverPoints = para.recoverPoints
    self.paddlePoints = para.paddlePoints

    self.ball = Ball(math.random(7))
end

function ServeState:update(dt)
    self.paddle:update(dt)
    self.ball.x = self.paddle.x + self.paddle.width / 2 - self.ball.width / 2
    self.ball.y = self.paddle.y - self.ball.height 

    if love.keyboard.keysPressed['enter'] or love.keyboard.keysPressed['return'] then
        gStateMachine:change('play',{
            paddle = self.paddle,
            bricks = self.bricks,
            health = self.health,
            score = self.score,
            ball = self.ball,
            level = self.level,
            highScores = self.highScores,
            recoverPoints = self.recoverPoints,
            paddlePoints = self.paddlePoints
        })
    end

    if love.keyboard.keysPressed['escape'] then
        love.event.quit()
    end
end

function ServeState:render()
    self.paddle:render()
    self.ball:render()

    for k,brick in pairs(self.bricks) do
        brick:render()

        renderHealth(self.health)
        renderScore(self.score)

        love.graphics.setFont(gFonts['medium'])
        love.graphics.printf('Press ENTER to serve!',0,VIRTUAL_HEIGHT / 2,VIRTUAL_WIDTH,'center')
    end
end