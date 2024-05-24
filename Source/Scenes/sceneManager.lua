local pd <const> = playdate
local gfx <const> = pd.graphics

class('SceneManager').extends()

function SceneManager:init()
    self.transitionTime = 1000
    self.transitioning = false
end

function SceneManager:switchScene(scene, ...)
    if self.transitioning then return end

    self.newScene = scene
    self.sceneArgs = ...

    self:startTransition(function() self:loadNewScene() end)
end

function SceneManager:loadNewScene()
    self:cleanupScene()
    self.newScene(self.sceneArgs)
end

function SceneManager:startTransition(callback)
    if self.transitioning then return end

    self.transitioning = true

    local transitionTimer = self:wipeTransition(0, 240)

    transitionTimer.timerEndedCallback = function()
        self.transitionSprite:remove()
        callback()
        transitionTimer = self:wipeTransition(240, 0)
        transitionTimer.timerEndedCallback = function()
            self.transitionSprite:remove()
            self.transitioning = false
        end
    end
end

function SceneManager:wipeTransition(startValue, endValue)
    self.transitionSprite = self:createTransitionSprite()
    self.transitionSprite:setClipRect(0, 0, 400, startValue)

    local transitionTimer = pd.timer.new(self.transitionTime, startValue, endValue, pd.easingFunctions.inOutCubic)
    transitionTimer.updateCallback = function(timer)
        if startValue > endValue then
            self.transitionSprite:setClipRect(0, 240 - timer.value, 400, timer.value)
        else
            self.transitionSprite:setClipRect(0, 0, 400, timer.value)
        end
    end
    return transitionTimer
end

function SceneManager:createTransitionSprite()
    local filledRect = gfx.image.new(400, 240, gfx.kColorBlack)
    local transitionSprite = gfx.sprite.new(filledRect)
    transitionSprite:moveTo(200, 120)
    transitionSprite:setZIndex(10000)
    transitionSprite:setIgnoresDrawOffset(true)
    transitionSprite:add()
    return transitionSprite
end

function SceneManager:cleanupScene()
    gfx.sprite.removeAll()
    local timers = pd.timer.allTimers()
    for i = 1, #timers do
        timers[i]:remove()
    end
    gfx.setDrawOffset(0, 0)
end