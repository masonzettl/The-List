import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/animation"
import "CoreLibs/timer"
import "Scenes/sceneManager"
import "Scenes/shoppingList"
import "Scenes/gameOver"
import "Scenes/store"
import "Entities/player"
import "Entities/shelf"
import "Entities/checkout"
import "Entities/sign"
import "util"

local pd <const> = playdate
local gfx <const> = pd.graphics

DELTATIME = 0

GLOBAL = {}
GLOBAL.storeData = json.decodeFile("items.json")

pd.display.setRefreshRate(50)

SCENE_MANAGER = SceneManager()
SCENE_MANAGER:switchScene(ShoppingList)

function pd.update()
	-- Update all sprites added
	gfx.sprite.update()

	-- Update all timers
	pd.timer.updateTimers()

	-- Get the time since the last frame
	DELTATIME = pd.getElapsedTime()
	pd.resetElapsedTime()

	-- Draw FPS in bottom-left corner for debugging
	pd.drawFPS(0, 228)
end