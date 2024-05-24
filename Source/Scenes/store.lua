local pd <const> = playdate
local gfx <const> = pd.graphics

class('Store').extends(gfx.sprite)

local floorImage = gfx.image.new(400, 60, gfx.kColorBlack)
local shoppingBasket = gfx.image.new("Images/shoppingBasket")
local alarmClock = gfx.image.new("Images/clock")
local itemFont = gfx.font.new("Images/font-rains-1x")

function Store:init()
    Store.super.init(self)

    self:setZIndex(0)
    self:setCenter(0, 0)
    self:setBounds(0, 0, 400, 240)
    self:setIgnoresDrawOffset(true)

    self:add()

    self.player = Player(240, 180, self)
    self.aisleNum = 1
    self.shelves = {}
    for i = 1, GLOBAL.storeData.shelvesPerAisle do
        table.insert(self.shelves, Shelf(160 - (i-1) * 64, 180, GLOBAL.storeData.aisles[self.aisleNum].items[i]))
    end
    self.signs = {}
    self.signs[1] = Sign(180, 100, self.aisleNum, GLOBAL.storeData.aisles[self.aisleNum].name)
    self.signs[2] = Sign(200 - #self.shelves * 64, 100, self.aisleNum, GLOBAL.storeData.aisles[self.aisleNum].name)
    self.checkout = Checkout(332, 180)

    self.timerSeconds = 5
    for k, v in pairs(GLOBAL.list) do
       self.timerSeconds += 5
    end
    self.timer = pd.timer.new(1000, function()
        self:updateCountdown()
    end)
    self.timer.repeats = true
end

function Store:update()
    local drawOffsetX, drawOffsetY = gfx.getDrawOffset()
    if math.floor(self.player.x / 2) * 2 ~= drawOffsetX - 200 then
        gfx.setDrawOffset(-(math.floor(self.player.x / 2) * 2) + 200, drawOffsetY)
    end
end

function Store:draw(x, y, width, height)
    floorImage:draw(0, 180)
    alarmClock:draw(8, 8)
    gfx.drawTextAligned("*" .. self.timerSeconds .. "*", 32, 24, kTextAlignment.center)
    shoppingBasket:draw(360, 8)
    if self.player.items.total ~= 0 then
        gfx.fillRect(373, 27, 18, 12)
        gfx.pushContext()
            gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
            gfx.setFont(itemFont)
            gfx.drawTextAligned(self.player.items.total, 382, 29, kTextAlignment.center)
        gfx.popContext()
    end
end

function Store:setAisle(aisleNum)
    -- Check to ensure the aisle number is valid
    if aisleNum < 1 or aisleNum > #GLOBAL.storeData.aisles then return end

    -- Set the aisle number and update the shelves
    self.aisleNum = aisleNum
    local shelf
    for i = 1, #self.shelves do
        shelf = self.shelves[i]
        shelf:setItem(GLOBAL.storeData.aisles[aisleNum].items[i])
    end
    local sign
    for i = 1, #self.signs do
        sign = self.signs[i]
        sign:setInfo(aisleNum, GLOBAL.storeData.aisles[aisleNum].name)
    end
end

function Store:updateCountdown()
    self.timerSeconds -= 1
    self:markDirty()
    if self.timerSeconds <= 0 then
        SCENE_MANAGER:switchScene(GameOver, "*You ran out of time!*")
    end
end