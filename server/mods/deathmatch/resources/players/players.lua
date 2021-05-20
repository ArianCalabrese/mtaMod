setTime(12, 0)
setMinuteDuration(10000000000)

addCommandHandler('clearchat', function(player)
    for i = 1, 16 do
        outputChatBox(' ', player)
    end
end, false, false)

addEventHandler('onPlayerJoin', root, function()
    triggerClientEvent(source, 'login-menu:open', source)
end)
addEventHandler("onPlayerWasted", getRootElement(), function()
    setTimer(spawnPlayer, 2000, 1, source, 2745.5830078125, -1608.7109375, 20)
end)
