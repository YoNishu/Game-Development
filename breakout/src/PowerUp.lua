PowerUp = Class{}

function PowerUp:init(x,y,p)
    self.x = x
    self.y = y

    self.width = 16
    self.height = 16

    self.dx = 0
    self.dy = 100
    
    self.power_up = p
end

function PowerUp:update(dt)
    self.y = self.y + self.dy * dt
end

function PowerUp:render()
    love.graphics.draw(gTextures['main'],gFrames['power-up'][self.power_up],self.x,self.y)
end

function PowerUp:collision(target)
    if self.x > target.x + target.width or self.x + self.width < target.x then
        return false
    end
    if self.y > target.y + target.height or self.y + self.height < target.y then
        return false
    end
    return true
end