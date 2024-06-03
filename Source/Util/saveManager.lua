local pd <const> = playdate
local ds <const> = pd.datastore

SAVE_MANAGER = {}

local function createData()
    GLOBAL.saveData = {}
    GLOBAL.saveData.mostItems = 1
    GLOBAL.saveData.tripsCompleted = 0
    GLOBAL.saveData.itemsForgotten = 0
end

function SAVE_MANAGER:loadData()
    GLOBAL.saveData = ds.read()
    if GLOBAL.saveData == nil then
        createData()
    end
end

function SAVE_MANAGER:saveData()
    ds.write(GLOBAL.saveData)
end