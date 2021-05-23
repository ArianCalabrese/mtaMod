--[[
  Author script: Jakub ;
  E-amil: None ;
  Country: Poland;
--]]
local screenW, screenH = guiGetScreenSize()
local h, w = (screenW / 800), (screenH / 600)

local startJobData = setElementData(localPlayer, "start:job", false)
trueGUI = true
local amount = math.random(9, 12)
local stone = {
    ['job'] = {w * 619, h * 136, w * 149, h * 216},
    ['image'] = {w * 649, h * 146, w * 89, h * 92},
    ['rectangle'] = {w * 629, h * 310, w * 129, h * 32},
    ['text_start'] = {w * 630, h * 310, w * 758, h * 342},
    ['text_job'] = {w * 633, h * 248, w * 738, h * 293},
    ['vehicle'] = {2098, -1825.7, 13.5}
}

local Delivery = {{2755, -1302.4, 53}, {2436.5, -1303.3, 24.9}, {2508.3, -1999.99, 13.54}, {2241.8, -1882.65, 14.23},
                  {1762.3, -2103.57, 13.85}, {128.97, -1098.96, 25.92}}

function isMouseInPosition(x, y, width, height)
    if (not isCursorShowing()) then
        return false
    end
    local sx, sy = guiGetScreenSize()
    local cx, cy = getCursorPosition()
    local cx, cy = (cx * sx), (cy * sy)

    return ((cx >= x and cx <= x + width) and (cy >= y and cy <= y + height))
end

local guiOpen = createMarker(2103.73, -1824.77, 13, "cylinder", 1.3, 188, 188, 188, 144)

function renderJob()
    if not isElementWithinMarker(localPlayer, guiOpen) then
        return
    end
    if not isElementWithinMarker(localPlayer, guiOpen) and getElementData("start:job") == true then
        return
    end
    if isElementWithinMarker(localPlayer, guiOpen) and getElementData("start:job") == false then
        if isElementWithinMarker(localPlayer, guiOpen) and getElementData("start:job") == false and trueGUI == true then
            showCursor(true)
            dxDrawRectangle(stone['job'][1], stone['job'][2], stone['job'][3], stone['job'][4],
                tocolor(34, 27, 38, 255), false)
            dxDrawImage(stone['image'][1], stone['image'][2], stone['image'][3], stone['image'][4],
                ":job_pizza/gui.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
            dxDrawRectangle(stone['rectangle'][1], stone['rectangle'][2], stone['rectangle'][3], stone['rectangle'][4],
                tocolor(229, 223, 232, 144), false)
            dxDrawText("START", stone['text_start'][1], stone['text_start'][2], stone['text_start'][3],
                stone['text_start'][4], tocolor(255, 255, 255, 255), 1.00, "bankgothic", "center", "top", false, false,
                false, false, false)
            dxDrawText("Job: Pizza Boy\nAmount: 9,12$\nGPS: San Andreasn\nK: ShowGUI", stone['text_job'][1],
                stone['text_job'][2], stone['text_job'][3], stone['text_job'][4], tocolor(255, 255, 255, 255), 1.00,
                "default", "left", "top", false, false, false, false, false)
        end
    end
end

function showMarker()
    local random = math.random(2, #Delivery)
    randomaize = Delivery
    Marker = createMarker(randomaize[random][1], randomaize[random][2], randomaize[random][3] - 1, "checkpoint", 1.8,
                 255, 255, 255)
    blip = createBlipAttachedTo(Marker, 12)
    addEventHandler("onClientMarkerHit", Marker, randomizeExit)
end

function randomizeExit()
    if getElementData(localPlayer, "start:job") == false then
        return
    end
    if isElement(Marker) and Marker then
        destroyElement(Marker)
        destroyElement(blip)
        Marker = nil
        blip = nil
        setElementData(localPlayer, "start:job", false)
        outputChatBox("You are earned for your delivery: " .. amount .. " $")
        triggerServerEvent("TakeMoneyCare", resourceRoot)
    end
end

function addGuiMember()
    if isElementWithinMarker(localPlayer, guiOpen) and getElementData("start:job") == false then
        addEventHandler("onClientRender", root, renderJob)
    end
    setElementData(localPlayer, "start:job", false)
end
addEventHandler("onClientResourceStart", resourceRoot, addGuiMember)

addEventHandler("onClientClick", root, function(button, bind)
    if button == "left" and bind == "down" and isMouseInPosition(w * 633, h * 248, w * 738, h * 293) then
        if not isElementWithinMarker(localPlayer, guiOpen) then
            return
        end
        if not isElementWithinMarker(localPlayer, guiOpen) and getElementData("start:job") == true then
            return
        end
        if isElementWithinMarker(localPlayer, guiOpen) and getElementData("start:job") == false then
            if isElementWithinMarker(localPlayer, guiOpen) and getElementData("start:job") == false and trueGUI == true then
                showCursor(false)
                setElementData(localPlayer, "start:job", true)
                outputChatBox("$You have decide person job, your skin has been set. In 3 seconds!", 255, 255, 255)
                triggerServerEvent("warpPedIntoVehicle", resourceRoot)
                outputChatBox("$You are service on the stack pizza san andreas go point to delivery!", 255, 255, 255)
                showMarker()
            end
        end
    end
end)

bindKey("K", "down", function()
    trueGUI = not trueGUI
    showCursor(false)
end)
