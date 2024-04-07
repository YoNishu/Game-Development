-- "The Day-13 update"
-- The Polish updates

push = require 'push'

Class = require 'class'

require 'StateMachine'
require 'states/BaseState'
require 'states/TitleScreenState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'

require 'Bird'

require 'PipePair'

require 'Pipe'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720  

VIRTUAL_WIDTH = 1024
VIRTUAL_HEIGHT = 576

local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 60
local GROUND_SCROLL_SPEED = 120

-- if not scrolling then
--     love.graphics.setBackgroundColor(115/255,27/255,135/255,0.5)
-- end

local BACKGROUND_LOOPING_POINT = 1024
local GROUND_LOOPING_POINT = 1024

local scrolling = true
local pause_image = love.graphics.newImage('pause.png')

function love.load()

    math.randomseed(os.time())

    love.graphics.setDefaultFilter('nearest','nearest')

    love.window.setTitle('FLAPPY Bird')
    
    smallFont = love.graphics.newFont('font.ttf',22)
    scoreFont = love.graphics.newFont('flappy.ttf',40)
    flappyFont = love.graphics.newFont('flappy.ttf',56)
    timerFont = love.graphics.newFont('flappy.ttf',200)
    love.graphics.setFont(flappyFont)

    g_var_stateMachine = StateMachine{
        ['title'] = function() return TitleScreenState() end,
        ['count'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    g_var_stateMachine:change('title')

    sounds = {
        ['jump'] = love.audio.newSource('jump.wav','static'),
        ['score'] = love.audio.newSource('score.wav','static'),
        ['explosion'] = love.audio.newSource('explosion.wav','static'),
        ['hurt'] = love.audio.newSource('hurt.wav','static'),
        ['pause'] = love.audio.newSource('pause.wav','static'),
        ['music'] = love.audio.newSource('marios_way.mp3','static')
    }
    sounds['music']:setLooping(true)
    sounds['music']:play()

    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
        vsync = true,
        fullscreen = false,
        resizable = true
    })


    love.keyboard.keysPressed = {}
    love.mouse.buttonPressed = {}
end

function love.resize(w,h)
    push:resize(w,h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true 

    if key == 'escape' then
        love.event.quit()
    end
end

function love.mousepressed(x,y,button)
    love.mouse.buttonPressed[button] = true
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end 
end 

function love.mouse.wasPressed(button)
    return love.mouse.buttonPressed[button]
end


function love.update(dt)
    if love.keyboard.wasPressed('p') then
        sounds['pause']:play()
        if scrolling == false then
            sounds['music']:play()
            scrolling = true
        else
            sounds['music']:pause()
            scrolling = false
        end
    end
    
    if scrolling then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED*dt) 
                                % BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED*dt) 
                                % GROUND_LOOPING_POINT

        g_var_stateMachine:update(dt)
    end

    love.keyboard.keysPressed = {}
    love.mouse.buttonPressed = {}
    
end

function love.draw()

    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)
    love.graphics.draw(background, -backgroundScroll + 1024, 0)

    if scrolling then
        g_var_stateMachine:render()
    end

    love.graphics.setColor(1,1,1)
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 65)
    love.graphics.draw(ground, -groundScroll + 1024, VIRTUAL_HEIGHT - 65)

    if not scrolling then
        love.graphics.draw(pause_image,VIRTUAL_WIDTH / 2 - 100,VIRTUAL_HEIGHT / 2 - 200)
        love.graphics.setColor(1,1,1,1)
        love.graphics.setFont(scoreFont)
        love.graphics.printf('Game is PAUSED!',0,VIRTUAL_HEIGHT / 2 + 60,VIRTUAL_WIDTH,'center')
        love.graphics.printf('Press P to RESUME',0,VIRTUAL_HEIGHT / 2 + 120,VIRTUAL_WIDTH,'center')
    end
    
    push:finish()

end