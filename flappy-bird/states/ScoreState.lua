ScoreState = Class{__includes = BaseState}

local gold = love.graphics.newImage('Gold.png')
local silver = love.graphics.newImage('Silver.png')
local bronze = love.graphics.newImage('Bronze.png')

function ScoreState:init() 
    scrolling = false
end

function ScoreState:enter(param) 
    self.score = param
end

function ScoreState:update(dt) 
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        g_var_stateMachine:change('count')
        scrolling = true
    end
end

function ScoreState:render() 
    
    love.graphics.setColor(6/255,20/255,61/255,1)
    love.graphics.setFont(scoreFont)
    love.graphics.printf('Score: '..tostring(self.score),0,260,VIRTUAL_WIDTH,'center')
    love.graphics.setFont(flappyFont)
    if self.score < 3 then
        love.graphics.printf('You LOST!',0,128,VIRTUAL_WIDTH,'center')
    elseif self.score >= 3 and self.score < 5 then
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(bronze,760,200)
        love.graphics.setColor(6/255,20/255,61/255,1)
        love.graphics.printf('Congratulations!',0,128,VIRTUAL_WIDTH,'center')
        love.graphics.setColor(205/255,127/255,50/255,1)
        
        love.graphics.printf(' You won BRONZE!',0,200,VIRTUAL_WIDTH,'center')
    elseif self.score >= 5 and self.score < 8 then
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(silver,750,200)
        love.graphics.setColor(6/255,20/255,61/255,1)
        love.graphics.printf('Congratulations!',0,128,VIRTUAL_WIDTH,'center')
        love.graphics.setColor(192/255,192/255,192/255,1)
        love.graphics.printf(' You won SILVER!',0,200,VIRTUAL_WIDTH,'center')
    elseif self.score >= 8 then
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(gold,725,200)
        love.graphics.setColor(6/255,20/255,61/255,1)
        love.graphics.printf('Congratulations!',0,128,VIRTUAL_WIDTH,'center')
        love.graphics.setColor(255/255,215/255,0,1) 
        love.graphics.printf(' You won GOLD!',0,200,VIRTUAL_WIDTH,'center')
    end
    love.graphics.setColor(6/255,20/255,61/255,1)
    love.graphics.setFont(smallFont)
    love.graphics.printf('Press ENTER to play again...',0,305,VIRTUAL_WIDTH,'center')
end

function ScoreState:exit() end