-- local Delivery = {{2755, -1302.4, 53}, {2436.5, -1303.3, 24.9}, {2508.3, -1999.99, 13.54}, {2241.8, -1882.65, 14.23},
--                   {1762.3, -2103.57, 13.85}, {128.97, -1098.96, 25.92}} -- Agregar mas
local amount = math.random(9, 12) -- Sistema de economia
local Delivery = {{2085.7, -1794, 14.4}, {2085.7, -1794, 14.4}, {2085.7, -1794, 14.4}, {2085.7, -1794, 14.4}}
local getJobPickup = createPickup(2100, -1804, 13.55, 3, 1239)

local guiOpen
local toggle = false;
-- Tomar trabajo draw
function isPedDrivingVehicle(ped)
    assert(isElement(ped) and (getElementType(ped) == "ped" or getElementType(ped) == "player"),
        "Bad argument @ isPedDrivingVehicle [ped/player expected, got " .. tostring(ped) .. "]")
    local isDriving = isPedInVehicle(ped) and getVehicleOccupant(getPedOccupiedVehicle(ped)) == ped
    return isDriving, isDriving and getPedOccupiedVehicle(ped) or nil
end

function dxDrawTextOnElement(TheElement, text, height, distance, R, G, B, alpha, size, font, ...)
    local x, y, z = getElementPosition(TheElement)
    local x2, y2, z2 = getCameraMatrix()
    local distance = distance or 20
    local height = height or 1

    if (isLineOfSightClear(x, y, z + 2, x2, y2, z2, ...)) then
        local sx, sy = getScreenFromWorldPosition(x, y, z + height)
        if (sx) and (sy) then
            local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
            if (distanceBetweenPoints < distance) then
                dxDrawText(text, sx + 2, sy + 2, sx, sy, tocolor(R or 255, G or 255, B or 255, alpha or 255),
                    (size or 1) - (distanceBetweenPoints / distance), font or "arial", "center", "center")
            end
        end
    end
end

addEventHandler("onClientRender", getRootElement(), function()
    dxDrawTextOnElement(getJobPickup, "Utilice /tomartrabajo para comenzar a trabajar de repartidor", 0.5, 20, 252, 236,
        3, 255, 2, "arial")
end)
--

function spawnYes(button, state)
    if button == 'left' and state == 'up' then
        if isElementWithinMarker(localPlayer, guiOpen) then
            showCursor(false)
            setElementData(localPlayer, "start:job", true)
            if getElementData(localPlayer, "start:job") == false then
                outputChatBox("Nunca cambia", 255, 255, 255)
            end
            outputChatBox("$You have decide person job, your skin has been set. In 3 seconds!", 255, 255, 255)
            triggerServerEvent("warpPedIntoVehicle", resourceRoot)
            outputChatBox("$You are service on the stack pizza san andreas go point to delivery!", 255, 255, 255)
            showMarker()
            destroyElement(window)
            showCursor(false)
        end
    end
end

function spawnNo(button, state)
    if button == "left" and state == "up" then
        destroyElement(window)
        showCursor(false)
    end
end

function renderJob()
    if not isElementWithinMarker(localPlayer, guiOpen) then
        return
    end
    if isPedInVehicle(localPlayer) then
        return outputChatBox("Debe estar fuera del vehiculo!")

    end
    if isElementWithinMarker(localPlayer, guiOpen) and getElementData(localPlayer, "start:job") == true then
        return outputChatBox("Ya estas en una entrega!")
    end
    -- if isElementWithinMarker(localPlayer, guiOpen) and getElementData("start:job") == false then
    if isElementWithinMarker(localPlayer, guiOpen) then
        local screenW, screenH = guiGetScreenSize()
        window = guiCreateWindow((screenW - 312) / 2, (screenH - 104) / 2, 312, 104, "Empezar viaje?", false)
        guiWindowSetSizable(window, false)
        showCursor(true)

        Yes_btn = guiCreateButton(56, 64, 89, 30, "Yes", false, window)
        No_btn = guiCreateButton(168, 65, 89, 29, "No", false, window)

        addEventHandler("onClientGUIClick", Yes_btn, spawnYes)
        addEventHandler("onClientGUIClick", No_btn, spawnNo)

    end
    outputChatBox("sale")
end

function showMarker()
    local random = math.random(2, #Delivery)
    randomaize = Delivery
    Marker = createMarker(randomaize[random][1], randomaize[random][2], randomaize[random][3] - 1, "checkpoint", 1.8,
                 255, 255, 255)
    blip = createBlipAttachedTo(Marker, 12)
    addEventHandler("onClientMarkerHit", Marker, randomizeExit)
end

function randomizeExit(hitPlayer)
    outputChatBox("randomizeExit")
    if source == Marker and hitPlayer == localPlayer then
        if getElementData(localPlayer, "start:job") == false then
            return outputChatBox("no tenes ninguna entrega")
        end
        if isElement(Marker) and Marker then
            destroyElement(Marker)
            destroyElement(blip)

            Marker = createMarker(2122.9, -1785.4, 13.38, "checkpoint", 1.8, 255, 255, 255)
            blip = createBlipAttachedTo(Marker, 12)
            addEventHandler("onClientMarkerHit", Marker, backToBase)
        end
    end
end

function backToBase(hitPlayer)
    if source == Marker and hitPlayer == localPlayer then
        if isElement(Marker) and Marker then
            destroyElement(Marker)
            destroyElement(blip)
            setElementData(localPlayer, "start:job", false)
            outputChatBox("You are earned for your delivery: " .. amount .. " $")
            triggerServerEvent("TakeMoneyCare", localPlayer)
        end
    end
end

-- addEventHandler("onClientMarkerHit", guiOpen, renderJob)

function tomarTrabajo(cmd, args)
    local theShape = getElementColShape(getJobPickup)
    if not isElementWithinColShape(localPlayer, theShape) then
        return outputChatBox("Debe estar sobre el marcador!")
    end
    if getPlayerTeam(localPlayer) then
        return outputChatBox("Usted ya tiene un trabajo!")
    end
    triggerServerEvent("setPizzaTeam", localPlayer)
    setElementData(localPlayer, "start:job", false)
    toggle = true
    guiOpen = createMarker(2103.73, -1824.77, 12.5, "cylinder", 2, 188, 188, 188, 144)
    addEventHandler("onClientMarkerHit", guiOpen, renderJob)

end

function renunciar(cmd, args)
    triggerServerEvent("unsetPizzaTeam", resourceRoot)
    guiOpen = nil
    removeEventHandler("onClientMarkerHit", guiOpen, renderJob)
end

addCommandHandler("tomartrabajo", tomarTrabajo)
addCommandHandler("renunciar", renunciar)

function toggleMarker()
    return createMarker(2103.73, -1824.77, 12.5, "cylinder", 2, 188, 188, 188, 144)
end

-- Para otros trabajos:
-- function init --> Inicializa marcadores, iconos, posiciones

-- SOLUCIONAR BUG: AL HACER CLICK EN CUALQUIER PARTE DEL A WINDOW ACEPTA EL VIAJE

-- INFO
-- tomartrabajo
-- chequear si ya tiene trabajo
-- chequear si esta sobre el icono
-- renunciar
-- chequear que tiene tabajo
