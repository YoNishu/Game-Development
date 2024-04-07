CountdownState = Class{__includes = BaseState}


COUNT_DOWN_TIME = 0.75

function CountdownState:init() 
    self.timer = 0
    self.count = 3
end

function CountdownState:update(dt) 
    self.timer = self.timer + dt

    if self.timer > COUNT_DOWN_TIME then
        self.timer = self.timer % COUNT_DOWN_TIME
        self.count = self.count - 1
    end

    if self.count == 0 then
        g_var_stateMachine:change('play')
    end
end

function CountdownState:render() 
    love.graphics.setFont(timerFont)
    love.graphics.printf(self.count,0,VIRTUAL_HEIGHT / 2 - 100,VIRTUAL_WIDTH,'center')
end

function CountdownState:enter() end

function CountdownState:exit() end