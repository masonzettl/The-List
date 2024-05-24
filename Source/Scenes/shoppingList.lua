local pd <const> = playdate
local gfx <const> = pd.graphics

class('ShoppingList').extends(gfx.sprite)

local groceriesImage = gfx.image.new("Images/groceries")
local listImage = gfx.image.new("Images/list")
local listFont = gfx.font.new("Images/font-notepen")

local function generateList()
    local list = {}
    local size = math.random(6)
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

function ShoppingList:init()
    ShoppingList.super.init(self)

    self:setBounds(0, 0, 400, 240)
    self:add()

    GLOBAL.list = generateList()

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
end

function ShoppingList:update()
    if pd.buttonJustPressed(pd.kButtonA) then
        SCENE_MANAGER:switchScene(Store)
    end

    local change = (boolToNum(pd.buttonIsPressed(pd.kButtonUp)) - boolToNum(pd.buttonIsPressed(pd.kButtonDown))) * 5
    if change == 0 then
        change = pd.getCrankChange() or 0
    end
    local newX, newY = self.x + change * self.dirX, self.y + change * self.dirY
    if newY < 120 + self.height / 4 and newY > 120 - self.height / 4 then
        self:moveTo(newX, newY)
    end
end