local pd <const> = playdate
local gfx <const> = pd.graphics

class('GameOver').extends(gfx.sprite)

function GameOver:init(text)
    GameOver.super.init(self)

    self:setCenter(0, 0)
    self:setBounds(0, 0, 400, 240)
    self:add()

    local spriteImage = gfx.image.new(400, 240)
    gfx.pushContext(spriteImage)
        gfx.drawTextAligned(text, 200, 100, kTextAlignment.center)
        gfx.drawTextAligned("Press Ⓐ to Play Again", 200, 140, kTextAlignment.center)
    gfx.popContext()

    self:setImage(spriteImage)
end

function GameOver:update()
    if pd.buttonJustPressed(pd.kButtonA) then
        SCENE_MANAGER:switchScene(ShoppingList)
    end
end