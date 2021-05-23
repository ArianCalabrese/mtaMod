local distanciaChat = 20
local distanciaSusurro = 5
local distanciaGritar = 30
local COLORS = {
    ["ME"] = "#CC97F2",
    ["DO"] = "#9EC73D",
    ["S"] = "#FAD98C",
    ["B"] = "#9C9C9C",
    ["ACCENT"] = "#BABABA"
}

-- new Float: AccionesRadios[20] = {
--     30.0, // 0 - /me
--     30.0, // 1 - /ame
--     35.0, // 2 - /do
--     50.0, // 3 - /g
--     3.0, // 4 - /s
--     60.0 // 5 - /m
-- };

function chatNormalME(mensaje, tipoMensaje)
    local jugadores = getElementsByType("player")
    local x, y, z = getElementPosition(source)
    local sourceName = string.gsub(getPlayerName(source), "_", " ")
    local account = getPlayerAccount(source)
    local accent = getAccountData(account, "accent")
    if tipoMensaje == 0 then
        for i, v in ipairs(jugadores) do
            local x2, y2, z2 = getElementPosition(v)
            if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= distanciaChat then
                if getElementDimension(source) == getElementDimension(v) then
                    if accent then
                        outputChatBox(COLORS["ACCENT"] .. "((Acento " .. accent .. ")) #FFFFFF" .. sourceName ..
                                          " dice: " .. mensaje .. ".", v, 255, 255, 255, true)

                    else
                        outputChatBox("" .. sourceName .. " dice: " .. mensaje .. ".", v, 255, 255, 255, false)
                    end
                end
            end
        end
        cancelEvent()
    elseif tipoMensaje == 1 then
        for i, v in ipairs(jugadores) do
            local x2, y2, z2 = getElementPosition(v)

            if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) <= distanciaChat then
                if getElementDimension(source) == getElementDimension(v) then
                    outputChatBox(COLORS["ME"] .. "- " .. sourceName .. " " .. mensaje .. ".", v, 255, 255, 255, true)
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
                outputChatBox(COLORS["S"] .. "" .. sourceName .. " susurra: " .. mensaje .. "...", v, 255, 255, 255,
                    true)
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
                outputChatBox(COLORS["DO"] .. "((" .. sourceName .. ")) [Entorno] " .. mensaje .. ".", v, 255, 255, 255,
                    true)
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
                outputChatBox(COLORS["B"] .. "" .. sourceName .. " [OOC]: (( " .. mensaje .. ". ))", v, 255, 255, 255,
                    true)
            end
        end
    end
end
addCommandHandler("b", chatOOC)

-- Accents:

function acento(player, cmd, acento)
    local acentos = {
        ["argentino"] = "argentino",
        ["colombiano"] = "colombiano",
        ["ruso"] = "ruso",
        ["ingles"] = "ingles",
        ["estadounidense"] = "estadounidense"
    }
    if not acento then
        return outputChatBox("SYNTAX: Usar /" .. cmd .. " [acento] para usar un acento. Utilice /" .. cmd ..
                                 " lista para ver todos los acentos disponibles", player, 255, 255, 255, false)
    end
    if acento == "lista" then
        return outputChatBox("Acentos disponibles: \n Argentino, Colombiano, Ruso, Ingles, Estadounidense", player, 255,
                   255, 255, false)
    end
    if not acentos[string.lower(acento)] then
        return outputChatBox("Error! El acento introducido no esta disponible. Pruebe utilizando /" .. cmd ..
                                 " lista para ver todos los acentos disponibles", player, 255, 100, 100, false)
    end
    local account = getPlayerAccount(player)
    setAccountData(account, "accent", acento)
    return outputChatBox("Acento actualizado con exito!", player, 100, 255, 100, false)
end
addCommandHandler("acento", acento)
