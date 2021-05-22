local window
local ped
local function getWindowPosition(width, height)
    local screenWidth, screenHeight = guiGetScreenSize()
    local x = (screenWidth) - (width)
    local y = (screenHeight) - (height)
    return x, y, width, height
end
local function isAgeValid(age)
    return string.len(age) > 1 and age == tostring(tonumber(age))
end
local function isSexValid(sex)
    return string.len(sex) > 1 and type(sex) == 'string'
end

addEvent('auth:register-character_creation', true)
addEventHandler("auth:register-character_creation", root, function(username, password)
    local skin = 0
    ped = createPed(0, 1655, -1638, 85)
    setElementRotation(ped, 0, 0, 270)
    setCameraMatrix(1668, -1636, 87, 1655, -1636, 83)
    fadeCamera(true)
    showCursor(true, true)
    guiSetInputMode('no_binds')
    -- open our menu
    local x, y, width, height = getWindowPosition(800, 1080)
    window = guiCreateWindow(x, y, width, height, 'Crea tu personaje', false)
    guiWindowSetMovable(window, false)
    guiWindowSetSizable(window, false)

    -- edad input   
    local edadLabel = guiCreateLabel(10, 30, width - 30, 20, 'Edad', false, window)
    local edadErrorLabel = guiCreateLabel(75, 30, width - 90, 20, 'La edad debe ser numerica y ser desde 18 hasta 90',
                               false, window)
    guiLabelSetColor(edadErrorLabel, 255, 100, 100)
    guiSetVisible(edadErrorLabel, false)
    local edadInput = guiCreateEdit(10, 50, width - 20, 30, '', false, window)
    -- sexo input
    local sexoLabel = guiCreateLabel(10, 90, width - 30, 20, 'Sexo', false, window)
    local sexoErrorLabel = guiCreateLabel(75, 90, width - 60, 20, 'Error sexo', false, window)
    guiLabelSetColor(sexoErrorLabel, 255, 100, 100)
    guiSetVisible(sexoErrorLabel, false)
    local sexoInput = guiCreateComboBox(10, 110, width - 20, 80, '', false, window) -- We create a combo box.
    guiComboBoxAddItem(sexoInput, "Hombre")
    guiComboBoxAddItem(sexoInput, "Mujer")
    -- Skin input
    local skinLabel = guiCreateLabel(10, 150, width - 30, 20, 'Skin', false, window)
    local skinErrorLabel = guiCreateLabel(75, 160, width - 90, 20, 'La edad debe ser numerica y ser desde 18 hasta 90',
                               false, window)
    guiLabelSetColor(skinErrorLabel, 255, 100, 100)
    guiSetVisible(skinErrorLabel, false)
    local skinInput = guiCreateEdit(width / 2, 170, width / 3, 30, '0', false, window)
    local restSkin = guiCreateButton(10, 170, 20, 30, '<<', false, window)
    local sumSkin = guiCreateButton(width - 100, 170, 20, 30, '>>', false, window)
    --
    addEventHandler('onClientGUIClick', restSkin, function(button, state)
        if button ~= 'left' or state ~= 'up' then
            return
        end
        if skin == 0 then -- <= future fix
            skin = 313
        end
        skin = skin - 1;
        guiSetText(skinInput, skin)
    end)

    addEventHandler('onClientGUIClick', sumSkin, function(button, state)
        if button ~= 'left' or state ~= 'up' then
            return
        end
        if skin == 312 then -- >= future fix
            skin = -1
        end
        skin = skin + 1;
        guiSetText(skinInput, skin)
    end)

    addEventHandler('onClientGUIChanged', skinInput, function(element)
        skin = guiGetText(element)
        setElementModel(ped, skin)
    end)

    local nombre = username;
    local contra = password;
    --------
    local createCharButton = guiCreateButton(10, 995, width - 20, 30, 'Crear', false, window)
    addEventHandler('onClientGUIClick', createCharButton, function(button, state)
        if button ~= 'left' or state ~= 'up' then
            return
        end
        local edad = guiGetText(edadInput)
        local sexo = guiGetText(sexoInput)
        -- local inputValid = true
        -- if not isAgeValid(edad) then
        --     guiSetVisible(edadErrorLabel, true)
        --     inputValid = false
        -- else
        --     guiSetVisible(edadErrorLabel, false)
        -- end
        -- if not isSexValid(sexo) then
        --     guiSetVisible(sexoErrorLabel, true)
        --     inputValid = false
        -- else
        --     guiSetVisible(sexoErrorLabel, false)
        -- end
        -- if not inputValid then
        --     return
        -- end
        triggerServerEvent('auth:register-attempt', localPlayer, nombre, contra, skin, edad, sexo)
    end, false)
end, true)
addEvent('register-character-creation:close', true)
addEventHandler('register-character-creation:close', root, function()
    destroyElement(ped)
    destroyElement(window)
    showCursor(false, false)
    guiSetInputMode('allow_binds')
end)
