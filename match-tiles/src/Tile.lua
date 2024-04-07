Tile = Class{}

function Tile:init(x,y,color,variety)
    self.gridX = x -- Position in 2D array(in the board)
    self.gridY = y

    self.x = (self.gridX - 1) * 32 -- coordinates in board
    self.y = (self.gridY - 1) * 32
    
    self.color = color
    self.variety = variety

    self.bolt = false

    self.imageWidth = gTextures['bolt']:getWidth()
    self.imageHeight = gTextures['bolt']:getHeight()
end

function Tile:update(dt)

end

function Tile:swap()

end

function Tile:render(x,y)
    -- shadow
    love.graphics.setColor(34 / 255,32 / 255,52 / 255,1)
    love.graphics.draw(gTextures['main'],gFrames['tiles'][self.color][self.variety],
                        self.x + x + 2,self.y + y + 2)

    love.graphics.setColor(1,1,1,1)
    if self.bolt then
        love.graphics.setColor(1,1,1)
        love.graphics.draw(gTextures['main'],gFrames['tiles'][self.color][self.variety],
                            self.x + x,self.y + y)
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(gTextures['bolt'],self.x + x + 4.5,self.y + y + 4.5,0,23 / self.imageWidth,23 / self.imageHeight)
    else
        love.graphics.draw(gTextures['main'],gFrames['tiles'][self.color][self.variety],
                            self.x + x,self.y + y)
    end
end