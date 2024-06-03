local pd <const> = playdate
local gfx <const> = pd.graphics

class('ShoppingList').extends(gfx.sprite)

local groceriesImage = gfx.image.new("Images/groceries")
local listImage = gfx.image.new("Images/list")
local checkmarkImage = gfx.image.new("Images/checkmark")
local listFont = gfx.font.new("Images/font-notepen")

local function generateList()
    local list = {}
    local size = math.random(GLOBAL.saveData.mostItems)
    local currentSize = 0
    local aisle, itemNum, item
    while currentSize < size do
        aisle = math.random(#GLOBAL.storeData.aisles)
        itemNum = math.random(GLOBAL.storeData.shelvesPerAisle)
        item = GLOBAL.storeData.aisles[aisle].items[itemNum]
        if list[item] == nil then
            list[item] = math.random(3)
            currentSize += 1
        end
    end

    return list
end

function ShoppingList:init(isNewRound)
    ShoppingList.super.init(self)

    self:setBounds(0, 0, 400, 240)
    self:add()

    self.isNewRound = isNewRound

    if isNewRound then
        GLOBAL.items = {}
        GLOBAL.items.total = 0
        GLOBAL.list = generateList()
    end

    local spriteImage = listImage:copy()
    local height = 22
    gfx.pushContext(spriteImage)
        groceriesImage:draw(2, 3)
        gfx.setFont(listFont)
        for k, v in pairs(GLOBAL.list) do
            textWidth, textHeight = gfx.drawText(v .. " " .. k, 22, height)
            height += 20
        end
    gfx.popContext()
    spriteImage = spriteImage:scaledImage(2)
    spriteImage = spriteImage:rotatedImage(8)
    self:setImage(spriteImage)

    self.angleInRad = math.rad(98)
    self.dirX, self.dirY = math.cos(self.angleInRad), math.sin(self.angleInRad)
    self:moveTo(200 + (self.height / 4) * self.dirX, 120 + (self.height / 4) * self.dirY)

    if isNewRound == false then
        self:checkList()
    end
end

function ShoppingList:update()
    if pd.buttonJustPressed(pd.kButtonA) then
        if self.isNewRound then
            SCENE_MANAGER:switchScene(Store)
        else
            SCENE_MANAGER:switchScene(ShoppingList, true)
        end
    end

    local change = (boolToNum(pd.buttonIsPressed(pd.kButtonUp)) - boolToNum(pd.buttonIsPressed(pd.kButtonDown))) * 5
    if change == 0 then
        change = pd.getCrankChange() or 0
    end
    local newX, newY = self.x + change * self.dirX, self.y + change * self.dirY
    if self.isNewRound then
        if newY < 120 + self.height / 4 and newY > 120 - self.height / 4 then
            self:moveTo(newX, newY)
        end
    else
        if newY < 120 + self.height / 4 and newY > 60 - self.height / 4 then
            self:moveTo(newX, newY)
        end
    end
end

function ShoppingList:checkList()
    local spriteImage = self:getImage()
    local checkmarkX, checkmarkY = 54, 32
    local isMatching = true

    gfx.pushContext(spriteImage)
        for k, v in pairs(GLOBAL.list) do
            if GLOBAL.items[k] == v then
                checkmarkImage:draw(checkmarkX, checkmarkY)
            else
                isMatching = false
                GLOBAL.saveData.itemsForgotten += 1
            end
            checkmarkX += self.dirX * 40
            checkmarkY += self.dirY * 40
        end
    gfx.pushContext()
    self:setImage(spriteImage)

    if isMatching then
        GameOver("You got all your groceries!")
        GLOBAL.saveData.tripsCompleted += 1

        -- Increase the max possible item count if the player completed a full trip (max of 8 items on the list)
        if tableCount(GLOBAL.list) == GLOBAL.saveData.mostItems and GLOBAL.saveData.mostItems < 8 then
            GLOBAL.saveData.mostItems += 1
        end
    else
        GameOver("You forgot some things...")
    end
end