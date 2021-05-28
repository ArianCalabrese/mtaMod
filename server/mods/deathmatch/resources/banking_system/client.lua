function createGUI()
	if (bankWdw) then
		return true
	end
	local screenW, screenH = guiGetScreenSize()
	bankWdw = guiCreateWindow((screenW - 347) / 2, (screenH - 316) / 2, 347, 316, "Bank System", false)
	guiWindowSetSizable(bankWdw, false)
	tabPanel = guiCreateTabPanel(9, 25, 328, 258, false, bankWdw)
	-- Tabs
	accInfoTab = guiCreateTab("Account info", tabPanel)
	registerTab = guiCreateTab("Register", tabPanel)
	actionsTab = guiCreateTab("Transfer/Deposit/Withdraw", tabPanel)
	-- Buttons
	closeBtn = guiCreateButton(107, 288, 133, 18, "Close", false, bankWdw)
	registerBtn = guiCreateButton(78, 155, 166, 28, "Register", false, registerTab)
	changePinBtn = guiCreateButton(97, 207, 139, 17, "Change PIN", false, accInfoTab)
	depositBtn = guiCreateButton(104, 76, 111, 19, "Deposit", false, actionsTab)
	withdrawBtn = guiCreateButton(104, 119, 111, 19, "Withdraw", false, actionsTab)
	transferBtn = guiCreateButton(104, 162, 111, 19, "Transfer", false, actionsTab)
	-- Labels
	guiCreateLabel(46, 129, 57, 21, "Old PIN:", false, accInfoTab)
	guiCreateLabel(42, 172, 57, 21, "New PIN:", false, accInfoTab)
	accountBlanceInfoLabel = guiCreateLabel(113, 14, 97, 15, "Account balance:", false, accInfoTab)
	guiSetFont(accountBlanceInfoLabel, "default-bold-small")
	changePinLabel = guiCreateLabel(113, 93, 101, 15, "Change your PIN:", false, accInfoTab)
	guiSetFont(changePinLabel, "default-bold-small")
	accountBalanceLabel = guiCreateLabel(113, 39, 165, 15, "", false, accInfoTab)
	guiCreateLabel(74, 81, 160, 16, "Enter your account password", false, registerTab)
	guiCreateLabel(136, 35, 23, 15, "PIN", false, registerTab)
	registerLabel = guiCreateLabel(77, 10, 158, 15, "Register your account here", false, registerTab)
	guiSetFont(registerLabel, "default-bold-small")
	guiCreateLabel(109, 10, 91, 15, "Fill the amount:", false, actionsTab)
	guiCreateLabel(81, 189, 170, 17, "Account name of the receiver:", false, actionsTab)
	guiCreateLabel(237, 25, 27, 15, "PIN:", false, actionsTab)
	-- Edit boxes
	oldPINEdit = guiCreateEdit(95, 129, 151, 20, "", false, accInfoTab)
	newPINEdit = guiCreateEdit(95, 172, 151, 20, "", false, accInfoTab)
	PINEdit = guiCreateEdit(108, 54, 84, 17, "", false, registerTab)
	accPassEdit = guiCreateEdit(108, 102, 84, 17, "", false, registerTab)
	guiEditSetMasked(accPassEdit, true)
	amountEdit = guiCreateEdit(109, 41, 91, 20, "", false, actionsTab)
	accNameEdit = guiCreateEdit(102, 206, 123, 18, "", false, actionsTab)
	actionsPINEdit = guiCreateEdit(225, 40, 49, 21, "", false, actionsTab)
	-- Event handlers
	addEventHandler("onClientGUIClick", closeBtn, closeGUI, false)
	addEventHandler("onClientGUIClick", registerBtn, registerAcc, false)
	addEventHandler("onClientGUIClick", changePinBtn, changeAccPin, false)
	addEventHandler("onClientGUIClick", depositBtn, depositMoney, false)
	addEventHandler("onClientGUIClick", withdrawBtn, withdrawMoney, false)
	addEventHandler("onClientGUIClick", transferBtn, transferMoney, false)
end

function openGUI(plrBankAcc)
	createGUI()
	guiSetVisible(bankWdw, true)
	showCursor(true)
	if (not plrBankAcc) then
		guiSetText(accountBalanceLabel, "")
		return false
	end
	local accBalance = plrBankAcc.cash
	guiSetText(accountBalanceLabel, "$"..tostring(accBalance))
end
addEvent("triggerBankGUI", true)
addEventHandler("triggerBankGUI", localPlayer, openGUI)

function closeGUI()
	guiSetVisible(bankWdw, false)
	showCursor(false)
end

function registerAcc()
	local pin = guiGetText(PINEdit)
	local accpass = guiGetText(accPassEdit)
	if (#pin < 1 or #accpass < 1) then
		outputChatBox("Please fill all of the fields", 255, 25, 25)
		return false
	end
	if (not tonumber(pin) or #pin ~= 4) then
		outputChatBox("PIN must be a 4-digit number", 255, 25, 25)
		return false
	end
	triggerServerEvent("createBankAccount", localPlayer, tonumber(pin), accpass)
end

function changeAccPin()
	local oldPIN = guiGetText(oldPINEdit)
	local newPIN = guiGetText(newPINEdit)
	if (#oldPIN < 1 or #newPIN < 1) then
		outputChatBox("Please fill all of the fields", 255, 25, 25)
		return false
	end
	if (#newPIN ~= 4) then
		outputChatBox("PIN should be a 4-digit number", 255, 25, 25)
		return false
	end
	triggerServerEvent("changeBankPIN", localPlayer, tonumber(oldPIN), tonumber(newPIN))
end

function depositMoney()
	local amount = guiGetText(amountEdit)
	if (#amount < 1) then
		outputChatBox("Please fill the amount box", 255, 25, 25)
		return false
	end
	if (not tonumber(amount)) then
		outputChatBox("Amount should be a number", 255, 25, 25)
		return false
	end
	triggerServerEvent("bankMoneyDeposit", localPlayer, tonumber(amount))
end

function withdrawMoney()
	local amount = guiGetText(amountEdit)
	if (#amount < 1) then
		outputChatBox("Please fill the amount box", 255, 25, 25)
		return false
	end
	if (not tonumber(amount)) then
		outputChatBox("Amount should be a number", 255, 25, 25)
		return false
	end
	local PIN = guiGetText(actionsPINEdit)
	if (#PIN < 1 or not tonumber(PIN)) then
		outputChatBox("Please fill out the PIN field. PIN should be a 4-digit number", 255, 25, 25)
		return false
	end
	triggerServerEvent("bankMoneyWithdraw", localPlayer, tonumber(amount), tonumber(PIN))
end

function transferMoney()
	local amount = guiGetText(amountEdit)
	if (#amount < 1) then
		outputChatBox("Please fill the amount box", 255, 25, 25)
		return false
	end
	if (not tonumber(amount)) then
		outputChatBox("Amount should be a number", 255, 25, 25)
		return false
	end
	local PIN = guiGetText(actionsPINEdit)
	if (#PIN < 1 or not tonumber(PIN)) then
		outputChatBox("Please fill out the PIN field. PIN should be a 4-digit number", 255, 25, 25)
		return false
	end
	local accName = guiGetText(accNameEdit)
	if (#accName < 1) then
		outputChatBox("Please fill the account name field", 255, 25, 25)
		return false
	end
	triggerServerEvent("bankMoneyTransfer", localPlayer, accName, tonumber(amount), tonumber(PIN))
end

function receiveUpdate(balance)
	if (not balance) then
		return false
	end
	if (guiGetVisible(bankWdw)) then
		guiSetText(accountBalanceLabel, "$"..tostring(balance))
	end
end
addEvent("receiveAccountBalance", true)
addEventHandler("receiveAccountBalance", localPlayer, receiveUpdate)