Object = require 'class'

Ball = Object:extend()

function Ball:init(x, y, width, height, dx, dy)
    self.x = x
    self.dx = dx
    self.y = y
    self.dy = dy
    self.w = width
    self.h = height
end

function Ball:move(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:reset(p)
    self.x = WIDTH_WINDOW / 2
    self.y = HEIGHT_WINDOW / 2 - (BALL_HEIGHT / 2)

    self.dy = math.random(-50, 50)

    if p == 1 then
        self.dx = 100
    elseif p == 2 then
        self.dx = -100
    end
end

function Ball:collide(paddle)
    if self.x > paddle.x + paddle.w or paddle.x > self.x + paddle.w then
        return false
    end

    if self.y > paddle.y + paddle.h or paddle.y > self.y + paddle.h then
        return false
    end

    Sounds.paddle:play()

    return true
end

function Ball:bounceWall()
    if self.y <= 0 then
        self.y = 0
        self.dy = -self.dy
        Sounds.wall:play()
    end

    if self.y >= HEIGHT_WINDOW - self.h then
        self.y = HEIGHT_WINDOW - self.h
        self.dy = -self.dy
        Sounds.wall:play()
    end
end

function Ball:bouncePaddle(paddleX)
    self.dx = -self.dx * BALL_VELOCITY_INCREMENT

    if self.dx < -800 or self > 800 then
        self.dx = 800
    end

    self.x = paddleX

    if self.dy < 0 then
        self.dy = -math.random(-100, 100)
    else
        self.dy = math.random(-100, 100)
    end
end

function Ball:render()
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end
