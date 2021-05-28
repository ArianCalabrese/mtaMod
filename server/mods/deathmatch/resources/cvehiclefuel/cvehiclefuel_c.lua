addEvent("onGasRefill",true)
function setUp(startedResource)
	if(startedResource == getThisResource()) then
		oX,oY,oZ = getElementPosition(getLocalPlayer())
		fBar = guiCreateProgressBar(598,158,154,25,false)
		fLabel = guiCreateLabel(615,140,155,25,"Fuel:",false)
		setTimer(fuelDepleting,500,0)
		distance = 0
		distanceOld = 0
	end
end
addEventHandler("onClientResourceStart",getRootElement(),setUp)

function drawFuelBar()
	fBar = guiCreateProgressBar(598,158,154,25,false)
	guiSetVisible(fBar,false)
end
addEventHandler("onClientPlayerJoin",getRootElement(),drawFuelBar)

function monitoring()
	if(isPlayerInVehicle(getLocalPlayer())) then
		vehicle = getPlayerOccupiedVehicle(getLocalPlayer())
		x,y,z = getElementPosition(getLocalPlayer())
		distance = distance + getDistanceBetweenPoints3D(x,y,z,oX,oY,oZ)
		oX = x
		oY = y
		oZ = z
	end
end
addEventHandler("onClientRender",getRootElement(),monitoring)

function fuelDepleting()
	if(isPlayerInVehicle(getLocalPlayer())) then
		vehicle = getPlayerOccupiedVehicle(getLocalPlayer())
		guiSetVisible(fBar,true)
		if(getElementData(vehicle,"fuel") == false) then
			fuel = math.random(85,100)
			setElementData(vehicle,"fuel",tonumber(fuel))
		end
		currentFuel = tonumber(getElementData(vehicle,"fuel"))
		if(currentFuel > 0) then
			setElementData(vehicle,"fuel",tostring(currentFuel - math.floor(distance - distanceOld)/200))
			currentFuel = tonumber(getElementData(vehicle,"fuel"))
			guiProgressBarSetProgress(fBar,currentFuel)
			guiSetText(fLabel,"Fuel Tank: " .. math.floor(currentFuel) .. "%")
			distanceOld = distance
		else
			toggleControl("accelerate",false)
			toggleControl("brake_reverse",false)	
			guiSetText(fLabel,"Fuel Tank: Empty")
		end
	else
		guiSetText(fLabel,"Fuel Tank: Out Of Vehicle")
		guiProgressBarSetProgress(fBar,0)
		guiSetVisible(fBar,false)
	end
end

function setFuel(player,seat,jacked)
	if(getElementData(vehicle,"fuel") == false) then
		fuel = math.random(70,100)
		setElementData(source,"fuel",tonumber(fuel))
	end
end
addEventHandler("onClientVehicleEnter",getRootElement(),setFuel)

function setFuelOnRespawn()
	local fuel = math.random(70,100)
	setElementData(source,"fuel",tonumber(fuel))
end
addEventHandler("onClientVehicleRespawn",getRootElement(),setFuelOnRespawn)

function enableDriving(player,seat)
	toggleControl("accelerate",true)
	toggleControl("brake_reverse",true)
end
addEventHandler("onClientVehicleExit",getRootElement(),enableDriving)

function refillGas()
	if(isPlayerInVehicle(getLocalPlayer()) and isPlayer) then
		local vehicle = getPlayerOccupiedVehicle(getLocalPlayer())
		setElementData(vehicle,"fuel","100")
		outputChatBox("Refilled")
		toggleControl("accelerate",true)
		toggleControl("brake_reverse",true)
	end
end
addCommandHandler("refill",refillGas)

function setTimerRefillGas(enabled)
	if(isPlayerInVehicle(getLocalPlayer())) then
		if(enabled == true) then
			refillTimer = setTimer(timerRefillGas,100,0)
		else
			killTimer(refillTimer)
		end
	else
		outputChatBox("You have to be in vehicle to refill!")
	end
end
addEventHandler("onGasRefill",getRootElement(),setTimerRefillGas)

function timerRefillGas()
	if(isPlayerInVehicle(getLocalPlayer())) then
		local player = getLocalPlayer()
		local vehicle = getPlayerOccupiedVehicle(player)
		local fuel = getElementData(vehicle,"fuel")
		if(tonumber(fuel) < 100) then
			setElementData(vehicle,"fuel",tostring(fuel + 1))
			distanceOld = distance
		end
	end
end
