local window
local function getWindowPosition(width, height)
    local screenWidth, screenHeight = guiGetScreenSize()
    local x = (screenWidth / 2) - (width / 2)
    local y = (screenHeight / 2) - (height / 2)
    return x, y, width, height
end

setTime(12, 0)
setMinuteDuration(10000000000)

addCommandHandler('clearchat', function(player)
    for i = 1, 16 do
        outputChatBox(' ', player)
    end
end, false, false)

addEventHandler('onPlayerJoin', root, function()
    setOcclusionsEnabled(false) -- esto soluciona los bugs de camera
    triggerClientEvent(source, 'login-menu:open', source)
end)
addEventHandler("onPlayerWasted", getRootElement(), function()
    setTimer(spawnPlayer, 2000, 1, source, 2745.5830078125, -1608.7109375, 20)
end)
addEventHandler("onPlayerQuit", root, function()
    -- local db = exports.userDB:getUserConnection()
    local player = source
    local account = getPlayerAccount(player)
    -- Position
    local x, y, z = getElementPosition(player)
    setAccountData(account, 'x', x)
    setAccountData(account, 'y', y)
    setAccountData(account, 'z', z)
    -- Rotation
    local rx, ry, rz = getElementRotation(player)
    setAccountData(account, 'rz', rz)
    -- Health and Armor
    local health = getElementHealth(player)
    local armor = getPedArmor(player)
    setAccountData(account, 'health', health)
    setAccountData(account, 'armor', armor)
    -- Money
    local money = getPlayerMoney(player)
    setAccountData(account, 'money', money)
    -- Skin
    local skin = getElementModel(player)
    setAccountData(account, 'skin', skin)

    -- dbExec(db, "UPDATE accounts SET x = ?, y = ?, z = ?, rx = ?, ry = ?, rz = ? WHERE id = ?", x, y, z, rx, ry, rz,
    --     getAccountData(account, "userid"))
end)

-- acentos feature
function acentos(player)
    setCameraMatrix(2366, -1055, 155, 0, 0, 20)
    fadeCamera(true)
    showCursor(true, true)
    guiSetInputMode('no_binds')
    local x, y, width, height = getWindowPosition(400, 230)
    window = guiCreateWindow(x, y, width, height, 'Complete los datos de su personaje', false)
    guiWindowSetMovable(window, false)
    guiWindowSetSizable(window, false)
    local usernameLabel = guiCreateLabel(10, 30, width - 30, 20, 'Username:', false, window)
    local usernameErrorLabel = guiCreateLabel(75, 30, width - 90, 20, 'Username is required.', false, window)
    guiLabelSetColor(usernameErrorLabel, 255, 100, 100)
    guiSetVisible(usernameErrorLabel, false)
end

addCommandHandler("acentos", acentos, false, false)

