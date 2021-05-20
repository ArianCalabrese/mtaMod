local distanciaChat = 20
local distanciaSusurro = 5
local distanciaGritar = 30

function chatNormalME(mensaje, tipoMensaje)
    local jugadores = getElementsByType("player")
    local x, y, z = getElementPosition(source)
    local sourceName = getPlayerName(source)

    if tipoMensaje == 0 then
        for i, v in ipairs(jugadores) do
            local x2, y2, z2 = getElementPosition(v)

            if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= distanciaChat then
                if getElementDimension(source) == getElementDimension(v) then
                    outputChatBox("" .. sourceName .. " dice: " .. mensaje .. ".", v, 255, 255, 255, false)
                end
            end
        end
        cancelEvent()
    elseif tipoMensaje == 1 then
        for i, v in ipairs(jugadores) do
            local x2, y2, z2 = getElementPosition(v)

            if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= distanciaChat then
                if getElementDimension(source) == getElementDimension(v) then
                    outputChatBox("- " .. sourceName .. " " .. mensaje .. ".", v, 2, 197, 255, false)
                end
            end
        end
        cancelEvent()
    elseif tipoMensaje == 2 then
        cancelEvent()
    end
end
addEventHandler("onPlayerChat", getRootElement(), chatNormalME)

function chatSusurro(player, cmd, ...)
    local jugadores = getElementsByType("player")
    local x, y, z = getElementPosition(player)
    local palabrasMensaje = {...}
    local mensaje = table.concat(palabrasMensaje, " ")
    local sourceName = getPlayerName(player)

    for i, v in ipairs(jugadores) do
        local x2, y2, z2 = getElementPosition(v)

        if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= distanciaSusurro then
            if getElementDimension(player) == getElementDimension(v) then
                outputChatBox("" .. sourceName .. " susurra: " .. mensaje .. "...", v, 210, 210, 210, false)
            end
        end
    end
end
addCommandHandler("s", chatSusurro)

function chatGritar(player, cmd, ...)
    local jugadores = getElementsByType("player")
    local x, y, z = getElementPosition(player)
    local palabrasMensaje = {...}
    local mensaje = table.concat(palabrasMensaje, " ")
    local sourceName = getPlayerName(player)

    for i, v in ipairs(jugadores) do
        local x2, y2, z2 = getElementPosition(v)

        if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= distanciaGritar then
            if getElementDimension(player) == getElementDimension(v) then
                outputChatBox("" .. sourceName .. " grita: ¡" .. mensaje .. "!", v, 255, 255, 255, false)
            end
        end
    end
end
addCommandHandler("g", chatGritar)

function chatDo(player, cmd, ...)
    local jugadores = getElementsByType("player")
    local x, y, z = getElementPosition(player)
    local palabrasMensaje = {...}
    local mensaje = table.concat(palabrasMensaje, " ")
    local sourceName = getPlayerName(player)

    for i, v in ipairs(jugadores) do
        local x2, y2, z2 = getElementPosition(v)

        if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= distanciaChat then
            if getElementDimension(player) == getElementDimension(v) then
                outputChatBox("" .. sourceName .. " [Entorno] " .. mensaje .. ".", v, 249, 255, 104, false)
            end
        end
    end
end
addCommandHandler("do", chatDo)

function chatOOC(player, cmd, ...)
    local jugadores = getElementsByType("player")
    local x, y, z = getElementPosition(player)
    local palabrasMensaje = {...}
    local mensaje = table.concat(palabrasMensaje, " ")
    local sourceName = getPlayerName(player)

    for i, v in ipairs(jugadores) do
        local x2, y2, z2 = getElementPosition(v)

        if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= distanciaChat then
            if getElementDimension(player) == getElementDimension(v) then
                outputChatBox("" .. sourceName .. " [OOC]: (( " .. mensaje .. ". ))", v, 255, 255, 255, false)
            end
        end
    end
end
addCommandHandler("b", chatOOC)
