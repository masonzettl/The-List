local pd <const> = playdate
local gfx <const> = pd.graphics

class('Sign').extends(gfx.sprite)

local signFont = gfx.font.new("Images/font-rains-1x")

function Sign:init(x, y, number, name)
    -- Run parent init
    Sign.super.init(self)

    self:setInfo(number, name)

    -- Initialize sprite
    self:setCenter(0.5, 1)
    self:setZIndex(1)
    self:moveTo(x, y)
    self:add()
end

function Sign:setInfo(number, name)
    local spriteImage = gfx.image.new(96, 36)
    gfx.pushContext(spriteImage)
        gfx.setColor(gfx.kColorWhite)
        gfx.fillRect(0, 24, 96, 12)
        gfx.setColor(gfx.kColorBlack)
        gfx.drawRect(0, 24, 96, 12)
        gfx.drawLine(8, 0, 8, 24)
        gfx.drawLine(88, 0, 88, 24)
        gfx.setFont(signFont)
        gfx.drawTextAligned(number, 8, 26, kTextAlignment.center)
        gfx.drawText(name, 16, 26)
    gfx.popContext()
    self:setImage(spriteImage)
end