Ball = Class{}

function Ball:init(x,y,radius)
    self.x = x
    self.y = y
    self.radius = radius

    self.xspeed = math.random(1,2) == 1 and 500 or -500
    self.yspeed = math.random(-100,100)
end

function Ball:reset()
    self.x = WINDOW_WIDTH / 2 
    self.y = WINDOW_HEIGHT / 2 

    self.xspeed = math.random(1,2) == 1 and 500 or -500
    self.yspeed = math.random(-100,100)
end

function Ball:update(dt)
    self.x = self.x + self.xspeed*dt
    self.y = self.y + self.yspeed*dt
end

function Ball:collision(paddle)
    if self.x - self.radius > paddle.x + paddle.width or self.x + self.radius < paddle.x then
        return false
    end
    
    if self.y + self.radius > paddle.y + paddle.height or self.y + self.radius < paddle.y then
        return false
    end

    return true
end

function Ball:render()
    love.graphics.circle('fill',self.x,self.y,self.radius)
end
