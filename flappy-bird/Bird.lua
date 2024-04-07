Bird = Class{}

local GRAVITY = 20

function Bird:init()
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    self.y = VIRTUAL_HEIGHT / 2 - self.height / 2

    self.yspeed = 0
end

function Bird:update(dt)
    self.yspeed = self.yspeed + GRAVITY*dt
    if love.keyboard.wasPressed('space') or love.mouse.wasPressed(1) then
        self.yspeed = -4.75
        sounds['jump']:play()
    end
    self.y = self.y + self.yspeed
end

function Bird:collision(pipe_check)
    if self.x + self.width - 10 >= pipe_check.x and self.x + 10 <= pipe_check.x + pipe_check.width then
        if self.y + 10 <= pipe_check.y + pipe_check.height and self.y + self.height - 10 >= pipe_check.y or self.y < 0 then
            return true
        end
    end

    return false
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

