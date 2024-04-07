PlayState = Class{}

GAP_HEIGHT = math.random(155,185)
local cmp = 2

function PlayState:init()

    self.bird = Bird()
    self.pipePairs = {}
    self.spawnTimer = 0

    self.score = 0

    self.lastY_topPipe = -PIPE_HEIGHT + 116 + math.random(60)

end

function PlayState:update(dt)
    
        self.spawnTimer = self.spawnTimer + dt
    
    if self.spawnTimer > cmp then
        local y_topPipe = math.max(math.min(self.lastY_topPipe + math.random(-50,50)),
        (VIRTUAL_HEIGHT - PIPE_HEIGHT - GAP_HEIGHT - 360), -PIPE_HEIGHT + 116)
        self.lastY_topPipe = y_topPipe
        
        table.insert(self.pipePairs,PipePair(y_topPipe))
        self.spawnTimer = 0
        cmp = math.random(1.6,3)
        GAP_HEIGHT = math.random(155,185)
    end
    
    self.bird:update(dt)
    
    for k,pair in pairs(self.pipePairs) do
        pair:update(dt)
        
        if not pair.score then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                sounds['score']:play()
                pair.score = true
            end
        end
        
        for l,pipe_check in pairs(pair.pipes) do
            if self.bird:collision(pipe_check) then
                sounds['explosion']:play()
                sounds['hurt']:play()
                g_var_stateMachine:change('score',self.score)
            end
        end
    end   
    
    if self.bird.y + self.bird.height - 10 > VIRTUAL_HEIGHT - 65 then
        sounds['explosion']:play()
        sounds['hurt']:play()
        g_var_stateMachine:change('score',self.score)
    end
    
    for k,pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end
end

function PlayState:render()

        for k,pair in pairs(self.pipePairs) do
            pair:render()
        end
        
        love.graphics.setColor(6/255,20/255,61/255,1)
        love.graphics.setFont(flappyFont)
        love.graphics.print('Score: '..tostring(self.score),16,16)

        love.graphics.setColor(1,1,1)        
        self.bird:render()
end

function PlayState:enter() end

function PlayState:exit() end
