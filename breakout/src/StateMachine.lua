StateMachine = Class{}

function StateMachine:init(states)
    self.empty = {
        enter = function() end,
        update = function() end,
        render = function() end,
        exit = function() end
    }
    self.state = states or {}
    self.current = self.empty
end

function StateMachine:change(stateName,para)
    assert(self.state[stateName])
    self.current:exit()
    self.current = self.state[stateName]()
    self.current:enter(para)
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end