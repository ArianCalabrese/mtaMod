local bankAccounts = {}
local informOnLogin = {} -- for offline transactions
-- positions(mess with these as you like)
local ATMpositions = {{-2416.24683, 351.27182, 34.712, 53.4313}, {-2417.23560, 349.81308, 34.712, 53.4313},
                      {-2415.12061, 352.78421, 34.712, 53.4313}, {1726.83215, -1218.91077, 18.662, 268.281},
                      {1726.82654, -1221.38892, 18.20137, 268.281}}
local ATMmarkers = {{-2416.62988, 349.36771, 34.17188}, {-2415.67480, 350.93085, 34.17188},
                    {-2414.59106, 352.38425, 34.17188}, {1725.88721, -1218.90222, 18.03185},
                    {1725.98706, -1221.41272, 17.57776}}
local blipPositions = {{-2413.94336, 349.54025, 35.17188}, {1724.27112, -1218.55115, 19.11462}}

-- Setup markers

function createMarkers()
    for i = 1, #ATMpositions do
        createObject(2942, ATMpositions[i][1], ATMpositions[i][2], ATMpositions[i][3], 0, 0, ATMpositions[i][4])
        createMarker(ATMmarkers[i][1], ATMmarkers[i][2], ATMmarkers[i][3], "cylinder", 1.5)
    end
    for i = 1, #blipPositions do
        createBlip(blipPositions[i][1], blipPositions[i][2], blipPositions[i][3], 52)
    end
end
addEventHandler("onResourceStart", resourceRoot, createMarkers)

function triggerGUI(hitElement, dim)
    if (not dim or getElementType(hitElement) == "object") then
        return false
    end
    if (getElementType(hitElement) == "vehicle") then
        return false
    end
    local plrBankAcc = getPlayerBankAccount(hitElement)
    triggerClientEvent(hitElement, "triggerBankGUI", hitElement, bankAccounts[plrBankAcc])
end
addEventHandler("onMarkerHit", resourceRoot, triggerGUI)

-- Save/Load

function loadBankAccounts(query)
    local result = dbPoll(query, 0)
    if (not result or #result < 0) then
        return false
    end
    for i, v in ipairs(result) do
        bankAccounts[#bankAccounts + 1] = {
            accName = v.accName,
            accPin = v.accPin,
            cash = v.accCash
        }
    end
end

function onStart()
    db = dbConnect("sqlite", ":/registry.db")
    if (not db) then
        return outputConsole("Error, base de datos inexistente")
    end
    dbExec(db, "CREATE TABLE IF NOT EXISTS `bankAccounts` (`accName` TEXT, `accPin` INT, `accCash` INT)")
    dbQuery(loadBankAccounts, db, "SELECT * FROM `bankAccounts`")
end
addEventHandler("onResourceStart", resourceRoot, onStart)

function onStop()
    for i, v in ipairs(getElementsByType("player")) do
        local acc = getPlayerBankAccount(v)
        if (acc) then
            local plrCash = getPlayerBankCash(v)
            local accName = getAccountName(getPlayerAccount(v))
            dbExec(db, "UPDATE `bankAccounts` SET `accCash` = ? WHERE `accName` = ?", plrCash, accName)
        end
    end
end
addEventHandler("onResourceStop", resourceRoot, onStop)

function onQuit()
    local bankAcc = getPlayerBankAccount(source)
    if (not bankAcc) then
        return false
    end
    local plrCash = getPlayerBankCash(source)
    local accName = getAccountName(getPlayerAccount(source))
    dbExec(db, "UPDATE `bankAccounts` SET `accCash` = ? WHERE `accName` = ?", plrCash, accName)
end
addEventHandler("onPlayerQuit", root, onQuit)

-- Main functions

function createBankAccount(PIN, accpass)
    if (not client or not PIN or not accpass) then
        return false
    end
    if (getPlayerBankAccount(client)) then
        outputChatBox("You already have a bank account", client, 255, 25, 25)
        return false
    end
    local acc = getPlayerAccount(client)
    -- local checkPassword = getAccount(getAccountName(acc))
    -- if (not checkPassword) then
    --     outputChatBox("Password is incorrect", client, 255, 25, 25)
    --     return false
    -- end
    local name = getAccountName(acc)
    local cash = 0
    bankAccounts[#bankAccounts + 1] = {
        accName = name,
        accPin = PIN,
        cash = cash
    }
    dbExec(db, "INSERT INTO `bankAccounts` (accName, accPin, accCash) VALUES (?, ?, ?)", name, PIN, cash)
    outputChatBox("You successfully created a bank account with PIN " .. tostring(PIN), client, 0, 255, 0)
end
addEvent("createBankAccount", true)
addEventHandler("createBankAccount", root, createBankAccount)

function changeAccountPIN(oldPIN, newPIN)
    if (not client or not oldPIN or not newPIN) then
        return false
    end
    local bankAcc = getPlayerBankAccount(client)
    if (not bankAcc) then
        outputChatBox("You don't have a bank account, please register one first", client, 255, 25, 25)
        return false
    end
    local plrPIN = getPlayerPIN(client)
    if (plrPIN ~= oldPIN) then
        outputChatBox("Old PIN is incorrect", client, 255, 25, 25)
        return false
    end
    local changeAttempt = setPlayerPIN(client, newPIN)
    if (changeAttempt) then
        outputChatBox("PIN changed successfully to " .. newPIN, client, 0, 255, 0)
    else
        outputChatBox("An error occured, couldn't change PIN", client, 255, 25, 25)
    end
end
addEvent("changeBankPIN", true)
addEventHandler("changeBankPIN", root, changeAccountPIN)

function sendBalanceToClient()
    if (not client) then
        return false
    end
    updateBankBalance(client)
end
addEvent("requestAccountBalance", true)
addEventHandler("requestAccountBalance", root, sendBalanceToClient)

function serverDepositMoney(amount)
    if (not client or not amount) then
        return false
    end
    local plrBankAcc = getPlayerBankAccount(client)
    if (not plrBankAcc) then
        outputChatBox("You don't have a bank account, register one first", client, 255, 25, 25)
        return false
    end
    local plrMoney = getPlayerMoney(client)
    if (plrMoney < amount) then
        outputChatBox("You don't have $" .. amount .. " on you", client, 255, 25, 25)
        return false
    end
    local plrBankMoney = getPlayerBankCash(client)
    bankAccounts[plrBankAcc].cash = plrBankMoney + amount
    takePlayerMoney(client, amount)
    outputChatBox("You successfully deposited $" .. amount, client, 0, 255, 0)
    updateBankBalance(client)
end
addEvent("bankMoneyDeposit", true)
addEventHandler("bankMoneyDeposit", root, serverDepositMoney)

function serverWithdrawMoney(amount, PIN)
    if (not client or not amount or not PIN) then
        return false
    end
    local plrBankAcc = getPlayerBankAccount(client)
    if (not plrBankAcc) then
        outputChatBox("You don't have a bank account, register one first", client, 255, 25, 25)
        return false
    end
    local plrPIN = getPlayerPIN(client)
    if (plrPIN ~= PIN) then
        outputChatBox("PIN is incorrect", client, 255, 25, 25)
        return false
    end
    local plrBankMoney = getPlayerBankCash(client)
    if (plrBankMoney < amount) then
        outputChatBox("You don't have enough money in your bank account", client, 255, 25, 25)
        return false
    end
    if (amount + getPlayerMoney(client) > 90000000) then
        outputChatBox("You can't withdraw this amount of money because you'll exceed $90,000,000 on hand", client, 255,
            25, 25)
        return false
    end
    bankAccounts[plrBankAcc].cash = plrBankMoney - amount
    givePlayerMoney(client, amount)
    outputChatBox("You successfully withdrew $" .. amount, client, 0, 255, 0)
    updateBankBalance(client)
end
addEvent("bankMoneyWithdraw", true)
addEventHandler("bankMoneyWithdraw", root, serverWithdrawMoney)

function serverTransferMoney(accName, amount, PIN)
    if (not client or not accName or not amount or not PIN) then
        return false
    end
    local plrBankAcc = getPlayerBankAccount(client)
    if (not plrBankAcc) then
        outputChatBox("You don't have a bank account, register one first", client, 255, 25, 25)
        return false
    end
    if (getAccountName(getPlayerAccount(client)) == accName) then
        outputChatBox("You can't transfer money to yourself", client, 255, 25, 25)
        return false
    end
    local plrPIN = getPlayerPIN(client)
    if (plrPIN ~= PIN) then
        outputChatBox("PIN is incorrect", client, 255, 25, 25)
        return false
    end
    local acc = getAccount(accName)
    if (not acc) then
        outputChatBox("Account name doesn't exist", client, 255, 25, 25)
        return false
    end
    local plr = getAccountPlayer(acc)
    local receiverBankAcc = getPlayerBankAccount(plr)
    if (not receiverBankAcc) then
        outputChatBox("Transaction couldn't be made, receiver doesn't have a bank account", client, 255, 25, 25)
        return false
    end
    local plrBankMoney = getPlayerBankCash(client)
    if (plrBankMoney < amount) then
        outputChatBox("You don't have $" .. amount .. " in your bank account to send", client, 255, 25, 25)
        return false
    end
    -- Complete transaction
    bankAccounts[plrBankAcc].cash = plrBankMoney - amount
    bankAccounts[receiverBankAcc].cash = bankAccounts[receiverBankAcc].cash + amount
    outputChatBox("BANK TRANSACTION: Sent $" .. amount .. " to account: " .. accName, client, 0, 255, 0)
    if (plr) then
        outputChatBox("BANK TRANSACTION: Received $" .. amount .. " from " .. getPlayerName(client), plr, 0, 255, 0)
    else
        informOnLogin[#informOnLogin + 1] = {
            acc = accName,
            msg = "BANK TRANSACTION: Received $" .. amount .. " from " .. getPlayerName(client)
        }
    end
    updateBankBalance(client)
    updateBankBalance(plr)
end
addEvent("bankMoneyTransfer", true)
addEventHandler("bankMoneyTransfer", root, serverTransferMoney)

function updateBankBalance(plr)
    local balance = getPlayerBankCash(plr)
    triggerClientEvent(plr, "receiveAccountBalance", plr, balance)
end

function informOnLoginPlayers(_, acc)
    local accName = getAccountName(acc)
    local i = isAccountToInform(accName)
    if (not i) then
        return false
    end
    outputChatBox(informOnLogin[i].msg, source, 0, 255, 0)
    table.remove(informOnLogin, i)
end
addEventHandler("onPlayerLogin", root, informOnLoginPlayers)

-- Utility

function getPlayerBankAccount(plr)
    if (not plr or not isElement(plr) or getElementType(plr) ~= "player") then
        return false
    end
    local accName = getAccountName(getPlayerAccount(plr))
    for i = 1, #bankAccounts do
        if (bankAccounts[i].accName == accName) then
            return i
        end
    end
    return false
end

function getPlayerBankCash(plr)
    local plrBankAcc = getPlayerBankAccount(plr)
    if (not plrBankAcc) then
        return false
    end
    return bankAccounts[plrBankAcc].cash
end

function getAccountBankCash(accName)
    if (not accName) then
        return false
    end
    for i = 1, #bankAccounts do
        if (bankAccounts[i].accName == accName) then
            return bankAccounts[i].cash
        end
    end
    return false
end

function setPlayerBankCash(plr, cash)
    if (not plr or not isElement(plr) or getElementType(plr) ~= "player" or not cash or not tonumber(cash)) then
        return false
    end
    cash = tonumber(cash)
    local bankAcc = getPlayerBankAccount(plr)
    if (not bankAcc) then
        return false
    end
    bankAccounts[bankAcc].cash = cash
    return true
end

function setAccountBankCash(acc, cash)
    if (not acc or not cash) then
        return false
    end
    if (not tonumber(cash)) then
        return false
    end
    cash = tonumber(cash)
    for i = 1, #bankAccounts do
        if (bankAccounts[i].accName == acc) then
            bankAccounts[i].cash = cash
            return true
        end
    end
    return false
end

function getPlayerPIN(plr)
    if (not plr or not isElement(plr) or getElementType(plr) ~= "player" or #bankAccounts < 1) then
        return false
    end
    local accName = getAccountName(getPlayerAccount(plr))
    for i = 1, #bankAccounts do
        if (bankAccounts[i].accName == accName) then
            return bankAccounts[i].accPin
        end
    end
    return false
end

function getAccountPIN(accName)
    if (not accName) then
        return false
    end
    for i = 1, #bankAccounts do
        if (bankAccounts[i].accName == accName) then
            return bankAccounts[i].accPin
        end
    end
    return false
end

function setPlayerPIN(plr, PIN)
    if (not plr or not isElement(plr) or getElementType(plr) ~= "player" or not PIN) then
        return false
    end
    if (#tostring(PIN) ~= 4 or #tostring(PIN) < 1) then
        return false
    end
    if (not tonumber(PIN)) then
        return false
    end
    PIN = tonumber(PIN)
    local bankAcc = getPlayerBankAccount(plr)
    if (not bankAcc) then
        return false
    end
    local accName = getAccountName(getPlayerAccount(plr))
    bankAccounts[bankAcc].accPin = PIN
    dbExec(db, "UPDATE `bankAccounts` SET `accPin` = ? WHERE `accName` = ?", PIN, accName)
    return true
end

function setAccountPIN(accName, PIN)
    if (not accName or not PIN) then
        return false
    end
    if (#tostring(PIN) ~= 4 or #tostring(PIN) < 1) then
        return false
    end
    if (not tonumber(PIN)) then
        return false
    end
    PIN = tonumber(PIN)
    for i = 1, #bankAccounts do
        if (bankAccounts[i].accName == accName) then
            bankAccounts[i].accPin = PIN
            dbExec(db, "UPDATE `bankAccounts` SET `accPin` = ? WHERE `accName` = ?", PIN, accName)
            return true
        end
    end
    return false
end

function isAccountToInform(accName)
    if (not accName) then
        return false
    end
    for i = 1, #informOnLogin do
        if (informOnLogin[i].acc == accName) then
            return i
        end
    end
    return false
end

function outputTable()
    iprint(bankAccounts)
end
addCommandHandler("pizza", outputTable)
