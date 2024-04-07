TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        g_var_stateMachine:change('count')
    end
end

function TitleScreenState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.setColor(6/255,20/255,61/255,1)
    love.graphics.printf('Flappy Bird',0,100,VIRTUAL_WIDTH,'center')
    
    love.graphics.setColor(6/255,20/255,61/255,1)
    love.graphics.setFont(smallFont)
    love.graphics.printf('press ENTER to start',0,160,VIRTUAL_WIDTH,'center')
end

function TitleScreenState:init()

end

function TitleScreenState:enter()

end

function TitleScreenState:exit()

end