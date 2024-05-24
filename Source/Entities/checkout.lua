local pd <const> = playdate
local gfx <const> = pd.graphics

class('Checkout').extends(gfx.sprite)

local spriteImage = gfx.image.new("Images/checkout")

-- Generate text bubble sprite
local bubbleWidth, bubbleHeight = gfx.getTextSize("Checkout")
local bubbleImage = gfx.image.new(bubbleWidth, bubbleHeight)
gfx.pushContext(bubbleImage)
    gfx.drawText("Checkout", 0, 0)
gfx.popContext()

function Checkout:init(x, y)
    Checkout.super.init(self)

    self.collisionResponse = gfx.sprite.kCollisionTypeOverlap
    self:setCollideRect(0, 0, 72, 23)
    self:setCenter(0.5, 1)
    self:setZIndex(1)
    self:setImage(spriteImage)
    self:moveTo(x, y)
    self:add()

    self.textBubble = gfx.sprite.new(bubbleImage)
    self.textBubble:setCenter(0.5, 1)
    self.textBubble:moveTo(x, y - 56)

    self.showBubble = false
end

function Checkout:update()
    if self.showBubble == true then
        local collisions = self:overlappingSprites()
        if #collisions == 0 then
            self.textBubble:remove()
            self.showBubble = false
        end
    end
end

function Checkout:setBubbleVisibility(bool)
    if bool ~= self.showBubble then
        if bool == true then self.textBubble:add()
        elseif bool == false then self.textBubble:remove() end
        self.showBubble = bool
    end
end