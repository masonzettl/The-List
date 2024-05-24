local pd <const> = playdate
local gfx <const> = pd.graphics

class('Shelf').extends(gfx.sprite)

local spriteImage = gfx.image.new("Images/shelf")

function Shelf:init(x, y, item)
    -- Run parent init
    Shelf.super.init(self)

    -- Initialize sprite
    self.collisionResponse = gfx.sprite.kCollisionTypeOverlap
    self:setCollideRect(0, 0, 64, 48)
    self:setCenter(0.5, 1)
    self:setZIndex(1)
    self:setImage(spriteImage)
    self:moveTo(x, y)
    self:add()

    -- Initalize class variables
    self.showBubble = false

    -- Set the shelf's item and its text bubble
    self:setItem(item)
end

function Shelf:update()
    if self.showBubble == true then
        local collisions = self:overlappingSprites()
        if #collisions == 0 then
            self.textBubble:remove()
            self.showBubble = false
        end
    end
end

function Shelf:setItem(item)
    -- Generate text bubble sprite
    local bubbleWidth, bubbleHeight = gfx.getTextSize(item)
    local bubbleImage = gfx.image.new(bubbleWidth, bubbleHeight)
    gfx.pushContext(bubbleImage)
        gfx.drawText(item, 0, 0)
    gfx.popContext()
    self.textBubble = gfx.sprite.new(bubbleImage)
    self.textBubble:setCenter(0.5, 1)
    self.textBubble:moveTo(self.x, self.y - 48)

    -- Keep track of the item the shelf contains
    self.item = item
end

function Shelf:setBubbleVisibility(bool)
    if bool ~= self.showBubble then
        if bool == true then self.textBubble:add()
        elseif bool == false then self.textBubble:remove() end
        self.showBubble = bool
    end
end