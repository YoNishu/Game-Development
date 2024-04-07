Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')

PIPE_SCROLL_SPEED = 120

PIPE_WIDTH = 170
PIPE_HEIGHT = 576

function Pipe:init(orientation, y)
    self.x = 0
    self.y = y

    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_HEIGHT

    self.orientation = orientation
end

function Pipe:update(dt)
    
end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, 
    (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y),
    0,
    1,
    self.orientation == 'top' and -1 or 1)
end