PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.transitionAlpha = 1

    self.boardHighlightedX = 0
    self.boardHighlightedY = 0

    self.rectHighlited = false

    self.canInput = true

    self.highlightedTile = nil

    self.score = 0
    self.timer = 60

    Timer.every(0.5,function()
        self.rectHighlited = not self.rectHighlited
    end)

    Timer.every(1,function()
        self.timer = self.timer - 1

        if self.timer <= 5 then
            gSounds['clock']:play()
        end
    end)
end

function PlayState:enter(para)
    self.level = para.level

    self.board = para.board or Board(VIRTUAL_WIDTH - 272,16)

    self.score = para.score or 0

    self.scoreGoal = self.level * 1250
end

function PlayState:update(dt)
    if love.keyboard.keysPressed['escape'] then
        love.event.quit()
    end

    if self.timer <= 0 then
        Timer.clear()

        gSounds['game-over']:play()

        gStateMachine:change('game-over',{
            score = self.score
        })
    end

    if self.score >= self.scoreGoal then
        Timer.clear()

        gSounds['next-level']:play()

        gLevel = gLevel + 1
        gStateMachine:change('begin-game',{
            level = self.level + 1
        })
    end

    if self.canInput then
        if love.keyboard.keysPressed['up'] then
            self.boardHighlightedY = math.max(0, self.boardHighlightedY - 1)
            gSounds['select']:play()
        elseif love.keyboard.keysPressed['down'] then
            self.boardHighlightedY = math.min(7, self.boardHighlightedY + 1)
            gSounds['select']:play()
        elseif love.keyboard.keysPressed['left'] then
            self.boardHighlightedX = math.max(0, self.boardHighlightedX - 1)
            gSounds['select']:play()
        elseif love.keyboard.keysPressed['right'] then
            self.boardHighlightedX = math.min(7, self.boardHighlightedX + 1)
            gSounds['select']:play()
        end

        if love.keyboard.keysPressed['enter'] or love.keyboard.keysPressed['return'] then
            local x = self.boardHighlightedX + 1
            local y = self.boardHighlightedY + 1

            if not self.highlightedTile then
                self.highlightedTile = self.board.tiles[y][x]
            elseif self.highlightedTile == self.board.tiles[y][x] then
                self.highlightedTile = nil
            elseif math.abs(self.highlightedTile.gridX - x) + math.abs(self.highlightedTile.gridY - y) > 1 then
                gSounds['error']:play()
                self.highlightedTile = nil
            else
                -- swapping gridX and gridY
                local tempX = self.highlightedTile.gridX
                local tempx = self.highlightedTile.x
                local tempY = self.highlightedTile.gridY
                local tempy = self.highlightedTile.y

                local newTile = self.board.tiles[y][x]
                -- local exTile = self.highlightedTile
                local newx = newTile.x
                local newX = newTile.gridX
                local newy = newTile.y
                local newY = newTile.gridY
                -- local exNewTile = newTile


                self.highlightedTile.gridX = newTile.gridX
                self.highlightedTile.gridY = newTile.gridY
                newTile.gridX = tempX
                newTile.gridY = tempY

                --swapping position in the table (array)
                self.board.tiles[y][x] = self.highlightedTile
                self.board.tiles[newTile.gridY][newTile.gridX] = newTile
                
                    Timer.tween(0.1,{
                        [self.highlightedTile] = {x = newTile.x,y = newTile.y},
                        [newTile] = {x = tempx,y = tempy}
                    }):finish(function()
                        self:calculateMatches()
                        if not check then
                            gSounds['error']:play()

                            self.highlightedTile.gridX = tempX
                            self.highlightedTile.gridY = tempY
                            newTile.gridX = newX
                            newTile.gridY = newY

                            self.board.tiles[y][x] = newTile
                            self.board.tiles[tempY][tempX] = self.highlightedTile

                            Timer.tween(0.1,{
                                [newTile] = {x = newx,y = newy},
                                [self.highlightedTile] = {x = tempx,y = tempy}
                            })
                            self.highlightedTile = nil
                        else
                            self.highlightedTile = nil
                        end
                    end)
                end
            end
            Timer.update(dt)
        end
    end
    
    function PlayState:calculateMatches()
        
    local matches = self.board:calculateMatches()
    check = self:noMatch(matches)

    if matches then
        gSounds['match']:stop()
        gSounds['match']:play()

        for k,match in pairs(matches) do
            for k,tile in pairs(match) do
                self.score = self.score + 50 * tile.variety
            end
            self.timer = self.timer + #match
        end

        self.board:removeMatches()

        local tilesToFall = self.board:getFallingTiles()

        Timer.tween(0.35,tilesToFall):finish(function()
            self:calculateMatches()
        end)
    else
        self.canInput = true
    end
end

function PlayState:noMatch(match3)
    if match3 then
        return true
    else
        return false
    end
end 

function PlayState:render()
    self.board:render()

    if self.highlightedTile then
        love.graphics.setBlendMode('add')
        
        love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 96 / 255)
        love.graphics.rectangle('fill',(self.highlightedTile.gridX - 1) * 32 + (VIRTUAL_WIDTH - 272),
        (self.highlightedTile.gridY - 1) * 32 + 16,32,32,4)
        
        love.graphics.setBlendMode('alpha')
    end

    if self.rectHighlited then
        love.graphics.setColor(217 / 255, 87 / 255, 99 / 255, 255 / 255)
    else
        love.graphics.setColor(172 / 255, 50 / 255, 50 / 255, 255 / 255)
    end

    love.graphics.setLineWidth(4)
    love.graphics.rectangle('line',self.boardHighlightedX * 32 + (VIRTUAL_WIDTH - 272),
                            self.boardHighlightedY * 32 + 16,32,32,4)

    love.graphics.setColor(56 / 255, 56 / 255, 56 / 255, 234 / 255)
    love.graphics.rectangle('fill',16, 16, 186, 116, 4)

    love.graphics.setColor(99 / 255, 155 / 255, 255 / 255, 255 / 255)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Level: ' .. tostring(self.level), 20, 24, 182, 'center')
    love.graphics.printf('Score: ' .. tostring(self.score), 20, 52, 182, 'center')
    love.graphics.printf('Goal : ' .. tostring(self.scoreGoal), 20, 80, 182, 'center')
    love.graphics.printf('Timer: ' .. tostring(self.timer), 20, 108, 182, 'center')
end 