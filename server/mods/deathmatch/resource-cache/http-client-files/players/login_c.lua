local window
local function getWindowPosition(width, height)
    local screenWidth, screenHeight = guiGetScreenSize()
    local x = (screenWidth / 2) - (width / 2)
    local y = (screenHeight / 2) - (height / 2)
    return x, y, width, height
end
local function isUsernameValid(username)
    return string.len(username) > 1 and type(username) == 'string'
end
local function isPasswordValid(password)
    return string.len(password) > 1 and type(password) == 'string'
end
addEvent('login-menu:open', true)
addEventHandler('login-menu:open', root, function()
    setCameraMatrix(1627, -2286, 95, 0, 0, 20)
    fadeCamera(true)
    local progress = 0.0; -- value between 0 and 1 will be used to get the new position of camera (0.5 will be half way through between the 2 points) 
    local i = 0;
    addEventHandler("onClientPreRender", root, function()
        if progress < 2 then
            progress = progress + 0.002; -- increase to move the camera faster 
        end
        local x = 1490 + 50 * math.cos(progress * math.pi);
        local y = -1675.5 + 50 * math.sin(progress * math.pi);
        i = i + 1
        setCameraMatrix(x, y, 100, i, 0, 0)
        -- if progress < 1 then
        --     progress = progress + 0.002; -- increase to move the camera faster 
        -- end
        -- local x, y, z = interpolateBetween(1627, -2286, 95, 186, -1380, 78, progress, "InQuad");
        -- setCameraMatrix(x, y, z, 28, 180, 30)
    end)
    -- initialize de cursor
    showCursor(true, true)
    guiSetInputMode('no_binds')
    -- open our menu
    local x, y, width, height = getWindowPosition(400, 230)
    window = guiCreateWindow(x, y, width, height, 'Login to Our Server', false)
    guiWindowSetMovable(window, false)
    guiWindowSetSizable(window, false)
    local usernameLabel = guiCreateLabel(10, 30, width - 30, 20, 'Username:', false, window)
    local usernameErrorLabel = guiCreateLabel(75, 30, width - 90, 20, 'Username is required.', false, window)
    guiLabelSetColor(usernameErrorLabel, 255, 100, 100)
    guiSetVisible(usernameErrorLabel, false)
    local usernameInput = guiCreateEdit(10, 50, width - 20, 30, '', false, window)
    local passwordLabel = guiCreateLabel(10, 90, width - 30, 20, 'Password:', false, window)
    local passwordErrorLabel = guiCreateLabel(75, 90, width - 60, 20, 'Password is required.', false, window)
    guiLabelSetColor(passwordErrorLabel, 255, 100, 100)
    guiSetVisible(passwordErrorLabel, false)
    local passwordInput = guiCreateEdit(10, 110, width - 20, 30, '', false, window)
    guiEditSetMasked(passwordInput, true)
    local loginButton = guiCreateButton(10, 150, width - 20, 30, 'Login', false, window)
    addEventHandler('onClientGUIClick', loginButton, function(button, state)
        if button ~= 'left' or state ~= 'up' then
            return
        end
        local username = guiGetText(usernameInput)
        local password = guiGetText(passwordInput)
        local inputValid = true
        if not isUsernameValid(username) then
            guiSetVisible(usernameErrorLabel, true)
            inputValid = false
        else
            guiSetVisible(usernameErrorLabel, false)
        end
        if not isPasswordValid(password) then
            guiSetVisible(passwordErrorLabel, true)
            inputValid = false
        else
            guiSetVisible(passwordErrorLabel, false)
        end
        if not inputValid then
            return
        end
        triggerServerEvent('auth:login-attempt', localPlayer, username, password)
    end, false)
    local registerButton = guiCreateButton(10, 190, (width / 2) - 15, 30, 'Sign Up', false, window)
    addEventHandler('onClientGUIClick', registerButton, function(button, state)
        if button ~= 'left' or state ~= 'up' then
            return
        end
        local username = guiGetText(usernameInput)
        local password = guiGetText(passwordInput)
        local inputValid = true
        if not isUsernameValid(username) then
            guiSetVisible(usernameErrorLabel, true)
            inputValid = false
        else
            guiSetVisible(usernameErrorLabel, false)
        end
        if not isPasswordValid(password) then
            guiSetVisible(passwordErrorLabel, true)
            inputValid = false
        else
            guiSetVisible(passwordErrorLabel, false)
        end
        if not inputValid then
            return
        end
        triggerServerEvent('auth:register-attempt', localPlayer, username, password)
    end, false)
    local forgotPasswordButton = guiCreateButton((width / 2) + 5, 190, (width / 2) - 15, 30, 'Forgoted password', false,
                                     window)
end, true)
addEvent('login-menu:close', true)
addEventHandler('login-menu:close', root, function()
    destroyElement(window)
    showCursor(false, false)
    guiSetInputMode('allow_binds')
end)
addEvent('register-menu:close', true)
addEventHandler('register-menu:close', root, function()
    destroyElement(window)
    showCursor(false, false)
    guiSetInputMode('allow_binds')
end)

