require 'class'
require 'Paddle'
require 'Ball'
require 'conf'

HEIGHT_WINDOW = 480
WIDTH_WINDOW = 800

PADDLE_MOVE = 200
PADDLE_HEIGHT = 100
PADDLE_WIDTH = 20

BALL_HEIGHT = 5
BALL_WIDTH = 5
BALL_VELOCITY_INCREMENT = 1.10

GAME_STATE = 'CLOSE'

local ball = Ball()
local player1 = Paddle()
local player2 = Paddle()
local p1_score = 0
local p2_score = 0

function love.load()
    love.window.setMode(WIDTH_WINDOW, HEIGHT_WINDOW, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    GAME_STATE = 'WAIT'

    local seed = os.time()

    math.randomseed(seed)

    local dx = math.random(2) == 1 and 100 or -100
    local dy = math.random(-50, 50)

    ball:init(WIDTH_WINDOW / 2, HEIGHT_WINDOW / 2 - (BALL_HEIGHT / 2), BALL_WIDTH, BALL_HEIGHT, dx, dy)
    player1:init(20, HEIGHT_WINDOW / 2 - (PADDLE_HEIGHT / 2), PADDLE_WIDTH, PADDLE_HEIGHT)
    player2:init(WIDTH_WINDOW - 40, HEIGHT_WINDOW / 2 - (PADDLE_HEIGHT / 2), PADDLE_WIDTH, PADDLE_HEIGHT)
end

function love.update(dt)
    PlayerKeydown(dt)

    if GAME_STATE == 'GAME' then
        ball:move(dt)

        if ball.x < 0 then
            p2_score = p2_score + 1
            GAME_STATE = 'POINT'
            ball:reset(2)
        end
        if ball:collide(player1) then
            ball:bouncePaddle(player1.x + player1.w)
        end

        if ball.x > WIDTH_WINDOW then
            p1_score = p1_score + 1
            GAME_STATE = 'POINT'
            ball:reset(1)
        end
        if ball:collide(player2) then
            ball:bouncePaddle(player2.x - player2.w)
        end

        ball:bounceWall()
    end
end

function love.keypressed()
    if love.keyboard.isDown("return") then
        GAME_STATE = 'GAME'
    end
end

function PlayerKeydown(dt)
    if (love.keyboard.isDown("w")) then
        player1:move(dt, -PADDLE_MOVE)
    end
    if (love.keyboard.isDown("s")) then
        player1:move(dt, PADDLE_MOVE)
    end

    if (love.keyboard.isDown("up")) then
        player2:move(dt, -PADDLE_MOVE)
    end
    if (love.keyboard.isDown("down")) then
        player2:move(dt, PADDLE_MOVE)
    end
end

function love.draw()
    if GAME_STATE == 'WAIT' then
        love.graphics.print("Pong!", WIDTH_WINDOW / 2 - 25, HEIGHT_WINDOW / 6)
    end

    if GAME_STATE == 'POINT' then
        love.graphics.print("P1 - " .. p1_score, WIDTH_WINDOW / 2 - 110, HEIGHT_WINDOW / 6)
        love.graphics.print("P2 - " .. p2_score, WIDTH_WINDOW / 2 + 60, HEIGHT_WINDOW / 6)
    end

    player1:render()
    player2:render()


    ball:render()
end
