local MINIMUM_PASSWORD_LENGTH = 6

local function isPasswordValid(password)
    return string.len(password) >= MINIMUM_PASSWORD_LENGTH
end

-- create an account
addEvent('auth:register-attempt', true)
addEventHandler('auth:register-attempt', root, function(username, password, skin, age, sex)
    -- check if an account with that username already exists
    if getAccount(username) then
        return outputChatBox('An account already exists with that name.', source, 255, 100, 100)
    end

    -- is the password valid?
    if not isPasswordValid(password) then
        return outputChatBox('The password supplied was not valid.', source, 255, 100, 100)
    end
    outputChatBox('Pasa los 2 ifs', source, 255, 100, 100)
    -- create a hash of the password
    local player = source
    passwordHash(password, 'bcrypt', {}, function(hashedPassword)
        -- create the account
        local account = addAccount(username, hashedPassword)
        setAccountData(account, 'hashed_password', hashedPassword)

        -- let the user know of our success
        outputChatBox('Registrado con exito!', player, 100, 255, 100)
        -- automatically login and spawn the player.
        logIn(player, account, hashedPassword)
        -- setting personal info
        setAccountData(account, 'age', age)
        setAccountData(account, 'sex', sex)
        spawnPlayer(player, 0, 0, 10)
        setElementModel(player, skin)
        setPlayerMoney(player, 10000)
        setCameraTarget(player, player)

        return triggerClientEvent(player, 'register-character-creation:close', player)
    end)
end)

-- login an account
addEvent("auth:login-attempt", true)
addEventHandler("auth:login-attempt", root, function(username, password)

    local account = getAccount(username)
    if not account then
        return outputChatBox('No such account could be found with that username or password.', source, 255, 100, 100)
    end

    local hashedPassword = getAccountData(account, "hashed_password")
    local player = source
    passwordVerify(password, hashedPassword, function(isValid)
        if not isValid then
            return
                outputChatBox('No such account could be found with that username or password.', player, 255, 100, 100)
        end

        if logIn(player, account, hashedPassword) then

            -- Player position and Rotation
            local x = getAccountData(account, "x")
            local y = getAccountData(account, "y")
            local z = getAccountData(account, "z")
            local rz = getAccountData(account, "rz")
            spawnPlayer(player, x, y, z)
            setElementRotation(player, 0, 0, rz)

            -- Player Stats (Skin, money, armour, health)
            local health, armor, money, skin = getAccountData(account, "health"), getAccountData(account, "armor"),
                getAccountData(account, "money"), getAccountData(account, "skin")
            setElementHealth(player, health)
            setPedArmor(player, armor)
            setPlayerMoney(player, money)
            setElementModel(player, skin)
            -- Camera
            setCameraTarget(player, player)
            return triggerClientEvent(player, 'login-menu:close', player)
        end

        return outputChatBox('An unknown error ocurred while attempting to authenticate .', player, 255, 100, 100)
    end)
end)
-- logout of account
addCommandHandler("accountLogout", function(player)
    logOut(player)
end, false, false)

