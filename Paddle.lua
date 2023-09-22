HEIGHT_WINDOW = 480
WIDTH_WINDOW = 800

Object = require 'class'

Paddle = Object:extend()

function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.w = width
    self.h = height
end

function Paddle:render()
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

function Paddle:move(dt, v)
    self.y = self.y + (dt * v)

    if self.y < 0 then
        self.y = 0
    elseif self.y > HEIGHT_WINDOW - self.h then
        self.y = HEIGHT_WINDOW - self.h
    end
end
