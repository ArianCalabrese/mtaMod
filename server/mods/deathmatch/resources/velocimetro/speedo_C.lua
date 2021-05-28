local screenX, screenY = guiGetScreenSize()
local myFont = dxCreateFont("font.ttf", 20)
local smothedRotation = 0

lightState = 0
localPlayer = getLocalPlayer()

addEventHandler("onClientVehicleEnter", getRootElement(), function(thePlayer, seat)
    if thePlayer == getLocalPlayer() then
        if seat == 0 then
            bindKey("i", "down", showLightState_panel)
            -- addEventHandler("onClientRender",root, showPanel_main ) 
            lightState = getVehicleOverrideLights(source) or 0
        end
    end
end)

addEventHandler("onClientVehicleExit", getRootElement(), function(thePlayer, seat)
    if thePlayer == getLocalPlayer() then
        if seat == 0 then
            --	removeEventHandler("onClientRender",root, showPanel_main )
            unbindKey("i", "down")

        end
    end
end)

function drawNeedle(vehicle, seat)
    if not getPedOccupiedVehicle(localPlayer) then
        unbindKey("3", "down")
        lightState = 0
        return true
    end
    if isPedInVehicle(getLocalPlayer()) then
        local veh = getElementSpeed(getPedOccupiedVehicle(getLocalPlayer()), "kmh")
        local engine = (getPedOccupiedVehicle(getLocalPlayer()))
        if not veh then
            return
        end
        local vehicleSpeed = getVehicleSpeed()
        local rot = math.floor(((220 / 12800) * getVehicleRPM(getPedOccupiedVehicle(getLocalPlayer()))) + 0.5)
        local fuel = getElementData(getPedOccupiedVehicle(localPlayer), "fuel") or 0
        if (smothedRotation < rot) then
            smothedRotation = smothedRotation + 1.5
        end
        if (smothedRotation > rot) then
            smothedRotation = smothedRotation - 1.5
        end

        if vehicleSpeed > 252 then
            vehicleSpeed = 252
        end
        if vehicleSpeed < -252 then
            vehicleSpeed = -252
        end
        dxDrawImage(screenX - 320, screenY - 250, 314, 220, "img/panel.png", 0.0, 0.0, 0.0, tocolor(255, 255, 255, 255),
            false)
        dxDrawImage(screenX - 216, screenY - 229, 200, 200, "img/arrowSpeedometer.png", vehicleSpeed - 0, 0.0, 0.0,
            tocolor(255, 255, 255, 255), false)
        dxDrawImage(screenX - 313, screenY - 208, 158, 158, "img/arrowTachometer.png", smothedRotation, 0.0, 0.0,
            tocolor(255, 255, 255, 255), false)
        dxDrawText("" .. tostring(getFormatSpeed(veh)) .. "", screenX - 142, screenY - 158, 170, 300,
            tocolor(255, 255, 255), 1, myFont)
        dxDrawText("" .. tostring(getFormatFuel(math.round(fuel))) .. "", screenX - 131, screenY - 130, 170, 300,
            tocolor(255, 255, 255), 0.6, myFont)
        dxDrawImage(screenX - 180, screenY - 83, 23, 26, "img/strafeLeftOff.png", 0.0, 0.0, 0.0,
            tocolor(255, 255, 255, 255), false)
        dxDrawImage(screenX - 73, screenY - 83, 23, 26, "img/strafeRightOff.png", 0.0, 0.0, 0.0,
            tocolor(255, 255, 255, 255), false)

        if (vehicleSpeed == 0) then
            dxDrawText(getFormatNeutral() .. "", screenX - 246, screenY - 158, 170, 300, tocolor(255, 255, 255), 1,
                myFont)
        else
            dxDrawText(getFormatGear() .. "", screenX - 246, screenY - 158, 170, 300, tocolor(255, 255, 255), 1, myFont)
        end

        if (getVehicleEngineState(engine) == true) then
            dxDrawImage(screenX - 125, screenY - 62, 23, 26, "img/engineOn.png", 0.0, 0.0, 0.0,
                tocolor(255, 255, 255, 255), false)
        else
            dxDrawImage(screenX - 125, screenY - 62, 23, 26, "img/engineOff.png", 0.0, 0.0, 0.0,
                tocolor(255, 255, 255, 255), false)
        end

        if lightState == 0 or lightState == 1 then
            dxDrawImage(screenX - 154, screenY - 70, 23, 26, "img/lightOff.png", 0.0, 0.0, 0.0,
                tocolor(255, 255, 255, 255), false)
        else
            dxDrawImage(screenX - 154, screenY - 70, 23, 26, "img/lightOn.png", 0.0, 0.0, 0.0,
                tocolor(255, 255, 255, 255), false)
        end

        if getElementData(getPedOccupiedVehicle(localPlayer), "l") then
            if (getTickCount() % 1400 >= 400) then
                outputChatBox('GIRANDO', 255, 100, 100)
                dxDrawImage(screenX - 180, screenY - 83, 23, 26, "img/strafeLeftOn.png", 0.0, 0.0, 0.0,
                    tocolor(255, 255, 255, 255), false)
            end
        end

        if getElementData(getPedOccupiedVehicle(localPlayer), "p") then
            if (getTickCount() % 1400 >= 400) then
                outputChatBox('GIRANDO', 255, 100, 100)
                dxDrawImage(screenX - 73, screenY - 83, 23, 26, "img/strafeRightOn.png", 0.0, 0.0, 0.0,
                    tocolor(255, 255, 255, 255), false)
            end
        end

        local theVehicle = getPedOccupiedVehicle(localPlayer)
        if (theVehicle) then
            if (enablelock) and (isVehicleLocked(theVehicle)) or (getElementData(theVehicle, "cl_vehiclelocked")) then
                dxDrawImage(screenX - 95, screenY - 65, 13, 15, "img/lock.png", 0.0, 0.0, 0.0,
                    tocolor(255, 255, 255, 255), false)
            else
                dxDrawImage(screenX - 95, screenY - 65, 13, 15, "img/open.png", 0.0, 0.0, 0.0,
                    tocolor(255, 255, 255, 255), false)
            end
        end
    end
end
addEventHandler("onClientRender", getRootElement(), drawNeedle)

function showLightState_panel()
    if lightState == 0 or lightState == 1 then
        lightState = 2
        setVehicleOverrideLights(getPedOccupiedVehicle(localPlayer), 2)
    else
        setVehicleOverrideLights(getPedOccupiedVehicle(localPlayer), 1)
        lightState = 0
    end
end

--- Стрелка спидометра
function getVehicleSpeed()
    if isPedInVehicle(getLocalPlayer()) then
        local theVehicle = getPedOccupiedVehicle(getLocalPlayer())
        local vx, vy, vz = getElementVelocity(theVehicle)
        return math.sqrt(vx ^ 2 + vy ^ 2 + vz ^ 2) * 225
    end
    return 0
end

function getElementSpeed(element, unit)
    if (unit == nil) then
        unit = 0
    end
    if (isElement(element)) then
        local x, y, z = getElementVelocity(element)
        if (unit == "mph" or unit == 1 or unit == '1') then
            return math.floor((x ^ 2 + y ^ 2 + z ^ 2) ^ 0.5 * 100)
        else
            return math.floor((x ^ 2 + y ^ 2 + z ^ 2) ^ 0.5 * 100 * 1.609344)
        end
    else
        return false
    end
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then
        return math[method](number * factor) / factor
    else
        return tonumber(("%." .. decimals .. "f"):format(number))
    end
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then
        return math[method](number * factor) / factor
    else
        return tonumber(("%." .. decimals .. "f"):format(number))
    end
end

-- Скорость 
function getFormatSpeed(unit)
    if unit < 10 then
        unit = "00" .. unit
    elseif unit < 100 then
        unit = "0" .. unit
    elseif unit >= 1000 then
        unit = "999"
    end
    return unit
end
-- бензин
function getFormatFuel(unit)
    if unit < 10 then
        unit = "00" .. unit
    elseif unit < 100 then
        unit = "0" .. unit
    elseif unit >= 1000 then
        unit = "999"
    end
    return unit
end
-- передачи и задняя
function getFormatGear()
    local gear = getVehicleCurrentGear(getPedOccupiedVehicle(getLocalPlayer()))
    local rear = "R"
    local neutral = "N"
    if (gear > 0) then
        return gear
    else
        return rear
    end
end
-- нетральная передача
function getFormatNeutral()
    local neutral = "N"
    return neutral
end
-- тахометр 
function getVehicleRPM(vehicle)
    local vehicleRPM = 0
    if (vehicle) then
        if (getVehicleEngineState(vehicle) == true) then
            if getVehicleCurrentGear(vehicle) > 0 then
                vehicleRPM =
                    math.floor(((getElementSpeed(vehicle, "kmh") / getVehicleCurrentGear(vehicle)) * 180) + 0.5)
                if (vehicleRPM < 650) then
                    vehicleRPM = math.random(650, 750)
                elseif (vehicleRPM >= 9800) then
                    vehicleRPM = math.random(9800, 9900)
                end
            else
                vehicleRPM = math.floor((getElementSpeed(vehicle, "kmh") * 180) + 0.5)
                if (vehicleRPM < 650) then
                    vehicleRPM = math.random(650, 750)
                elseif (vehicleRPM >= 9800) then
                    vehicleRPM = math.random(9800, 9900)
                end
            end
        else
            vehicleRPM = 0
        end
        return tonumber(vehicleRPM)
    else
        return 0
    end
end

-- MERGE FUEL
MaxFuel = 100 -- 100 is the default Max Fuel.
decreasing = 0.0005 -- per frame.
increasing = 0.35 -- per frame. (when refuelling)
price = 3 -- $3 is default. When changing this variable, make sure that the (new price * increasing speed) > 1, else it won't take player money. 
-- current price * increasing speed = 3 * 0.35 = 1.05 ( > 1)
--- MARKERS
marker1 = createMarker(1943.6787109375, -1778.5, 12.390598297119, "cylinder", 2, 150, 255, 150, 150)
marker2 = createMarker(1943.9921875, -1771.1083984375, 12.390598297119, "cylinder", 2, 150, 255, 150, 150)
marker3 = createMarker(1939.2060546875, -1771.4345703125, 12.3828125, "cylinder", 2, 150, 255, 150, 150)
marker4 = createMarker(1939.3017578125, -1778.236328125, 12.390598297119, "cylinder", 2, 150, 255, 150, 150)
marker5 = createMarker(2120.9228515625, 927.486328125, 9.8203125, "cylinder", 2, 150, 255, 150, 150)
marker6 = createMarker(2114.7607421875, 927.7734375, 9.8203125, "cylinder", 2, 150, 255, 150, 150)
marker7 = createMarker(2114.951171875, 917.513671875, 9.8203125, "cylinder", 2, 150, 255, 150, 150)
marker8 = createMarker(70.021484375, 1218.794921875, 17.810596466064, "cylinder", 2, 150, 255, 150, 150)
marker9 = createMarker(-2029.5693359375, 157.0537109375, 27.8359375, "cylinder", 2, 150, 255, 150, 150)
marker10 = createMarker(-2023.94140625, 156.91796875, 27.8359375, "cylinder", 2, 150, 255, 150, 150)
marker11 = createMarker(-2407.7900390625, 981.638671875, 44.296875, "cylinder", 2, 150, 255, 150, 150)
marker12 = createMarker(-2407.966796875, 971.537109375, 44.296875, "cylinder", 2, 150, 255, 150, 150)
marker13 = createMarker(2205.5888671875, 2469.7236328125, 9.8203125, "cylinder", 2, 150, 255, 150, 150)
marker14 = createMarker(2205.7412109375, 2480.01953125, 9.8203125, "cylinder", 2, 150, 255, 150, 150)
marker15 = createMarker(2194.095703125, 2475.271484375, 9.8203125, "cylinder", 2, 150, 255, 150, 150)
marker16 = createMarker(2194.220703125, 2470.84765625, 9.8203125, "cylinder", 2, 150, 255, 150, 150)
marker17 = createMarker(-1602.03125, -2710.5712890625, 47.5390625, "cylinder", 2, 150, 255, 150, 150)
marker18 = createMarker(-1605.4091796875, -2714.3037109375, 47.533473968506, "cylinder", 2, 150, 255, 150, 150)
marker19 = createMarker(-1608.5830078125, -2718.638671875, 47.5390625, "cylinder", 2, 150, 255, 150, 150)
marker20 = createMarker(622.9189453125, 1680.3486328125, 5.9921875, "cylinder", 2, 150, 255, 150, 150)
marker21 = createMarker(615.6982421875, 1690.5673828125, 5.9921875, "cylinder", 2, 150, 255, 150, 150)
marker22 = createMarker(608.8447265625, 1700.0146484375, 5.9921875, "cylinder", 2, 150, 255, 150, 150)
marker23 = createMarker(1008.3486328125, -939.84375, 41.1796875, "cylinder", 2, 150, 255, 150, 150)
marker24 = createMarker(999.6259765625, -940.79296875, 41.1796875, "cylinder", 2, 150, 255, 150, 150)
marker25 = createMarker(-92.314453125, -1176.08984375, 1.2067136764526, "cylinder", 2, 150, 255, 150, 150)
marker26 = createMarker(-94.1083984375, -1161.775390625, 1.2461423873901, "cylinder", 2, 150, 255, 150, 150)
marker27 = createMarker(1873.2841796875, -2380.119140625, 12.5546875, "cylinder", 4, 150, 255, 150, 150)
marker28 = createMarker(-1280.7412109375, -0.7314453125, 13.1484375, "cylinder", 4, 150, 255, 150, 150)
marker29 = createMarker(1574.8916015625, 1449.80078125, 9.8299560546875, "cylinder", 4, 150, 255, 150, 150)
marker30 = createMarker(354.5390625, 2538.3251953125, 15.717609405518, "cylinder", 4, 150, 255, 150, 150)
-- CUSTOM MARKERS
---------------------------------PLAZA AYUNTA ESTACION
marker31 = createMarker(1355.56, -1749.7, 11.37, "cylinder", 4, 150, 255, 150, 150)
marker32 = createMarker(1366, -1749.7, 11.54, "cylinder", 4, 150, 255, 150, 150)
marker33 = createMarker(1366, -1760.37, 11.52, "cylinder", 4, 150, 255, 150, 150)
marker34 = createMarker(1355, -1760.58, 11.43, "cylinder", 4, 150, 255, 150, 150)
--------------------PLAZA NORTE
marker35 = createMarker(1007, -933, 40.1, "cylinder", 4, 150, 255, 150, 150)
marker36 = createMarker(999.5, -933, 40.1, "cylinder", 4, 150, 255, 150, 150)
function showTheGuiAndDx()
    veh = getPedOccupiedVehicle(source)
    setElementData(source, "refuelling", true)
    outputChatBox("Turn the vehicle engine off to start refuelling.", 0, 255, 0)
    function showDx()
        dxDrawRectangle(x * 0.452, y * 0.290, x * 0.396, y * 0.2, tocolor(0, 0, 0, 175), false)
        dxDrawRectangle(x * 0.452, y * 0.290, x * 0.396, y * 0.25, tocolor(0, 0, 0, 254), false)
        dxDrawText("Fuel Station", x * 0.546, y * 0.295, x * 0.760, y * 0.325, tocolor(255, 255, 255, 254), 1.00,
            "bankgothic", "center", "center", false, false, true, false, false)
        dxDrawText("Current Fuel : " .. math.floor(getElementData(veh, "fuel") * 1000) / 1000, x * 0.457, y * 0.332,
            x * 0.842, y * 0.371, tocolor(255, 255, 255, 255), 1.10, "sans", "left", "center", false, false, true,
            false, false)
        if (MaxFuel - getElementData(veh, "fuel")) < 1 then
            dxDrawText("Needed Fuel : " .. (MaxFuel) - math.floor(getElementData(veh, "fuel")), x * 0.457, y * 0.371,
                x * 0.842, y * 0.410, tocolor(255, 255, 255, 255), 1.10, "sans", "left", "center", false, false, true,
                false, false)
        else
            dxDrawText("Needed Fuel : " .. (MaxFuel) - (math.floor(getElementData(veh, "fuel") * 1000) / 1000),
                x * 0.457, y * 0.371, x * 0.842, y * 0.410, tocolor(255, 255, 255, 255), 1.10, "sans", "left", "center",
                false, false, true, false, false)
        end
        dxDrawText("Liter Price : $" .. price, x * 0.457, y * 0.410, x * 0.842, y * 0.449, tocolor(255, 255, 255, 255),
            1.10, "sans", "left", "center", false, false, true, false, false)
        dxDrawText("Total Cost : " .. math.floor(getElementData(localPlayer, "price") * 100) / 100, x * 0.457,
            y * 0.449, x * 0.842, y * 0.488, tocolor(255, 255, 255, 255), 1.10, "sans", "left", "center", false, false,
            true, false, false)
        if getVehicleEngineState(veh) == true then
            dxDrawText("Turn Your Engine Off.", x * 0.457, y * 0.488, x * 0.842, y * 0.527, tocolor(255, 255, 255, 255),
                1.10, "sans", "center", "center", false, false, true, false, false)
        else
            dxDrawText("Turn Your Engine ON To Stop Refuelling.", x * 0.457, y * 0.488, x * 0.842, y * 0.527,
                tocolor(255, 255, 255, 255), 1.10, "sans", "center", "center", false, false, true, false, false)
        end
    end
    showDx()

    addEventHandler("onClientRender", root, showDx)
end
addEvent("onClientWantToRefuel", true)
addEventHandler("onClientWantToRefuel", getLocalPlayer(), showTheGuiAndDx)

function setVehicleFuelOnRespawn()
    for k, v in ipairs(getElementsByType("vehicle")) do
        if getElementData(v, "fuel") == false then
            setElementData(v, "fuel", MaxFuel)
        end
    end
end
addEventHandler("onClientRender", root, setVehicleFuelOnRespawn)

function setFuelDecreasing()
    for f, v in ipairs(getElementsByType("vehicle")) do
        local fuel = getElementData(v, "fuel")
        if getVehicleEngineState(v) == true and (not getElementData(v, "fuel") == false) then
            setElementData(v, "fuel", fuel - getElementSpeed(v, "kph") * 0.00004 - decreasing)
        end
    end
end
addEventHandler("onClientRender", root, setFuelDecreasing)

function showFuelSystem(hitElement)
    triggerEvent("onClientWantToRefuel", hitElement)
    setElementData(hitElement, "price", 0)
end
addEventHandler("onClientMarkerHit", marker1, showFuelSystem)
addEventHandler("onClientMarkerHit", marker2, showFuelSystem)
addEventHandler("onClientMarkerHit", marker3, showFuelSystem)
addEventHandler("onClientMarkerHit", marker4, showFuelSystem)
addEventHandler("onClientMarkerHit", marker5, showFuelSystem)
addEventHandler("onClientMarkerHit", marker6, showFuelSystem)
addEventHandler("onClientMarkerHit", marker7, showFuelSystem)
addEventHandler("onClientMarkerHit", marker8, showFuelSystem)
addEventHandler("onClientMarkerHit", marker9, showFuelSystem)
addEventHandler("onClientMarkerHit", marker10, showFuelSystem)
addEventHandler("onClientMarkerHit", marker11, showFuelSystem)
addEventHandler("onClientMarkerHit", marker12, showFuelSystem)
addEventHandler("onClientMarkerHit", marker13, showFuelSystem)
addEventHandler("onClientMarkerHit", marker14, showFuelSystem)
addEventHandler("onClientMarkerHit", marker15, showFuelSystem)
addEventHandler("onClientMarkerHit", marker16, showFuelSystem)
addEventHandler("onClientMarkerHit", marker17, showFuelSystem)
addEventHandler("onClientMarkerHit", marker18, showFuelSystem)
addEventHandler("onClientMarkerHit", marker19, showFuelSystem)
addEventHandler("onClientMarkerHit", marker20, showFuelSystem)
addEventHandler("onClientMarkerHit", marker21, showFuelSystem)
addEventHandler("onClientMarkerHit", marker22, showFuelSystem)
addEventHandler("onClientMarkerHit", marker23, showFuelSystem)
addEventHandler("onClientMarkerHit", marker24, showFuelSystem)
addEventHandler("onClientMarkerHit", marker25, showFuelSystem)
addEventHandler("onClientMarkerHit", marker26, showFuelSystem)
addEventHandler("onClientMarkerHit", marker27, showFuelSystem)
addEventHandler("onClientMarkerHit", marker28, showFuelSystem)
addEventHandler("onClientMarkerHit", marker29, showFuelSystem)
addEventHandler("onClientMarkerHit", marker30, showFuelSystem)
addEventHandler("onClientMarkerHit", marker31, showFuelSystem)
addEventHandler("onClientMarkerHit", marker32, showFuelSystem)
addEventHandler("onClientMarkerHit", marker33, showFuelSystem)
addEventHandler("onClientMarkerHit", marker34, showFuelSystem)
addEventHandler("onClientMarkerHit", marker35, showFuelSystem)
addEventHandler("onClientMarkerHit", marker36, showFuelSystem)

function hideTheFuelSystem(hitElement)
    removeEventHandler("onClientRender", root, showDx)
    setElementData(hitElement, "refuelling", false)
    setElementData(hitElement, "price", 0)
end
addEventHandler("onClientMarkerLeave", marker1, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker2, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker3, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker4, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker5, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker6, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker7, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker8, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker9, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker10, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker11, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker12, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker13, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker14, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker15, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker16, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker17, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker18, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker19, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker20, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker21, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker22, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker23, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker24, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker25, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker26, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker27, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker28, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker29, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker30, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker31, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker32, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker33, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker34, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker35, hideTheFuelSystem)
addEventHandler("onClientMarkerLeave", marker36, hideTheFuelSystem)

function startRefulling()
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh then
        local fuel = getElementData(veh, "fuel")
        local prices = getElementData(localPlayer, "price")
        if getVehicleEngineState(veh) == false and (not getElementData(veh, "fuel") == false) and
            getElementData(veh, "fuel") <= MaxFuel and getPlayerMoney(localPlayer) > 0 and
            getElementData(localPlayer, "refuelling") == true then
            setElementData(veh, "fuel", fuel + increasing)
            setElementData(localPlayer, "price", prices + increasing * price)
            takePlayerMoney(increasing * price)
        end
    end
end
addEventHandler("onClientRender", root, startRefulling)

function onClientResourceStart()
    for k, v in ipairs(getElementsByType("vehicle")) do
        setElementData(v, "fuel", MaxFuel)
    end
end
addEventHandler("onClientResourceStart", resourceRoot, onClientResourceStart)

function setVehicleFuelToZero()
    veh = getPedOccupiedVehicle(localPlayer)
    if veh and (not getElementData(veh, "fuel") == false) and getElementData(veh, "fuel") <= 0 then
        setElementData(veh, "fuel", 0)
        setElementData(veh, "run.of.fuel", true)
        setVehicleEngineState(veh, false)
    end
end
addEventHandler("onClientRender", root, setVehicleFuelToZero)

function setPriceTo0()
    if getElementData(localPlayer, "price") == false then
        setElementData(localPlayer, "price", 0)
    end
end
addEventHandler("onClientRender", root, setPriceTo0)
