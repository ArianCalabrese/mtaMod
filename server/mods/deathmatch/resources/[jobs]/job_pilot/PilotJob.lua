pilot = createTeam("Pilot",255,255,0)
marker1 = createMarker(1591.93921, 1448.08423, 9.83063,"cylinder",2,0,150,255,255)
marker5 = createMarker(-1415.17041 ,-131.17546 ,13.14397,"cylinder",2,0,150,255,255)
marker6 = createMarker(2006.68823, -2289.57202 ,12.54688,"cylinder",2,0,150,255,255)
blip11 = createBlip(2006.68823, -2289.57202 ,13.54688,41,2)
blip9 = createBlip(1591.93921, 1448.08423, 9.83063,41,2)
blip10 = createBlip(-1415.17041 ,-131.17546 ,13.14397,41,2)
marker2 = createMarker(-1385.98352, -216.73637 ,13.14844,"cylinder",6,255,255,0,255)
marker3 = createMarker(1891.00195, -2624.34082 ,13.54688,"cylinder",6,255,255,0,255)
marker4 = createMarker(1604.27612 ,1266.63037 ,10.81250,"cylinder",6,255,255,0,255)
setElementAlpha(marker2,0)
setElementAlpha(marker3,0)
setElementAlpha(marker4,0)
------------
function acceptJob(thePlayer)
    if isElementWithinMarker(thePlayer, marker1) then
    outputChatBox("*PILOT JOB* type /accept to get job. Or , just type /deny to deny working as pilot.",thePlayer,255,255,0)
    end
end
addEventHandler("onMarkerHit",marker1,acceptJob) 
----------------
function acceptJob(thePlayer)
    if isElementWithinMarker(thePlayer, marker5) then
    outputChatBox("*PILOT JOB* type /accept to get job. Or , just type /deny to deny working as pilot.",thePlayer,255,255,0)
    end
end
addEventHandler("onMarkerHit",marker5,acceptJob) 
---------------
function acceptJob(thePlayer)
    if isElementWithinMarker(thePlayer, marker6) then
    outputChatBox("*PILOT JOB* type /accept to get job. Or , just type /deny to deny working as pilot.",thePlayer,255,255,0)
    end
end
addEventHandler("onMarkerHit",marker6,acceptJob) 

-------------------------------
function getJob(thePlayer)
	if isElementWithinMarker(thePlayer, marker1) then
	setElementAlpha(marker2,255)
	blip2 = createBlip(-1385.98352, -216.73637 ,13.14844,51,2)
	setPlayerTeam(thePlayer,pilot)
	setPlayerSkin(thePlayer,61)
end
end
addCommandHandler("accept",getJob)
-------
function getJob(thePlayer)
	if isElementWithinMarker(thePlayer, marker5) then
	marker3 = createMarker(1891.00195, -2624.34082 ,13.54688,"cylinder",6,255,255,0,255)
	blip3 = createBlip(1891.00195, -2624.34082 ,13.54688,51,2)
	setPlayerTeam(thePlayer,pilot)
	setPlayerSkin(thePlayer,61)
end
end
addCommandHandler("accept",getJob)
-------------
function getJob(thePlayer)
	if isElementWithinMarker(thePlayer, marker6) then
	marker2 = createMarker(-1385.98352, -216.73637 ,13.14844,"cylinder",6,255,255,0,255)
	blip2 = createBlip(-1385.98352, -216.73637 ,13.14844,51,2)
	setPlayerTeam(thePlayer,pilot)
	setPlayerSkin(thePlayer,61)
end
end
addCommandHandler("accept",getJob)

--------
function giveCash( thePlayer )
	theVehicle = getPlayerOccupiedVehicle( thePlayer ) 
	if( theVehicle ) and (getVehicleType(theVehicle)=="Plane") then
	givePlayerMoney(thePlayer,800)
	outputChatBox("You have earned $800",thePlayer,0,90,90)
	setElementAlpha(marker3,255)
	blip3 = createBlip(1891.00195, -2624.34082 ,13.54688,51,2)
	outputChatBox ("Go to Los Santos International Airport",thePlayer,0,255,0)
	destroyElement(marker2)
	destroyElement(blip2)
	
end
end
addEventHandler("onMarkerHit",marker2,giveCash)
------------
function secondMarker(thePlayer)
	theVehicle = getPlayerOccupiedVehicle( thePlayer )
	if( theVehicle ) and (getVehicleType(theVehicle)=="Plane") then
	givePlayerMoney(thePlayer,1000)
	outputChatBox("You have earned $1000",thePlayer,0,90,90)
	setElementAlpha(marker4,255)
	blip4 = createBlip(1604.27612 ,1266.63037 ,10.81250,51,2)
	outputChatBox("Go to Las Venturas Airport for your last trip",thePlayer,0,255,0)
	destroyElement(marker3)
	destroyElement(blip3)
	end
end
addEventHandler("onMarkerHit",marker3,secondMarker)
---------------
function thirdMarker(thePlayer)
	theVehicle = getPlayerOccupiedVehicle( thePlayer )
	if( theVehicle ) and (getVehicleType(theVehicle)=="Plane") then
	givePlayerMoney(thePlayer,1200)
	outputChatBox("You have earned $1200",thePlayer,0,90,90)
	outputChatBox("You have finished pilot job! Go to the blue blip to get employed again",thePlayer,0,255,0)
	destroyElement(marker4)
	destroyElement(blip4)
	end
end
addEventHandler("onMarkerHit",marker4,thirdMarker)
-------------

function cancelMission()
	destroyElement(marker2)
	destroyElement(marker3)
	destroyElement(marker4)
	destroyElement(blip2)
	destroyElement(blip3)
	destroyElement(blip4)
end
addEventHandler("onPlayerWasted", getRootElement(),cancelMission);

function loseCash()
	thePlane = getPlayerOccupiedVehicle(thePlayer)
	price = 1001 - getElementHealth(thePlane) 
	takePlayerMoney(thePlayer,price*0.1)
	outputChatBox("You lost some load for hitting the jet",thePlayer,255,0,0)
end
addEventHandler("onVehicleDamage",loseCash)