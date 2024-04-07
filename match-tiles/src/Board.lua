Board = Class{}

function Board:init(x,y)
    self.x = x
    self.y = y

    self.mod = gLevel % 7 == 0 and 1 or gLevel % 7     

    bolt = true
    
    self:initializeTiles()
end

function Board:initializeTiles()
    self.tiles = {}
    
    for tileY = 1,8 do 
        table.insert(self.tiles,{})
        for tileX = 1,8 do 
            if gLevel <= 6 then
                self.pattern = math.random(self.mod)
                table.insert(self.tiles[tileY],Tile(tileX,tileY,math.random(5,12),self.pattern))
                if bolt then
                    self.tiles[tileY][tileX].bolt = math.random(15) == 1 and true or false
                    if self.tiles[tileY][tileX].bolt then
                        bolt = false
                    end
                end
            else
                self.pattern = math.random(6)
                table.insert(self.tiles[tileY],Tile(tileX,tileY,math.random(5,12),self.pattern))
                if bolt then
                    self.tiles[tileY][tileX].bolt = math.random(15) == 1 and true or false
                    if self.tiles[tileY][tileX].bolt then
                        bolt = false
                    end
                end
            end
        end
    end

    while self:calculateMatches() do
        self:initializeTiles()
    end
end

function Board:calculateMatches()
    local matches = {}

    local matchNUM = 1

    for y = 1,8 do
        local colorToMatch = self.tiles[y][1].color
        matchNUM = 1
        for x = 2,8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNUM = matchNUM + 1
            else
                colorToMatch = self.tiles[y][x].color

                if matchNUM >= 3 then
                    local match = {}

                    for x2 = x - 1,x - matchNUM,-1 do
                        if self.tiles[y][x2].bolt then
                            bolt = true
                            for k in pairs(match) do
                                match[k] = nil
                            end
                            for x_r = 1,8 do
                                table.insert(match,self.tiles[y][x_r])
                            end
                            break
                        else
                            table.insert(match,self.tiles[y][x2])
                        end
                    end
                    table.insert(matches,match)
                end
                
                matchNUM = 1

                if x >= 7 then
                    break
                end
            end
        end
        if matchNUM >= 3 then
            local match = {}

            for x2 = 8,8 - matchNUM + 1,-1 do
                if self.tiles[y][x2].bolt then
                    bolt = true
                    for k in pairs(match) do
                        match[k] = nil
                    end
                    for x_r = 1,8 do
                        table.insert(match,self.tiles[y][x_r])
                    end
                    break
                else
                    table.insert(match,self.tiles[y][x2])
                end
            end
            table.insert(matches,match)
        end
    end
    
    for x = 1,8 do
        local colorToMatch = self.tiles[1][x].color
        matchNUM = 1
        for y = 2,8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNUM = matchNUM + 1
            else
                colorToMatch = self.tiles[y][x].color

                if matchNUM >= 3 then
                    local match = {}

                    for y2 = y - 1,y - matchNUM,-1 do
                        if self.tiles[y2][x].bolt then
                            bolt = true
                            for k in pairs(match) do
                                match[k] = nil
                            end
                            for y_r = 1,8 do
                                table.insert(match,self.tiles[y_r][x])
                            end
                            break
                        else
                            table.insert(match,self.tiles[y2][x])
                        end
                    end
                    table.insert(matches,match)
                end

                matchNUM = 1

                if y >= 7 then
                    break
                end
            end
        end
        if matchNUM >= 3 then
            local match = {}

            for y2 = 8,8 - matchNUM + 1,-1 do
                if self.tiles[y2][x].bolt then
                    bolt = true
                    for k in pairs(match) do
                        match[k] = nil
                    end
                    for y_r = 1,8 do
                        table.insert(match,self.tiles[y_r][x])
                    end
                break
                else
                    table.insert(match,self.tiles[y2][x])
                end
            end
            table.insert(matches,match)
        end
    end

    self.matches = matches

    return #self.matches > 0 and self.matches or false
end

function Board:removeMatches() 
    for k,match in pairs(self.matches) do
        for k,tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end

    self.matches = nil
end

function Board:getFallingTiles()
    local tweens = {}

    
    for x = 1,8 do
        local space = false
        local spaceY = 0 -- gridY of space

        local y = 8
        while y >= 1 do
            local tile = self.tiles[y][x]

            if space then
                if tile then
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY

                    self.tiles[y][x] = nil

                    tweens[tile] = {
                        y = (spaceY - 1) * 32
                    }

                    y = spaceY
                    space = false
                    spaceY = 0
                end
            elseif tile == nil then
                space = true

                if spaceY == 0 then
                    spaceY = y
                end
            end
            y = y - 1
        end
    end 

    
    for x = 1,8 do
        for y = 8,1,-1 do
            local tile = self.tiles[y][x]

            if not tile then
                if gLevel <= 6 then
                    self.pattern = math.random(self.mod)
                    tile = Tile(x,y,math.random(5,12),self.pattern)  
                    tile.bolt = math.random(10) == 1 and true or false  
                else
                    self.pattern = math.random(6)
                    tile = Tile(x,y,math.random(5,12),self.pattern)
                    tile.bolt = math.random(10) == 1 and true or false
                end
                tile.y = -32
                self.tiles[y][x] = tile

                tweens[tile] = {
                    y = (tile.gridY - 1) * 32
                }
            end
        end
    end
    return tweens
end

function Board:render()
    for y = 1,#self.tiles do 
        for x = 1,#self.tiles[y] do 
            self.tiles[y][x]:render(self.x,self.y)
        end
    end
end