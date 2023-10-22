require 'StateMachine'
require 'states.TitleScreenState'
require 'states.PlayState'
require 'states.ScoreState'

push = require 'libraries.push'


WINDOW_WIDTH    = 1280
WINDOW_HEIGHT   = 720

VIRTUAL_WIDTH   = 512
VIRTUAL_HEIGHT  = 288

local background = love.graphics.newImage('assets/background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('assets/ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 567
local GROUND_LOOPING_POINT = VIRTUAL_WIDTH

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Fifty Bird')
    
    SMALL_FONT = love.graphics.newFont('fonts/font.ttf', 8)
    MEDIUM_FONT = love.graphics.newFont('fonts/flappy.ttf', 14)
    FLAPPY_FONT = love.graphics.newFont('fonts/flappy.ttf', 28)
    HUGE_FONT = love.graphics.newFont('fonts/flappy.ttf', 56)
    love.graphics.setFont(FLAPPY_FONT)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gStateMachine = StateMachine({
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function () return PlayState() end,
        ['score'] = function () return ScoreState end,
    })
    gStateMachine:change('title')

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    
    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false        
    end
end

function love.update(dt)
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % GROUND_LOOPING_POINT
    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)
    gStateMachine:render()
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    
    push:finish()
end