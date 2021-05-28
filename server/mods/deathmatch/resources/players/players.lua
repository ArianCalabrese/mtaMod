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
    -- NAME CONTROL
    -- HasNumber
    -- Name_Format (check if _ exist)
    -- Invalid characters ($,%,#)

    -- local playerName = getPlayerName(source)
    -- if string.match(playerName, "%d+") then
    --     kickPlayer(source, nil, "Su nombre contiene numeros. Corrija esto y vuelva a ingresar")
    -- end
    setOcclusionsEnabled(false) -- esto soluciona los bugs de camera
    triggerClientEvent(source, 'login-menu:open', source)
end)
addEventHandler("onPlayerWasted", getRootElement(), function()
    local acc = getPlayerAccount(source)
    local skin = getAccountData(acc, "skin")
    setTimer(spawnPlayer, 2000, 1, source, 1182.62, -1324.36, 13.9, 0, skin)
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
