local pd <const> = playdate
local gfx <const> = pd.graphics

class('GameOver').extends(gfx.sprite)

local gameOverFont = gfx.font.new("Images/Roobert-24-Medium")

function GameOver:init(text)
    GameOver.super.init(self)

    self:setCenter(0, 0)
    self:setBounds(0, 0, 400, 240)
    self:add()

    local spriteImage = gfx.image.new(400, 240)
    gfx.pushContext(spriteImage)
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        gfx.drawTextAligned("*Press* Ⓐ *to Play Again*", 199, 199, kTextAlignment.center)
        gfx.drawTextAligned("*Press* Ⓐ *to Play Again*", 201, 201, kTextAlignment.center)
        gfx.setImageDrawMode(gfx.kDrawModeCopy)
        gfx.drawTextAligned("*Press* Ⓐ *to Play Again*", 200, 200, kTextAlignment.center)

        gfx.setFont(gameOverFont)
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        gfx.drawTextAligned(text, 199, 159, kTextAlignment.center)
        gfx.drawTextAligned(text, 201, 161, kTextAlignment.center)
        gfx.setImageDrawMode(gfx.kDrawModeCopy)
        gfx.drawTextAligned(text, 200, 160, kTextAlignment.center)
    gfx.popContext()

    self:setImage(spriteImage)
end