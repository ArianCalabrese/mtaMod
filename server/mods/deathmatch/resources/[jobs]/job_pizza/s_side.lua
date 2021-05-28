local jobBlip = createBlip(2103.73, -1824.77, 13, 10)
local jobVehicle = {448, 2098, -1825.7, 13.5};
local amount = math.random(9, 12)
local PizzaTeam = createTeam("Repartidor de Pizza", 252, 236, 3)

addEvent("warpPedIntoVehicle", true)
addEventHandler("warpPedIntoVehicle", root, function()
    if getElementData(client, "start:job") == false then
        return
    end
    local vehJob = createVehicle(jobVehicle[1], jobVehicle[2], jobVehicle[3], jobVehicle[4])
    warpPedIntoVehicle(client, vehJob, 0)
end)

addEvent("TakeMoneyCare", true)
addEventHandler("TakeMoneyCare", root, function()
    outputChatBox("takemoneycare")
    if getElementData(client, "start:job") == true then
        outputChatBox("OLA", client)
        return
    end
    local vehicle = getPedOccupiedVehicle(client)
    if vehicle then
        outputChatBox(getVehicleName(vehicle))
        destroyElement(vehicle)
    end
    givePlayerMoney(client, amount)
end)

addEvent("onMarkerHit", true)
addEventHandler("onMarkerHit", root, function(marker)
    triggerClientEvent(marker, "onOpenGUI")
end)

addEvent("setPizzaTeam", true)
addEventHandler("setPizzaTeam", root, function()
    setPlayerTeam(client, PizzaTeam)
    if getPlayerTeam(client) then
        outputChatBox("Firmaste contrato con la pizzeria. Felicitaciones!", client)
    end
end)

addEvent("unsetPizzaTeam", true)
addEventHandler("unsetPizzaTeam", root, function()
    setPlayerTeam(client, nil)
end)

