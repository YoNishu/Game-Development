PlayState = Class{__includes = BaseState}

function PlayState:enter(para)
    self.paddle = para.paddle
    self.bricks = para.bricks
    self.health = para.health
    self.score = para.score
    self.ball = para.ball
    self.level = para.level
    self.highScores = para.highScores
    self.recoverPoints = para.recoverPoints
    self.paddlePoints = para.paddlePoints
    
    self.ball.dx = math.random(-200,200) 
    self.ball.dy = math.random(-80,-100) 
    
    self.pause = false
    
end

function PlayState:init()
    self.timer1 = 0
    self.timer2 = 0
    self.powerup1 = {}
    self.powerup2 = {}
    self.extraBalls = {}
end

function PlayState:update(dt)
    
    self.timer1 = self.timer1 + dt
    self.timer2 = self.timer2 + dt

   if love.keyboard.keysPressed['p'] then
        self.pause = self.pause == false and true or false
        gSounds['pause']:stop()
        gSounds['pause']:play()
        if self.pause then
            gSounds['music']:stop()
        else
            gSounds['music']:play()
            gSounds['music']:setLooping(true)
        end
   end

   if not self.pause then
        self.ball:update(dt)
        self.paddle:update(dt)

        if self.ball:collision(self.paddle) then
            self.ball.dy = -self.ball.dy
            self.ball.y = self.paddle.y - self.ball.height

            if self.ball.x < (self.paddle.x + self.paddle.width / 2) and self.paddle.dx < 0 then
                self.ball.dx = 
                -(50 + (8 * math.abs(self.ball.x - (self.paddle.x + self.paddle.width / 2))))
            elseif self.ball.x > (self.paddle.x + self.paddle.width / 2) and self.paddle.dx > 0 then
                self.ball.dx = 
                (50 + (8 * math.abs(self.ball.x - (self.paddle.x + self.paddle.width / 2))))
            end

            gSounds['paddle-hit']:play()
        end

        for k,eballs in pairs(self.extraBalls) do 
            if eballs:collision(self.paddle) then
                eballs.dy = -eballs.dy
                eballs.y = self.paddle.y - eballs.height
    
                if eballs.x < (self.paddle.x + self.paddle.width / 2) and self.paddle.dx < 0 then
                    eballs.dx = 
                    -(50 + (8 * math.abs(eballs.x - (self.paddle.x + self.paddle.width / 2))))
                elseif eballs.x > (self.paddle.x + self.paddle.width / 2) and self.paddle.dx > 0 then
                    eballs.dx = 
                    (50 + (8 * math.abs(eballs.x - (self.paddle.x + self.paddle.width / 2))))
                end
    
                gSounds['paddle-hit']:play()
            end
        end

        for k,brick in pairs(self.bricks) do 
            if brick.inPlay and self.ball:collision(brick) then
                brick:hit()
                if brick.color <= 5 then
                    self.score = self.score + ((brick.tier - 1) * 200 + brick.color * 25)
                elseif brick.color > 5 and self.tier == 1 then
                    self.score = self.score + 1500
                end

                if brick.color <= 5 then
                    if self.timer1 > 8 then
                        table.insert(self.powerup1,PowerUp(brick.x,brick.y,1))
                        gSounds['no-select']:play()
                        self.timer1 = 0
                    end
                    if Lock then
                        if self.timer2 > 6 and #self.powerup1 == 0 then
                            table.insert(self.powerup2,PowerUp(brick.x,brick.y,2))
                            gSounds['no-select']:play()
                            self.timer2 = 0
                        end
                    end
                end
                
                if self.score > self.recoverPoints then
                    gSounds['recover']:play()
                    self.health = math.min(3,self.health + 1)
                    self.recoverPoints = math.min(100000,self.recoverPoints * 2)
                end
                
                if self.score > self.paddlePoints then
                    gSounds['recover']:play()
                    self.paddle.size = math.min(4,self.paddle.size + 1)
                    self.paddlePoints = math.min(100000,2 * self.paddlePoints)
                end
    
                if self:checkVictory() then
                    gSounds['victory']:play()
    
                    gStateMachine:change('victory',{
                        paddle = self.paddle,
                        health = self.health,
                        score = self.score,
                        ball = self.ball,
                        level = self.level,
                        highScores = self.highScores,
                        recoverPoints = self.recoverPoints,
                        paddlePoints = self.paddlePoints
                    })
                end
    
                if self.ball.x < brick.x and self.ball.dx > 0 then
                    self.ball.dx = - self.ball.dx
                    self.ball.x = brick.x - self.ball.width
                    self.ball.dx = self.ball.dx * 1.02
                elseif self.ball.x + self.ball.width > brick.x + brick.width and self.ball.dx < 0 then 
                    --doubt
                    self.ball.dx = - self.ball.dx
                    self.ball.x = brick.x + brick.width
                    self.ball.dx = self.ball.dx * 1.02
                elseif self.ball.y < brick.y and self.ball.dy > 0 then
                    self.ball.dy = - self.ball.dy
                    self.ball.y = brick.y - self.ball.height
                    self.ball.dy = self.ball.dy * 1.02
                else 
                    self.ball.dy = - self.ball.dy
                    self.ball.y = brick.y + brick.height
                    self.ball.dy = self.ball.dy * 1.02
                end
                
                break
    
            end

            for j,eballs in pairs(self.extraBalls) do 
                if brick.inPlay and eballs:collision(brick) then
                    brick:hit()
                if brick.color <= 5 then
                    self.score = self.score + ((brick.tier - 1) * 200 + brick.color * 25)
                elseif brick.color > 5 and self.tier == 1 then
                    self.score = self.score + 1500
                end
                    
                if brick.color <= 5 then
                    if self.timer1 > 8 then
                        table.insert(self.powerup1,PowerUp(brick.x,brick.y,1))
                        gSounds['no-select']:play()
                        self.timer1 = 0
                    end

                    if Lock then
                        if self.timer2 > 6 and #self.powerup1 == 0 then
                            table.insert(self.powerup2,PowerUp(brick.x,brick.y,2))
                            gSounds['no-select']:play()
                            self.timer2 = 0
                        end
                    end
                end

                    if self.score > self.recoverPoints then
                        gSounds['recover']:play()
                        self.health = math.min(3,self.health + 1)
                        self.recoverPoints = math.min(100000,self.recoverPoints * 2)
                    end
                    
                    if self.score > self.paddlePoints then
                        gSounds['recover']:play()
                        self.paddle.size = math.min(4,self.paddle.size + 1)
                        self.paddlePoints = math.min(100000,2 * self.paddlePoints)
                    end
                
                    if self:checkVictory() then
                        gSounds['victory']:play()
                
                        gStateMachine:change('victory',{
                            paddle = self.paddle,
                            health = self.health,
                            score = self.score,
                            ball = self.ball,
                            level = self.level,
                            highScores = self.highScores,
                            recoverPoints = self.recoverPoints,
                            paddlePoints = self.paddlePoints
                        })
                    end
                
                    if eballs.x < brick.x and eballs.dx > 0 then
                        eballs.dx = - eballs.dx
                        eballs.x = brick.x - eballs.width
                        eballs.dx = eballs.dx * 1.02
                    elseif eballs.x + eballs.width > brick.x + brick.width and eballs.dx < 0 then 
                        --doubt
                        eballs.dx = - eballs.dx
                        eballs.x = brick.x + brick.width
                        eballs.dx = eballs.dx * 1.02
                    elseif eballs.y < brick.y and eballs.dy > 0 then
                        eballs.dy = - eballs.dy
                        eballs.y = brick.y - eballs.height
                        eballs.dy = eballs.dy * 1.02
                    else 
                        eballs.dy = - eballs.dy
                        eballs.y = brick.y + brick.height
                        eballs.dy = eballs.dy * 1.02
                    end
                
                    break
                end
            end
       end

       for k,p in pairs(self.powerup1) do 
            p:update(dt)
            if p:collision(self.paddle) then
                gSounds['brick-hit-2']:play()
                for i = 0,1 do 
                    table.insert(self.extraBalls,Ball(math.random(7)))
                    self.extraBalls[#self.extraBalls].x = p.x
                    self.extraBalls[#self.extraBalls].y = p.y
                end
                table.remove(self.powerup1,k)
            elseif p.y >= VIRTUAL_HEIGHT then
                table.remove(self.powerup1,k)
            end
       end
       for k,p in pairs(self.powerup2) do 
            p:update(dt)
            if p:collision(self.paddle) then
                gSounds['brick-hit-2']:play()
                table.remove(self.powerup2,k)
                Lock = not Lock
            elseif p.y >= VIRTUAL_HEIGHT then
                table.remove(self.powerup2,k)
            end
       end

       for k,eballs in pairs(self.extraBalls) do 
            eballs:update(dt)
            if eballs.y >= VIRTUAL_HEIGHT then
                table.remove(self.extraBalls,k)
            end
       end

       if self.ball.y >= VIRTUAL_HEIGHT and #self.extraBalls == 0 then
            gSounds['hurt']:play()
            self.health = self.health - 1
            if self.paddle.size > 1 then
                self.paddle.size = self.paddle.size - 1
            end
            if self.health == 0 then
                gStateMachine:change('game-over',{
                    score = self.score,
                    highScores = self.highScores
                })
            else
                gStateMachine:change('serve',{
                    level = self.level,
                    paddle = self.paddle,
                    bricks = self.bricks, 
                    health = self.health, 
                    score = self.score,
                    ball = self.ball,
                    highScores = self.highScores,
                    recoverPoints = self.recoverPoints,
                    paddlePoints = self.paddlePoints
                })
            end
       end
    
       for k,brick in pairs(self.bricks) do
            brick:update(dt)
       end
   end

   if love.keyboard.keysPressed['escape'] then
        love.event.quit()
   end
end

function PlayState:render()

    for k,brick in pairs(self.bricks) do 
        brick:render()
    end

    for k,brick in pairs(self.bricks) do
        brick:renderParticleSystem()
    end

    self.ball:render()
    self.paddle:render()

    for k,p in pairs(self.powerup1) do 
        p:render()
    end
    for k,p in pairs(self.powerup2) do 
        p:render()
    end

    for k,eballs in pairs(self.extraBalls) do 
        eballs:render()
    end

    renderHealth(self.health)
    renderScore(self.score)

    if self.pause then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf('PAUSED',0,VIRTUAL_HEIGHT / 2 - 16,VIRTUAL_WIDTH,'center')
    end
end

function PlayState:checkVictory()
    for k,brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end
    end
    return true
end