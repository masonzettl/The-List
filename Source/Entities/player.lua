local pd <const> = playdate
local gfx <const> = pd.graphics

class('Player').extends(gfx.sprite)

local animationImagetable = gfx.imagetable.new("Images/player-animations")
local idleAnimation = gfx.animation.loop.new(110, animationImagetable, true)
idleAnimation.startFrame = 1
idleAnimation.endFrame = 4
local runAnimation = gfx.animation.loop.new(110, animationImagetable, true)
runAnimation.startFrame = 5
runAnimation.endFrame = 8

local itemPickupSP = pd.sound.sampleplayer.new("Audio/pickupItem")
local itemRemoveSP = pd.sound.sampleplayer.new("Audio/removeItem")

function Player:init(x, y, store)
    -- Run parent init
    Player.super.init(self)

    -- Initalize sprite
    self:setImage(idleAnimation:image())
    self:setCollideRect(0, 0, 32, 32)
    self:setCenter(0.5, 1)
    self:setZIndex(2)
    self:moveTo(x, y)
    self:add()

    -- Initalize class variables
    self.store = store
    self.speed = 100
    self.items = {}
    self.items.total = 0
end

function Player:update()
    local dir = boolToNum(pd.buttonIsPressed(pd.kButtonRight)) - boolToNum(pd.buttonIsPressed(pd.kButtonLeft))
    local dpadSpeed = self.speed * dir * DELTATIME

    local change, acceleratedChange = pd.getCrankChange()
    local crankSpeed = (change / 360) * self.speed

    if math.abs(dpadSpeed) > math.abs(crankSpeed) then
        self.dx = dpadSpeed
    else
        self.dx = crankSpeed
    end
    self:moveWithCollisions(self.x + self.dx, self.y)

    if math.abs(self.dx) > 0 then
        runAnimation.delay = (0.005 * math.abs(self.dx)) ^ -1
    end

    if self.dx ~= 0 then
        self:setImage(runAnimation:image())
        if self.dx < 0 then
            self:setImageFlip(gfx.kImageFlippedX)
        end
    else
        self:setImage(idleAnimation:image())
    end

    if pd.buttonJustPressed(pd.kButtonA) then
        self:interact(pd.kButtonA)
    elseif pd.buttonJustPressed(pd.kButtonB) then
        self:interact(pd.kButtonB)
    end

    local overlappingSprites = self:overlappingSprites()
    if #overlappingSprites ~= 0 then
        local other, closestEntity
        closestEntity = overlappingSprites[1]
        for i = 1, #overlappingSprites do
            other = overlappingSprites[i]
            if other:isa(Shelf) or other:isa(Checkout) then
                if math.abs(other.x - self.x) < math.abs(closestEntity.x - self.x) then
                    closestEntity = other
                else
                    other:setBubbleVisibility(false)
                end
            end
        end

        closestEntity:setBubbleVisibility(true)
    else
        if pd.buttonJustPressed(pd.kButtonUp) then
            self.store:setAisle(self.store.aisleNum + 1)
        elseif pd.buttonJustPressed(pd.kButtonDown) then
            self.store:setAisle(self.store.aisleNum - 1)
        end
    end
end

function Player:collisionResponse(other)
    if other:isa(Shelf) or other:isa(Checkout) then
        return gfx.sprite.kCollisionTypeOverlap
    end
end

function Player:interact(button)
    -- Get all overlapping sprites and find the closest one to the player
    local collisions = self:overlappingSprites()
    if #collisions == 0 then return end

    local closestSprite;
    local other;
    for i = 1, #collisions do
        other = collisions[i]
        if closestSprite == nil then
            closestSprite = other
        elseif math.abs(other.x - self.x) < math.abs(closestSprite.x - self.x) then
            closestSprite = other
        end
    end

    -- If it is a shelf, add the item to the player's table of items
    if closestSprite:isa(Shelf) then
        if button == pd.kButtonA then
            if self.items.total >= 99 then return end

            if self.items[closestSprite.item] == nil then
                self.items[closestSprite.item] = 1
            else
                self.items[closestSprite.item] += 1
            end
            self.items.total += 1
    
            -- Make the store sprite redraw to update the displayed item count
            self.store:markDirty()
    
            -- Play the item pickup sound
            itemPickupSP:play()
        elseif button == pd.kButtonB then
            if self.items[closestSprite.item] ~= nil and self.items[closestSprite.item] > 0 then
                self.items[closestSprite.item] -= 1
                self.items.total -= 1

                self.store:markDirty()

                itemRemoveSP:play()
            end
        end
    
    -- If it is a checkout sprite, check the player out with their items
    elseif closestSprite:isa(Checkout) then
        if button ~= pd.kButtonA then return end

        local isMatching = true

        for k, v in pairs(GLOBAL.list) do
            if self.items[k] ~= v then
                isMatching = false
            end
        end

        if isMatching then
            SCENE_MANAGER:switchScene(GameOver, "*You got all your groceries!*")
        else
            SCENE_MANAGER:switchScene(GameOver, "*You forgot some things...*")
        end
    end
end